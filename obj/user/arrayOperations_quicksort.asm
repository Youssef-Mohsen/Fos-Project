
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 40 03 00 00       	call   800376 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 e3 1a 00 00       	call   801b26 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 0d 1b 00 00       	call   801b58 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  80004e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 a0 3f 80 00       	push   $0x803fa0
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 93 39 00 00       	call   8039f5 <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 a6 3f 80 00       	push   $0x803fa6
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 7c 39 00 00       	call   8039f5 <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 dc             	pushl  -0x24(%ebp)
  800082:	e8 b9 39 00 00       	call   803a40 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80008a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800091:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  800098:	83 ec 08             	sub    $0x8,%esp
  80009b:	68 af 3f 80 00       	push   $0x803faf
  8000a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a3:	e8 54 16 00 00       	call   8016fc <sget>
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	68 b3 3f 80 00       	push   $0x803fb3
  8000b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b9:	e8 3e 16 00 00       	call   8016fc <sget>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000c7:	8b 00                	mov    (%eax),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	6a 00                	push   $0x0
  8000d1:	50                   	push   %eax
  8000d2:	68 bb 3f 80 00       	push   $0x803fbb
  8000d7:	e8 7b 15 00 00       	call   801657 <smalloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000e9:	eb 25                	jmp    800110 <_main+0xd8>
	{
		sortedArray[i] = sharedArray[i];
  8000eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000f8:	01 c2                	add    %eax,%edx
  8000fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800104:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800107:	01 c8                	add    %ecx,%eax
  800109:	8b 00                	mov    (%eax),%eax
  80010b:	89 02                	mov    %eax,(%edx)
	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80010d:	ff 45 f4             	incl   -0xc(%ebp)
  800110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800113:	8b 00                	mov    (%eax),%eax
  800115:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800118:	7f d1                	jg     8000eb <_main+0xb3>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  80011a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80011d:	8b 00                	mov    (%eax),%eax
  80011f:	83 ec 08             	sub    $0x8,%esp
  800122:	50                   	push   %eax
  800123:	ff 75 e0             	pushl  -0x20(%ebp)
  800126:	e8 24 00 00 00       	call   80014f <QuickSort>
  80012b:	83 c4 10             	add    $0x10,%esp
	cprintf("Quick sort is Finished!!!!\n") ;
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	68 ca 3f 80 00       	push   $0x803fca
  800136:	e8 4e 04 00 00       	call   800589 <cprintf>
  80013b:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	ff 75 d8             	pushl  -0x28(%ebp)
  800144:	e8 79 39 00 00       	call   803ac2 <signal_semaphore>
  800149:	83 c4 10             	add    $0x10,%esp

}
  80014c:	90                   	nop
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

0080014f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80014f:	55                   	push   %ebp
  800150:	89 e5                	mov    %esp,%ebp
  800152:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800155:	8b 45 0c             	mov    0xc(%ebp),%eax
  800158:	48                   	dec    %eax
  800159:	50                   	push   %eax
  80015a:	6a 00                	push   $0x0
  80015c:	ff 75 0c             	pushl  0xc(%ebp)
  80015f:	ff 75 08             	pushl  0x8(%ebp)
  800162:	e8 06 00 00 00       	call   80016d <QSort>
  800167:	83 c4 10             	add    $0x10,%esp
}
  80016a:	90                   	nop
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    

0080016d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800173:	8b 45 10             	mov    0x10(%ebp),%eax
  800176:	3b 45 14             	cmp    0x14(%ebp),%eax
  800179:	0f 8d 1b 01 00 00    	jge    80029a <QSort+0x12d>
	int pvtIndex = RAND(startIndex, finalIndex) ;
  80017f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 00 1a 00 00       	call   801b8b <sys_get_virtual_time>
  80018b:	83 c4 0c             	add    $0xc,%esp
  80018e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800191:	8b 55 14             	mov    0x14(%ebp),%edx
  800194:	2b 55 10             	sub    0x10(%ebp),%edx
  800197:	89 d1                	mov    %edx,%ecx
  800199:	ba 00 00 00 00       	mov    $0x0,%edx
  80019e:	f7 f1                	div    %ecx
  8001a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a3:	01 d0                	add    %edx,%eax
  8001a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ae:	ff 75 10             	pushl  0x10(%ebp)
  8001b1:	ff 75 08             	pushl  0x8(%ebp)
  8001b4:	e8 e4 00 00 00       	call   80029d <Swap>
  8001b9:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  8001bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bf:	40                   	inc    %eax
  8001c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8001c6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8001c9:	e9 80 00 00 00       	jmp    80024e <QSort+0xe1>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8001ce:	ff 45 f4             	incl   -0xc(%ebp)
  8001d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001d7:	7f 2b                	jg     800204 <QSort+0x97>
  8001d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e6:	01 d0                	add    %edx,%eax
  8001e8:	8b 10                	mov    (%eax),%edx
  8001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f7:	01 c8                	add    %ecx,%eax
  8001f9:	8b 00                	mov    (%eax),%eax
  8001fb:	39 c2                	cmp    %eax,%edx
  8001fd:	7d cf                	jge    8001ce <QSort+0x61>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8001ff:	eb 03                	jmp    800204 <QSort+0x97>
  800201:	ff 4d f0             	decl   -0x10(%ebp)
  800204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800207:	3b 45 10             	cmp    0x10(%ebp),%eax
  80020a:	7e 26                	jle    800232 <QSort+0xc5>
  80020c:	8b 45 10             	mov    0x10(%ebp),%eax
  80020f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800216:	8b 45 08             	mov    0x8(%ebp),%eax
  800219:	01 d0                	add    %edx,%eax
  80021b:	8b 10                	mov    (%eax),%edx
  80021d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800220:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800227:	8b 45 08             	mov    0x8(%ebp),%eax
  80022a:	01 c8                	add    %ecx,%eax
  80022c:	8b 00                	mov    (%eax),%eax
  80022e:	39 c2                	cmp    %eax,%edx
  800230:	7e cf                	jle    800201 <QSort+0x94>

		if (i <= j)
  800232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800235:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800238:	7f 14                	jg     80024e <QSort+0xe1>
		{
			Swap(Elements, i, j);
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	ff 75 f0             	pushl  -0x10(%ebp)
  800240:	ff 75 f4             	pushl  -0xc(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 52 00 00 00       	call   80029d <Swap>
  80024b:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80024e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800251:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800254:	0f 8e 77 ff ff ff    	jle    8001d1 <QSort+0x64>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80025a:	83 ec 04             	sub    $0x4,%esp
  80025d:	ff 75 f0             	pushl  -0x10(%ebp)
  800260:	ff 75 10             	pushl  0x10(%ebp)
  800263:	ff 75 08             	pushl  0x8(%ebp)
  800266:	e8 32 00 00 00       	call   80029d <Swap>
  80026b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80026e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800271:	48                   	dec    %eax
  800272:	50                   	push   %eax
  800273:	ff 75 10             	pushl  0x10(%ebp)
  800276:	ff 75 0c             	pushl  0xc(%ebp)
  800279:	ff 75 08             	pushl  0x8(%ebp)
  80027c:	e8 ec fe ff ff       	call   80016d <QSort>
  800281:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800284:	ff 75 14             	pushl  0x14(%ebp)
  800287:	ff 75 f4             	pushl  -0xc(%ebp)
  80028a:	ff 75 0c             	pushl  0xc(%ebp)
  80028d:	ff 75 08             	pushl  0x8(%ebp)
  800290:	e8 d8 fe ff ff       	call   80016d <QSort>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	eb 01                	jmp    80029b <QSort+0x12e>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80029a:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8002a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b0:	01 d0                	add    %edx,%eax
  8002b2:	8b 00                	mov    (%eax),%eax
  8002b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c4:	01 c2                	add    %eax,%edx
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d3:	01 c8                	add    %ecx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8002d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e6:	01 c2                	add    %eax,%edx
  8002e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8002eb:	89 02                	mov    %eax,(%edx)
}
  8002ed:	90                   	nop
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8002f6:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8002fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800304:	eb 42                	jmp    800348 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800309:	99                   	cltd   
  80030a:	f7 7d f0             	idivl  -0x10(%ebp)
  80030d:	89 d0                	mov    %edx,%eax
  80030f:	85 c0                	test   %eax,%eax
  800311:	75 10                	jne    800323 <PrintElements+0x33>
			cprintf("\n");
  800313:	83 ec 0c             	sub    $0xc,%esp
  800316:	68 e6 3f 80 00       	push   $0x803fe6
  80031b:	e8 69 02 00 00       	call   800589 <cprintf>
  800320:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800326:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032d:	8b 45 08             	mov    0x8(%ebp),%eax
  800330:	01 d0                	add    %edx,%eax
  800332:	8b 00                	mov    (%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 e8 3f 80 00       	push   $0x803fe8
  80033d:	e8 47 02 00 00       	call   800589 <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800345:	ff 45 f4             	incl   -0xc(%ebp)
  800348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034b:	48                   	dec    %eax
  80034c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80034f:	7f b5                	jg     800306 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800354:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035b:	8b 45 08             	mov    0x8(%ebp),%eax
  80035e:	01 d0                	add    %edx,%eax
  800360:	8b 00                	mov    (%eax),%eax
  800362:	83 ec 08             	sub    $0x8,%esp
  800365:	50                   	push   %eax
  800366:	68 ed 3f 80 00       	push   $0x803fed
  80036b:	e8 19 02 00 00       	call   800589 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

}
  800373:	90                   	nop
  800374:	c9                   	leave  
  800375:	c3                   	ret    

00800376 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80037c:	e8 be 17 00 00       	call   801b3f <sys_getenvindex>
  800381:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800384:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800387:	89 d0                	mov    %edx,%eax
  800389:	c1 e0 03             	shl    $0x3,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800395:	01 c8                	add    %ecx,%eax
  800397:	01 c0                	add    %eax,%eax
  800399:	01 d0                	add    %edx,%eax
  80039b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ab:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b5:	8a 40 20             	mov    0x20(%eax),%al
  8003b8:	84 c0                	test   %al,%al
  8003ba:	74 0d                	je     8003c9 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8003bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c1:	83 c0 20             	add    $0x20,%eax
  8003c4:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003cd:	7e 0a                	jle    8003d9 <libmain+0x63>
		binaryname = argv[0];
  8003cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	ff 75 0c             	pushl  0xc(%ebp)
  8003df:	ff 75 08             	pushl  0x8(%ebp)
  8003e2:	e8 51 fc ff ff       	call   800038 <_main>
  8003e7:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8003ea:	e8 d4 14 00 00       	call   8018c3 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8003ef:	83 ec 0c             	sub    $0xc,%esp
  8003f2:	68 0c 40 80 00       	push   $0x80400c
  8003f7:	e8 8d 01 00 00       	call   800589 <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800404:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80040a:	a1 20 50 80 00       	mov    0x805020,%eax
  80040f:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	52                   	push   %edx
  800419:	50                   	push   %eax
  80041a:	68 34 40 80 00       	push   $0x804034
  80041f:	e8 65 01 00 00       	call   800589 <cprintf>
  800424:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800427:	a1 20 50 80 00       	mov    0x805020,%eax
  80042c:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800432:	a1 20 50 80 00       	mov    0x805020,%eax
  800437:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80043d:	a1 20 50 80 00       	mov    0x805020,%eax
  800442:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800448:	51                   	push   %ecx
  800449:	52                   	push   %edx
  80044a:	50                   	push   %eax
  80044b:	68 5c 40 80 00       	push   $0x80405c
  800450:	e8 34 01 00 00       	call   800589 <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800458:	a1 20 50 80 00       	mov    0x805020,%eax
  80045d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	50                   	push   %eax
  800467:	68 b4 40 80 00       	push   $0x8040b4
  80046c:	e8 18 01 00 00       	call   800589 <cprintf>
  800471:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	68 0c 40 80 00       	push   $0x80400c
  80047c:	e8 08 01 00 00       	call   800589 <cprintf>
  800481:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800484:	e8 54 14 00 00       	call   8018dd <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800489:	e8 19 00 00 00       	call   8004a7 <exit>
}
  80048e:	90                   	nop
  80048f:	c9                   	leave  
  800490:	c3                   	ret    

00800491 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800491:	55                   	push   %ebp
  800492:	89 e5                	mov    %esp,%ebp
  800494:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800497:	83 ec 0c             	sub    $0xc,%esp
  80049a:	6a 00                	push   $0x0
  80049c:	e8 6a 16 00 00       	call   801b0b <sys_destroy_env>
  8004a1:	83 c4 10             	add    $0x10,%esp
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <exit>:

void
exit(void)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ad:	e8 bf 16 00 00       	call   801b71 <sys_exit_env>
}
  8004b2:	90                   	nop
  8004b3:	c9                   	leave  
  8004b4:	c3                   	ret    

008004b5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 48 01             	lea    0x1(%eax),%ecx
  8004c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c6:	89 0a                	mov    %ecx,(%edx)
  8004c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8004cb:	88 d1                	mov    %dl,%cl
  8004cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004de:	75 2c                	jne    80050c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004e0:	a0 28 50 80 00       	mov    0x805028,%al
  8004e5:	0f b6 c0             	movzbl %al,%eax
  8004e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004eb:	8b 12                	mov    (%edx),%edx
  8004ed:	89 d1                	mov    %edx,%ecx
  8004ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f2:	83 c2 08             	add    $0x8,%edx
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	50                   	push   %eax
  8004f9:	51                   	push   %ecx
  8004fa:	52                   	push   %edx
  8004fb:	e8 81 13 00 00       	call   801881 <sys_cputs>
  800500:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 40 04             	mov    0x4(%eax),%eax
  800512:	8d 50 01             	lea    0x1(%eax),%edx
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	89 50 04             	mov    %edx,0x4(%eax)
}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800527:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80052e:	00 00 00 
	b.cnt = 0;
  800531:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800538:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80053b:	ff 75 0c             	pushl  0xc(%ebp)
  80053e:	ff 75 08             	pushl  0x8(%ebp)
  800541:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800547:	50                   	push   %eax
  800548:	68 b5 04 80 00       	push   $0x8004b5
  80054d:	e8 11 02 00 00       	call   800763 <vprintfmt>
  800552:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800555:	a0 28 50 80 00       	mov    0x805028,%al
  80055a:	0f b6 c0             	movzbl %al,%eax
  80055d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	50                   	push   %eax
  800567:	52                   	push   %edx
  800568:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056e:	83 c0 08             	add    $0x8,%eax
  800571:	50                   	push   %eax
  800572:	e8 0a 13 00 00       	call   801881 <sys_cputs>
  800577:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80057a:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800581:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
  80058c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058f:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800596:	8d 45 0c             	lea    0xc(%ebp),%eax
  800599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a5:	50                   	push   %eax
  8005a6:	e8 73 ff ff ff       	call   80051e <vcprintf>
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    

008005b6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005bc:	e8 02 13 00 00       	call   8018c3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005c1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	83 ec 08             	sub    $0x8,%esp
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	50                   	push   %eax
  8005d1:	e8 48 ff ff ff       	call   80051e <vcprintf>
  8005d6:	83 c4 10             	add    $0x10,%esp
  8005d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005dc:	e8 fc 12 00 00       	call   8018dd <sys_unlock_cons>
	return cnt;
  8005e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	53                   	push   %ebx
  8005ea:	83 ec 14             	sub    $0x14,%esp
  8005ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800601:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800604:	77 55                	ja     80065b <printnum+0x75>
  800606:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800609:	72 05                	jb     800610 <printnum+0x2a>
  80060b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80060e:	77 4b                	ja     80065b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800610:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800613:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800616:	8b 45 18             	mov    0x18(%ebp),%eax
  800619:	ba 00 00 00 00       	mov    $0x0,%edx
  80061e:	52                   	push   %edx
  80061f:	50                   	push   %eax
  800620:	ff 75 f4             	pushl  -0xc(%ebp)
  800623:	ff 75 f0             	pushl  -0x10(%ebp)
  800626:	e8 fd 36 00 00       	call   803d28 <__udivdi3>
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	83 ec 04             	sub    $0x4,%esp
  800631:	ff 75 20             	pushl  0x20(%ebp)
  800634:	53                   	push   %ebx
  800635:	ff 75 18             	pushl  0x18(%ebp)
  800638:	52                   	push   %edx
  800639:	50                   	push   %eax
  80063a:	ff 75 0c             	pushl  0xc(%ebp)
  80063d:	ff 75 08             	pushl  0x8(%ebp)
  800640:	e8 a1 ff ff ff       	call   8005e6 <printnum>
  800645:	83 c4 20             	add    $0x20,%esp
  800648:	eb 1a                	jmp    800664 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 20             	pushl  0x20(%ebp)
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	ff d0                	call   *%eax
  800658:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80065b:	ff 4d 1c             	decl   0x1c(%ebp)
  80065e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800662:	7f e6                	jg     80064a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800664:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800667:	bb 00 00 00 00       	mov    $0x0,%ebx
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800672:	53                   	push   %ebx
  800673:	51                   	push   %ecx
  800674:	52                   	push   %edx
  800675:	50                   	push   %eax
  800676:	e8 bd 37 00 00       	call   803e38 <__umoddi3>
  80067b:	83 c4 10             	add    $0x10,%esp
  80067e:	05 f4 42 80 00       	add    $0x8042f4,%eax
  800683:	8a 00                	mov    (%eax),%al
  800685:	0f be c0             	movsbl %al,%eax
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	50                   	push   %eax
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	ff d0                	call   *%eax
  800694:	83 c4 10             	add    $0x10,%esp
}
  800697:	90                   	nop
  800698:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80069b:	c9                   	leave  
  80069c:	c3                   	ret    

0080069d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a4:	7e 1c                	jle    8006c2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	8d 50 08             	lea    0x8(%eax),%edx
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	89 10                	mov    %edx,(%eax)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	83 e8 08             	sub    $0x8,%eax
  8006bb:	8b 50 04             	mov    0x4(%eax),%edx
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	eb 40                	jmp    800702 <getuint+0x65>
	else if (lflag)
  8006c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c6:	74 1e                	je     8006e6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 04             	lea    0x4(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 04             	sub    $0x4,%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e4:	eb 1c                	jmp    800702 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	89 10                	mov    %edx,(%eax)
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	83 e8 04             	sub    $0x4,%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800702:	5d                   	pop    %ebp
  800703:	c3                   	ret    

00800704 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800707:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80070b:	7e 1c                	jle    800729 <getint+0x25>
		return va_arg(*ap, long long);
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	8d 50 08             	lea    0x8(%eax),%edx
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	89 10                	mov    %edx,(%eax)
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	83 e8 08             	sub    $0x8,%eax
  800722:	8b 50 04             	mov    0x4(%eax),%edx
  800725:	8b 00                	mov    (%eax),%eax
  800727:	eb 38                	jmp    800761 <getint+0x5d>
	else if (lflag)
  800729:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80072d:	74 1a                	je     800749 <getint+0x45>
		return va_arg(*ap, long);
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	8d 50 04             	lea    0x4(%eax),%edx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	89 10                	mov    %edx,(%eax)
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	83 e8 04             	sub    $0x4,%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	99                   	cltd   
  800747:	eb 18                	jmp    800761 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	8d 50 04             	lea    0x4(%eax),%edx
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	89 10                	mov    %edx,(%eax)
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	83 e8 04             	sub    $0x4,%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	99                   	cltd   
}
  800761:	5d                   	pop    %ebp
  800762:	c3                   	ret    

00800763 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800763:	55                   	push   %ebp
  800764:	89 e5                	mov    %esp,%ebp
  800766:	56                   	push   %esi
  800767:	53                   	push   %ebx
  800768:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076b:	eb 17                	jmp    800784 <vprintfmt+0x21>
			if (ch == '\0')
  80076d:	85 db                	test   %ebx,%ebx
  80076f:	0f 84 c1 03 00 00    	je     800b36 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	53                   	push   %ebx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	ff d0                	call   *%eax
  800781:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800784:	8b 45 10             	mov    0x10(%ebp),%eax
  800787:	8d 50 01             	lea    0x1(%eax),%edx
  80078a:	89 55 10             	mov    %edx,0x10(%ebp)
  80078d:	8a 00                	mov    (%eax),%al
  80078f:	0f b6 d8             	movzbl %al,%ebx
  800792:	83 fb 25             	cmp    $0x25,%ebx
  800795:	75 d6                	jne    80076d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800797:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80079b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007a2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007b0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ba:	8d 50 01             	lea    0x1(%eax),%edx
  8007bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8007c0:	8a 00                	mov    (%eax),%al
  8007c2:	0f b6 d8             	movzbl %al,%ebx
  8007c5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c8:	83 f8 5b             	cmp    $0x5b,%eax
  8007cb:	0f 87 3d 03 00 00    	ja     800b0e <vprintfmt+0x3ab>
  8007d1:	8b 04 85 18 43 80 00 	mov    0x804318(,%eax,4),%eax
  8007d8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007da:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007de:	eb d7                	jmp    8007b7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007e0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e4:	eb d1                	jmp    8007b7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007f0:	89 d0                	mov    %edx,%eax
  8007f2:	c1 e0 02             	shl    $0x2,%eax
  8007f5:	01 d0                	add    %edx,%eax
  8007f7:	01 c0                	add    %eax,%eax
  8007f9:	01 d8                	add    %ebx,%eax
  8007fb:	83 e8 30             	sub    $0x30,%eax
  8007fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800801:	8b 45 10             	mov    0x10(%ebp),%eax
  800804:	8a 00                	mov    (%eax),%al
  800806:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800809:	83 fb 2f             	cmp    $0x2f,%ebx
  80080c:	7e 3e                	jle    80084c <vprintfmt+0xe9>
  80080e:	83 fb 39             	cmp    $0x39,%ebx
  800811:	7f 39                	jg     80084c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800813:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800816:	eb d5                	jmp    8007ed <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	83 c0 04             	add    $0x4,%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	83 e8 04             	sub    $0x4,%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80082c:	eb 1f                	jmp    80084d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	79 83                	jns    8007b7 <vprintfmt+0x54>
				width = 0;
  800834:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80083b:	e9 77 ff ff ff       	jmp    8007b7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800840:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800847:	e9 6b ff ff ff       	jmp    8007b7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80084c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80084d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800851:	0f 89 60 ff ff ff    	jns    8007b7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800857:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80085a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80085d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800864:	e9 4e ff ff ff       	jmp    8007b7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800869:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80086c:	e9 46 ff ff ff       	jmp    8007b7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	83 c0 04             	add    $0x4,%eax
  800877:	89 45 14             	mov    %eax,0x14(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	83 e8 04             	sub    $0x4,%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	50                   	push   %eax
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	ff d0                	call   *%eax
  80088e:	83 c4 10             	add    $0x10,%esp
			break;
  800891:	e9 9b 02 00 00       	jmp    800b31 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800896:	8b 45 14             	mov    0x14(%ebp),%eax
  800899:	83 c0 04             	add    $0x4,%eax
  80089c:	89 45 14             	mov    %eax,0x14(%ebp)
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	83 e8 04             	sub    $0x4,%eax
  8008a5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a7:	85 db                	test   %ebx,%ebx
  8008a9:	79 02                	jns    8008ad <vprintfmt+0x14a>
				err = -err;
  8008ab:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ad:	83 fb 64             	cmp    $0x64,%ebx
  8008b0:	7f 0b                	jg     8008bd <vprintfmt+0x15a>
  8008b2:	8b 34 9d 60 41 80 00 	mov    0x804160(,%ebx,4),%esi
  8008b9:	85 f6                	test   %esi,%esi
  8008bb:	75 19                	jne    8008d6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008bd:	53                   	push   %ebx
  8008be:	68 05 43 80 00       	push   $0x804305
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	ff 75 08             	pushl  0x8(%ebp)
  8008c9:	e8 70 02 00 00       	call   800b3e <printfmt>
  8008ce:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008d1:	e9 5b 02 00 00       	jmp    800b31 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d6:	56                   	push   %esi
  8008d7:	68 0e 43 80 00       	push   $0x80430e
  8008dc:	ff 75 0c             	pushl  0xc(%ebp)
  8008df:	ff 75 08             	pushl  0x8(%ebp)
  8008e2:	e8 57 02 00 00       	call   800b3e <printfmt>
  8008e7:	83 c4 10             	add    $0x10,%esp
			break;
  8008ea:	e9 42 02 00 00       	jmp    800b31 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	83 c0 04             	add    $0x4,%eax
  8008f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fb:	83 e8 04             	sub    $0x4,%eax
  8008fe:	8b 30                	mov    (%eax),%esi
  800900:	85 f6                	test   %esi,%esi
  800902:	75 05                	jne    800909 <vprintfmt+0x1a6>
				p = "(null)";
  800904:	be 11 43 80 00       	mov    $0x804311,%esi
			if (width > 0 && padc != '-')
  800909:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090d:	7e 6d                	jle    80097c <vprintfmt+0x219>
  80090f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800913:	74 67                	je     80097c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800915:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	50                   	push   %eax
  80091c:	56                   	push   %esi
  80091d:	e8 1e 03 00 00       	call   800c40 <strnlen>
  800922:	83 c4 10             	add    $0x10,%esp
  800925:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800928:	eb 16                	jmp    800940 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80092a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	ff d0                	call   *%eax
  80093a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80093d:	ff 4d e4             	decl   -0x1c(%ebp)
  800940:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800944:	7f e4                	jg     80092a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800946:	eb 34                	jmp    80097c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800948:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80094c:	74 1c                	je     80096a <vprintfmt+0x207>
  80094e:	83 fb 1f             	cmp    $0x1f,%ebx
  800951:	7e 05                	jle    800958 <vprintfmt+0x1f5>
  800953:	83 fb 7e             	cmp    $0x7e,%ebx
  800956:	7e 12                	jle    80096a <vprintfmt+0x207>
					putch('?', putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	6a 3f                	push   $0x3f
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	ff d0                	call   *%eax
  800965:	83 c4 10             	add    $0x10,%esp
  800968:	eb 0f                	jmp    800979 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 0c             	pushl  0xc(%ebp)
  800970:	53                   	push   %ebx
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	ff d0                	call   *%eax
  800976:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800979:	ff 4d e4             	decl   -0x1c(%ebp)
  80097c:	89 f0                	mov    %esi,%eax
  80097e:	8d 70 01             	lea    0x1(%eax),%esi
  800981:	8a 00                	mov    (%eax),%al
  800983:	0f be d8             	movsbl %al,%ebx
  800986:	85 db                	test   %ebx,%ebx
  800988:	74 24                	je     8009ae <vprintfmt+0x24b>
  80098a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098e:	78 b8                	js     800948 <vprintfmt+0x1e5>
  800990:	ff 4d e0             	decl   -0x20(%ebp)
  800993:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800997:	79 af                	jns    800948 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800999:	eb 13                	jmp    8009ae <vprintfmt+0x24b>
				putch(' ', putdat);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	6a 20                	push   $0x20
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	ff d0                	call   *%eax
  8009a8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ab:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b2:	7f e7                	jg     80099b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b4:	e9 78 01 00 00       	jmp    800b31 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bf:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c2:	50                   	push   %eax
  8009c3:	e8 3c fd ff ff       	call   800704 <getint>
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d7:	85 d2                	test   %edx,%edx
  8009d9:	79 23                	jns    8009fe <vprintfmt+0x29b>
				putch('-', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 2d                	push   $0x2d
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f1:	f7 d8                	neg    %eax
  8009f3:	83 d2 00             	adc    $0x0,%edx
  8009f6:	f7 da                	neg    %edx
  8009f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009fe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a05:	e9 bc 00 00 00       	jmp    800ac6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
  800a13:	50                   	push   %eax
  800a14:	e8 84 fc ff ff       	call   80069d <getuint>
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a22:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a29:	e9 98 00 00 00       	jmp    800ac6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 58                	push   $0x58
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	ff 75 0c             	pushl  0xc(%ebp)
  800a44:	6a 58                	push   $0x58
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	ff d0                	call   *%eax
  800a4b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	6a 58                	push   $0x58
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
			break;
  800a5e:	e9 ce 00 00 00       	jmp    800b31 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	6a 30                	push   $0x30
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	6a 78                	push   $0x78
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	ff d0                	call   *%eax
  800a80:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	83 c0 04             	add    $0x4,%eax
  800a89:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8f:	83 e8 04             	sub    $0x4,%eax
  800a92:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a9e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aa5:	eb 1f                	jmp    800ac6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 e8             	pushl  -0x18(%ebp)
  800aad:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab0:	50                   	push   %eax
  800ab1:	e8 e7 fb ff ff       	call   80069d <getuint>
  800ab6:	83 c4 10             	add    $0x10,%esp
  800ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800abc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800abf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800acd:	83 ec 04             	sub    $0x4,%esp
  800ad0:	52                   	push   %edx
  800ad1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad4:	50                   	push   %eax
  800ad5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad8:	ff 75 f0             	pushl  -0x10(%ebp)
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	ff 75 08             	pushl  0x8(%ebp)
  800ae1:	e8 00 fb ff ff       	call   8005e6 <printnum>
  800ae6:	83 c4 20             	add    $0x20,%esp
			break;
  800ae9:	eb 46                	jmp    800b31 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	53                   	push   %ebx
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
			break;
  800afa:	eb 35                	jmp    800b31 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800afc:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800b03:	eb 2c                	jmp    800b31 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b05:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800b0c:	eb 23                	jmp    800b31 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	6a 25                	push   $0x25
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	ff d0                	call   *%eax
  800b1b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b1e:	ff 4d 10             	decl   0x10(%ebp)
  800b21:	eb 03                	jmp    800b26 <vprintfmt+0x3c3>
  800b23:	ff 4d 10             	decl   0x10(%ebp)
  800b26:	8b 45 10             	mov    0x10(%ebp),%eax
  800b29:	48                   	dec    %eax
  800b2a:	8a 00                	mov    (%eax),%al
  800b2c:	3c 25                	cmp    $0x25,%al
  800b2e:	75 f3                	jne    800b23 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b30:	90                   	nop
		}
	}
  800b31:	e9 35 fc ff ff       	jmp    80076b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b36:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3a:	5b                   	pop    %ebx
  800b3b:	5e                   	pop    %esi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b44:	8d 45 10             	lea    0x10(%ebp),%eax
  800b47:	83 c0 04             	add    $0x4,%eax
  800b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b50:	ff 75 f4             	pushl  -0xc(%ebp)
  800b53:	50                   	push   %eax
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	ff 75 08             	pushl  0x8(%ebp)
  800b5a:	e8 04 fc ff ff       	call   800763 <vprintfmt>
  800b5f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b62:	90                   	nop
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	8b 40 08             	mov    0x8(%eax),%eax
  800b6e:	8d 50 01             	lea    0x1(%eax),%edx
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7a:	8b 10                	mov    (%eax),%edx
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	8b 40 04             	mov    0x4(%eax),%eax
  800b82:	39 c2                	cmp    %eax,%edx
  800b84:	73 12                	jae    800b98 <sprintputch+0x33>
		*b->buf++ = ch;
  800b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b89:	8b 00                	mov    (%eax),%eax
  800b8b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b91:	89 0a                	mov    %ecx,(%edx)
  800b93:	8b 55 08             	mov    0x8(%ebp),%edx
  800b96:	88 10                	mov    %dl,(%eax)
}
  800b98:	90                   	nop
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	01 d0                	add    %edx,%eax
  800bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc0:	74 06                	je     800bc8 <vsnprintf+0x2d>
  800bc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc6:	7f 07                	jg     800bcf <vsnprintf+0x34>
		return -E_INVAL;
  800bc8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcd:	eb 20                	jmp    800bef <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bcf:	ff 75 14             	pushl  0x14(%ebp)
  800bd2:	ff 75 10             	pushl  0x10(%ebp)
  800bd5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bd8:	50                   	push   %eax
  800bd9:	68 65 0b 80 00       	push   $0x800b65
  800bde:	e8 80 fb ff ff       	call   800763 <vprintfmt>
  800be3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfa:	83 c0 04             	add    $0x4,%eax
  800bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	ff 75 f4             	pushl  -0xc(%ebp)
  800c06:	50                   	push   %eax
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	ff 75 08             	pushl  0x8(%ebp)
  800c0d:	e8 89 ff ff ff       	call   800b9b <vsnprintf>
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2a:	eb 06                	jmp    800c32 <strlen+0x15>
		n++;
  800c2c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c2f:	ff 45 08             	incl   0x8(%ebp)
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	84 c0                	test   %al,%al
  800c39:	75 f1                	jne    800c2c <strlen+0xf>
		n++;
	return n;
  800c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4d:	eb 09                	jmp    800c58 <strnlen+0x18>
		n++;
  800c4f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c52:	ff 45 08             	incl   0x8(%ebp)
  800c55:	ff 4d 0c             	decl   0xc(%ebp)
  800c58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5c:	74 09                	je     800c67 <strnlen+0x27>
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	84 c0                	test   %al,%al
  800c65:	75 e8                	jne    800c4f <strnlen+0xf>
		n++;
	return n;
  800c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c78:	90                   	nop
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8b:	8a 12                	mov    (%edx),%dl
  800c8d:	88 10                	mov    %dl,(%eax)
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	75 e4                	jne    800c79 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cad:	eb 1f                	jmp    800cce <strncpy+0x34>
		*dst++ = *src;
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8d 50 01             	lea    0x1(%eax),%edx
  800cb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbb:	8a 12                	mov    (%edx),%dl
  800cbd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	84 c0                	test   %al,%al
  800cc6:	74 03                	je     800ccb <strncpy+0x31>
			src++;
  800cc8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccb:	ff 45 fc             	incl   -0x4(%ebp)
  800cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd4:	72 d9                	jb     800caf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ceb:	74 30                	je     800d1d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ced:	eb 16                	jmp    800d05 <strlcpy+0x2a>
			*dst++ = *src++;
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d01:	8a 12                	mov    (%edx),%dl
  800d03:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d05:	ff 4d 10             	decl   0x10(%ebp)
  800d08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0c:	74 09                	je     800d17 <strlcpy+0x3c>
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	84 c0                	test   %al,%al
  800d15:	75 d8                	jne    800cef <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d23:	29 c2                	sub    %eax,%edx
  800d25:	89 d0                	mov    %edx,%eax
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2c:	eb 06                	jmp    800d34 <strcmp+0xb>
		p++, q++;
  800d2e:	ff 45 08             	incl   0x8(%ebp)
  800d31:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	84 c0                	test   %al,%al
  800d3b:	74 0e                	je     800d4b <strcmp+0x22>
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8a 10                	mov    (%eax),%dl
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	38 c2                	cmp    %al,%dl
  800d49:	74 e3                	je     800d2e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	0f b6 d0             	movzbl %al,%edx
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	0f b6 c0             	movzbl %al,%eax
  800d5b:	29 c2                	sub    %eax,%edx
  800d5d:	89 d0                	mov    %edx,%eax
}
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    

00800d61 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d64:	eb 09                	jmp    800d6f <strncmp+0xe>
		n--, p++, q++;
  800d66:	ff 4d 10             	decl   0x10(%ebp)
  800d69:	ff 45 08             	incl   0x8(%ebp)
  800d6c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d73:	74 17                	je     800d8c <strncmp+0x2b>
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 0e                	je     800d8c <strncmp+0x2b>
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 10                	mov    (%eax),%dl
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	38 c2                	cmp    %al,%dl
  800d8a:	74 da                	je     800d66 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d90:	75 07                	jne    800d99 <strncmp+0x38>
		return 0;
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
  800d97:	eb 14                	jmp    800dad <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	0f b6 d0             	movzbl %al,%edx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	0f b6 c0             	movzbl %al,%eax
  800da9:	29 c2                	sub    %eax,%edx
  800dab:	89 d0                	mov    %edx,%eax
}
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 04             	sub    $0x4,%esp
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbb:	eb 12                	jmp    800dcf <strchr+0x20>
		if (*s == c)
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc5:	75 05                	jne    800dcc <strchr+0x1d>
			return (char *) s;
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	eb 11                	jmp    800ddd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dcc:	ff 45 08             	incl   0x8(%ebp)
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	84 c0                	test   %al,%al
  800dd6:	75 e5                	jne    800dbd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	83 ec 04             	sub    $0x4,%esp
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800deb:	eb 0d                	jmp    800dfa <strfind+0x1b>
		if (*s == c)
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df5:	74 0e                	je     800e05 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df7:	ff 45 08             	incl   0x8(%ebp)
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	84 c0                	test   %al,%al
  800e01:	75 ea                	jne    800ded <strfind+0xe>
  800e03:	eb 01                	jmp    800e06 <strfind+0x27>
		if (*s == c)
			break;
  800e05:	90                   	nop
	return (char *) s;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e09:	c9                   	leave  
  800e0a:	c3                   	ret    

00800e0b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e17:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1d:	eb 0e                	jmp    800e2d <memset+0x22>
		*p++ = c;
  800e1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e22:	8d 50 01             	lea    0x1(%eax),%edx
  800e25:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2d:	ff 4d f8             	decl   -0x8(%ebp)
  800e30:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e34:	79 e9                	jns    800e1f <memset+0x14>
		*p++ = c;

	return v;
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4d:	eb 16                	jmp    800e65 <memcpy+0x2a>
		*d++ = *s++;
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	8d 50 01             	lea    0x1(%eax),%edx
  800e55:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e61:	8a 12                	mov    (%edx),%dl
  800e63:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 dd                	jne    800e4f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e8f:	73 50                	jae    800ee1 <memmove+0x6a>
  800e91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e94:	8b 45 10             	mov    0x10(%ebp),%eax
  800e97:	01 d0                	add    %edx,%eax
  800e99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9c:	76 43                	jbe    800ee1 <memmove+0x6a>
		s += n;
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eaa:	eb 10                	jmp    800ebc <memmove+0x45>
			*--d = *--s;
  800eac:	ff 4d f8             	decl   -0x8(%ebp)
  800eaf:	ff 4d fc             	decl   -0x4(%ebp)
  800eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb5:	8a 10                	mov    (%eax),%dl
  800eb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eba:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	75 e3                	jne    800eac <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ec9:	eb 23                	jmp    800eee <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ece:	8d 50 01             	lea    0x1(%eax),%edx
  800ed1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eda:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edd:	8a 12                	mov    (%edx),%dl
  800edf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eea:	85 c0                	test   %eax,%eax
  800eec:	75 dd                	jne    800ecb <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f05:	eb 2a                	jmp    800f31 <memcmp+0x3e>
		if (*s1 != *s2)
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	8a 10                	mov    (%eax),%dl
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	38 c2                	cmp    %al,%dl
  800f13:	74 16                	je     800f2b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	0f b6 d0             	movzbl %al,%edx
  800f1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	0f b6 c0             	movzbl %al,%eax
  800f25:	29 c2                	sub    %eax,%edx
  800f27:	89 d0                	mov    %edx,%eax
  800f29:	eb 18                	jmp    800f43 <memcmp+0x50>
		s1++, s2++;
  800f2b:	ff 45 fc             	incl   -0x4(%ebp)
  800f2e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f31:	8b 45 10             	mov    0x10(%ebp),%eax
  800f34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f37:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	75 c9                	jne    800f07 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f43:	c9                   	leave  
  800f44:	c3                   	ret    

00800f45 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f51:	01 d0                	add    %edx,%eax
  800f53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f56:	eb 15                	jmp    800f6d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	0f b6 d0             	movzbl %al,%edx
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	39 c2                	cmp    %eax,%edx
  800f68:	74 0d                	je     800f77 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6a:	ff 45 08             	incl   0x8(%ebp)
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f73:	72 e3                	jb     800f58 <memfind+0x13>
  800f75:	eb 01                	jmp    800f78 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f77:	90                   	nop
	return (void *) s;
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7b:	c9                   	leave  
  800f7c:	c3                   	ret    

00800f7d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f91:	eb 03                	jmp    800f96 <strtol+0x19>
		s++;
  800f93:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 20                	cmp    $0x20,%al
  800f9d:	74 f4                	je     800f93 <strtol+0x16>
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3c 09                	cmp    $0x9,%al
  800fa6:	74 eb                	je     800f93 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	3c 2b                	cmp    $0x2b,%al
  800faf:	75 05                	jne    800fb6 <strtol+0x39>
		s++;
  800fb1:	ff 45 08             	incl   0x8(%ebp)
  800fb4:	eb 13                	jmp    800fc9 <strtol+0x4c>
	else if (*s == '-')
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 2d                	cmp    $0x2d,%al
  800fbd:	75 0a                	jne    800fc9 <strtol+0x4c>
		s++, neg = 1;
  800fbf:	ff 45 08             	incl   0x8(%ebp)
  800fc2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcd:	74 06                	je     800fd5 <strtol+0x58>
  800fcf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd3:	75 20                	jne    800ff5 <strtol+0x78>
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 30                	cmp    $0x30,%al
  800fdc:	75 17                	jne    800ff5 <strtol+0x78>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	40                   	inc    %eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	3c 78                	cmp    $0x78,%al
  800fe6:	75 0d                	jne    800ff5 <strtol+0x78>
		s += 2, base = 16;
  800fe8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fec:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff3:	eb 28                	jmp    80101d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff9:	75 15                	jne    801010 <strtol+0x93>
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	3c 30                	cmp    $0x30,%al
  801002:	75 0c                	jne    801010 <strtol+0x93>
		s++, base = 8;
  801004:	ff 45 08             	incl   0x8(%ebp)
  801007:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80100e:	eb 0d                	jmp    80101d <strtol+0xa0>
	else if (base == 0)
  801010:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801014:	75 07                	jne    80101d <strtol+0xa0>
		base = 10;
  801016:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 2f                	cmp    $0x2f,%al
  801024:	7e 19                	jle    80103f <strtol+0xc2>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 39                	cmp    $0x39,%al
  80102d:	7f 10                	jg     80103f <strtol+0xc2>
			dig = *s - '0';
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	0f be c0             	movsbl %al,%eax
  801037:	83 e8 30             	sub    $0x30,%eax
  80103a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103d:	eb 42                	jmp    801081 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 60                	cmp    $0x60,%al
  801046:	7e 19                	jle    801061 <strtol+0xe4>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 7a                	cmp    $0x7a,%al
  80104f:	7f 10                	jg     801061 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	0f be c0             	movsbl %al,%eax
  801059:	83 e8 57             	sub    $0x57,%eax
  80105c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80105f:	eb 20                	jmp    801081 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	3c 40                	cmp    $0x40,%al
  801068:	7e 39                	jle    8010a3 <strtol+0x126>
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	3c 5a                	cmp    $0x5a,%al
  801071:	7f 30                	jg     8010a3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	0f be c0             	movsbl %al,%eax
  80107b:	83 e8 37             	sub    $0x37,%eax
  80107e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801084:	3b 45 10             	cmp    0x10(%ebp),%eax
  801087:	7d 19                	jge    8010a2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801089:	ff 45 08             	incl   0x8(%ebp)
  80108c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801093:	89 c2                	mov    %eax,%edx
  801095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801098:	01 d0                	add    %edx,%eax
  80109a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109d:	e9 7b ff ff ff       	jmp    80101d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a7:	74 08                	je     8010b1 <strtol+0x134>
		*endptr = (char *) s;
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8010af:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b5:	74 07                	je     8010be <strtol+0x141>
  8010b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ba:	f7 d8                	neg    %eax
  8010bc:	eb 03                	jmp    8010c1 <strtol+0x144>
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010db:	79 13                	jns    8010f0 <ltostr+0x2d>
	{
		neg = 1;
  8010dd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ea:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ed:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010f8:	99                   	cltd   
  8010f9:	f7 f9                	idiv   %ecx
  8010fb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801107:	89 c2                	mov    %eax,%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 d0                	add    %edx,%eax
  80110e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801111:	83 c2 30             	add    $0x30,%edx
  801114:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801119:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111e:	f7 e9                	imul   %ecx
  801120:	c1 fa 02             	sar    $0x2,%edx
  801123:	89 c8                	mov    %ecx,%eax
  801125:	c1 f8 1f             	sar    $0x1f,%eax
  801128:	29 c2                	sub    %eax,%edx
  80112a:	89 d0                	mov    %edx,%eax
  80112c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80112f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801133:	75 bb                	jne    8010f0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801135:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80113c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113f:	48                   	dec    %eax
  801140:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801143:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801147:	74 3d                	je     801186 <ltostr+0xc3>
		start = 1 ;
  801149:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801150:	eb 34                	jmp    801186 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801152:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801155:	8b 45 0c             	mov    0xc(%ebp),%eax
  801158:	01 d0                	add    %edx,%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80115f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	01 c2                	add    %eax,%edx
  801167:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	01 c8                	add    %ecx,%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801173:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 c2                	add    %eax,%edx
  80117b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80117e:	88 02                	mov    %al,(%edx)
		start++ ;
  801180:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801183:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801189:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80118c:	7c c4                	jl     801152 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80118e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	01 d0                	add    %edx,%eax
  801196:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801199:	90                   	nop
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011a2:	ff 75 08             	pushl  0x8(%ebp)
  8011a5:	e8 73 fa ff ff       	call   800c1d <strlen>
  8011aa:	83 c4 04             	add    $0x4,%esp
  8011ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b0:	ff 75 0c             	pushl  0xc(%ebp)
  8011b3:	e8 65 fa ff ff       	call   800c1d <strlen>
  8011b8:	83 c4 04             	add    $0x4,%esp
  8011bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011cc:	eb 17                	jmp    8011e5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d4:	01 c2                	add    %eax,%edx
  8011d6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	01 c8                	add    %ecx,%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011e2:	ff 45 fc             	incl   -0x4(%ebp)
  8011e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011eb:	7c e1                	jl     8011ce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011fb:	eb 1f                	jmp    80121c <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801200:	8d 50 01             	lea    0x1(%eax),%edx
  801203:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801206:	89 c2                	mov    %eax,%edx
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	01 c2                	add    %eax,%edx
  80120d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c8                	add    %ecx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801219:	ff 45 f8             	incl   -0x8(%ebp)
  80121c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801222:	7c d9                	jl     8011fd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801227:	8b 45 10             	mov    0x10(%ebp),%eax
  80122a:	01 d0                	add    %edx,%eax
  80122c:	c6 00 00             	movb   $0x0,(%eax)
}
  80122f:	90                   	nop
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801235:	8b 45 14             	mov    0x14(%ebp),%eax
  801238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80124a:	8b 45 10             	mov    0x10(%ebp),%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801255:	eb 0c                	jmp    801263 <strsplit+0x31>
			*string++ = 0;
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8d 50 01             	lea    0x1(%eax),%edx
  80125d:	89 55 08             	mov    %edx,0x8(%ebp)
  801260:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	84 c0                	test   %al,%al
  80126a:	74 18                	je     801284 <strsplit+0x52>
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	0f be c0             	movsbl %al,%eax
  801274:	50                   	push   %eax
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	e8 32 fb ff ff       	call   800daf <strchr>
  80127d:	83 c4 08             	add    $0x8,%esp
  801280:	85 c0                	test   %eax,%eax
  801282:	75 d3                	jne    801257 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	84 c0                	test   %al,%al
  80128b:	74 5a                	je     8012e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80128d:	8b 45 14             	mov    0x14(%ebp),%eax
  801290:	8b 00                	mov    (%eax),%eax
  801292:	83 f8 0f             	cmp    $0xf,%eax
  801295:	75 07                	jne    80129e <strsplit+0x6c>
		{
			return 0;
  801297:	b8 00 00 00 00       	mov    $0x0,%eax
  80129c:	eb 66                	jmp    801304 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80129e:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a1:	8b 00                	mov    (%eax),%eax
  8012a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8012a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8012a9:	89 0a                	mov    %ecx,(%edx)
  8012ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b5:	01 c2                	add    %eax,%edx
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012bc:	eb 03                	jmp    8012c1 <strsplit+0x8f>
			string++;
  8012be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	84 c0                	test   %al,%al
  8012c8:	74 8b                	je     801255 <strsplit+0x23>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	e8 d4 fa ff ff       	call   800daf <strchr>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	74 dc                	je     8012be <strsplit+0x8c>
			string++;
	}
  8012e2:	e9 6e ff ff ff       	jmp    801255 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012eb:	8b 00                	mov    (%eax),%eax
  8012ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	01 d0                	add    %edx,%eax
  8012f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80130c:	83 ec 04             	sub    $0x4,%esp
  80130f:	68 88 44 80 00       	push   $0x804488
  801314:	68 3f 01 00 00       	push   $0x13f
  801319:	68 aa 44 80 00       	push   $0x8044aa
  80131e:	e8 1c 28 00 00       	call   803b3f <_panic>

00801323 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	ff 75 08             	pushl  0x8(%ebp)
  80132f:	e8 f8 0a 00 00       	call   801e2c <sys_sbrk>
  801334:	83 c4 10             	add    $0x10,%esp
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80133f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801343:	75 0a                	jne    80134f <malloc+0x16>
  801345:	b8 00 00 00 00       	mov    $0x0,%eax
  80134a:	e9 07 02 00 00       	jmp    801556 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  80134f:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801356:	8b 55 08             	mov    0x8(%ebp),%edx
  801359:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80135c:	01 d0                	add    %edx,%eax
  80135e:	48                   	dec    %eax
  80135f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801362:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801365:	ba 00 00 00 00       	mov    $0x0,%edx
  80136a:	f7 75 dc             	divl   -0x24(%ebp)
  80136d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801370:	29 d0                	sub    %edx,%eax
  801372:	c1 e8 0c             	shr    $0xc,%eax
  801375:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801378:	a1 20 50 80 00       	mov    0x805020,%eax
  80137d:	8b 40 78             	mov    0x78(%eax),%eax
  801380:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801385:	29 c2                	sub    %eax,%edx
  801387:	89 d0                	mov    %edx,%eax
  801389:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80138c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80138f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801394:	c1 e8 0c             	shr    $0xc,%eax
  801397:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80139a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8013a1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8013a8:	77 42                	ja     8013ec <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8013aa:	e8 01 09 00 00       	call   801cb0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	74 16                	je     8013c9 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	ff 75 08             	pushl  0x8(%ebp)
  8013b9:	e8 dd 0e 00 00       	call   80229b <alloc_block_FF>
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013c4:	e9 8a 01 00 00       	jmp    801553 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013c9:	e8 13 09 00 00       	call   801ce1 <sys_isUHeapPlacementStrategyBESTFIT>
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	0f 84 7d 01 00 00    	je     801553 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013d6:	83 ec 0c             	sub    $0xc,%esp
  8013d9:	ff 75 08             	pushl  0x8(%ebp)
  8013dc:	e8 76 13 00 00       	call   802757 <alloc_block_BF>
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013e7:	e9 67 01 00 00       	jmp    801553 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8013ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8013ef:	48                   	dec    %eax
  8013f0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8013f3:	0f 86 53 01 00 00    	jbe    80154c <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8013f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8013fe:	8b 40 78             	mov    0x78(%eax),%eax
  801401:	05 00 10 00 00       	add    $0x1000,%eax
  801406:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801409:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801410:	e9 de 00 00 00       	jmp    8014f3 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801415:	a1 20 50 80 00       	mov    0x805020,%eax
  80141a:	8b 40 78             	mov    0x78(%eax),%eax
  80141d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801420:	29 c2                	sub    %eax,%edx
  801422:	89 d0                	mov    %edx,%eax
  801424:	2d 00 10 00 00       	sub    $0x1000,%eax
  801429:	c1 e8 0c             	shr    $0xc,%eax
  80142c:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801433:	85 c0                	test   %eax,%eax
  801435:	0f 85 ab 00 00 00    	jne    8014e6 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  80143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143e:	05 00 10 00 00       	add    $0x1000,%eax
  801443:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801446:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  80144d:	eb 47                	jmp    801496 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  80144f:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801456:	76 0a                	jbe    801462 <malloc+0x129>
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	e9 f4 00 00 00       	jmp    801556 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801462:	a1 20 50 80 00       	mov    0x805020,%eax
  801467:	8b 40 78             	mov    0x78(%eax),%eax
  80146a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80146d:	29 c2                	sub    %eax,%edx
  80146f:	89 d0                	mov    %edx,%eax
  801471:	2d 00 10 00 00       	sub    $0x1000,%eax
  801476:	c1 e8 0c             	shr    $0xc,%eax
  801479:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801480:	85 c0                	test   %eax,%eax
  801482:	74 08                	je     80148c <malloc+0x153>
					{
						
						i = j;
  801484:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801487:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  80148a:	eb 5a                	jmp    8014e6 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  80148c:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801493:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801496:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801499:	48                   	dec    %eax
  80149a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80149d:	77 b0                	ja     80144f <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80149f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8014a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8014ad:	eb 2f                	jmp    8014de <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8014af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b2:	c1 e0 0c             	shl    $0xc,%eax
  8014b5:	89 c2                	mov    %eax,%edx
  8014b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ba:	01 c2                	add    %eax,%edx
  8014bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8014c1:	8b 40 78             	mov    0x78(%eax),%eax
  8014c4:	29 c2                	sub    %eax,%edx
  8014c6:	89 d0                	mov    %edx,%eax
  8014c8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014cd:	c1 e8 0c             	shr    $0xc,%eax
  8014d0:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  8014d7:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8014db:	ff 45 e0             	incl   -0x20(%ebp)
  8014de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8014e4:	72 c9                	jb     8014af <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  8014e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014ea:	75 16                	jne    801502 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8014ec:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8014f3:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8014fa:	0f 86 15 ff ff ff    	jbe    801415 <malloc+0xdc>
  801500:	eb 01                	jmp    801503 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801502:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801503:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801507:	75 07                	jne    801510 <malloc+0x1d7>
  801509:	b8 00 00 00 00       	mov    $0x0,%eax
  80150e:	eb 46                	jmp    801556 <malloc+0x21d>
		ptr = (void*)i;
  801510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801513:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801516:	a1 20 50 80 00       	mov    0x805020,%eax
  80151b:	8b 40 78             	mov    0x78(%eax),%eax
  80151e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801521:	29 c2                	sub    %eax,%edx
  801523:	89 d0                	mov    %edx,%eax
  801525:	2d 00 10 00 00       	sub    $0x1000,%eax
  80152a:	c1 e8 0c             	shr    $0xc,%eax
  80152d:	89 c2                	mov    %eax,%edx
  80152f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801532:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801539:	83 ec 08             	sub    $0x8,%esp
  80153c:	ff 75 08             	pushl  0x8(%ebp)
  80153f:	ff 75 f0             	pushl  -0x10(%ebp)
  801542:	e8 1c 09 00 00       	call   801e63 <sys_allocate_user_mem>
  801547:	83 c4 10             	add    $0x10,%esp
  80154a:	eb 07                	jmp    801553 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  80154c:	b8 00 00 00 00       	mov    $0x0,%eax
  801551:	eb 03                	jmp    801556 <malloc+0x21d>
	}
	return ptr;
  801553:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  80155e:	a1 20 50 80 00       	mov    0x805020,%eax
  801563:	8b 40 78             	mov    0x78(%eax),%eax
  801566:	05 00 10 00 00       	add    $0x1000,%eax
  80156b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  80156e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801575:	a1 20 50 80 00       	mov    0x805020,%eax
  80157a:	8b 50 78             	mov    0x78(%eax),%edx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	39 c2                	cmp    %eax,%edx
  801582:	76 24                	jbe    8015a8 <free+0x50>
		size = get_block_size(va);
  801584:	83 ec 0c             	sub    $0xc,%esp
  801587:	ff 75 08             	pushl  0x8(%ebp)
  80158a:	e8 8c 09 00 00       	call   801f1b <get_block_size>
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801595:	83 ec 0c             	sub    $0xc,%esp
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 9c 1b 00 00       	call   80313c <free_block>
  8015a0:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8015a3:	e9 ac 00 00 00       	jmp    801654 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015ae:	0f 82 89 00 00 00    	jb     80163d <free+0xe5>
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8015bc:	77 7f                	ja     80163d <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8015be:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8015c6:	8b 40 78             	mov    0x78(%eax),%eax
  8015c9:	29 c2                	sub    %eax,%edx
  8015cb:	89 d0                	mov    %edx,%eax
  8015cd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015d2:	c1 e8 0c             	shr    $0xc,%eax
  8015d5:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  8015dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8015df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e2:	c1 e0 0c             	shl    $0xc,%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8015e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015ef:	eb 42                	jmp    801633 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f4:	c1 e0 0c             	shl    $0xc,%eax
  8015f7:	89 c2                	mov    %eax,%edx
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	01 c2                	add    %eax,%edx
  8015fe:	a1 20 50 80 00       	mov    0x805020,%eax
  801603:	8b 40 78             	mov    0x78(%eax),%eax
  801606:	29 c2                	sub    %eax,%edx
  801608:	89 d0                	mov    %edx,%eax
  80160a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80160f:	c1 e8 0c             	shr    $0xc,%eax
  801612:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801619:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  80161d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	52                   	push   %edx
  801627:	50                   	push   %eax
  801628:	e8 1a 08 00 00       	call   801e47 <sys_free_user_mem>
  80162d:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801630:	ff 45 f4             	incl   -0xc(%ebp)
  801633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801636:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801639:	72 b6                	jb     8015f1 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80163b:	eb 17                	jmp    801654 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	68 b8 44 80 00       	push   $0x8044b8
  801645:	68 87 00 00 00       	push   $0x87
  80164a:	68 e2 44 80 00       	push   $0x8044e2
  80164f:	e8 eb 24 00 00       	call   803b3f <_panic>
	}
}
  801654:	90                   	nop
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 28             	sub    $0x28,%esp
  80165d:	8b 45 10             	mov    0x10(%ebp),%eax
  801660:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801663:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801667:	75 0a                	jne    801673 <smalloc+0x1c>
  801669:	b8 00 00 00 00       	mov    $0x0,%eax
  80166e:	e9 87 00 00 00       	jmp    8016fa <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801679:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801680:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801686:	39 d0                	cmp    %edx,%eax
  801688:	73 02                	jae    80168c <smalloc+0x35>
  80168a:	89 d0                	mov    %edx,%eax
  80168c:	83 ec 0c             	sub    $0xc,%esp
  80168f:	50                   	push   %eax
  801690:	e8 a4 fc ff ff       	call   801339 <malloc>
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80169b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80169f:	75 07                	jne    8016a8 <smalloc+0x51>
  8016a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a6:	eb 52                	jmp    8016fa <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016a8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8016af:	50                   	push   %eax
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	ff 75 08             	pushl  0x8(%ebp)
  8016b6:	e8 93 03 00 00       	call   801a4e <sys_createSharedObject>
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8016c1:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016c5:	74 06                	je     8016cd <smalloc+0x76>
  8016c7:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016cb:	75 07                	jne    8016d4 <smalloc+0x7d>
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d2:	eb 26                	jmp    8016fa <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8016d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8016dc:	8b 40 78             	mov    0x78(%eax),%eax
  8016df:	29 c2                	sub    %eax,%edx
  8016e1:	89 d0                	mov    %edx,%eax
  8016e3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016e8:	c1 e8 0c             	shr    $0xc,%eax
  8016eb:	89 c2                	mov    %eax,%edx
  8016ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f0:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8016f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	ff 75 0c             	pushl  0xc(%ebp)
  801708:	ff 75 08             	pushl  0x8(%ebp)
  80170b:	e8 68 03 00 00       	call   801a78 <sys_getSizeOfSharedObject>
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801716:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80171a:	75 07                	jne    801723 <sget+0x27>
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
  801721:	eb 7f                	jmp    8017a2 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801726:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801729:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801730:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801736:	39 d0                	cmp    %edx,%eax
  801738:	73 02                	jae    80173c <sget+0x40>
  80173a:	89 d0                	mov    %edx,%eax
  80173c:	83 ec 0c             	sub    $0xc,%esp
  80173f:	50                   	push   %eax
  801740:	e8 f4 fb ff ff       	call   801339 <malloc>
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80174b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80174f:	75 07                	jne    801758 <sget+0x5c>
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
  801756:	eb 4a                	jmp    8017a2 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	ff 75 e8             	pushl  -0x18(%ebp)
  80175e:	ff 75 0c             	pushl  0xc(%ebp)
  801761:	ff 75 08             	pushl  0x8(%ebp)
  801764:	e8 2c 03 00 00       	call   801a95 <sys_getSharedObject>
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80176f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801772:	a1 20 50 80 00       	mov    0x805020,%eax
  801777:	8b 40 78             	mov    0x78(%eax),%eax
  80177a:	29 c2                	sub    %eax,%edx
  80177c:	89 d0                	mov    %edx,%eax
  80177e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801783:	c1 e8 0c             	shr    $0xc,%eax
  801786:	89 c2                	mov    %eax,%edx
  801788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80178b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801792:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801796:	75 07                	jne    80179f <sget+0xa3>
  801798:	b8 00 00 00 00       	mov    $0x0,%eax
  80179d:	eb 03                	jmp    8017a2 <sget+0xa6>
	return ptr;
  80179f:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8017aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8017b2:	8b 40 78             	mov    0x78(%eax),%eax
  8017b5:	29 c2                	sub    %eax,%edx
  8017b7:	89 d0                	mov    %edx,%eax
  8017b9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017be:	c1 e8 0c             	shr    $0xc,%eax
  8017c1:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8017c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	ff 75 08             	pushl  0x8(%ebp)
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	e8 db 02 00 00       	call   801ab4 <sys_freeSharedObject>
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8017df:	90                   	nop
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017e8:	83 ec 04             	sub    $0x4,%esp
  8017eb:	68 f0 44 80 00       	push   $0x8044f0
  8017f0:	68 e4 00 00 00       	push   $0xe4
  8017f5:	68 e2 44 80 00       	push   $0x8044e2
  8017fa:	e8 40 23 00 00       	call   803b3f <_panic>

008017ff <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	68 16 45 80 00       	push   $0x804516
  80180d:	68 f0 00 00 00       	push   $0xf0
  801812:	68 e2 44 80 00       	push   $0x8044e2
  801817:	e8 23 23 00 00       	call   803b3f <_panic>

0080181c <shrink>:

}
void shrink(uint32 newSize)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 16 45 80 00       	push   $0x804516
  80182a:	68 f5 00 00 00       	push   $0xf5
  80182f:	68 e2 44 80 00       	push   $0x8044e2
  801834:	e8 06 23 00 00       	call   803b3f <_panic>

00801839 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183f:	83 ec 04             	sub    $0x4,%esp
  801842:	68 16 45 80 00       	push   $0x804516
  801847:	68 fa 00 00 00       	push   $0xfa
  80184c:	68 e2 44 80 00       	push   $0x8044e2
  801851:	e8 e9 22 00 00       	call   803b3f <_panic>

00801856 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	57                   	push   %edi
  80185a:	56                   	push   %esi
  80185b:	53                   	push   %ebx
  80185c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8b 55 0c             	mov    0xc(%ebp),%edx
  801865:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801868:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80186e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801871:	cd 30                	int    $0x30
  801873:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	5b                   	pop    %ebx
  80187d:	5e                   	pop    %esi
  80187e:	5f                   	pop    %edi
  80187f:	5d                   	pop    %ebp
  801880:	c3                   	ret    

00801881 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 04             	sub    $0x4,%esp
  801887:	8b 45 10             	mov    0x10(%ebp),%eax
  80188a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80188d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	52                   	push   %edx
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	50                   	push   %eax
  80189d:	6a 00                	push   $0x0
  80189f:	e8 b2 ff ff ff       	call   801856 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	90                   	nop
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_cgetc>:

int
sys_cgetc(void)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 02                	push   $0x2
  8018b9:	e8 98 ff ff ff       	call   801856 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 03                	push   $0x3
  8018d2:	e8 7f ff ff ff       	call   801856 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	90                   	nop
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 04                	push   $0x4
  8018ec:	e8 65 ff ff ff       	call   801856 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	90                   	nop
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	52                   	push   %edx
  801907:	50                   	push   %eax
  801908:	6a 08                	push   $0x8
  80190a:	e8 47 ff ff ff       	call   801856 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	56                   	push   %esi
  801918:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801919:	8b 75 18             	mov    0x18(%ebp),%esi
  80191c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80191f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801922:	8b 55 0c             	mov    0xc(%ebp),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	56                   	push   %esi
  801929:	53                   	push   %ebx
  80192a:	51                   	push   %ecx
  80192b:	52                   	push   %edx
  80192c:	50                   	push   %eax
  80192d:	6a 09                	push   $0x9
  80192f:	e8 22 ff ff ff       	call   801856 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193a:	5b                   	pop    %ebx
  80193b:	5e                   	pop    %esi
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    

0080193e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801941:	8b 55 0c             	mov    0xc(%ebp),%edx
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	52                   	push   %edx
  80194e:	50                   	push   %eax
  80194f:	6a 0a                	push   $0xa
  801951:	e8 00 ff ff ff       	call   801856 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	ff 75 0c             	pushl  0xc(%ebp)
  801967:	ff 75 08             	pushl  0x8(%ebp)
  80196a:	6a 0b                	push   $0xb
  80196c:	e8 e5 fe ff ff       	call   801856 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 0c                	push   $0xc
  801985:	e8 cc fe ff ff       	call   801856 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 0d                	push   $0xd
  80199e:	e8 b3 fe ff ff       	call   801856 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 0e                	push   $0xe
  8019b7:	e8 9a fe ff ff       	call   801856 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 0f                	push   $0xf
  8019d0:	e8 81 fe ff ff       	call   801856 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	6a 10                	push   $0x10
  8019ea:	e8 67 fe ff ff       	call   801856 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 11                	push   $0x11
  801a03:	e8 4e fe ff ff       	call   801856 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	90                   	nop
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_cputc>:

void
sys_cputc(const char c)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	50                   	push   %eax
  801a27:	6a 01                	push   $0x1
  801a29:	e8 28 fe ff ff       	call   801856 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	90                   	nop
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 14                	push   $0x14
  801a43:	e8 0e fe ff ff       	call   801856 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	90                   	nop
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	8b 45 10             	mov    0x10(%ebp),%eax
  801a57:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a5a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a5d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	6a 00                	push   $0x0
  801a66:	51                   	push   %ecx
  801a67:	52                   	push   %edx
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	50                   	push   %eax
  801a6c:	6a 15                	push   $0x15
  801a6e:	e8 e3 fd ff ff       	call   801856 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 16                	push   $0x16
  801a8b:	e8 c6 fd ff ff       	call   801856 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	51                   	push   %ecx
  801aa6:	52                   	push   %edx
  801aa7:	50                   	push   %eax
  801aa8:	6a 17                	push   $0x17
  801aaa:	e8 a7 fd ff ff       	call   801856 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	52                   	push   %edx
  801ac4:	50                   	push   %eax
  801ac5:	6a 18                	push   $0x18
  801ac7:	e8 8a fd ff ff       	call   801856 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	ff 75 14             	pushl  0x14(%ebp)
  801adc:	ff 75 10             	pushl  0x10(%ebp)
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	50                   	push   %eax
  801ae3:	6a 19                	push   $0x19
  801ae5:	e8 6c fd ff ff       	call   801856 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_run_env>:

void sys_run_env(int32 envId)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	50                   	push   %eax
  801afe:	6a 1a                	push   $0x1a
  801b00:	e8 51 fd ff ff       	call   801856 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	90                   	nop
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	50                   	push   %eax
  801b1a:	6a 1b                	push   $0x1b
  801b1c:	e8 35 fd ff ff       	call   801856 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 05                	push   $0x5
  801b35:	e8 1c fd ff ff       	call   801856 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 06                	push   $0x6
  801b4e:	e8 03 fd ff ff       	call   801856 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 07                	push   $0x7
  801b67:	e8 ea fc ff ff       	call   801856 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_exit_env>:


void sys_exit_env(void)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 1c                	push   $0x1c
  801b80:	e8 d1 fc ff ff       	call   801856 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	90                   	nop
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b91:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b94:	8d 50 04             	lea    0x4(%eax),%edx
  801b97:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	52                   	push   %edx
  801ba1:	50                   	push   %eax
  801ba2:	6a 1d                	push   $0x1d
  801ba4:	e8 ad fc ff ff       	call   801856 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
	return result;
  801bac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801baf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb5:	89 01                	mov    %eax,(%ecx)
  801bb7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	c9                   	leave  
  801bbe:	c2 04 00             	ret    $0x4

00801bc1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	ff 75 10             	pushl  0x10(%ebp)
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	ff 75 08             	pushl  0x8(%ebp)
  801bd1:	6a 13                	push   $0x13
  801bd3:	e8 7e fc ff ff       	call   801856 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdb:	90                   	nop
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_rcr2>:
uint32 sys_rcr2()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 1e                	push   $0x1e
  801bed:	e8 64 fc ff ff       	call   801856 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c03:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	50                   	push   %eax
  801c10:	6a 1f                	push   $0x1f
  801c12:	e8 3f fc ff ff       	call   801856 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1a:	90                   	nop
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <rsttst>:
void rsttst()
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 21                	push   $0x21
  801c2c:	e8 25 fc ff ff       	call   801856 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return ;
  801c34:	90                   	nop
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c43:	8b 55 18             	mov    0x18(%ebp),%edx
  801c46:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c4a:	52                   	push   %edx
  801c4b:	50                   	push   %eax
  801c4c:	ff 75 10             	pushl  0x10(%ebp)
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	ff 75 08             	pushl  0x8(%ebp)
  801c55:	6a 20                	push   $0x20
  801c57:	e8 fa fb ff ff       	call   801856 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5f:	90                   	nop
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <chktst>:
void chktst(uint32 n)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	ff 75 08             	pushl  0x8(%ebp)
  801c70:	6a 22                	push   $0x22
  801c72:	e8 df fb ff ff       	call   801856 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7a:	90                   	nop
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <inctst>:

void inctst()
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 23                	push   $0x23
  801c8c:	e8 c5 fb ff ff       	call   801856 <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
	return ;
  801c94:	90                   	nop
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <gettst>:
uint32 gettst()
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 24                	push   $0x24
  801ca6:	e8 ab fb ff ff       	call   801856 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 25                	push   $0x25
  801cc2:	e8 8f fb ff ff       	call   801856 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
  801cca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ccd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cd1:	75 07                	jne    801cda <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd8:	eb 05                	jmp    801cdf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 25                	push   $0x25
  801cf3:	e8 5e fb ff ff       	call   801856 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
  801cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cfe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d02:	75 07                	jne    801d0b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d04:	b8 01 00 00 00       	mov    $0x1,%eax
  801d09:	eb 05                	jmp    801d10 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 25                	push   $0x25
  801d24:	e8 2d fb ff ff       	call   801856 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
  801d2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d2f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d33:	75 07                	jne    801d3c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d35:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3a:	eb 05                	jmp    801d41 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 25                	push   $0x25
  801d55:	e8 fc fa ff ff       	call   801856 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
  801d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d60:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d64:	75 07                	jne    801d6d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d66:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6b:	eb 05                	jmp    801d72 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	ff 75 08             	pushl  0x8(%ebp)
  801d82:	6a 26                	push   $0x26
  801d84:	e8 cd fa ff ff       	call   801856 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8c:	90                   	nop
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	6a 00                	push   $0x0
  801da1:	53                   	push   %ebx
  801da2:	51                   	push   %ecx
  801da3:	52                   	push   %edx
  801da4:	50                   	push   %eax
  801da5:	6a 27                	push   $0x27
  801da7:	e8 aa fa ff ff       	call   801856 <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
}
  801daf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	52                   	push   %edx
  801dc4:	50                   	push   %eax
  801dc5:	6a 28                	push   $0x28
  801dc7:	e8 8a fa ff ff       	call   801856 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801dd4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	51                   	push   %ecx
  801de0:	ff 75 10             	pushl  0x10(%ebp)
  801de3:	52                   	push   %edx
  801de4:	50                   	push   %eax
  801de5:	6a 29                	push   $0x29
  801de7:	e8 6a fa ff ff       	call   801856 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	ff 75 10             	pushl  0x10(%ebp)
  801dfb:	ff 75 0c             	pushl  0xc(%ebp)
  801dfe:	ff 75 08             	pushl  0x8(%ebp)
  801e01:	6a 12                	push   $0x12
  801e03:	e8 4e fa ff ff       	call   801856 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0b:	90                   	nop
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	52                   	push   %edx
  801e1e:	50                   	push   %eax
  801e1f:	6a 2a                	push   $0x2a
  801e21:	e8 30 fa ff ff       	call   801856 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
	return;
  801e29:	90                   	nop
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	50                   	push   %eax
  801e3b:	6a 2b                	push   $0x2b
  801e3d:	e8 14 fa ff ff       	call   801856 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	ff 75 08             	pushl  0x8(%ebp)
  801e56:	6a 2c                	push   $0x2c
  801e58:	e8 f9 f9 ff ff       	call   801856 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
	return;
  801e60:	90                   	nop
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	ff 75 0c             	pushl  0xc(%ebp)
  801e6f:	ff 75 08             	pushl  0x8(%ebp)
  801e72:	6a 2d                	push   $0x2d
  801e74:	e8 dd f9 ff ff       	call   801856 <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
	return;
  801e7c:	90                   	nop
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 2e                	push   $0x2e
  801e91:	e8 c0 f9 ff ff       	call   801856 <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
  801e99:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	50                   	push   %eax
  801eb0:	6a 2f                	push   $0x2f
  801eb2:	e8 9f f9 ff ff       	call   801856 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
	return;
  801eba:	90                   	nop
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	52                   	push   %edx
  801ecd:	50                   	push   %eax
  801ece:	6a 30                	push   $0x30
  801ed0:	e8 81 f9 ff ff       	call   801856 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
	return;
  801ed8:	90                   	nop
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	50                   	push   %eax
  801eed:	6a 31                	push   $0x31
  801eef:	e8 62 f9 ff ff       	call   801856 <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
  801ef7:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	50                   	push   %eax
  801f0e:	6a 32                	push   $0x32
  801f10:	e8 41 f9 ff ff       	call   801856 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
	return;
  801f18:	90                   	nop
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	83 e8 04             	sub    $0x4,%eax
  801f27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f2d:	8b 00                	mov    (%eax),%eax
  801f2f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	83 e8 04             	sub    $0x4,%eax
  801f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f46:	8b 00                	mov    (%eax),%eax
  801f48:	83 e0 01             	and    $0x1,%eax
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	0f 94 c0             	sete   %al
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f62:	83 f8 02             	cmp    $0x2,%eax
  801f65:	74 2b                	je     801f92 <alloc_block+0x40>
  801f67:	83 f8 02             	cmp    $0x2,%eax
  801f6a:	7f 07                	jg     801f73 <alloc_block+0x21>
  801f6c:	83 f8 01             	cmp    $0x1,%eax
  801f6f:	74 0e                	je     801f7f <alloc_block+0x2d>
  801f71:	eb 58                	jmp    801fcb <alloc_block+0x79>
  801f73:	83 f8 03             	cmp    $0x3,%eax
  801f76:	74 2d                	je     801fa5 <alloc_block+0x53>
  801f78:	83 f8 04             	cmp    $0x4,%eax
  801f7b:	74 3b                	je     801fb8 <alloc_block+0x66>
  801f7d:	eb 4c                	jmp    801fcb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	ff 75 08             	pushl  0x8(%ebp)
  801f85:	e8 11 03 00 00       	call   80229b <alloc_block_FF>
  801f8a:	83 c4 10             	add    $0x10,%esp
  801f8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f90:	eb 4a                	jmp    801fdc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f92:	83 ec 0c             	sub    $0xc,%esp
  801f95:	ff 75 08             	pushl  0x8(%ebp)
  801f98:	e8 c7 19 00 00       	call   803964 <alloc_block_NF>
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fa3:	eb 37                	jmp    801fdc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fa5:	83 ec 0c             	sub    $0xc,%esp
  801fa8:	ff 75 08             	pushl  0x8(%ebp)
  801fab:	e8 a7 07 00 00       	call   802757 <alloc_block_BF>
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fb6:	eb 24                	jmp    801fdc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fb8:	83 ec 0c             	sub    $0xc,%esp
  801fbb:	ff 75 08             	pushl  0x8(%ebp)
  801fbe:	e8 84 19 00 00       	call   803947 <alloc_block_WF>
  801fc3:	83 c4 10             	add    $0x10,%esp
  801fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fc9:	eb 11                	jmp    801fdc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	68 28 45 80 00       	push   $0x804528
  801fd3:	e8 b1 e5 ff ff       	call   800589 <cprintf>
  801fd8:	83 c4 10             	add    $0x10,%esp
		break;
  801fdb:	90                   	nop
	}
	return va;
  801fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	53                   	push   %ebx
  801fe5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	68 48 45 80 00       	push   $0x804548
  801ff0:	e8 94 e5 ff ff       	call   800589 <cprintf>
  801ff5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	68 73 45 80 00       	push   $0x804573
  802000:	e8 84 e5 ff ff       	call   800589 <cprintf>
  802005:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200e:	eb 37                	jmp    802047 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	ff 75 f4             	pushl  -0xc(%ebp)
  802016:	e8 19 ff ff ff       	call   801f34 <is_free_block>
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	0f be d8             	movsbl %al,%ebx
  802021:	83 ec 0c             	sub    $0xc,%esp
  802024:	ff 75 f4             	pushl  -0xc(%ebp)
  802027:	e8 ef fe ff ff       	call   801f1b <get_block_size>
  80202c:	83 c4 10             	add    $0x10,%esp
  80202f:	83 ec 04             	sub    $0x4,%esp
  802032:	53                   	push   %ebx
  802033:	50                   	push   %eax
  802034:	68 8b 45 80 00       	push   $0x80458b
  802039:	e8 4b e5 ff ff       	call   800589 <cprintf>
  80203e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802041:	8b 45 10             	mov    0x10(%ebp),%eax
  802044:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204b:	74 07                	je     802054 <print_blocks_list+0x73>
  80204d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802050:	8b 00                	mov    (%eax),%eax
  802052:	eb 05                	jmp    802059 <print_blocks_list+0x78>
  802054:	b8 00 00 00 00       	mov    $0x0,%eax
  802059:	89 45 10             	mov    %eax,0x10(%ebp)
  80205c:	8b 45 10             	mov    0x10(%ebp),%eax
  80205f:	85 c0                	test   %eax,%eax
  802061:	75 ad                	jne    802010 <print_blocks_list+0x2f>
  802063:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802067:	75 a7                	jne    802010 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802069:	83 ec 0c             	sub    $0xc,%esp
  80206c:	68 48 45 80 00       	push   $0x804548
  802071:	e8 13 e5 ff ff       	call   800589 <cprintf>
  802076:	83 c4 10             	add    $0x10,%esp

}
  802079:	90                   	nop
  80207a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802085:	8b 45 0c             	mov    0xc(%ebp),%eax
  802088:	83 e0 01             	and    $0x1,%eax
  80208b:	85 c0                	test   %eax,%eax
  80208d:	74 03                	je     802092 <initialize_dynamic_allocator+0x13>
  80208f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802092:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802096:	0f 84 c7 01 00 00    	je     802263 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80209c:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020a3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ac:	01 d0                	add    %edx,%eax
  8020ae:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020b3:	0f 87 ad 01 00 00    	ja     802266 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	0f 89 a5 01 00 00    	jns    802269 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ca:	01 d0                	add    %edx,%eax
  8020cc:	83 e8 04             	sub    $0x4,%eax
  8020cf:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020db:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e3:	e9 87 00 00 00       	jmp    80216f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ec:	75 14                	jne    802102 <initialize_dynamic_allocator+0x83>
  8020ee:	83 ec 04             	sub    $0x4,%esp
  8020f1:	68 a3 45 80 00       	push   $0x8045a3
  8020f6:	6a 79                	push   $0x79
  8020f8:	68 c1 45 80 00       	push   $0x8045c1
  8020fd:	e8 3d 1a 00 00       	call   803b3f <_panic>
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	85 c0                	test   %eax,%eax
  802109:	74 10                	je     80211b <initialize_dynamic_allocator+0x9c>
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802113:	8b 52 04             	mov    0x4(%edx),%edx
  802116:	89 50 04             	mov    %edx,0x4(%eax)
  802119:	eb 0b                	jmp    802126 <initialize_dynamic_allocator+0xa7>
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	8b 40 04             	mov    0x4(%eax),%eax
  802121:	a3 30 50 80 00       	mov    %eax,0x805030
  802126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802129:	8b 40 04             	mov    0x4(%eax),%eax
  80212c:	85 c0                	test   %eax,%eax
  80212e:	74 0f                	je     80213f <initialize_dynamic_allocator+0xc0>
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	8b 40 04             	mov    0x4(%eax),%eax
  802136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802139:	8b 12                	mov    (%edx),%edx
  80213b:	89 10                	mov    %edx,(%eax)
  80213d:	eb 0a                	jmp    802149 <initialize_dynamic_allocator+0xca>
  80213f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802142:	8b 00                	mov    (%eax),%eax
  802144:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80215c:	a1 38 50 80 00       	mov    0x805038,%eax
  802161:	48                   	dec    %eax
  802162:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802167:	a1 34 50 80 00       	mov    0x805034,%eax
  80216c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802173:	74 07                	je     80217c <initialize_dynamic_allocator+0xfd>
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 00                	mov    (%eax),%eax
  80217a:	eb 05                	jmp    802181 <initialize_dynamic_allocator+0x102>
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
  802181:	a3 34 50 80 00       	mov    %eax,0x805034
  802186:	a1 34 50 80 00       	mov    0x805034,%eax
  80218b:	85 c0                	test   %eax,%eax
  80218d:	0f 85 55 ff ff ff    	jne    8020e8 <initialize_dynamic_allocator+0x69>
  802193:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802197:	0f 85 4b ff ff ff    	jne    8020e8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021ac:	a1 44 50 80 00       	mov    0x805044,%eax
  8021b1:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021b6:	a1 40 50 80 00       	mov    0x805040,%eax
  8021bb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	83 c0 08             	add    $0x8,%eax
  8021c7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cd:	83 c0 04             	add    $0x4,%eax
  8021d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d3:	83 ea 08             	sub    $0x8,%edx
  8021d6:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	01 d0                	add    %edx,%eax
  8021e0:	83 e8 08             	sub    $0x8,%eax
  8021e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e6:	83 ea 08             	sub    $0x8,%edx
  8021e9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802202:	75 17                	jne    80221b <initialize_dynamic_allocator+0x19c>
  802204:	83 ec 04             	sub    $0x4,%esp
  802207:	68 dc 45 80 00       	push   $0x8045dc
  80220c:	68 90 00 00 00       	push   $0x90
  802211:	68 c1 45 80 00       	push   $0x8045c1
  802216:	e8 24 19 00 00       	call   803b3f <_panic>
  80221b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802221:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802224:	89 10                	mov    %edx,(%eax)
  802226:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802229:	8b 00                	mov    (%eax),%eax
  80222b:	85 c0                	test   %eax,%eax
  80222d:	74 0d                	je     80223c <initialize_dynamic_allocator+0x1bd>
  80222f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802234:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802237:	89 50 04             	mov    %edx,0x4(%eax)
  80223a:	eb 08                	jmp    802244 <initialize_dynamic_allocator+0x1c5>
  80223c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223f:	a3 30 50 80 00       	mov    %eax,0x805030
  802244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802247:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80224c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802256:	a1 38 50 80 00       	mov    0x805038,%eax
  80225b:	40                   	inc    %eax
  80225c:	a3 38 50 80 00       	mov    %eax,0x805038
  802261:	eb 07                	jmp    80226a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802263:	90                   	nop
  802264:	eb 04                	jmp    80226a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802266:	90                   	nop
  802267:	eb 01                	jmp    80226a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802269:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80226f:	8b 45 10             	mov    0x10(%ebp),%eax
  802272:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	8d 50 fc             	lea    -0x4(%eax),%edx
  80227b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	83 e8 04             	sub    $0x4,%eax
  802286:	8b 00                	mov    (%eax),%eax
  802288:	83 e0 fe             	and    $0xfffffffe,%eax
  80228b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	01 c2                	add    %eax,%edx
  802293:	8b 45 0c             	mov    0xc(%ebp),%eax
  802296:	89 02                	mov    %eax,(%edx)
}
  802298:	90                   	nop
  802299:	5d                   	pop    %ebp
  80229a:	c3                   	ret    

0080229b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	83 e0 01             	and    $0x1,%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	74 03                	je     8022ae <alloc_block_FF+0x13>
  8022ab:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022ae:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022b2:	77 07                	ja     8022bb <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022b4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022bb:	a1 24 50 80 00       	mov    0x805024,%eax
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	75 73                	jne    802337 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	83 c0 10             	add    $0x10,%eax
  8022ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022cd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022da:	01 d0                	add    %edx,%eax
  8022dc:	48                   	dec    %eax
  8022dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e8:	f7 75 ec             	divl   -0x14(%ebp)
  8022eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ee:	29 d0                	sub    %edx,%eax
  8022f0:	c1 e8 0c             	shr    $0xc,%eax
  8022f3:	83 ec 0c             	sub    $0xc,%esp
  8022f6:	50                   	push   %eax
  8022f7:	e8 27 f0 ff ff       	call   801323 <sbrk>
  8022fc:	83 c4 10             	add    $0x10,%esp
  8022ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802302:	83 ec 0c             	sub    $0xc,%esp
  802305:	6a 00                	push   $0x0
  802307:	e8 17 f0 ff ff       	call   801323 <sbrk>
  80230c:	83 c4 10             	add    $0x10,%esp
  80230f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802312:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802315:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802318:	83 ec 08             	sub    $0x8,%esp
  80231b:	50                   	push   %eax
  80231c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80231f:	e8 5b fd ff ff       	call   80207f <initialize_dynamic_allocator>
  802324:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802327:	83 ec 0c             	sub    $0xc,%esp
  80232a:	68 ff 45 80 00       	push   $0x8045ff
  80232f:	e8 55 e2 ff ff       	call   800589 <cprintf>
  802334:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802337:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80233b:	75 0a                	jne    802347 <alloc_block_FF+0xac>
	        return NULL;
  80233d:	b8 00 00 00 00       	mov    $0x0,%eax
  802342:	e9 0e 04 00 00       	jmp    802755 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802347:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80234e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802353:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802356:	e9 f3 02 00 00       	jmp    80264e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802361:	83 ec 0c             	sub    $0xc,%esp
  802364:	ff 75 bc             	pushl  -0x44(%ebp)
  802367:	e8 af fb ff ff       	call   801f1b <get_block_size>
  80236c:	83 c4 10             	add    $0x10,%esp
  80236f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	83 c0 08             	add    $0x8,%eax
  802378:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80237b:	0f 87 c5 02 00 00    	ja     802646 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	83 c0 18             	add    $0x18,%eax
  802387:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80238a:	0f 87 19 02 00 00    	ja     8025a9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802390:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802393:	2b 45 08             	sub    0x8(%ebp),%eax
  802396:	83 e8 08             	sub    $0x8,%eax
  802399:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	8d 50 08             	lea    0x8(%eax),%edx
  8023a2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023a5:	01 d0                	add    %edx,%eax
  8023a7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	83 c0 08             	add    $0x8,%eax
  8023b0:	83 ec 04             	sub    $0x4,%esp
  8023b3:	6a 01                	push   $0x1
  8023b5:	50                   	push   %eax
  8023b6:	ff 75 bc             	pushl  -0x44(%ebp)
  8023b9:	e8 ae fe ff ff       	call   80226c <set_block_data>
  8023be:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 40 04             	mov    0x4(%eax),%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	75 68                	jne    802433 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023cb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023cf:	75 17                	jne    8023e8 <alloc_block_FF+0x14d>
  8023d1:	83 ec 04             	sub    $0x4,%esp
  8023d4:	68 dc 45 80 00       	push   $0x8045dc
  8023d9:	68 d7 00 00 00       	push   $0xd7
  8023de:	68 c1 45 80 00       	push   $0x8045c1
  8023e3:	e8 57 17 00 00       	call   803b3f <_panic>
  8023e8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f1:	89 10                	mov    %edx,(%eax)
  8023f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	74 0d                	je     802409 <alloc_block_FF+0x16e>
  8023fc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802401:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802404:	89 50 04             	mov    %edx,0x4(%eax)
  802407:	eb 08                	jmp    802411 <alloc_block_FF+0x176>
  802409:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240c:	a3 30 50 80 00       	mov    %eax,0x805030
  802411:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802414:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802419:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802423:	a1 38 50 80 00       	mov    0x805038,%eax
  802428:	40                   	inc    %eax
  802429:	a3 38 50 80 00       	mov    %eax,0x805038
  80242e:	e9 dc 00 00 00       	jmp    80250f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	85 c0                	test   %eax,%eax
  80243a:	75 65                	jne    8024a1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80243c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802440:	75 17                	jne    802459 <alloc_block_FF+0x1be>
  802442:	83 ec 04             	sub    $0x4,%esp
  802445:	68 10 46 80 00       	push   $0x804610
  80244a:	68 db 00 00 00       	push   $0xdb
  80244f:	68 c1 45 80 00       	push   $0x8045c1
  802454:	e8 e6 16 00 00       	call   803b3f <_panic>
  802459:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80245f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802462:	89 50 04             	mov    %edx,0x4(%eax)
  802465:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802468:	8b 40 04             	mov    0x4(%eax),%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	74 0c                	je     80247b <alloc_block_FF+0x1e0>
  80246f:	a1 30 50 80 00       	mov    0x805030,%eax
  802474:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802477:	89 10                	mov    %edx,(%eax)
  802479:	eb 08                	jmp    802483 <alloc_block_FF+0x1e8>
  80247b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802483:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802486:	a3 30 50 80 00       	mov    %eax,0x805030
  80248b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802494:	a1 38 50 80 00       	mov    0x805038,%eax
  802499:	40                   	inc    %eax
  80249a:	a3 38 50 80 00       	mov    %eax,0x805038
  80249f:	eb 6e                	jmp    80250f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a5:	74 06                	je     8024ad <alloc_block_FF+0x212>
  8024a7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024ab:	75 17                	jne    8024c4 <alloc_block_FF+0x229>
  8024ad:	83 ec 04             	sub    $0x4,%esp
  8024b0:	68 34 46 80 00       	push   $0x804634
  8024b5:	68 df 00 00 00       	push   $0xdf
  8024ba:	68 c1 45 80 00       	push   $0x8045c1
  8024bf:	e8 7b 16 00 00       	call   803b3f <_panic>
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 10                	mov    (%eax),%edx
  8024c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cc:	89 10                	mov    %edx,(%eax)
  8024ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	74 0b                	je     8024e2 <alloc_block_FF+0x247>
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 00                	mov    (%eax),%eax
  8024dc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024df:	89 50 04             	mov    %edx,0x4(%eax)
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024e8:	89 10                	mov    %edx,(%eax)
  8024ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f0:	89 50 04             	mov    %edx,0x4(%eax)
  8024f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f6:	8b 00                	mov    (%eax),%eax
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	75 08                	jne    802504 <alloc_block_FF+0x269>
  8024fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ff:	a3 30 50 80 00       	mov    %eax,0x805030
  802504:	a1 38 50 80 00       	mov    0x805038,%eax
  802509:	40                   	inc    %eax
  80250a:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80250f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802513:	75 17                	jne    80252c <alloc_block_FF+0x291>
  802515:	83 ec 04             	sub    $0x4,%esp
  802518:	68 a3 45 80 00       	push   $0x8045a3
  80251d:	68 e1 00 00 00       	push   $0xe1
  802522:	68 c1 45 80 00       	push   $0x8045c1
  802527:	e8 13 16 00 00       	call   803b3f <_panic>
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 00                	mov    (%eax),%eax
  802531:	85 c0                	test   %eax,%eax
  802533:	74 10                	je     802545 <alloc_block_FF+0x2aa>
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 00                	mov    (%eax),%eax
  80253a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253d:	8b 52 04             	mov    0x4(%edx),%edx
  802540:	89 50 04             	mov    %edx,0x4(%eax)
  802543:	eb 0b                	jmp    802550 <alloc_block_FF+0x2b5>
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 40 04             	mov    0x4(%eax),%eax
  80254b:	a3 30 50 80 00       	mov    %eax,0x805030
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 40 04             	mov    0x4(%eax),%eax
  802556:	85 c0                	test   %eax,%eax
  802558:	74 0f                	je     802569 <alloc_block_FF+0x2ce>
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 04             	mov    0x4(%eax),%eax
  802560:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802563:	8b 12                	mov    (%edx),%edx
  802565:	89 10                	mov    %edx,(%eax)
  802567:	eb 0a                	jmp    802573 <alloc_block_FF+0x2d8>
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802586:	a1 38 50 80 00       	mov    0x805038,%eax
  80258b:	48                   	dec    %eax
  80258c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802591:	83 ec 04             	sub    $0x4,%esp
  802594:	6a 00                	push   $0x0
  802596:	ff 75 b4             	pushl  -0x4c(%ebp)
  802599:	ff 75 b0             	pushl  -0x50(%ebp)
  80259c:	e8 cb fc ff ff       	call   80226c <set_block_data>
  8025a1:	83 c4 10             	add    $0x10,%esp
  8025a4:	e9 95 00 00 00       	jmp    80263e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	6a 01                	push   $0x1
  8025ae:	ff 75 b8             	pushl  -0x48(%ebp)
  8025b1:	ff 75 bc             	pushl  -0x44(%ebp)
  8025b4:	e8 b3 fc ff ff       	call   80226c <set_block_data>
  8025b9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c0:	75 17                	jne    8025d9 <alloc_block_FF+0x33e>
  8025c2:	83 ec 04             	sub    $0x4,%esp
  8025c5:	68 a3 45 80 00       	push   $0x8045a3
  8025ca:	68 e8 00 00 00       	push   $0xe8
  8025cf:	68 c1 45 80 00       	push   $0x8045c1
  8025d4:	e8 66 15 00 00       	call   803b3f <_panic>
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 00                	mov    (%eax),%eax
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	74 10                	je     8025f2 <alloc_block_FF+0x357>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 00                	mov    (%eax),%eax
  8025e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ea:	8b 52 04             	mov    0x4(%edx),%edx
  8025ed:	89 50 04             	mov    %edx,0x4(%eax)
  8025f0:	eb 0b                	jmp    8025fd <alloc_block_FF+0x362>
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 40 04             	mov    0x4(%eax),%eax
  8025f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 04             	mov    0x4(%eax),%eax
  802603:	85 c0                	test   %eax,%eax
  802605:	74 0f                	je     802616 <alloc_block_FF+0x37b>
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 40 04             	mov    0x4(%eax),%eax
  80260d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802610:	8b 12                	mov    (%edx),%edx
  802612:	89 10                	mov    %edx,(%eax)
  802614:	eb 0a                	jmp    802620 <alloc_block_FF+0x385>
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 00                	mov    (%eax),%eax
  80261b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802633:	a1 38 50 80 00       	mov    0x805038,%eax
  802638:	48                   	dec    %eax
  802639:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80263e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802641:	e9 0f 01 00 00       	jmp    802755 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802646:	a1 34 50 80 00       	mov    0x805034,%eax
  80264b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802652:	74 07                	je     80265b <alloc_block_FF+0x3c0>
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 00                	mov    (%eax),%eax
  802659:	eb 05                	jmp    802660 <alloc_block_FF+0x3c5>
  80265b:	b8 00 00 00 00       	mov    $0x0,%eax
  802660:	a3 34 50 80 00       	mov    %eax,0x805034
  802665:	a1 34 50 80 00       	mov    0x805034,%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	0f 85 e9 fc ff ff    	jne    80235b <alloc_block_FF+0xc0>
  802672:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802676:	0f 85 df fc ff ff    	jne    80235b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80267c:	8b 45 08             	mov    0x8(%ebp),%eax
  80267f:	83 c0 08             	add    $0x8,%eax
  802682:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802685:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80268c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80268f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802692:	01 d0                	add    %edx,%eax
  802694:	48                   	dec    %eax
  802695:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802698:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80269b:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a0:	f7 75 d8             	divl   -0x28(%ebp)
  8026a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026a6:	29 d0                	sub    %edx,%eax
  8026a8:	c1 e8 0c             	shr    $0xc,%eax
  8026ab:	83 ec 0c             	sub    $0xc,%esp
  8026ae:	50                   	push   %eax
  8026af:	e8 6f ec ff ff       	call   801323 <sbrk>
  8026b4:	83 c4 10             	add    $0x10,%esp
  8026b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026ba:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026be:	75 0a                	jne    8026ca <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c5:	e9 8b 00 00 00       	jmp    802755 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026ca:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026d7:	01 d0                	add    %edx,%eax
  8026d9:	48                   	dec    %eax
  8026da:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e5:	f7 75 cc             	divl   -0x34(%ebp)
  8026e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026eb:	29 d0                	sub    %edx,%eax
  8026ed:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026f3:	01 d0                	add    %edx,%eax
  8026f5:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8026ff:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802705:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80270c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80270f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802712:	01 d0                	add    %edx,%eax
  802714:	48                   	dec    %eax
  802715:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802718:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80271b:	ba 00 00 00 00       	mov    $0x0,%edx
  802720:	f7 75 c4             	divl   -0x3c(%ebp)
  802723:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802726:	29 d0                	sub    %edx,%eax
  802728:	83 ec 04             	sub    $0x4,%esp
  80272b:	6a 01                	push   $0x1
  80272d:	50                   	push   %eax
  80272e:	ff 75 d0             	pushl  -0x30(%ebp)
  802731:	e8 36 fb ff ff       	call   80226c <set_block_data>
  802736:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802739:	83 ec 0c             	sub    $0xc,%esp
  80273c:	ff 75 d0             	pushl  -0x30(%ebp)
  80273f:	e8 f8 09 00 00       	call   80313c <free_block>
  802744:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802747:	83 ec 0c             	sub    $0xc,%esp
  80274a:	ff 75 08             	pushl  0x8(%ebp)
  80274d:	e8 49 fb ff ff       	call   80229b <alloc_block_FF>
  802752:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
  80275a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80275d:	8b 45 08             	mov    0x8(%ebp),%eax
  802760:	83 e0 01             	and    $0x1,%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 03                	je     80276a <alloc_block_BF+0x13>
  802767:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80276a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80276e:	77 07                	ja     802777 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802770:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802777:	a1 24 50 80 00       	mov    0x805024,%eax
  80277c:	85 c0                	test   %eax,%eax
  80277e:	75 73                	jne    8027f3 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	83 c0 10             	add    $0x10,%eax
  802786:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802789:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802790:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802793:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802796:	01 d0                	add    %edx,%eax
  802798:	48                   	dec    %eax
  802799:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80279c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80279f:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a4:	f7 75 e0             	divl   -0x20(%ebp)
  8027a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027aa:	29 d0                	sub    %edx,%eax
  8027ac:	c1 e8 0c             	shr    $0xc,%eax
  8027af:	83 ec 0c             	sub    $0xc,%esp
  8027b2:	50                   	push   %eax
  8027b3:	e8 6b eb ff ff       	call   801323 <sbrk>
  8027b8:	83 c4 10             	add    $0x10,%esp
  8027bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027be:	83 ec 0c             	sub    $0xc,%esp
  8027c1:	6a 00                	push   $0x0
  8027c3:	e8 5b eb ff ff       	call   801323 <sbrk>
  8027c8:	83 c4 10             	add    $0x10,%esp
  8027cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027d1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027d4:	83 ec 08             	sub    $0x8,%esp
  8027d7:	50                   	push   %eax
  8027d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8027db:	e8 9f f8 ff ff       	call   80207f <initialize_dynamic_allocator>
  8027e0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027e3:	83 ec 0c             	sub    $0xc,%esp
  8027e6:	68 ff 45 80 00       	push   $0x8045ff
  8027eb:	e8 99 dd ff ff       	call   800589 <cprintf>
  8027f0:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802801:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802808:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80280f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802817:	e9 1d 01 00 00       	jmp    802939 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802822:	83 ec 0c             	sub    $0xc,%esp
  802825:	ff 75 a8             	pushl  -0x58(%ebp)
  802828:	e8 ee f6 ff ff       	call   801f1b <get_block_size>
  80282d:	83 c4 10             	add    $0x10,%esp
  802830:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	83 c0 08             	add    $0x8,%eax
  802839:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80283c:	0f 87 ef 00 00 00    	ja     802931 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802842:	8b 45 08             	mov    0x8(%ebp),%eax
  802845:	83 c0 18             	add    $0x18,%eax
  802848:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80284b:	77 1d                	ja     80286a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80284d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802850:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802853:	0f 86 d8 00 00 00    	jbe    802931 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802859:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80285c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80285f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802862:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802865:	e9 c7 00 00 00       	jmp    802931 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	83 c0 08             	add    $0x8,%eax
  802870:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802873:	0f 85 9d 00 00 00    	jne    802916 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	6a 01                	push   $0x1
  80287e:	ff 75 a4             	pushl  -0x5c(%ebp)
  802881:	ff 75 a8             	pushl  -0x58(%ebp)
  802884:	e8 e3 f9 ff ff       	call   80226c <set_block_data>
  802889:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80288c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802890:	75 17                	jne    8028a9 <alloc_block_BF+0x152>
  802892:	83 ec 04             	sub    $0x4,%esp
  802895:	68 a3 45 80 00       	push   $0x8045a3
  80289a:	68 2c 01 00 00       	push   $0x12c
  80289f:	68 c1 45 80 00       	push   $0x8045c1
  8028a4:	e8 96 12 00 00       	call   803b3f <_panic>
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 10                	je     8028c2 <alloc_block_BF+0x16b>
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ba:	8b 52 04             	mov    0x4(%edx),%edx
  8028bd:	89 50 04             	mov    %edx,0x4(%eax)
  8028c0:	eb 0b                	jmp    8028cd <alloc_block_BF+0x176>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 04             	mov    0x4(%eax),%eax
  8028c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 40 04             	mov    0x4(%eax),%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	74 0f                	je     8028e6 <alloc_block_BF+0x18f>
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 40 04             	mov    0x4(%eax),%eax
  8028dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e0:	8b 12                	mov    (%edx),%edx
  8028e2:	89 10                	mov    %edx,(%eax)
  8028e4:	eb 0a                	jmp    8028f0 <alloc_block_BF+0x199>
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 00                	mov    (%eax),%eax
  8028eb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802903:	a1 38 50 80 00       	mov    0x805038,%eax
  802908:	48                   	dec    %eax
  802909:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80290e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802911:	e9 01 04 00 00       	jmp    802d17 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802919:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80291c:	76 13                	jbe    802931 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80291e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802925:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802928:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80292b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80292e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802931:	a1 34 50 80 00       	mov    0x805034,%eax
  802936:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293d:	74 07                	je     802946 <alloc_block_BF+0x1ef>
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 00                	mov    (%eax),%eax
  802944:	eb 05                	jmp    80294b <alloc_block_BF+0x1f4>
  802946:	b8 00 00 00 00       	mov    $0x0,%eax
  80294b:	a3 34 50 80 00       	mov    %eax,0x805034
  802950:	a1 34 50 80 00       	mov    0x805034,%eax
  802955:	85 c0                	test   %eax,%eax
  802957:	0f 85 bf fe ff ff    	jne    80281c <alloc_block_BF+0xc5>
  80295d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802961:	0f 85 b5 fe ff ff    	jne    80281c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802967:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80296b:	0f 84 26 02 00 00    	je     802b97 <alloc_block_BF+0x440>
  802971:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802975:	0f 85 1c 02 00 00    	jne    802b97 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80297b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297e:	2b 45 08             	sub    0x8(%ebp),%eax
  802981:	83 e8 08             	sub    $0x8,%eax
  802984:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	8d 50 08             	lea    0x8(%eax),%edx
  80298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802990:	01 d0                	add    %edx,%eax
  802992:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	83 c0 08             	add    $0x8,%eax
  80299b:	83 ec 04             	sub    $0x4,%esp
  80299e:	6a 01                	push   $0x1
  8029a0:	50                   	push   %eax
  8029a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8029a4:	e8 c3 f8 ff ff       	call   80226c <set_block_data>
  8029a9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	75 68                	jne    802a1e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029b6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029ba:	75 17                	jne    8029d3 <alloc_block_BF+0x27c>
  8029bc:	83 ec 04             	sub    $0x4,%esp
  8029bf:	68 dc 45 80 00       	push   $0x8045dc
  8029c4:	68 45 01 00 00       	push   $0x145
  8029c9:	68 c1 45 80 00       	push   $0x8045c1
  8029ce:	e8 6c 11 00 00       	call   803b3f <_panic>
  8029d3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029dc:	89 10                	mov    %edx,(%eax)
  8029de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e1:	8b 00                	mov    (%eax),%eax
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	74 0d                	je     8029f4 <alloc_block_BF+0x29d>
  8029e7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029ec:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029ef:	89 50 04             	mov    %edx,0x4(%eax)
  8029f2:	eb 08                	jmp    8029fc <alloc_block_BF+0x2a5>
  8029f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f7:	a3 30 50 80 00       	mov    %eax,0x805030
  8029fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0e:	a1 38 50 80 00       	mov    0x805038,%eax
  802a13:	40                   	inc    %eax
  802a14:	a3 38 50 80 00       	mov    %eax,0x805038
  802a19:	e9 dc 00 00 00       	jmp    802afa <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	75 65                	jne    802a8c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a27:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a2b:	75 17                	jne    802a44 <alloc_block_BF+0x2ed>
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	68 10 46 80 00       	push   $0x804610
  802a35:	68 4a 01 00 00       	push   $0x14a
  802a3a:	68 c1 45 80 00       	push   $0x8045c1
  802a3f:	e8 fb 10 00 00       	call   803b3f <_panic>
  802a44:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4d:	89 50 04             	mov    %edx,0x4(%eax)
  802a50:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a53:	8b 40 04             	mov    0x4(%eax),%eax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	74 0c                	je     802a66 <alloc_block_BF+0x30f>
  802a5a:	a1 30 50 80 00       	mov    0x805030,%eax
  802a5f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a62:	89 10                	mov    %edx,(%eax)
  802a64:	eb 08                	jmp    802a6e <alloc_block_BF+0x317>
  802a66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a69:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a71:	a3 30 50 80 00       	mov    %eax,0x805030
  802a76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a84:	40                   	inc    %eax
  802a85:	a3 38 50 80 00       	mov    %eax,0x805038
  802a8a:	eb 6e                	jmp    802afa <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a90:	74 06                	je     802a98 <alloc_block_BF+0x341>
  802a92:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a96:	75 17                	jne    802aaf <alloc_block_BF+0x358>
  802a98:	83 ec 04             	sub    $0x4,%esp
  802a9b:	68 34 46 80 00       	push   $0x804634
  802aa0:	68 4f 01 00 00       	push   $0x14f
  802aa5:	68 c1 45 80 00       	push   $0x8045c1
  802aaa:	e8 90 10 00 00       	call   803b3f <_panic>
  802aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab2:	8b 10                	mov    (%eax),%edx
  802ab4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab7:	89 10                	mov    %edx,(%eax)
  802ab9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 0b                	je     802acd <alloc_block_BF+0x376>
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aca:	89 50 04             	mov    %edx,0x4(%eax)
  802acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ad3:	89 10                	mov    %edx,(%eax)
  802ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802adb:	89 50 04             	mov    %edx,0x4(%eax)
  802ade:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae1:	8b 00                	mov    (%eax),%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	75 08                	jne    802aef <alloc_block_BF+0x398>
  802ae7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aea:	a3 30 50 80 00       	mov    %eax,0x805030
  802aef:	a1 38 50 80 00       	mov    0x805038,%eax
  802af4:	40                   	inc    %eax
  802af5:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802afa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802afe:	75 17                	jne    802b17 <alloc_block_BF+0x3c0>
  802b00:	83 ec 04             	sub    $0x4,%esp
  802b03:	68 a3 45 80 00       	push   $0x8045a3
  802b08:	68 51 01 00 00       	push   $0x151
  802b0d:	68 c1 45 80 00       	push   $0x8045c1
  802b12:	e8 28 10 00 00       	call   803b3f <_panic>
  802b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	74 10                	je     802b30 <alloc_block_BF+0x3d9>
  802b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b28:	8b 52 04             	mov    0x4(%edx),%edx
  802b2b:	89 50 04             	mov    %edx,0x4(%eax)
  802b2e:	eb 0b                	jmp    802b3b <alloc_block_BF+0x3e4>
  802b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	a3 30 50 80 00       	mov    %eax,0x805030
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 40 04             	mov    0x4(%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 0f                	je     802b54 <alloc_block_BF+0x3fd>
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4e:	8b 12                	mov    (%edx),%edx
  802b50:	89 10                	mov    %edx,(%eax)
  802b52:	eb 0a                	jmp    802b5e <alloc_block_BF+0x407>
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b71:	a1 38 50 80 00       	mov    0x805038,%eax
  802b76:	48                   	dec    %eax
  802b77:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b7c:	83 ec 04             	sub    $0x4,%esp
  802b7f:	6a 00                	push   $0x0
  802b81:	ff 75 d0             	pushl  -0x30(%ebp)
  802b84:	ff 75 cc             	pushl  -0x34(%ebp)
  802b87:	e8 e0 f6 ff ff       	call   80226c <set_block_data>
  802b8c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	e9 80 01 00 00       	jmp    802d17 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802b97:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b9b:	0f 85 9d 00 00 00    	jne    802c3e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ba1:	83 ec 04             	sub    $0x4,%esp
  802ba4:	6a 01                	push   $0x1
  802ba6:	ff 75 ec             	pushl  -0x14(%ebp)
  802ba9:	ff 75 f0             	pushl  -0x10(%ebp)
  802bac:	e8 bb f6 ff ff       	call   80226c <set_block_data>
  802bb1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb8:	75 17                	jne    802bd1 <alloc_block_BF+0x47a>
  802bba:	83 ec 04             	sub    $0x4,%esp
  802bbd:	68 a3 45 80 00       	push   $0x8045a3
  802bc2:	68 58 01 00 00       	push   $0x158
  802bc7:	68 c1 45 80 00       	push   $0x8045c1
  802bcc:	e8 6e 0f 00 00       	call   803b3f <_panic>
  802bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	74 10                	je     802bea <alloc_block_BF+0x493>
  802bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be2:	8b 52 04             	mov    0x4(%edx),%edx
  802be5:	89 50 04             	mov    %edx,0x4(%eax)
  802be8:	eb 0b                	jmp    802bf5 <alloc_block_BF+0x49e>
  802bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bed:	8b 40 04             	mov    0x4(%eax),%eax
  802bf0:	a3 30 50 80 00       	mov    %eax,0x805030
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	74 0f                	je     802c0e <alloc_block_BF+0x4b7>
  802bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c08:	8b 12                	mov    (%edx),%edx
  802c0a:	89 10                	mov    %edx,(%eax)
  802c0c:	eb 0a                	jmp    802c18 <alloc_block_BF+0x4c1>
  802c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2b:	a1 38 50 80 00       	mov    0x805038,%eax
  802c30:	48                   	dec    %eax
  802c31:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	e9 d9 00 00 00       	jmp    802d17 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	83 c0 08             	add    $0x8,%eax
  802c44:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c47:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c4e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c51:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c54:	01 d0                	add    %edx,%eax
  802c56:	48                   	dec    %eax
  802c57:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c5a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  802c62:	f7 75 c4             	divl   -0x3c(%ebp)
  802c65:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c68:	29 d0                	sub    %edx,%eax
  802c6a:	c1 e8 0c             	shr    $0xc,%eax
  802c6d:	83 ec 0c             	sub    $0xc,%esp
  802c70:	50                   	push   %eax
  802c71:	e8 ad e6 ff ff       	call   801323 <sbrk>
  802c76:	83 c4 10             	add    $0x10,%esp
  802c79:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c7c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c80:	75 0a                	jne    802c8c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c82:	b8 00 00 00 00       	mov    $0x0,%eax
  802c87:	e9 8b 00 00 00       	jmp    802d17 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c8c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c93:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c96:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c99:	01 d0                	add    %edx,%eax
  802c9b:	48                   	dec    %eax
  802c9c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c9f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca7:	f7 75 b8             	divl   -0x48(%ebp)
  802caa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cad:	29 d0                	sub    %edx,%eax
  802caf:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cb2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cb5:	01 d0                	add    %edx,%eax
  802cb7:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cbc:	a1 40 50 80 00       	mov    0x805040,%eax
  802cc1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cc7:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cce:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cd1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cd4:	01 d0                	add    %edx,%eax
  802cd6:	48                   	dec    %eax
  802cd7:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802cda:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cdd:	ba 00 00 00 00       	mov    $0x0,%edx
  802ce2:	f7 75 b0             	divl   -0x50(%ebp)
  802ce5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ce8:	29 d0                	sub    %edx,%eax
  802cea:	83 ec 04             	sub    $0x4,%esp
  802ced:	6a 01                	push   $0x1
  802cef:	50                   	push   %eax
  802cf0:	ff 75 bc             	pushl  -0x44(%ebp)
  802cf3:	e8 74 f5 ff ff       	call   80226c <set_block_data>
  802cf8:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802cfb:	83 ec 0c             	sub    $0xc,%esp
  802cfe:	ff 75 bc             	pushl  -0x44(%ebp)
  802d01:	e8 36 04 00 00       	call   80313c <free_block>
  802d06:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d09:	83 ec 0c             	sub    $0xc,%esp
  802d0c:	ff 75 08             	pushl  0x8(%ebp)
  802d0f:	e8 43 fa ff ff       	call   802757 <alloc_block_BF>
  802d14:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d17:	c9                   	leave  
  802d18:	c3                   	ret    

00802d19 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d19:	55                   	push   %ebp
  802d1a:	89 e5                	mov    %esp,%ebp
  802d1c:	53                   	push   %ebx
  802d1d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d27:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d32:	74 1e                	je     802d52 <merging+0x39>
  802d34:	ff 75 08             	pushl  0x8(%ebp)
  802d37:	e8 df f1 ff ff       	call   801f1b <get_block_size>
  802d3c:	83 c4 04             	add    $0x4,%esp
  802d3f:	89 c2                	mov    %eax,%edx
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	01 d0                	add    %edx,%eax
  802d46:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d49:	75 07                	jne    802d52 <merging+0x39>
		prev_is_free = 1;
  802d4b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d56:	74 1e                	je     802d76 <merging+0x5d>
  802d58:	ff 75 10             	pushl  0x10(%ebp)
  802d5b:	e8 bb f1 ff ff       	call   801f1b <get_block_size>
  802d60:	83 c4 04             	add    $0x4,%esp
  802d63:	89 c2                	mov    %eax,%edx
  802d65:	8b 45 10             	mov    0x10(%ebp),%eax
  802d68:	01 d0                	add    %edx,%eax
  802d6a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d6d:	75 07                	jne    802d76 <merging+0x5d>
		next_is_free = 1;
  802d6f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7a:	0f 84 cc 00 00 00    	je     802e4c <merging+0x133>
  802d80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d84:	0f 84 c2 00 00 00    	je     802e4c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d8a:	ff 75 08             	pushl  0x8(%ebp)
  802d8d:	e8 89 f1 ff ff       	call   801f1b <get_block_size>
  802d92:	83 c4 04             	add    $0x4,%esp
  802d95:	89 c3                	mov    %eax,%ebx
  802d97:	ff 75 10             	pushl  0x10(%ebp)
  802d9a:	e8 7c f1 ff ff       	call   801f1b <get_block_size>
  802d9f:	83 c4 04             	add    $0x4,%esp
  802da2:	01 c3                	add    %eax,%ebx
  802da4:	ff 75 0c             	pushl  0xc(%ebp)
  802da7:	e8 6f f1 ff ff       	call   801f1b <get_block_size>
  802dac:	83 c4 04             	add    $0x4,%esp
  802daf:	01 d8                	add    %ebx,%eax
  802db1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802db4:	6a 00                	push   $0x0
  802db6:	ff 75 ec             	pushl  -0x14(%ebp)
  802db9:	ff 75 08             	pushl  0x8(%ebp)
  802dbc:	e8 ab f4 ff ff       	call   80226c <set_block_data>
  802dc1:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802dc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dc8:	75 17                	jne    802de1 <merging+0xc8>
  802dca:	83 ec 04             	sub    $0x4,%esp
  802dcd:	68 a3 45 80 00       	push   $0x8045a3
  802dd2:	68 7d 01 00 00       	push   $0x17d
  802dd7:	68 c1 45 80 00       	push   $0x8045c1
  802ddc:	e8 5e 0d 00 00       	call   803b3f <_panic>
  802de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	74 10                	je     802dfa <merging+0xe1>
  802dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df2:	8b 52 04             	mov    0x4(%edx),%edx
  802df5:	89 50 04             	mov    %edx,0x4(%eax)
  802df8:	eb 0b                	jmp    802e05 <merging+0xec>
  802dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	a3 30 50 80 00       	mov    %eax,0x805030
  802e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e08:	8b 40 04             	mov    0x4(%eax),%eax
  802e0b:	85 c0                	test   %eax,%eax
  802e0d:	74 0f                	je     802e1e <merging+0x105>
  802e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e12:	8b 40 04             	mov    0x4(%eax),%eax
  802e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e18:	8b 12                	mov    (%edx),%edx
  802e1a:	89 10                	mov    %edx,(%eax)
  802e1c:	eb 0a                	jmp    802e28 <merging+0x10f>
  802e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e40:	48                   	dec    %eax
  802e41:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e46:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e47:	e9 ea 02 00 00       	jmp    803136 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e50:	74 3b                	je     802e8d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e52:	83 ec 0c             	sub    $0xc,%esp
  802e55:	ff 75 08             	pushl  0x8(%ebp)
  802e58:	e8 be f0 ff ff       	call   801f1b <get_block_size>
  802e5d:	83 c4 10             	add    $0x10,%esp
  802e60:	89 c3                	mov    %eax,%ebx
  802e62:	83 ec 0c             	sub    $0xc,%esp
  802e65:	ff 75 10             	pushl  0x10(%ebp)
  802e68:	e8 ae f0 ff ff       	call   801f1b <get_block_size>
  802e6d:	83 c4 10             	add    $0x10,%esp
  802e70:	01 d8                	add    %ebx,%eax
  802e72:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e75:	83 ec 04             	sub    $0x4,%esp
  802e78:	6a 00                	push   $0x0
  802e7a:	ff 75 e8             	pushl  -0x18(%ebp)
  802e7d:	ff 75 08             	pushl  0x8(%ebp)
  802e80:	e8 e7 f3 ff ff       	call   80226c <set_block_data>
  802e85:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e88:	e9 a9 02 00 00       	jmp    803136 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e91:	0f 84 2d 01 00 00    	je     802fc4 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e97:	83 ec 0c             	sub    $0xc,%esp
  802e9a:	ff 75 10             	pushl  0x10(%ebp)
  802e9d:	e8 79 f0 ff ff       	call   801f1b <get_block_size>
  802ea2:	83 c4 10             	add    $0x10,%esp
  802ea5:	89 c3                	mov    %eax,%ebx
  802ea7:	83 ec 0c             	sub    $0xc,%esp
  802eaa:	ff 75 0c             	pushl  0xc(%ebp)
  802ead:	e8 69 f0 ff ff       	call   801f1b <get_block_size>
  802eb2:	83 c4 10             	add    $0x10,%esp
  802eb5:	01 d8                	add    %ebx,%eax
  802eb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802eba:	83 ec 04             	sub    $0x4,%esp
  802ebd:	6a 00                	push   $0x0
  802ebf:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ec2:	ff 75 10             	pushl  0x10(%ebp)
  802ec5:	e8 a2 f3 ff ff       	call   80226c <set_block_data>
  802eca:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  802ed0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ed3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ed7:	74 06                	je     802edf <merging+0x1c6>
  802ed9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802edd:	75 17                	jne    802ef6 <merging+0x1dd>
  802edf:	83 ec 04             	sub    $0x4,%esp
  802ee2:	68 68 46 80 00       	push   $0x804668
  802ee7:	68 8d 01 00 00       	push   $0x18d
  802eec:	68 c1 45 80 00       	push   $0x8045c1
  802ef1:	e8 49 0c 00 00       	call   803b3f <_panic>
  802ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef9:	8b 50 04             	mov    0x4(%eax),%edx
  802efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eff:	89 50 04             	mov    %edx,0x4(%eax)
  802f02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f05:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f08:	89 10                	mov    %edx,(%eax)
  802f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0d:	8b 40 04             	mov    0x4(%eax),%eax
  802f10:	85 c0                	test   %eax,%eax
  802f12:	74 0d                	je     802f21 <merging+0x208>
  802f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f17:	8b 40 04             	mov    0x4(%eax),%eax
  802f1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f1d:	89 10                	mov    %edx,(%eax)
  802f1f:	eb 08                	jmp    802f29 <merging+0x210>
  802f21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f24:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f2f:	89 50 04             	mov    %edx,0x4(%eax)
  802f32:	a1 38 50 80 00       	mov    0x805038,%eax
  802f37:	40                   	inc    %eax
  802f38:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f41:	75 17                	jne    802f5a <merging+0x241>
  802f43:	83 ec 04             	sub    $0x4,%esp
  802f46:	68 a3 45 80 00       	push   $0x8045a3
  802f4b:	68 8e 01 00 00       	push   $0x18e
  802f50:	68 c1 45 80 00       	push   $0x8045c1
  802f55:	e8 e5 0b 00 00       	call   803b3f <_panic>
  802f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	85 c0                	test   %eax,%eax
  802f61:	74 10                	je     802f73 <merging+0x25a>
  802f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f66:	8b 00                	mov    (%eax),%eax
  802f68:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f6b:	8b 52 04             	mov    0x4(%edx),%edx
  802f6e:	89 50 04             	mov    %edx,0x4(%eax)
  802f71:	eb 0b                	jmp    802f7e <merging+0x265>
  802f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f76:	8b 40 04             	mov    0x4(%eax),%eax
  802f79:	a3 30 50 80 00       	mov    %eax,0x805030
  802f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f81:	8b 40 04             	mov    0x4(%eax),%eax
  802f84:	85 c0                	test   %eax,%eax
  802f86:	74 0f                	je     802f97 <merging+0x27e>
  802f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8b:	8b 40 04             	mov    0x4(%eax),%eax
  802f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f91:	8b 12                	mov    (%edx),%edx
  802f93:	89 10                	mov    %edx,(%eax)
  802f95:	eb 0a                	jmp    802fa1 <merging+0x288>
  802f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9a:	8b 00                	mov    (%eax),%eax
  802f9c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb4:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb9:	48                   	dec    %eax
  802fba:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fbf:	e9 72 01 00 00       	jmp    803136 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  802fc7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802fca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fce:	74 79                	je     803049 <merging+0x330>
  802fd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fd4:	74 73                	je     803049 <merging+0x330>
  802fd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fda:	74 06                	je     802fe2 <merging+0x2c9>
  802fdc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fe0:	75 17                	jne    802ff9 <merging+0x2e0>
  802fe2:	83 ec 04             	sub    $0x4,%esp
  802fe5:	68 34 46 80 00       	push   $0x804634
  802fea:	68 94 01 00 00       	push   $0x194
  802fef:	68 c1 45 80 00       	push   $0x8045c1
  802ff4:	e8 46 0b 00 00       	call   803b3f <_panic>
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	8b 10                	mov    (%eax),%edx
  802ffe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803001:	89 10                	mov    %edx,(%eax)
  803003:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	85 c0                	test   %eax,%eax
  80300a:	74 0b                	je     803017 <merging+0x2fe>
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803014:	89 50 04             	mov    %edx,0x4(%eax)
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80301d:	89 10                	mov    %edx,(%eax)
  80301f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803022:	8b 55 08             	mov    0x8(%ebp),%edx
  803025:	89 50 04             	mov    %edx,0x4(%eax)
  803028:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302b:	8b 00                	mov    (%eax),%eax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	75 08                	jne    803039 <merging+0x320>
  803031:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803034:	a3 30 50 80 00       	mov    %eax,0x805030
  803039:	a1 38 50 80 00       	mov    0x805038,%eax
  80303e:	40                   	inc    %eax
  80303f:	a3 38 50 80 00       	mov    %eax,0x805038
  803044:	e9 ce 00 00 00       	jmp    803117 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803049:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304d:	74 65                	je     8030b4 <merging+0x39b>
  80304f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803053:	75 17                	jne    80306c <merging+0x353>
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	68 10 46 80 00       	push   $0x804610
  80305d:	68 95 01 00 00       	push   $0x195
  803062:	68 c1 45 80 00       	push   $0x8045c1
  803067:	e8 d3 0a 00 00       	call   803b3f <_panic>
  80306c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803072:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803075:	89 50 04             	mov    %edx,0x4(%eax)
  803078:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307b:	8b 40 04             	mov    0x4(%eax),%eax
  80307e:	85 c0                	test   %eax,%eax
  803080:	74 0c                	je     80308e <merging+0x375>
  803082:	a1 30 50 80 00       	mov    0x805030,%eax
  803087:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80308a:	89 10                	mov    %edx,(%eax)
  80308c:	eb 08                	jmp    803096 <merging+0x37d>
  80308e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803091:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803096:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803099:	a3 30 50 80 00       	mov    %eax,0x805030
  80309e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8030ac:	40                   	inc    %eax
  8030ad:	a3 38 50 80 00       	mov    %eax,0x805038
  8030b2:	eb 63                	jmp    803117 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030b8:	75 17                	jne    8030d1 <merging+0x3b8>
  8030ba:	83 ec 04             	sub    $0x4,%esp
  8030bd:	68 dc 45 80 00       	push   $0x8045dc
  8030c2:	68 98 01 00 00       	push   $0x198
  8030c7:	68 c1 45 80 00       	push   $0x8045c1
  8030cc:	e8 6e 0a 00 00       	call   803b3f <_panic>
  8030d1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030da:	89 10                	mov    %edx,(%eax)
  8030dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	85 c0                	test   %eax,%eax
  8030e3:	74 0d                	je     8030f2 <merging+0x3d9>
  8030e5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ed:	89 50 04             	mov    %edx,0x4(%eax)
  8030f0:	eb 08                	jmp    8030fa <merging+0x3e1>
  8030f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8030fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803102:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803105:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310c:	a1 38 50 80 00       	mov    0x805038,%eax
  803111:	40                   	inc    %eax
  803112:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803117:	83 ec 0c             	sub    $0xc,%esp
  80311a:	ff 75 10             	pushl  0x10(%ebp)
  80311d:	e8 f9 ed ff ff       	call   801f1b <get_block_size>
  803122:	83 c4 10             	add    $0x10,%esp
  803125:	83 ec 04             	sub    $0x4,%esp
  803128:	6a 00                	push   $0x0
  80312a:	50                   	push   %eax
  80312b:	ff 75 10             	pushl  0x10(%ebp)
  80312e:	e8 39 f1 ff ff       	call   80226c <set_block_data>
  803133:	83 c4 10             	add    $0x10,%esp
	}
}
  803136:	90                   	nop
  803137:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80313a:	c9                   	leave  
  80313b:	c3                   	ret    

0080313c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80313c:	55                   	push   %ebp
  80313d:	89 e5                	mov    %esp,%ebp
  80313f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803142:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803147:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80314a:	a1 30 50 80 00       	mov    0x805030,%eax
  80314f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803152:	73 1b                	jae    80316f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803154:	a1 30 50 80 00       	mov    0x805030,%eax
  803159:	83 ec 04             	sub    $0x4,%esp
  80315c:	ff 75 08             	pushl  0x8(%ebp)
  80315f:	6a 00                	push   $0x0
  803161:	50                   	push   %eax
  803162:	e8 b2 fb ff ff       	call   802d19 <merging>
  803167:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80316a:	e9 8b 00 00 00       	jmp    8031fa <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80316f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803174:	3b 45 08             	cmp    0x8(%ebp),%eax
  803177:	76 18                	jbe    803191 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803179:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	ff 75 08             	pushl  0x8(%ebp)
  803184:	50                   	push   %eax
  803185:	6a 00                	push   $0x0
  803187:	e8 8d fb ff ff       	call   802d19 <merging>
  80318c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80318f:	eb 69                	jmp    8031fa <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803191:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803196:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803199:	eb 39                	jmp    8031d4 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a1:	73 29                	jae    8031cc <free_block+0x90>
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 00                	mov    (%eax),%eax
  8031a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ab:	76 1f                	jbe    8031cc <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031b5:	83 ec 04             	sub    $0x4,%esp
  8031b8:	ff 75 08             	pushl  0x8(%ebp)
  8031bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8031be:	ff 75 f4             	pushl  -0xc(%ebp)
  8031c1:	e8 53 fb ff ff       	call   802d19 <merging>
  8031c6:	83 c4 10             	add    $0x10,%esp
			break;
  8031c9:	90                   	nop
		}
	}
}
  8031ca:	eb 2e                	jmp    8031fa <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031cc:	a1 34 50 80 00       	mov    0x805034,%eax
  8031d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d8:	74 07                	je     8031e1 <free_block+0xa5>
  8031da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	eb 05                	jmp    8031e6 <free_block+0xaa>
  8031e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e6:	a3 34 50 80 00       	mov    %eax,0x805034
  8031eb:	a1 34 50 80 00       	mov    0x805034,%eax
  8031f0:	85 c0                	test   %eax,%eax
  8031f2:	75 a7                	jne    80319b <free_block+0x5f>
  8031f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f8:	75 a1                	jne    80319b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031fa:	90                   	nop
  8031fb:	c9                   	leave  
  8031fc:	c3                   	ret    

008031fd <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031fd:	55                   	push   %ebp
  8031fe:	89 e5                	mov    %esp,%ebp
  803200:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803203:	ff 75 08             	pushl  0x8(%ebp)
  803206:	e8 10 ed ff ff       	call   801f1b <get_block_size>
  80320b:	83 c4 04             	add    $0x4,%esp
  80320e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803218:	eb 17                	jmp    803231 <copy_data+0x34>
  80321a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80321d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803220:	01 c2                	add    %eax,%edx
  803222:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	01 c8                	add    %ecx,%eax
  80322a:	8a 00                	mov    (%eax),%al
  80322c:	88 02                	mov    %al,(%edx)
  80322e:	ff 45 fc             	incl   -0x4(%ebp)
  803231:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803234:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803237:	72 e1                	jb     80321a <copy_data+0x1d>
}
  803239:	90                   	nop
  80323a:	c9                   	leave  
  80323b:	c3                   	ret    

0080323c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80323c:	55                   	push   %ebp
  80323d:	89 e5                	mov    %esp,%ebp
  80323f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803242:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803246:	75 23                	jne    80326b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803248:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80324c:	74 13                	je     803261 <realloc_block_FF+0x25>
  80324e:	83 ec 0c             	sub    $0xc,%esp
  803251:	ff 75 0c             	pushl  0xc(%ebp)
  803254:	e8 42 f0 ff ff       	call   80229b <alloc_block_FF>
  803259:	83 c4 10             	add    $0x10,%esp
  80325c:	e9 e4 06 00 00       	jmp    803945 <realloc_block_FF+0x709>
		return NULL;
  803261:	b8 00 00 00 00       	mov    $0x0,%eax
  803266:	e9 da 06 00 00       	jmp    803945 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  80326b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80326f:	75 18                	jne    803289 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803271:	83 ec 0c             	sub    $0xc,%esp
  803274:	ff 75 08             	pushl  0x8(%ebp)
  803277:	e8 c0 fe ff ff       	call   80313c <free_block>
  80327c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80327f:	b8 00 00 00 00       	mov    $0x0,%eax
  803284:	e9 bc 06 00 00       	jmp    803945 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803289:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80328d:	77 07                	ja     803296 <realloc_block_FF+0x5a>
  80328f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803296:	8b 45 0c             	mov    0xc(%ebp),%eax
  803299:	83 e0 01             	and    $0x1,%eax
  80329c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80329f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a2:	83 c0 08             	add    $0x8,%eax
  8032a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032a8:	83 ec 0c             	sub    $0xc,%esp
  8032ab:	ff 75 08             	pushl  0x8(%ebp)
  8032ae:	e8 68 ec ff ff       	call   801f1b <get_block_size>
  8032b3:	83 c4 10             	add    $0x10,%esp
  8032b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bc:	83 e8 08             	sub    $0x8,%eax
  8032bf:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	83 e8 04             	sub    $0x4,%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	83 e0 fe             	and    $0xfffffffe,%eax
  8032cd:	89 c2                	mov    %eax,%edx
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	01 d0                	add    %edx,%eax
  8032d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032d7:	83 ec 0c             	sub    $0xc,%esp
  8032da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032dd:	e8 39 ec ff ff       	call   801f1b <get_block_size>
  8032e2:	83 c4 10             	add    $0x10,%esp
  8032e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032eb:	83 e8 08             	sub    $0x8,%eax
  8032ee:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032f7:	75 08                	jne    803301 <realloc_block_FF+0xc5>
	{
		 return va;
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	e9 44 06 00 00       	jmp    803945 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803301:	8b 45 0c             	mov    0xc(%ebp),%eax
  803304:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803307:	0f 83 d5 03 00 00    	jae    8036e2 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803310:	2b 45 0c             	sub    0xc(%ebp),%eax
  803313:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803316:	83 ec 0c             	sub    $0xc,%esp
  803319:	ff 75 e4             	pushl  -0x1c(%ebp)
  80331c:	e8 13 ec ff ff       	call   801f34 <is_free_block>
  803321:	83 c4 10             	add    $0x10,%esp
  803324:	84 c0                	test   %al,%al
  803326:	0f 84 3b 01 00 00    	je     803467 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80332c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80332f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803332:	01 d0                	add    %edx,%eax
  803334:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803337:	83 ec 04             	sub    $0x4,%esp
  80333a:	6a 01                	push   $0x1
  80333c:	ff 75 f0             	pushl  -0x10(%ebp)
  80333f:	ff 75 08             	pushl  0x8(%ebp)
  803342:	e8 25 ef ff ff       	call   80226c <set_block_data>
  803347:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	83 e8 04             	sub    $0x4,%eax
  803350:	8b 00                	mov    (%eax),%eax
  803352:	83 e0 fe             	and    $0xfffffffe,%eax
  803355:	89 c2                	mov    %eax,%edx
  803357:	8b 45 08             	mov    0x8(%ebp),%eax
  80335a:	01 d0                	add    %edx,%eax
  80335c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80335f:	83 ec 04             	sub    $0x4,%esp
  803362:	6a 00                	push   $0x0
  803364:	ff 75 cc             	pushl  -0x34(%ebp)
  803367:	ff 75 c8             	pushl  -0x38(%ebp)
  80336a:	e8 fd ee ff ff       	call   80226c <set_block_data>
  80336f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803372:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803376:	74 06                	je     80337e <realloc_block_FF+0x142>
  803378:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80337c:	75 17                	jne    803395 <realloc_block_FF+0x159>
  80337e:	83 ec 04             	sub    $0x4,%esp
  803381:	68 34 46 80 00       	push   $0x804634
  803386:	68 f6 01 00 00       	push   $0x1f6
  80338b:	68 c1 45 80 00       	push   $0x8045c1
  803390:	e8 aa 07 00 00       	call   803b3f <_panic>
  803395:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803398:	8b 10                	mov    (%eax),%edx
  80339a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80339d:	89 10                	mov    %edx,(%eax)
  80339f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	74 0b                	je     8033b3 <realloc_block_FF+0x177>
  8033a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ab:	8b 00                	mov    (%eax),%eax
  8033ad:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033b0:	89 50 04             	mov    %edx,0x4(%eax)
  8033b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033b9:	89 10                	mov    %edx,(%eax)
  8033bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033c1:	89 50 04             	mov    %edx,0x4(%eax)
  8033c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033c7:	8b 00                	mov    (%eax),%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	75 08                	jne    8033d5 <realloc_block_FF+0x199>
  8033cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8033d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8033da:	40                   	inc    %eax
  8033db:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033e4:	75 17                	jne    8033fd <realloc_block_FF+0x1c1>
  8033e6:	83 ec 04             	sub    $0x4,%esp
  8033e9:	68 a3 45 80 00       	push   $0x8045a3
  8033ee:	68 f7 01 00 00       	push   $0x1f7
  8033f3:	68 c1 45 80 00       	push   $0x8045c1
  8033f8:	e8 42 07 00 00       	call   803b3f <_panic>
  8033fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803400:	8b 00                	mov    (%eax),%eax
  803402:	85 c0                	test   %eax,%eax
  803404:	74 10                	je     803416 <realloc_block_FF+0x1da>
  803406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803409:	8b 00                	mov    (%eax),%eax
  80340b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80340e:	8b 52 04             	mov    0x4(%edx),%edx
  803411:	89 50 04             	mov    %edx,0x4(%eax)
  803414:	eb 0b                	jmp    803421 <realloc_block_FF+0x1e5>
  803416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803419:	8b 40 04             	mov    0x4(%eax),%eax
  80341c:	a3 30 50 80 00       	mov    %eax,0x805030
  803421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803424:	8b 40 04             	mov    0x4(%eax),%eax
  803427:	85 c0                	test   %eax,%eax
  803429:	74 0f                	je     80343a <realloc_block_FF+0x1fe>
  80342b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342e:	8b 40 04             	mov    0x4(%eax),%eax
  803431:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803434:	8b 12                	mov    (%edx),%edx
  803436:	89 10                	mov    %edx,(%eax)
  803438:	eb 0a                	jmp    803444 <realloc_block_FF+0x208>
  80343a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343d:	8b 00                	mov    (%eax),%eax
  80343f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803447:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80344d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803450:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803457:	a1 38 50 80 00       	mov    0x805038,%eax
  80345c:	48                   	dec    %eax
  80345d:	a3 38 50 80 00       	mov    %eax,0x805038
  803462:	e9 73 02 00 00       	jmp    8036da <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803467:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80346b:	0f 86 69 02 00 00    	jbe    8036da <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803471:	83 ec 04             	sub    $0x4,%esp
  803474:	6a 01                	push   $0x1
  803476:	ff 75 f0             	pushl  -0x10(%ebp)
  803479:	ff 75 08             	pushl  0x8(%ebp)
  80347c:	e8 eb ed ff ff       	call   80226c <set_block_data>
  803481:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	83 e8 04             	sub    $0x4,%eax
  80348a:	8b 00                	mov    (%eax),%eax
  80348c:	83 e0 fe             	and    $0xfffffffe,%eax
  80348f:	89 c2                	mov    %eax,%edx
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	01 d0                	add    %edx,%eax
  803496:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803499:	a1 38 50 80 00       	mov    0x805038,%eax
  80349e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034a1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034a5:	75 68                	jne    80350f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034a7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034ab:	75 17                	jne    8034c4 <realloc_block_FF+0x288>
  8034ad:	83 ec 04             	sub    $0x4,%esp
  8034b0:	68 dc 45 80 00       	push   $0x8045dc
  8034b5:	68 06 02 00 00       	push   $0x206
  8034ba:	68 c1 45 80 00       	push   $0x8045c1
  8034bf:	e8 7b 06 00 00       	call   803b3f <_panic>
  8034c4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034cd:	89 10                	mov    %edx,(%eax)
  8034cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d2:	8b 00                	mov    (%eax),%eax
  8034d4:	85 c0                	test   %eax,%eax
  8034d6:	74 0d                	je     8034e5 <realloc_block_FF+0x2a9>
  8034d8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034e0:	89 50 04             	mov    %edx,0x4(%eax)
  8034e3:	eb 08                	jmp    8034ed <realloc_block_FF+0x2b1>
  8034e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ff:	a1 38 50 80 00       	mov    0x805038,%eax
  803504:	40                   	inc    %eax
  803505:	a3 38 50 80 00       	mov    %eax,0x805038
  80350a:	e9 b0 01 00 00       	jmp    8036bf <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80350f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803514:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803517:	76 68                	jbe    803581 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803519:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80351d:	75 17                	jne    803536 <realloc_block_FF+0x2fa>
  80351f:	83 ec 04             	sub    $0x4,%esp
  803522:	68 dc 45 80 00       	push   $0x8045dc
  803527:	68 0b 02 00 00       	push   $0x20b
  80352c:	68 c1 45 80 00       	push   $0x8045c1
  803531:	e8 09 06 00 00       	call   803b3f <_panic>
  803536:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80353c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353f:	89 10                	mov    %edx,(%eax)
  803541:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803544:	8b 00                	mov    (%eax),%eax
  803546:	85 c0                	test   %eax,%eax
  803548:	74 0d                	je     803557 <realloc_block_FF+0x31b>
  80354a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80354f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803552:	89 50 04             	mov    %edx,0x4(%eax)
  803555:	eb 08                	jmp    80355f <realloc_block_FF+0x323>
  803557:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355a:	a3 30 50 80 00       	mov    %eax,0x805030
  80355f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803562:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803571:	a1 38 50 80 00       	mov    0x805038,%eax
  803576:	40                   	inc    %eax
  803577:	a3 38 50 80 00       	mov    %eax,0x805038
  80357c:	e9 3e 01 00 00       	jmp    8036bf <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803581:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803586:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803589:	73 68                	jae    8035f3 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80358b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80358f:	75 17                	jne    8035a8 <realloc_block_FF+0x36c>
  803591:	83 ec 04             	sub    $0x4,%esp
  803594:	68 10 46 80 00       	push   $0x804610
  803599:	68 10 02 00 00       	push   $0x210
  80359e:	68 c1 45 80 00       	push   $0x8045c1
  8035a3:	e8 97 05 00 00       	call   803b3f <_panic>
  8035a8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b1:	89 50 04             	mov    %edx,0x4(%eax)
  8035b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ba:	85 c0                	test   %eax,%eax
  8035bc:	74 0c                	je     8035ca <realloc_block_FF+0x38e>
  8035be:	a1 30 50 80 00       	mov    0x805030,%eax
  8035c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035c6:	89 10                	mov    %edx,(%eax)
  8035c8:	eb 08                	jmp    8035d2 <realloc_block_FF+0x396>
  8035ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8035da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e8:	40                   	inc    %eax
  8035e9:	a3 38 50 80 00       	mov    %eax,0x805038
  8035ee:	e9 cc 00 00 00       	jmp    8036bf <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035fa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803602:	e9 8a 00 00 00       	jmp    803691 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80360d:	73 7a                	jae    803689 <realloc_block_FF+0x44d>
  80360f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803612:	8b 00                	mov    (%eax),%eax
  803614:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803617:	73 70                	jae    803689 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361d:	74 06                	je     803625 <realloc_block_FF+0x3e9>
  80361f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803623:	75 17                	jne    80363c <realloc_block_FF+0x400>
  803625:	83 ec 04             	sub    $0x4,%esp
  803628:	68 34 46 80 00       	push   $0x804634
  80362d:	68 1a 02 00 00       	push   $0x21a
  803632:	68 c1 45 80 00       	push   $0x8045c1
  803637:	e8 03 05 00 00       	call   803b3f <_panic>
  80363c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363f:	8b 10                	mov    (%eax),%edx
  803641:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803644:	89 10                	mov    %edx,(%eax)
  803646:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803649:	8b 00                	mov    (%eax),%eax
  80364b:	85 c0                	test   %eax,%eax
  80364d:	74 0b                	je     80365a <realloc_block_FF+0x41e>
  80364f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803652:	8b 00                	mov    (%eax),%eax
  803654:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803657:	89 50 04             	mov    %edx,0x4(%eax)
  80365a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803660:	89 10                	mov    %edx,(%eax)
  803662:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803665:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803668:	89 50 04             	mov    %edx,0x4(%eax)
  80366b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366e:	8b 00                	mov    (%eax),%eax
  803670:	85 c0                	test   %eax,%eax
  803672:	75 08                	jne    80367c <realloc_block_FF+0x440>
  803674:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803677:	a3 30 50 80 00       	mov    %eax,0x805030
  80367c:	a1 38 50 80 00       	mov    0x805038,%eax
  803681:	40                   	inc    %eax
  803682:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803687:	eb 36                	jmp    8036bf <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803689:	a1 34 50 80 00       	mov    0x805034,%eax
  80368e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803695:	74 07                	je     80369e <realloc_block_FF+0x462>
  803697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	eb 05                	jmp    8036a3 <realloc_block_FF+0x467>
  80369e:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8036a8:	a1 34 50 80 00       	mov    0x805034,%eax
  8036ad:	85 c0                	test   %eax,%eax
  8036af:	0f 85 52 ff ff ff    	jne    803607 <realloc_block_FF+0x3cb>
  8036b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b9:	0f 85 48 ff ff ff    	jne    803607 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036bf:	83 ec 04             	sub    $0x4,%esp
  8036c2:	6a 00                	push   $0x0
  8036c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8036c7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036ca:	e8 9d eb ff ff       	call   80226c <set_block_data>
  8036cf:	83 c4 10             	add    $0x10,%esp
				return va;
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	e9 6b 02 00 00       	jmp    803945 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8036da:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dd:	e9 63 02 00 00       	jmp    803945 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8036e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036e8:	0f 86 4d 02 00 00    	jbe    80393b <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8036ee:	83 ec 0c             	sub    $0xc,%esp
  8036f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036f4:	e8 3b e8 ff ff       	call   801f34 <is_free_block>
  8036f9:	83 c4 10             	add    $0x10,%esp
  8036fc:	84 c0                	test   %al,%al
  8036fe:	0f 84 37 02 00 00    	je     80393b <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803704:	8b 45 0c             	mov    0xc(%ebp),%eax
  803707:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80370a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80370d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803710:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803713:	76 38                	jbe    80374d <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803715:	83 ec 0c             	sub    $0xc,%esp
  803718:	ff 75 0c             	pushl  0xc(%ebp)
  80371b:	e8 7b eb ff ff       	call   80229b <alloc_block_FF>
  803720:	83 c4 10             	add    $0x10,%esp
  803723:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803726:	83 ec 08             	sub    $0x8,%esp
  803729:	ff 75 c0             	pushl  -0x40(%ebp)
  80372c:	ff 75 08             	pushl  0x8(%ebp)
  80372f:	e8 c9 fa ff ff       	call   8031fd <copy_data>
  803734:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803737:	83 ec 0c             	sub    $0xc,%esp
  80373a:	ff 75 08             	pushl  0x8(%ebp)
  80373d:	e8 fa f9 ff ff       	call   80313c <free_block>
  803742:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803745:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803748:	e9 f8 01 00 00       	jmp    803945 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80374d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803750:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803753:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803756:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80375a:	0f 87 a0 00 00 00    	ja     803800 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803760:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803764:	75 17                	jne    80377d <realloc_block_FF+0x541>
  803766:	83 ec 04             	sub    $0x4,%esp
  803769:	68 a3 45 80 00       	push   $0x8045a3
  80376e:	68 38 02 00 00       	push   $0x238
  803773:	68 c1 45 80 00       	push   $0x8045c1
  803778:	e8 c2 03 00 00       	call   803b3f <_panic>
  80377d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803780:	8b 00                	mov    (%eax),%eax
  803782:	85 c0                	test   %eax,%eax
  803784:	74 10                	je     803796 <realloc_block_FF+0x55a>
  803786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803789:	8b 00                	mov    (%eax),%eax
  80378b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80378e:	8b 52 04             	mov    0x4(%edx),%edx
  803791:	89 50 04             	mov    %edx,0x4(%eax)
  803794:	eb 0b                	jmp    8037a1 <realloc_block_FF+0x565>
  803796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803799:	8b 40 04             	mov    0x4(%eax),%eax
  80379c:	a3 30 50 80 00       	mov    %eax,0x805030
  8037a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a4:	8b 40 04             	mov    0x4(%eax),%eax
  8037a7:	85 c0                	test   %eax,%eax
  8037a9:	74 0f                	je     8037ba <realloc_block_FF+0x57e>
  8037ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ae:	8b 40 04             	mov    0x4(%eax),%eax
  8037b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037b4:	8b 12                	mov    (%edx),%edx
  8037b6:	89 10                	mov    %edx,(%eax)
  8037b8:	eb 0a                	jmp    8037c4 <realloc_block_FF+0x588>
  8037ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bd:	8b 00                	mov    (%eax),%eax
  8037bf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8037dc:	48                   	dec    %eax
  8037dd:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e8:	01 d0                	add    %edx,%eax
  8037ea:	83 ec 04             	sub    $0x4,%esp
  8037ed:	6a 01                	push   $0x1
  8037ef:	50                   	push   %eax
  8037f0:	ff 75 08             	pushl  0x8(%ebp)
  8037f3:	e8 74 ea ff ff       	call   80226c <set_block_data>
  8037f8:	83 c4 10             	add    $0x10,%esp
  8037fb:	e9 36 01 00 00       	jmp    803936 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803800:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803803:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803806:	01 d0                	add    %edx,%eax
  803808:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80380b:	83 ec 04             	sub    $0x4,%esp
  80380e:	6a 01                	push   $0x1
  803810:	ff 75 f0             	pushl  -0x10(%ebp)
  803813:	ff 75 08             	pushl  0x8(%ebp)
  803816:	e8 51 ea ff ff       	call   80226c <set_block_data>
  80381b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80381e:	8b 45 08             	mov    0x8(%ebp),%eax
  803821:	83 e8 04             	sub    $0x4,%eax
  803824:	8b 00                	mov    (%eax),%eax
  803826:	83 e0 fe             	and    $0xfffffffe,%eax
  803829:	89 c2                	mov    %eax,%edx
  80382b:	8b 45 08             	mov    0x8(%ebp),%eax
  80382e:	01 d0                	add    %edx,%eax
  803830:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803833:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803837:	74 06                	je     80383f <realloc_block_FF+0x603>
  803839:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80383d:	75 17                	jne    803856 <realloc_block_FF+0x61a>
  80383f:	83 ec 04             	sub    $0x4,%esp
  803842:	68 34 46 80 00       	push   $0x804634
  803847:	68 44 02 00 00       	push   $0x244
  80384c:	68 c1 45 80 00       	push   $0x8045c1
  803851:	e8 e9 02 00 00       	call   803b3f <_panic>
  803856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803859:	8b 10                	mov    (%eax),%edx
  80385b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80385e:	89 10                	mov    %edx,(%eax)
  803860:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803863:	8b 00                	mov    (%eax),%eax
  803865:	85 c0                	test   %eax,%eax
  803867:	74 0b                	je     803874 <realloc_block_FF+0x638>
  803869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386c:	8b 00                	mov    (%eax),%eax
  80386e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803871:	89 50 04             	mov    %edx,0x4(%eax)
  803874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803877:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80387a:	89 10                	mov    %edx,(%eax)
  80387c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80387f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803882:	89 50 04             	mov    %edx,0x4(%eax)
  803885:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803888:	8b 00                	mov    (%eax),%eax
  80388a:	85 c0                	test   %eax,%eax
  80388c:	75 08                	jne    803896 <realloc_block_FF+0x65a>
  80388e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803891:	a3 30 50 80 00       	mov    %eax,0x805030
  803896:	a1 38 50 80 00       	mov    0x805038,%eax
  80389b:	40                   	inc    %eax
  80389c:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038a5:	75 17                	jne    8038be <realloc_block_FF+0x682>
  8038a7:	83 ec 04             	sub    $0x4,%esp
  8038aa:	68 a3 45 80 00       	push   $0x8045a3
  8038af:	68 45 02 00 00       	push   $0x245
  8038b4:	68 c1 45 80 00       	push   $0x8045c1
  8038b9:	e8 81 02 00 00       	call   803b3f <_panic>
  8038be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c1:	8b 00                	mov    (%eax),%eax
  8038c3:	85 c0                	test   %eax,%eax
  8038c5:	74 10                	je     8038d7 <realloc_block_FF+0x69b>
  8038c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ca:	8b 00                	mov    (%eax),%eax
  8038cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038cf:	8b 52 04             	mov    0x4(%edx),%edx
  8038d2:	89 50 04             	mov    %edx,0x4(%eax)
  8038d5:	eb 0b                	jmp    8038e2 <realloc_block_FF+0x6a6>
  8038d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038da:	8b 40 04             	mov    0x4(%eax),%eax
  8038dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8038e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e5:	8b 40 04             	mov    0x4(%eax),%eax
  8038e8:	85 c0                	test   %eax,%eax
  8038ea:	74 0f                	je     8038fb <realloc_block_FF+0x6bf>
  8038ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ef:	8b 40 04             	mov    0x4(%eax),%eax
  8038f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f5:	8b 12                	mov    (%edx),%edx
  8038f7:	89 10                	mov    %edx,(%eax)
  8038f9:	eb 0a                	jmp    803905 <realloc_block_FF+0x6c9>
  8038fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fe:	8b 00                	mov    (%eax),%eax
  803900:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803908:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80390e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803911:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803918:	a1 38 50 80 00       	mov    0x805038,%eax
  80391d:	48                   	dec    %eax
  80391e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803923:	83 ec 04             	sub    $0x4,%esp
  803926:	6a 00                	push   $0x0
  803928:	ff 75 bc             	pushl  -0x44(%ebp)
  80392b:	ff 75 b8             	pushl  -0x48(%ebp)
  80392e:	e8 39 e9 ff ff       	call   80226c <set_block_data>
  803933:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803936:	8b 45 08             	mov    0x8(%ebp),%eax
  803939:	eb 0a                	jmp    803945 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80393b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803942:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803945:	c9                   	leave  
  803946:	c3                   	ret    

00803947 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803947:	55                   	push   %ebp
  803948:	89 e5                	mov    %esp,%ebp
  80394a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80394d:	83 ec 04             	sub    $0x4,%esp
  803950:	68 a0 46 80 00       	push   $0x8046a0
  803955:	68 58 02 00 00       	push   $0x258
  80395a:	68 c1 45 80 00       	push   $0x8045c1
  80395f:	e8 db 01 00 00       	call   803b3f <_panic>

00803964 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803964:	55                   	push   %ebp
  803965:	89 e5                	mov    %esp,%ebp
  803967:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80396a:	83 ec 04             	sub    $0x4,%esp
  80396d:	68 c8 46 80 00       	push   $0x8046c8
  803972:	68 61 02 00 00       	push   $0x261
  803977:	68 c1 45 80 00       	push   $0x8045c1
  80397c:	e8 be 01 00 00       	call   803b3f <_panic>

00803981 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803981:	55                   	push   %ebp
  803982:	89 e5                	mov    %esp,%ebp
  803984:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  803987:	83 ec 04             	sub    $0x4,%esp
  80398a:	6a 01                	push   $0x1
  80398c:	6a 04                	push   $0x4
  80398e:	ff 75 0c             	pushl  0xc(%ebp)
  803991:	e8 c1 dc ff ff       	call   801657 <smalloc>
  803996:	83 c4 10             	add    $0x10,%esp
  803999:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  80399c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039a0:	75 14                	jne    8039b6 <create_semaphore+0x35>
  8039a2:	83 ec 04             	sub    $0x4,%esp
  8039a5:	68 ee 46 80 00       	push   $0x8046ee
  8039aa:	6a 0d                	push   $0xd
  8039ac:	68 0b 47 80 00       	push   $0x80470b
  8039b1:	e8 89 01 00 00       	call   803b3f <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  8039b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  8039bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039bf:	8b 00                	mov    (%eax),%eax
  8039c1:	8b 55 10             	mov    0x10(%ebp),%edx
  8039c4:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  8039c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ca:	8b 00                	mov    (%eax),%eax
  8039cc:	83 ec 0c             	sub    $0xc,%esp
  8039cf:	50                   	push   %eax
  8039d0:	e8 cc e4 ff ff       	call   801ea1 <sys_init_queue>
  8039d5:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  8039d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039db:	8b 00                	mov    (%eax),%eax
  8039dd:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  8039e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039ea:	8b 12                	mov    (%edx),%edx
  8039ec:	89 10                	mov    %edx,(%eax)
}
  8039ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f1:	c9                   	leave  
  8039f2:	c2 04 00             	ret    $0x4

008039f5 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8039f5:	55                   	push   %ebp
  8039f6:	89 e5                	mov    %esp,%ebp
  8039f8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  8039fb:	83 ec 08             	sub    $0x8,%esp
  8039fe:	ff 75 10             	pushl  0x10(%ebp)
  803a01:	ff 75 0c             	pushl  0xc(%ebp)
  803a04:	e8 f3 dc ff ff       	call   8016fc <sget>
  803a09:	83 c4 10             	add    $0x10,%esp
  803a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  803a0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a13:	75 14                	jne    803a29 <get_semaphore+0x34>
  803a15:	83 ec 04             	sub    $0x4,%esp
  803a18:	68 1b 47 80 00       	push   $0x80471b
  803a1d:	6a 1f                	push   $0x1f
  803a1f:	68 0b 47 80 00       	push   $0x80470b
  803a24:	e8 16 01 00 00       	call   803b3f <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  803a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a35:	8b 12                	mov    (%edx),%edx
  803a37:	89 10                	mov    %edx,(%eax)
}
  803a39:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3c:	c9                   	leave  
  803a3d:	c2 04 00             	ret    $0x4

00803a40 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803a40:	55                   	push   %ebp
  803a41:	89 e5                	mov    %esp,%ebp
  803a43:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  803a46:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  803a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a50:	83 c0 14             	add    $0x14,%eax
  803a53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a59:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803a5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a62:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803a65:	f0 87 02             	lock xchg %eax,(%edx)
  803a68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a6f:	75 dc                	jne    803a4d <wait_semaphore+0xd>

		    sem.semdata->count--;
  803a71:	8b 45 08             	mov    0x8(%ebp),%eax
  803a74:	8b 50 10             	mov    0x10(%eax),%edx
  803a77:	4a                   	dec    %edx
  803a78:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  803a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7e:	8b 40 10             	mov    0x10(%eax),%eax
  803a81:	85 c0                	test   %eax,%eax
  803a83:	79 30                	jns    803ab5 <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  803a85:	e8 f5 e3 ff ff       	call   801e7f <sys_get_cpu_process>
  803a8a:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  803a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a90:	83 ec 08             	sub    $0x8,%esp
  803a93:	ff 75 f0             	pushl  -0x10(%ebp)
  803a96:	50                   	push   %eax
  803a97:	e8 21 e4 ff ff       	call   801ebd <sys_enqueue>
  803a9c:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  803a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa2:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  803aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aac:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  803ab3:	eb 0a                	jmp    803abf <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  803ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  803abf:	90                   	nop
  803ac0:	c9                   	leave  
  803ac1:	c3                   	ret    

00803ac2 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  803ac2:	55                   	push   %ebp
  803ac3:	89 e5                	mov    %esp,%ebp
  803ac5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  803ac8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  803acf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad2:	83 c0 14             	add    $0x14,%eax
  803ad5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803ade:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ae1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803ae7:	f0 87 02             	lock xchg %eax,(%edx)
  803aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803af1:	75 dc                	jne    803acf <signal_semaphore+0xd>
	    sem.semdata->count++;
  803af3:	8b 45 08             	mov    0x8(%ebp),%eax
  803af6:	8b 50 10             	mov    0x10(%eax),%edx
  803af9:	42                   	inc    %edx
  803afa:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  803afd:	8b 45 08             	mov    0x8(%ebp),%eax
  803b00:	8b 40 10             	mov    0x10(%eax),%eax
  803b03:	85 c0                	test   %eax,%eax
  803b05:	7f 20                	jg     803b27 <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  803b07:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0a:	83 ec 0c             	sub    $0xc,%esp
  803b0d:	50                   	push   %eax
  803b0e:	e8 c8 e3 ff ff       	call   801edb <sys_dequeue>
  803b13:	83 c4 10             	add    $0x10,%esp
  803b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  803b19:	83 ec 0c             	sub    $0xc,%esp
  803b1c:	ff 75 f0             	pushl  -0x10(%ebp)
  803b1f:	e8 db e3 ff ff       	call   801eff <sys_sched_insert_ready>
  803b24:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  803b27:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803b31:	90                   	nop
  803b32:	c9                   	leave  
  803b33:	c3                   	ret    

00803b34 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  803b34:	55                   	push   %ebp
  803b35:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803b37:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3a:	8b 40 10             	mov    0x10(%eax),%eax
}
  803b3d:	5d                   	pop    %ebp
  803b3e:	c3                   	ret    

00803b3f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803b3f:	55                   	push   %ebp
  803b40:	89 e5                	mov    %esp,%ebp
  803b42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803b45:	8d 45 10             	lea    0x10(%ebp),%eax
  803b48:	83 c0 04             	add    $0x4,%eax
  803b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803b4e:	a1 60 50 98 00       	mov    0x985060,%eax
  803b53:	85 c0                	test   %eax,%eax
  803b55:	74 16                	je     803b6d <_panic+0x2e>
		cprintf("%s: ", argv0);
  803b57:	a1 60 50 98 00       	mov    0x985060,%eax
  803b5c:	83 ec 08             	sub    $0x8,%esp
  803b5f:	50                   	push   %eax
  803b60:	68 3c 47 80 00       	push   $0x80473c
  803b65:	e8 1f ca ff ff       	call   800589 <cprintf>
  803b6a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803b6d:	a1 00 50 80 00       	mov    0x805000,%eax
  803b72:	ff 75 0c             	pushl  0xc(%ebp)
  803b75:	ff 75 08             	pushl  0x8(%ebp)
  803b78:	50                   	push   %eax
  803b79:	68 41 47 80 00       	push   $0x804741
  803b7e:	e8 06 ca ff ff       	call   800589 <cprintf>
  803b83:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803b86:	8b 45 10             	mov    0x10(%ebp),%eax
  803b89:	83 ec 08             	sub    $0x8,%esp
  803b8c:	ff 75 f4             	pushl  -0xc(%ebp)
  803b8f:	50                   	push   %eax
  803b90:	e8 89 c9 ff ff       	call   80051e <vcprintf>
  803b95:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803b98:	83 ec 08             	sub    $0x8,%esp
  803b9b:	6a 00                	push   $0x0
  803b9d:	68 5d 47 80 00       	push   $0x80475d
  803ba2:	e8 77 c9 ff ff       	call   80051e <vcprintf>
  803ba7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803baa:	e8 f8 c8 ff ff       	call   8004a7 <exit>

	// should not return here
	while (1) ;
  803baf:	eb fe                	jmp    803baf <_panic+0x70>

00803bb1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803bb1:	55                   	push   %ebp
  803bb2:	89 e5                	mov    %esp,%ebp
  803bb4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803bb7:	a1 20 50 80 00       	mov    0x805020,%eax
  803bbc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bc5:	39 c2                	cmp    %eax,%edx
  803bc7:	74 14                	je     803bdd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803bc9:	83 ec 04             	sub    $0x4,%esp
  803bcc:	68 60 47 80 00       	push   $0x804760
  803bd1:	6a 26                	push   $0x26
  803bd3:	68 ac 47 80 00       	push   $0x8047ac
  803bd8:	e8 62 ff ff ff       	call   803b3f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803bdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803be4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803beb:	e9 c5 00 00 00       	jmp    803cb5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfd:	01 d0                	add    %edx,%eax
  803bff:	8b 00                	mov    (%eax),%eax
  803c01:	85 c0                	test   %eax,%eax
  803c03:	75 08                	jne    803c0d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803c05:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803c08:	e9 a5 00 00 00       	jmp    803cb2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803c0d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c14:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803c1b:	eb 69                	jmp    803c86 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803c1d:	a1 20 50 80 00       	mov    0x805020,%eax
  803c22:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c28:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c2b:	89 d0                	mov    %edx,%eax
  803c2d:	01 c0                	add    %eax,%eax
  803c2f:	01 d0                	add    %edx,%eax
  803c31:	c1 e0 03             	shl    $0x3,%eax
  803c34:	01 c8                	add    %ecx,%eax
  803c36:	8a 40 04             	mov    0x4(%eax),%al
  803c39:	84 c0                	test   %al,%al
  803c3b:	75 46                	jne    803c83 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803c3d:	a1 20 50 80 00       	mov    0x805020,%eax
  803c42:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c4b:	89 d0                	mov    %edx,%eax
  803c4d:	01 c0                	add    %eax,%eax
  803c4f:	01 d0                	add    %edx,%eax
  803c51:	c1 e0 03             	shl    $0x3,%eax
  803c54:	01 c8                	add    %ecx,%eax
  803c56:	8b 00                	mov    (%eax),%eax
  803c58:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803c5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803c63:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c68:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c72:	01 c8                	add    %ecx,%eax
  803c74:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803c76:	39 c2                	cmp    %eax,%edx
  803c78:	75 09                	jne    803c83 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803c7a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803c81:	eb 15                	jmp    803c98 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c83:	ff 45 e8             	incl   -0x18(%ebp)
  803c86:	a1 20 50 80 00       	mov    0x805020,%eax
  803c8b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c94:	39 c2                	cmp    %eax,%edx
  803c96:	77 85                	ja     803c1d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803c98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c9c:	75 14                	jne    803cb2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803c9e:	83 ec 04             	sub    $0x4,%esp
  803ca1:	68 b8 47 80 00       	push   $0x8047b8
  803ca6:	6a 3a                	push   $0x3a
  803ca8:	68 ac 47 80 00       	push   $0x8047ac
  803cad:	e8 8d fe ff ff       	call   803b3f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803cb2:	ff 45 f0             	incl   -0x10(%ebp)
  803cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803cbb:	0f 8c 2f ff ff ff    	jl     803bf0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803cc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803cc8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803ccf:	eb 26                	jmp    803cf7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803cd1:	a1 20 50 80 00       	mov    0x805020,%eax
  803cd6:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803cdc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cdf:	89 d0                	mov    %edx,%eax
  803ce1:	01 c0                	add    %eax,%eax
  803ce3:	01 d0                	add    %edx,%eax
  803ce5:	c1 e0 03             	shl    $0x3,%eax
  803ce8:	01 c8                	add    %ecx,%eax
  803cea:	8a 40 04             	mov    0x4(%eax),%al
  803ced:	3c 01                	cmp    $0x1,%al
  803cef:	75 03                	jne    803cf4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803cf1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803cf4:	ff 45 e0             	incl   -0x20(%ebp)
  803cf7:	a1 20 50 80 00       	mov    0x805020,%eax
  803cfc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d05:	39 c2                	cmp    %eax,%edx
  803d07:	77 c8                	ja     803cd1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803d0f:	74 14                	je     803d25 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803d11:	83 ec 04             	sub    $0x4,%esp
  803d14:	68 0c 48 80 00       	push   $0x80480c
  803d19:	6a 44                	push   $0x44
  803d1b:	68 ac 47 80 00       	push   $0x8047ac
  803d20:	e8 1a fe ff ff       	call   803b3f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803d25:	90                   	nop
  803d26:	c9                   	leave  
  803d27:	c3                   	ret    

00803d28 <__udivdi3>:
  803d28:	55                   	push   %ebp
  803d29:	57                   	push   %edi
  803d2a:	56                   	push   %esi
  803d2b:	53                   	push   %ebx
  803d2c:	83 ec 1c             	sub    $0x1c,%esp
  803d2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d3f:	89 ca                	mov    %ecx,%edx
  803d41:	89 f8                	mov    %edi,%eax
  803d43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d47:	85 f6                	test   %esi,%esi
  803d49:	75 2d                	jne    803d78 <__udivdi3+0x50>
  803d4b:	39 cf                	cmp    %ecx,%edi
  803d4d:	77 65                	ja     803db4 <__udivdi3+0x8c>
  803d4f:	89 fd                	mov    %edi,%ebp
  803d51:	85 ff                	test   %edi,%edi
  803d53:	75 0b                	jne    803d60 <__udivdi3+0x38>
  803d55:	b8 01 00 00 00       	mov    $0x1,%eax
  803d5a:	31 d2                	xor    %edx,%edx
  803d5c:	f7 f7                	div    %edi
  803d5e:	89 c5                	mov    %eax,%ebp
  803d60:	31 d2                	xor    %edx,%edx
  803d62:	89 c8                	mov    %ecx,%eax
  803d64:	f7 f5                	div    %ebp
  803d66:	89 c1                	mov    %eax,%ecx
  803d68:	89 d8                	mov    %ebx,%eax
  803d6a:	f7 f5                	div    %ebp
  803d6c:	89 cf                	mov    %ecx,%edi
  803d6e:	89 fa                	mov    %edi,%edx
  803d70:	83 c4 1c             	add    $0x1c,%esp
  803d73:	5b                   	pop    %ebx
  803d74:	5e                   	pop    %esi
  803d75:	5f                   	pop    %edi
  803d76:	5d                   	pop    %ebp
  803d77:	c3                   	ret    
  803d78:	39 ce                	cmp    %ecx,%esi
  803d7a:	77 28                	ja     803da4 <__udivdi3+0x7c>
  803d7c:	0f bd fe             	bsr    %esi,%edi
  803d7f:	83 f7 1f             	xor    $0x1f,%edi
  803d82:	75 40                	jne    803dc4 <__udivdi3+0x9c>
  803d84:	39 ce                	cmp    %ecx,%esi
  803d86:	72 0a                	jb     803d92 <__udivdi3+0x6a>
  803d88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d8c:	0f 87 9e 00 00 00    	ja     803e30 <__udivdi3+0x108>
  803d92:	b8 01 00 00 00       	mov    $0x1,%eax
  803d97:	89 fa                	mov    %edi,%edx
  803d99:	83 c4 1c             	add    $0x1c,%esp
  803d9c:	5b                   	pop    %ebx
  803d9d:	5e                   	pop    %esi
  803d9e:	5f                   	pop    %edi
  803d9f:	5d                   	pop    %ebp
  803da0:	c3                   	ret    
  803da1:	8d 76 00             	lea    0x0(%esi),%esi
  803da4:	31 ff                	xor    %edi,%edi
  803da6:	31 c0                	xor    %eax,%eax
  803da8:	89 fa                	mov    %edi,%edx
  803daa:	83 c4 1c             	add    $0x1c,%esp
  803dad:	5b                   	pop    %ebx
  803dae:	5e                   	pop    %esi
  803daf:	5f                   	pop    %edi
  803db0:	5d                   	pop    %ebp
  803db1:	c3                   	ret    
  803db2:	66 90                	xchg   %ax,%ax
  803db4:	89 d8                	mov    %ebx,%eax
  803db6:	f7 f7                	div    %edi
  803db8:	31 ff                	xor    %edi,%edi
  803dba:	89 fa                	mov    %edi,%edx
  803dbc:	83 c4 1c             	add    $0x1c,%esp
  803dbf:	5b                   	pop    %ebx
  803dc0:	5e                   	pop    %esi
  803dc1:	5f                   	pop    %edi
  803dc2:	5d                   	pop    %ebp
  803dc3:	c3                   	ret    
  803dc4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803dc9:	89 eb                	mov    %ebp,%ebx
  803dcb:	29 fb                	sub    %edi,%ebx
  803dcd:	89 f9                	mov    %edi,%ecx
  803dcf:	d3 e6                	shl    %cl,%esi
  803dd1:	89 c5                	mov    %eax,%ebp
  803dd3:	88 d9                	mov    %bl,%cl
  803dd5:	d3 ed                	shr    %cl,%ebp
  803dd7:	89 e9                	mov    %ebp,%ecx
  803dd9:	09 f1                	or     %esi,%ecx
  803ddb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ddf:	89 f9                	mov    %edi,%ecx
  803de1:	d3 e0                	shl    %cl,%eax
  803de3:	89 c5                	mov    %eax,%ebp
  803de5:	89 d6                	mov    %edx,%esi
  803de7:	88 d9                	mov    %bl,%cl
  803de9:	d3 ee                	shr    %cl,%esi
  803deb:	89 f9                	mov    %edi,%ecx
  803ded:	d3 e2                	shl    %cl,%edx
  803def:	8b 44 24 08          	mov    0x8(%esp),%eax
  803df3:	88 d9                	mov    %bl,%cl
  803df5:	d3 e8                	shr    %cl,%eax
  803df7:	09 c2                	or     %eax,%edx
  803df9:	89 d0                	mov    %edx,%eax
  803dfb:	89 f2                	mov    %esi,%edx
  803dfd:	f7 74 24 0c          	divl   0xc(%esp)
  803e01:	89 d6                	mov    %edx,%esi
  803e03:	89 c3                	mov    %eax,%ebx
  803e05:	f7 e5                	mul    %ebp
  803e07:	39 d6                	cmp    %edx,%esi
  803e09:	72 19                	jb     803e24 <__udivdi3+0xfc>
  803e0b:	74 0b                	je     803e18 <__udivdi3+0xf0>
  803e0d:	89 d8                	mov    %ebx,%eax
  803e0f:	31 ff                	xor    %edi,%edi
  803e11:	e9 58 ff ff ff       	jmp    803d6e <__udivdi3+0x46>
  803e16:	66 90                	xchg   %ax,%ax
  803e18:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e1c:	89 f9                	mov    %edi,%ecx
  803e1e:	d3 e2                	shl    %cl,%edx
  803e20:	39 c2                	cmp    %eax,%edx
  803e22:	73 e9                	jae    803e0d <__udivdi3+0xe5>
  803e24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e27:	31 ff                	xor    %edi,%edi
  803e29:	e9 40 ff ff ff       	jmp    803d6e <__udivdi3+0x46>
  803e2e:	66 90                	xchg   %ax,%ax
  803e30:	31 c0                	xor    %eax,%eax
  803e32:	e9 37 ff ff ff       	jmp    803d6e <__udivdi3+0x46>
  803e37:	90                   	nop

00803e38 <__umoddi3>:
  803e38:	55                   	push   %ebp
  803e39:	57                   	push   %edi
  803e3a:	56                   	push   %esi
  803e3b:	53                   	push   %ebx
  803e3c:	83 ec 1c             	sub    $0x1c,%esp
  803e3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e43:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e57:	89 f3                	mov    %esi,%ebx
  803e59:	89 fa                	mov    %edi,%edx
  803e5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e5f:	89 34 24             	mov    %esi,(%esp)
  803e62:	85 c0                	test   %eax,%eax
  803e64:	75 1a                	jne    803e80 <__umoddi3+0x48>
  803e66:	39 f7                	cmp    %esi,%edi
  803e68:	0f 86 a2 00 00 00    	jbe    803f10 <__umoddi3+0xd8>
  803e6e:	89 c8                	mov    %ecx,%eax
  803e70:	89 f2                	mov    %esi,%edx
  803e72:	f7 f7                	div    %edi
  803e74:	89 d0                	mov    %edx,%eax
  803e76:	31 d2                	xor    %edx,%edx
  803e78:	83 c4 1c             	add    $0x1c,%esp
  803e7b:	5b                   	pop    %ebx
  803e7c:	5e                   	pop    %esi
  803e7d:	5f                   	pop    %edi
  803e7e:	5d                   	pop    %ebp
  803e7f:	c3                   	ret    
  803e80:	39 f0                	cmp    %esi,%eax
  803e82:	0f 87 ac 00 00 00    	ja     803f34 <__umoddi3+0xfc>
  803e88:	0f bd e8             	bsr    %eax,%ebp
  803e8b:	83 f5 1f             	xor    $0x1f,%ebp
  803e8e:	0f 84 ac 00 00 00    	je     803f40 <__umoddi3+0x108>
  803e94:	bf 20 00 00 00       	mov    $0x20,%edi
  803e99:	29 ef                	sub    %ebp,%edi
  803e9b:	89 fe                	mov    %edi,%esi
  803e9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ea1:	89 e9                	mov    %ebp,%ecx
  803ea3:	d3 e0                	shl    %cl,%eax
  803ea5:	89 d7                	mov    %edx,%edi
  803ea7:	89 f1                	mov    %esi,%ecx
  803ea9:	d3 ef                	shr    %cl,%edi
  803eab:	09 c7                	or     %eax,%edi
  803ead:	89 e9                	mov    %ebp,%ecx
  803eaf:	d3 e2                	shl    %cl,%edx
  803eb1:	89 14 24             	mov    %edx,(%esp)
  803eb4:	89 d8                	mov    %ebx,%eax
  803eb6:	d3 e0                	shl    %cl,%eax
  803eb8:	89 c2                	mov    %eax,%edx
  803eba:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ebe:	d3 e0                	shl    %cl,%eax
  803ec0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ec4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ec8:	89 f1                	mov    %esi,%ecx
  803eca:	d3 e8                	shr    %cl,%eax
  803ecc:	09 d0                	or     %edx,%eax
  803ece:	d3 eb                	shr    %cl,%ebx
  803ed0:	89 da                	mov    %ebx,%edx
  803ed2:	f7 f7                	div    %edi
  803ed4:	89 d3                	mov    %edx,%ebx
  803ed6:	f7 24 24             	mull   (%esp)
  803ed9:	89 c6                	mov    %eax,%esi
  803edb:	89 d1                	mov    %edx,%ecx
  803edd:	39 d3                	cmp    %edx,%ebx
  803edf:	0f 82 87 00 00 00    	jb     803f6c <__umoddi3+0x134>
  803ee5:	0f 84 91 00 00 00    	je     803f7c <__umoddi3+0x144>
  803eeb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803eef:	29 f2                	sub    %esi,%edx
  803ef1:	19 cb                	sbb    %ecx,%ebx
  803ef3:	89 d8                	mov    %ebx,%eax
  803ef5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ef9:	d3 e0                	shl    %cl,%eax
  803efb:	89 e9                	mov    %ebp,%ecx
  803efd:	d3 ea                	shr    %cl,%edx
  803eff:	09 d0                	or     %edx,%eax
  803f01:	89 e9                	mov    %ebp,%ecx
  803f03:	d3 eb                	shr    %cl,%ebx
  803f05:	89 da                	mov    %ebx,%edx
  803f07:	83 c4 1c             	add    $0x1c,%esp
  803f0a:	5b                   	pop    %ebx
  803f0b:	5e                   	pop    %esi
  803f0c:	5f                   	pop    %edi
  803f0d:	5d                   	pop    %ebp
  803f0e:	c3                   	ret    
  803f0f:	90                   	nop
  803f10:	89 fd                	mov    %edi,%ebp
  803f12:	85 ff                	test   %edi,%edi
  803f14:	75 0b                	jne    803f21 <__umoddi3+0xe9>
  803f16:	b8 01 00 00 00       	mov    $0x1,%eax
  803f1b:	31 d2                	xor    %edx,%edx
  803f1d:	f7 f7                	div    %edi
  803f1f:	89 c5                	mov    %eax,%ebp
  803f21:	89 f0                	mov    %esi,%eax
  803f23:	31 d2                	xor    %edx,%edx
  803f25:	f7 f5                	div    %ebp
  803f27:	89 c8                	mov    %ecx,%eax
  803f29:	f7 f5                	div    %ebp
  803f2b:	89 d0                	mov    %edx,%eax
  803f2d:	e9 44 ff ff ff       	jmp    803e76 <__umoddi3+0x3e>
  803f32:	66 90                	xchg   %ax,%ax
  803f34:	89 c8                	mov    %ecx,%eax
  803f36:	89 f2                	mov    %esi,%edx
  803f38:	83 c4 1c             	add    $0x1c,%esp
  803f3b:	5b                   	pop    %ebx
  803f3c:	5e                   	pop    %esi
  803f3d:	5f                   	pop    %edi
  803f3e:	5d                   	pop    %ebp
  803f3f:	c3                   	ret    
  803f40:	3b 04 24             	cmp    (%esp),%eax
  803f43:	72 06                	jb     803f4b <__umoddi3+0x113>
  803f45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f49:	77 0f                	ja     803f5a <__umoddi3+0x122>
  803f4b:	89 f2                	mov    %esi,%edx
  803f4d:	29 f9                	sub    %edi,%ecx
  803f4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f53:	89 14 24             	mov    %edx,(%esp)
  803f56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f5e:	8b 14 24             	mov    (%esp),%edx
  803f61:	83 c4 1c             	add    $0x1c,%esp
  803f64:	5b                   	pop    %ebx
  803f65:	5e                   	pop    %esi
  803f66:	5f                   	pop    %edi
  803f67:	5d                   	pop    %ebp
  803f68:	c3                   	ret    
  803f69:	8d 76 00             	lea    0x0(%esi),%esi
  803f6c:	2b 04 24             	sub    (%esp),%eax
  803f6f:	19 fa                	sbb    %edi,%edx
  803f71:	89 d1                	mov    %edx,%ecx
  803f73:	89 c6                	mov    %eax,%esi
  803f75:	e9 71 ff ff ff       	jmp    803eeb <__umoddi3+0xb3>
  803f7a:	66 90                	xchg   %ax,%ax
  803f7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f80:	72 ea                	jb     803f6c <__umoddi3+0x134>
  803f82:	89 d9                	mov    %ebx,%ecx
  803f84:	e9 62 ff ff ff       	jmp    803eeb <__umoddi3+0xb3>
