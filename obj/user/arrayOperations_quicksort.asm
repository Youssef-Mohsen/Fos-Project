
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
  800054:	68 c0 3d 80 00       	push   $0x803dc0
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 9d 38 00 00       	call   8038ff <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 c6 3d 80 00       	push   $0x803dc6
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 86 38 00 00       	call   8038ff <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 dc             	pushl  -0x24(%ebp)
  800082:	e8 92 38 00 00       	call   803919 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80008a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800091:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  800098:	83 ec 08             	sub    $0x8,%esp
  80009b:	68 cf 3d 80 00       	push   $0x803dcf
  8000a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a3:	e8 54 16 00 00       	call   8016fc <sget>
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	68 d3 3d 80 00       	push   $0x803dd3
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
  8000d2:	68 db 3d 80 00       	push   $0x803ddb
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
  800131:	68 ea 3d 80 00       	push   $0x803dea
  800136:	e8 4e 04 00 00       	call   800589 <cprintf>
  80013b:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	ff 75 d8             	pushl  -0x28(%ebp)
  800144:	e8 ea 37 00 00       	call   803933 <signal_semaphore>
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
  800316:	68 06 3e 80 00       	push   $0x803e06
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
  800338:	68 08 3e 80 00       	push   $0x803e08
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
  800366:	68 0d 3e 80 00       	push   $0x803e0d
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
  8003f2:	68 2c 3e 80 00       	push   $0x803e2c
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
  80041a:	68 54 3e 80 00       	push   $0x803e54
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
  80044b:	68 7c 3e 80 00       	push   $0x803e7c
  800450:	e8 34 01 00 00       	call   800589 <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800458:	a1 20 50 80 00       	mov    0x805020,%eax
  80045d:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	50                   	push   %eax
  800467:	68 d4 3e 80 00       	push   $0x803ed4
  80046c:	e8 18 01 00 00       	call   800589 <cprintf>
  800471:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	68 2c 3e 80 00       	push   $0x803e2c
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
  800626:	e8 19 35 00 00       	call   803b44 <__udivdi3>
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
  800676:	e8 d9 35 00 00       	call   803c54 <__umoddi3>
  80067b:	83 c4 10             	add    $0x10,%esp
  80067e:	05 14 41 80 00       	add    $0x804114,%eax
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
  8007d1:	8b 04 85 38 41 80 00 	mov    0x804138(,%eax,4),%eax
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
  8008b2:	8b 34 9d 80 3f 80 00 	mov    0x803f80(,%ebx,4),%esi
  8008b9:	85 f6                	test   %esi,%esi
  8008bb:	75 19                	jne    8008d6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008bd:	53                   	push   %ebx
  8008be:	68 25 41 80 00       	push   $0x804125
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
  8008d7:	68 2e 41 80 00       	push   $0x80412e
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
  800904:	be 31 41 80 00       	mov    $0x804131,%esi
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
  80130f:	68 a8 42 80 00       	push   $0x8042a8
  801314:	68 3f 01 00 00       	push   $0x13f
  801319:	68 ca 42 80 00       	push   $0x8042ca
  80131e:	e8 35 26 00 00       	call   803958 <_panic>

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
  8013b9:	e8 41 0e 00 00       	call   8021ff <alloc_block_FF>
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
  8013dc:	e8 da 12 00 00       	call   8026bb <alloc_block_BF>
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
  80158a:	e8 f0 08 00 00       	call   801e7f <get_block_size>
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801595:	83 ec 0c             	sub    $0xc,%esp
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 00 1b 00 00       	call   8030a0 <free_block>
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
  801640:	68 d8 42 80 00       	push   $0x8042d8
  801645:	68 87 00 00 00       	push   $0x87
  80164a:	68 02 43 80 00       	push   $0x804302
  80164f:	e8 04 23 00 00       	call   803958 <_panic>
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
  8017eb:	68 10 43 80 00       	push   $0x804310
  8017f0:	68 e4 00 00 00       	push   $0xe4
  8017f5:	68 02 43 80 00       	push   $0x804302
  8017fa:	e8 59 21 00 00       	call   803958 <_panic>

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
  801808:	68 36 43 80 00       	push   $0x804336
  80180d:	68 f0 00 00 00       	push   $0xf0
  801812:	68 02 43 80 00       	push   $0x804302
  801817:	e8 3c 21 00 00       	call   803958 <_panic>

0080181c <shrink>:

}
void shrink(uint32 newSize)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 36 43 80 00       	push   $0x804336
  80182a:	68 f5 00 00 00       	push   $0xf5
  80182f:	68 02 43 80 00       	push   $0x804302
  801834:	e8 1f 21 00 00       	call   803958 <_panic>

00801839 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183f:	83 ec 04             	sub    $0x4,%esp
  801842:	68 36 43 80 00       	push   $0x804336
  801847:	68 fa 00 00 00       	push   $0xfa
  80184c:	68 02 43 80 00       	push   $0x804302
  801851:	e8 02 21 00 00       	call   803958 <_panic>

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

00801e7f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	83 e8 04             	sub    $0x4,%eax
  801e8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e91:	8b 00                	mov    (%eax),%eax
  801e93:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	83 e8 04             	sub    $0x4,%eax
  801ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eaa:	8b 00                	mov    (%eax),%eax
  801eac:	83 e0 01             	and    $0x1,%eax
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	0f 94 c0             	sete   %al
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ebc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec6:	83 f8 02             	cmp    $0x2,%eax
  801ec9:	74 2b                	je     801ef6 <alloc_block+0x40>
  801ecb:	83 f8 02             	cmp    $0x2,%eax
  801ece:	7f 07                	jg     801ed7 <alloc_block+0x21>
  801ed0:	83 f8 01             	cmp    $0x1,%eax
  801ed3:	74 0e                	je     801ee3 <alloc_block+0x2d>
  801ed5:	eb 58                	jmp    801f2f <alloc_block+0x79>
  801ed7:	83 f8 03             	cmp    $0x3,%eax
  801eda:	74 2d                	je     801f09 <alloc_block+0x53>
  801edc:	83 f8 04             	cmp    $0x4,%eax
  801edf:	74 3b                	je     801f1c <alloc_block+0x66>
  801ee1:	eb 4c                	jmp    801f2f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	ff 75 08             	pushl  0x8(%ebp)
  801ee9:	e8 11 03 00 00       	call   8021ff <alloc_block_FF>
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ef4:	eb 4a                	jmp    801f40 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ef6:	83 ec 0c             	sub    $0xc,%esp
  801ef9:	ff 75 08             	pushl  0x8(%ebp)
  801efc:	e8 c7 19 00 00       	call   8038c8 <alloc_block_NF>
  801f01:	83 c4 10             	add    $0x10,%esp
  801f04:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f07:	eb 37                	jmp    801f40 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	ff 75 08             	pushl  0x8(%ebp)
  801f0f:	e8 a7 07 00 00       	call   8026bb <alloc_block_BF>
  801f14:	83 c4 10             	add    $0x10,%esp
  801f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f1a:	eb 24                	jmp    801f40 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f1c:	83 ec 0c             	sub    $0xc,%esp
  801f1f:	ff 75 08             	pushl  0x8(%ebp)
  801f22:	e8 84 19 00 00       	call   8038ab <alloc_block_WF>
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f2d:	eb 11                	jmp    801f40 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f2f:	83 ec 0c             	sub    $0xc,%esp
  801f32:	68 48 43 80 00       	push   $0x804348
  801f37:	e8 4d e6 ff ff       	call   800589 <cprintf>
  801f3c:	83 c4 10             	add    $0x10,%esp
		break;
  801f3f:	90                   	nop
	}
	return va;
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	53                   	push   %ebx
  801f49:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f4c:	83 ec 0c             	sub    $0xc,%esp
  801f4f:	68 68 43 80 00       	push   $0x804368
  801f54:	e8 30 e6 ff ff       	call   800589 <cprintf>
  801f59:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f5c:	83 ec 0c             	sub    $0xc,%esp
  801f5f:	68 93 43 80 00       	push   $0x804393
  801f64:	e8 20 e6 ff ff       	call   800589 <cprintf>
  801f69:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f72:	eb 37                	jmp    801fab <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7a:	e8 19 ff ff ff       	call   801e98 <is_free_block>
  801f7f:	83 c4 10             	add    $0x10,%esp
  801f82:	0f be d8             	movsbl %al,%ebx
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8b:	e8 ef fe ff ff       	call   801e7f <get_block_size>
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	83 ec 04             	sub    $0x4,%esp
  801f96:	53                   	push   %ebx
  801f97:	50                   	push   %eax
  801f98:	68 ab 43 80 00       	push   $0x8043ab
  801f9d:	e8 e7 e5 ff ff       	call   800589 <cprintf>
  801fa2:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801faf:	74 07                	je     801fb8 <print_blocks_list+0x73>
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	8b 00                	mov    (%eax),%eax
  801fb6:	eb 05                	jmp    801fbd <print_blocks_list+0x78>
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbd:	89 45 10             	mov    %eax,0x10(%ebp)
  801fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	75 ad                	jne    801f74 <print_blocks_list+0x2f>
  801fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcb:	75 a7                	jne    801f74 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	68 68 43 80 00       	push   $0x804368
  801fd5:	e8 af e5 ff ff       	call   800589 <cprintf>
  801fda:	83 c4 10             	add    $0x10,%esp

}
  801fdd:	90                   	nop
  801fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fec:	83 e0 01             	and    $0x1,%eax
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	74 03                	je     801ff6 <initialize_dynamic_allocator+0x13>
  801ff3:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801ff6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ffa:	0f 84 c7 01 00 00    	je     8021c7 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802000:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802007:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80200a:	8b 55 08             	mov    0x8(%ebp),%edx
  80200d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802010:	01 d0                	add    %edx,%eax
  802012:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802017:	0f 87 ad 01 00 00    	ja     8021ca <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	85 c0                	test   %eax,%eax
  802022:	0f 89 a5 01 00 00    	jns    8021cd <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802028:	8b 55 08             	mov    0x8(%ebp),%edx
  80202b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202e:	01 d0                	add    %edx,%eax
  802030:	83 e8 04             	sub    $0x4,%eax
  802033:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802038:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80203f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802044:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802047:	e9 87 00 00 00       	jmp    8020d3 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80204c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802050:	75 14                	jne    802066 <initialize_dynamic_allocator+0x83>
  802052:	83 ec 04             	sub    $0x4,%esp
  802055:	68 c3 43 80 00       	push   $0x8043c3
  80205a:	6a 79                	push   $0x79
  80205c:	68 e1 43 80 00       	push   $0x8043e1
  802061:	e8 f2 18 00 00       	call   803958 <_panic>
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	8b 00                	mov    (%eax),%eax
  80206b:	85 c0                	test   %eax,%eax
  80206d:	74 10                	je     80207f <initialize_dynamic_allocator+0x9c>
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	8b 00                	mov    (%eax),%eax
  802074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802077:	8b 52 04             	mov    0x4(%edx),%edx
  80207a:	89 50 04             	mov    %edx,0x4(%eax)
  80207d:	eb 0b                	jmp    80208a <initialize_dynamic_allocator+0xa7>
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	8b 40 04             	mov    0x4(%eax),%eax
  802085:	a3 30 50 80 00       	mov    %eax,0x805030
  80208a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208d:	8b 40 04             	mov    0x4(%eax),%eax
  802090:	85 c0                	test   %eax,%eax
  802092:	74 0f                	je     8020a3 <initialize_dynamic_allocator+0xc0>
  802094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802097:	8b 40 04             	mov    0x4(%eax),%eax
  80209a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209d:	8b 12                	mov    (%edx),%edx
  80209f:	89 10                	mov    %edx,(%eax)
  8020a1:	eb 0a                	jmp    8020ad <initialize_dynamic_allocator+0xca>
  8020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a6:	8b 00                	mov    (%eax),%eax
  8020a8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8020c5:	48                   	dec    %eax
  8020c6:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020cb:	a1 34 50 80 00       	mov    0x805034,%eax
  8020d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d7:	74 07                	je     8020e0 <initialize_dynamic_allocator+0xfd>
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	8b 00                	mov    (%eax),%eax
  8020de:	eb 05                	jmp    8020e5 <initialize_dynamic_allocator+0x102>
  8020e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e5:	a3 34 50 80 00       	mov    %eax,0x805034
  8020ea:	a1 34 50 80 00       	mov    0x805034,%eax
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	0f 85 55 ff ff ff    	jne    80204c <initialize_dynamic_allocator+0x69>
  8020f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020fb:	0f 85 4b ff ff ff    	jne    80204c <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802110:	a1 44 50 80 00       	mov    0x805044,%eax
  802115:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80211a:	a1 40 50 80 00       	mov    0x805040,%eax
  80211f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	83 c0 08             	add    $0x8,%eax
  80212b:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	83 c0 04             	add    $0x4,%eax
  802134:	8b 55 0c             	mov    0xc(%ebp),%edx
  802137:	83 ea 08             	sub    $0x8,%edx
  80213a:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80213c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	01 d0                	add    %edx,%eax
  802144:	83 e8 08             	sub    $0x8,%eax
  802147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214a:	83 ea 08             	sub    $0x8,%edx
  80214d:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80214f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802152:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802162:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802166:	75 17                	jne    80217f <initialize_dynamic_allocator+0x19c>
  802168:	83 ec 04             	sub    $0x4,%esp
  80216b:	68 fc 43 80 00       	push   $0x8043fc
  802170:	68 90 00 00 00       	push   $0x90
  802175:	68 e1 43 80 00       	push   $0x8043e1
  80217a:	e8 d9 17 00 00       	call   803958 <_panic>
  80217f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802188:	89 10                	mov    %edx,(%eax)
  80218a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218d:	8b 00                	mov    (%eax),%eax
  80218f:	85 c0                	test   %eax,%eax
  802191:	74 0d                	je     8021a0 <initialize_dynamic_allocator+0x1bd>
  802193:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802198:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80219b:	89 50 04             	mov    %edx,0x4(%eax)
  80219e:	eb 08                	jmp    8021a8 <initialize_dynamic_allocator+0x1c5>
  8021a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8021a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8021bf:	40                   	inc    %eax
  8021c0:	a3 38 50 80 00       	mov    %eax,0x805038
  8021c5:	eb 07                	jmp    8021ce <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021c7:	90                   	nop
  8021c8:	eb 04                	jmp    8021ce <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8021ca:	90                   	nop
  8021cb:	eb 01                	jmp    8021ce <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021cd:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d6:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e2:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	83 e8 04             	sub    $0x4,%eax
  8021ea:	8b 00                	mov    (%eax),%eax
  8021ec:	83 e0 fe             	and    $0xfffffffe,%eax
  8021ef:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	01 c2                	add    %eax,%edx
  8021f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fa:	89 02                	mov    %eax,(%edx)
}
  8021fc:	90                   	nop
  8021fd:	5d                   	pop    %ebp
  8021fe:	c3                   	ret    

008021ff <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
  802202:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	83 e0 01             	and    $0x1,%eax
  80220b:	85 c0                	test   %eax,%eax
  80220d:	74 03                	je     802212 <alloc_block_FF+0x13>
  80220f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802212:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802216:	77 07                	ja     80221f <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802218:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80221f:	a1 24 50 80 00       	mov    0x805024,%eax
  802224:	85 c0                	test   %eax,%eax
  802226:	75 73                	jne    80229b <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	83 c0 10             	add    $0x10,%eax
  80222e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802231:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802238:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80223b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223e:	01 d0                	add    %edx,%eax
  802240:	48                   	dec    %eax
  802241:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802247:	ba 00 00 00 00       	mov    $0x0,%edx
  80224c:	f7 75 ec             	divl   -0x14(%ebp)
  80224f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802252:	29 d0                	sub    %edx,%eax
  802254:	c1 e8 0c             	shr    $0xc,%eax
  802257:	83 ec 0c             	sub    $0xc,%esp
  80225a:	50                   	push   %eax
  80225b:	e8 c3 f0 ff ff       	call   801323 <sbrk>
  802260:	83 c4 10             	add    $0x10,%esp
  802263:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802266:	83 ec 0c             	sub    $0xc,%esp
  802269:	6a 00                	push   $0x0
  80226b:	e8 b3 f0 ff ff       	call   801323 <sbrk>
  802270:	83 c4 10             	add    $0x10,%esp
  802273:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802276:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802279:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80227c:	83 ec 08             	sub    $0x8,%esp
  80227f:	50                   	push   %eax
  802280:	ff 75 e4             	pushl  -0x1c(%ebp)
  802283:	e8 5b fd ff ff       	call   801fe3 <initialize_dynamic_allocator>
  802288:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80228b:	83 ec 0c             	sub    $0xc,%esp
  80228e:	68 1f 44 80 00       	push   $0x80441f
  802293:	e8 f1 e2 ff ff       	call   800589 <cprintf>
  802298:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80229b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229f:	75 0a                	jne    8022ab <alloc_block_FF+0xac>
	        return NULL;
  8022a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a6:	e9 0e 04 00 00       	jmp    8026b9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8022ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022b2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ba:	e9 f3 02 00 00       	jmp    8025b2 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022c5:	83 ec 0c             	sub    $0xc,%esp
  8022c8:	ff 75 bc             	pushl  -0x44(%ebp)
  8022cb:	e8 af fb ff ff       	call   801e7f <get_block_size>
  8022d0:	83 c4 10             	add    $0x10,%esp
  8022d3:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	83 c0 08             	add    $0x8,%eax
  8022dc:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022df:	0f 87 c5 02 00 00    	ja     8025aa <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	83 c0 18             	add    $0x18,%eax
  8022eb:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022ee:	0f 87 19 02 00 00    	ja     80250d <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8022fa:	83 e8 08             	sub    $0x8,%eax
  8022fd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8d 50 08             	lea    0x8(%eax),%edx
  802306:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802309:	01 d0                	add    %edx,%eax
  80230b:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80230e:	8b 45 08             	mov    0x8(%ebp),%eax
  802311:	83 c0 08             	add    $0x8,%eax
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	6a 01                	push   $0x1
  802319:	50                   	push   %eax
  80231a:	ff 75 bc             	pushl  -0x44(%ebp)
  80231d:	e8 ae fe ff ff       	call   8021d0 <set_block_data>
  802322:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	8b 40 04             	mov    0x4(%eax),%eax
  80232b:	85 c0                	test   %eax,%eax
  80232d:	75 68                	jne    802397 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80232f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802333:	75 17                	jne    80234c <alloc_block_FF+0x14d>
  802335:	83 ec 04             	sub    $0x4,%esp
  802338:	68 fc 43 80 00       	push   $0x8043fc
  80233d:	68 d7 00 00 00       	push   $0xd7
  802342:	68 e1 43 80 00       	push   $0x8043e1
  802347:	e8 0c 16 00 00       	call   803958 <_panic>
  80234c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802352:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802355:	89 10                	mov    %edx,(%eax)
  802357:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 0d                	je     80236d <alloc_block_FF+0x16e>
  802360:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802365:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802368:	89 50 04             	mov    %edx,0x4(%eax)
  80236b:	eb 08                	jmp    802375 <alloc_block_FF+0x176>
  80236d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802370:	a3 30 50 80 00       	mov    %eax,0x805030
  802375:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802378:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80237d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802380:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802387:	a1 38 50 80 00       	mov    0x805038,%eax
  80238c:	40                   	inc    %eax
  80238d:	a3 38 50 80 00       	mov    %eax,0x805038
  802392:	e9 dc 00 00 00       	jmp    802473 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 00                	mov    (%eax),%eax
  80239c:	85 c0                	test   %eax,%eax
  80239e:	75 65                	jne    802405 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023a0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023a4:	75 17                	jne    8023bd <alloc_block_FF+0x1be>
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	68 30 44 80 00       	push   $0x804430
  8023ae:	68 db 00 00 00       	push   $0xdb
  8023b3:	68 e1 43 80 00       	push   $0x8043e1
  8023b8:	e8 9b 15 00 00       	call   803958 <_panic>
  8023bd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c6:	89 50 04             	mov    %edx,0x4(%eax)
  8023c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023cc:	8b 40 04             	mov    0x4(%eax),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	74 0c                	je     8023df <alloc_block_FF+0x1e0>
  8023d3:	a1 30 50 80 00       	mov    0x805030,%eax
  8023d8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023db:	89 10                	mov    %edx,(%eax)
  8023dd:	eb 08                	jmp    8023e7 <alloc_block_FF+0x1e8>
  8023df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8023fd:	40                   	inc    %eax
  8023fe:	a3 38 50 80 00       	mov    %eax,0x805038
  802403:	eb 6e                	jmp    802473 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802405:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802409:	74 06                	je     802411 <alloc_block_FF+0x212>
  80240b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80240f:	75 17                	jne    802428 <alloc_block_FF+0x229>
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	68 54 44 80 00       	push   $0x804454
  802419:	68 df 00 00 00       	push   $0xdf
  80241e:	68 e1 43 80 00       	push   $0x8043e1
  802423:	e8 30 15 00 00       	call   803958 <_panic>
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	8b 10                	mov    (%eax),%edx
  80242d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802430:	89 10                	mov    %edx,(%eax)
  802432:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802435:	8b 00                	mov    (%eax),%eax
  802437:	85 c0                	test   %eax,%eax
  802439:	74 0b                	je     802446 <alloc_block_FF+0x247>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802443:	89 50 04             	mov    %edx,0x4(%eax)
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80244c:	89 10                	mov    %edx,(%eax)
  80244e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802451:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802454:	89 50 04             	mov    %edx,0x4(%eax)
  802457:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	75 08                	jne    802468 <alloc_block_FF+0x269>
  802460:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802463:	a3 30 50 80 00       	mov    %eax,0x805030
  802468:	a1 38 50 80 00       	mov    0x805038,%eax
  80246d:	40                   	inc    %eax
  80246e:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802477:	75 17                	jne    802490 <alloc_block_FF+0x291>
  802479:	83 ec 04             	sub    $0x4,%esp
  80247c:	68 c3 43 80 00       	push   $0x8043c3
  802481:	68 e1 00 00 00       	push   $0xe1
  802486:	68 e1 43 80 00       	push   $0x8043e1
  80248b:	e8 c8 14 00 00       	call   803958 <_panic>
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	74 10                	je     8024a9 <alloc_block_FF+0x2aa>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a1:	8b 52 04             	mov    0x4(%edx),%edx
  8024a4:	89 50 04             	mov    %edx,0x4(%eax)
  8024a7:	eb 0b                	jmp    8024b4 <alloc_block_FF+0x2b5>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 40 04             	mov    0x4(%eax),%eax
  8024af:	a3 30 50 80 00       	mov    %eax,0x805030
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	74 0f                	je     8024cd <alloc_block_FF+0x2ce>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 40 04             	mov    0x4(%eax),%eax
  8024c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c7:	8b 12                	mov    (%edx),%edx
  8024c9:	89 10                	mov    %edx,(%eax)
  8024cb:	eb 0a                	jmp    8024d7 <alloc_block_FF+0x2d8>
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8024ef:	48                   	dec    %eax
  8024f0:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	6a 00                	push   $0x0
  8024fa:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024fd:	ff 75 b0             	pushl  -0x50(%ebp)
  802500:	e8 cb fc ff ff       	call   8021d0 <set_block_data>
  802505:	83 c4 10             	add    $0x10,%esp
  802508:	e9 95 00 00 00       	jmp    8025a2 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80250d:	83 ec 04             	sub    $0x4,%esp
  802510:	6a 01                	push   $0x1
  802512:	ff 75 b8             	pushl  -0x48(%ebp)
  802515:	ff 75 bc             	pushl  -0x44(%ebp)
  802518:	e8 b3 fc ff ff       	call   8021d0 <set_block_data>
  80251d:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802524:	75 17                	jne    80253d <alloc_block_FF+0x33e>
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	68 c3 43 80 00       	push   $0x8043c3
  80252e:	68 e8 00 00 00       	push   $0xe8
  802533:	68 e1 43 80 00       	push   $0x8043e1
  802538:	e8 1b 14 00 00       	call   803958 <_panic>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	74 10                	je     802556 <alloc_block_FF+0x357>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254e:	8b 52 04             	mov    0x4(%edx),%edx
  802551:	89 50 04             	mov    %edx,0x4(%eax)
  802554:	eb 0b                	jmp    802561 <alloc_block_FF+0x362>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 40 04             	mov    0x4(%eax),%eax
  80255c:	a3 30 50 80 00       	mov    %eax,0x805030
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	74 0f                	je     80257a <alloc_block_FF+0x37b>
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802574:	8b 12                	mov    (%edx),%edx
  802576:	89 10                	mov    %edx,(%eax)
  802578:	eb 0a                	jmp    802584 <alloc_block_FF+0x385>
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802597:	a1 38 50 80 00       	mov    0x805038,%eax
  80259c:	48                   	dec    %eax
  80259d:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8025a2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025a5:	e9 0f 01 00 00       	jmp    8026b9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025aa:	a1 34 50 80 00       	mov    0x805034,%eax
  8025af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b6:	74 07                	je     8025bf <alloc_block_FF+0x3c0>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	eb 05                	jmp    8025c4 <alloc_block_FF+0x3c5>
  8025bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c4:	a3 34 50 80 00       	mov    %eax,0x805034
  8025c9:	a1 34 50 80 00       	mov    0x805034,%eax
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	0f 85 e9 fc ff ff    	jne    8022bf <alloc_block_FF+0xc0>
  8025d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025da:	0f 85 df fc ff ff    	jne    8022bf <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	83 c0 08             	add    $0x8,%eax
  8025e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025e9:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025f6:	01 d0                	add    %edx,%eax
  8025f8:	48                   	dec    %eax
  8025f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802604:	f7 75 d8             	divl   -0x28(%ebp)
  802607:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80260a:	29 d0                	sub    %edx,%eax
  80260c:	c1 e8 0c             	shr    $0xc,%eax
  80260f:	83 ec 0c             	sub    $0xc,%esp
  802612:	50                   	push   %eax
  802613:	e8 0b ed ff ff       	call   801323 <sbrk>
  802618:	83 c4 10             	add    $0x10,%esp
  80261b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80261e:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802622:	75 0a                	jne    80262e <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
  802629:	e9 8b 00 00 00       	jmp    8026b9 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80262e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802635:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802638:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80263b:	01 d0                	add    %edx,%eax
  80263d:	48                   	dec    %eax
  80263e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802641:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802644:	ba 00 00 00 00       	mov    $0x0,%edx
  802649:	f7 75 cc             	divl   -0x34(%ebp)
  80264c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80264f:	29 d0                	sub    %edx,%eax
  802651:	8d 50 fc             	lea    -0x4(%eax),%edx
  802654:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802657:	01 d0                	add    %edx,%eax
  802659:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80265e:	a1 40 50 80 00       	mov    0x805040,%eax
  802663:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802669:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802670:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802673:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802676:	01 d0                	add    %edx,%eax
  802678:	48                   	dec    %eax
  802679:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80267c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80267f:	ba 00 00 00 00       	mov    $0x0,%edx
  802684:	f7 75 c4             	divl   -0x3c(%ebp)
  802687:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80268a:	29 d0                	sub    %edx,%eax
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	6a 01                	push   $0x1
  802691:	50                   	push   %eax
  802692:	ff 75 d0             	pushl  -0x30(%ebp)
  802695:	e8 36 fb ff ff       	call   8021d0 <set_block_data>
  80269a:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80269d:	83 ec 0c             	sub    $0xc,%esp
  8026a0:	ff 75 d0             	pushl  -0x30(%ebp)
  8026a3:	e8 f8 09 00 00       	call   8030a0 <free_block>
  8026a8:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8026ab:	83 ec 0c             	sub    $0xc,%esp
  8026ae:	ff 75 08             	pushl  0x8(%ebp)
  8026b1:	e8 49 fb ff ff       	call   8021ff <alloc_block_FF>
  8026b6:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	83 e0 01             	and    $0x1,%eax
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	74 03                	je     8026ce <alloc_block_BF+0x13>
  8026cb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026ce:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026d2:	77 07                	ja     8026db <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026d4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026db:	a1 24 50 80 00       	mov    0x805024,%eax
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	75 73                	jne    802757 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	83 c0 10             	add    $0x10,%eax
  8026ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026ed:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fa:	01 d0                	add    %edx,%eax
  8026fc:	48                   	dec    %eax
  8026fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802700:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802703:	ba 00 00 00 00       	mov    $0x0,%edx
  802708:	f7 75 e0             	divl   -0x20(%ebp)
  80270b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80270e:	29 d0                	sub    %edx,%eax
  802710:	c1 e8 0c             	shr    $0xc,%eax
  802713:	83 ec 0c             	sub    $0xc,%esp
  802716:	50                   	push   %eax
  802717:	e8 07 ec ff ff       	call   801323 <sbrk>
  80271c:	83 c4 10             	add    $0x10,%esp
  80271f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802722:	83 ec 0c             	sub    $0xc,%esp
  802725:	6a 00                	push   $0x0
  802727:	e8 f7 eb ff ff       	call   801323 <sbrk>
  80272c:	83 c4 10             	add    $0x10,%esp
  80272f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802735:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802738:	83 ec 08             	sub    $0x8,%esp
  80273b:	50                   	push   %eax
  80273c:	ff 75 d8             	pushl  -0x28(%ebp)
  80273f:	e8 9f f8 ff ff       	call   801fe3 <initialize_dynamic_allocator>
  802744:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802747:	83 ec 0c             	sub    $0xc,%esp
  80274a:	68 1f 44 80 00       	push   $0x80441f
  80274f:	e8 35 de ff ff       	call   800589 <cprintf>
  802754:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802757:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80275e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802765:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80276c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802773:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802778:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277b:	e9 1d 01 00 00       	jmp    80289d <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802786:	83 ec 0c             	sub    $0xc,%esp
  802789:	ff 75 a8             	pushl  -0x58(%ebp)
  80278c:	e8 ee f6 ff ff       	call   801e7f <get_block_size>
  802791:	83 c4 10             	add    $0x10,%esp
  802794:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	83 c0 08             	add    $0x8,%eax
  80279d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027a0:	0f 87 ef 00 00 00    	ja     802895 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	83 c0 18             	add    $0x18,%eax
  8027ac:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027af:	77 1d                	ja     8027ce <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027b7:	0f 86 d8 00 00 00    	jbe    802895 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027c3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027c9:	e9 c7 00 00 00       	jmp    802895 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d1:	83 c0 08             	add    $0x8,%eax
  8027d4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027d7:	0f 85 9d 00 00 00    	jne    80287a <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027dd:	83 ec 04             	sub    $0x4,%esp
  8027e0:	6a 01                	push   $0x1
  8027e2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8027e5:	ff 75 a8             	pushl  -0x58(%ebp)
  8027e8:	e8 e3 f9 ff ff       	call   8021d0 <set_block_data>
  8027ed:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f4:	75 17                	jne    80280d <alloc_block_BF+0x152>
  8027f6:	83 ec 04             	sub    $0x4,%esp
  8027f9:	68 c3 43 80 00       	push   $0x8043c3
  8027fe:	68 2c 01 00 00       	push   $0x12c
  802803:	68 e1 43 80 00       	push   $0x8043e1
  802808:	e8 4b 11 00 00       	call   803958 <_panic>
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 00                	mov    (%eax),%eax
  802812:	85 c0                	test   %eax,%eax
  802814:	74 10                	je     802826 <alloc_block_BF+0x16b>
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 00                	mov    (%eax),%eax
  80281b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281e:	8b 52 04             	mov    0x4(%edx),%edx
  802821:	89 50 04             	mov    %edx,0x4(%eax)
  802824:	eb 0b                	jmp    802831 <alloc_block_BF+0x176>
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	a3 30 50 80 00       	mov    %eax,0x805030
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 40 04             	mov    0x4(%eax),%eax
  802837:	85 c0                	test   %eax,%eax
  802839:	74 0f                	je     80284a <alloc_block_BF+0x18f>
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 40 04             	mov    0x4(%eax),%eax
  802841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802844:	8b 12                	mov    (%edx),%edx
  802846:	89 10                	mov    %edx,(%eax)
  802848:	eb 0a                	jmp    802854 <alloc_block_BF+0x199>
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802867:	a1 38 50 80 00       	mov    0x805038,%eax
  80286c:	48                   	dec    %eax
  80286d:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802872:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802875:	e9 01 04 00 00       	jmp    802c7b <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80287a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802880:	76 13                	jbe    802895 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802882:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802889:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80288c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80288f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802892:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802895:	a1 34 50 80 00       	mov    0x805034,%eax
  80289a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a1:	74 07                	je     8028aa <alloc_block_BF+0x1ef>
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	eb 05                	jmp    8028af <alloc_block_BF+0x1f4>
  8028aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8028af:	a3 34 50 80 00       	mov    %eax,0x805034
  8028b4:	a1 34 50 80 00       	mov    0x805034,%eax
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	0f 85 bf fe ff ff    	jne    802780 <alloc_block_BF+0xc5>
  8028c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c5:	0f 85 b5 fe ff ff    	jne    802780 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028cf:	0f 84 26 02 00 00    	je     802afb <alloc_block_BF+0x440>
  8028d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028d9:	0f 85 1c 02 00 00    	jne    802afb <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e2:	2b 45 08             	sub    0x8(%ebp),%eax
  8028e5:	83 e8 08             	sub    $0x8,%eax
  8028e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	8d 50 08             	lea    0x8(%eax),%edx
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	01 d0                	add    %edx,%eax
  8028f6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	83 c0 08             	add    $0x8,%eax
  8028ff:	83 ec 04             	sub    $0x4,%esp
  802902:	6a 01                	push   $0x1
  802904:	50                   	push   %eax
  802905:	ff 75 f0             	pushl  -0x10(%ebp)
  802908:	e8 c3 f8 ff ff       	call   8021d0 <set_block_data>
  80290d:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	85 c0                	test   %eax,%eax
  802918:	75 68                	jne    802982 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80291a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80291e:	75 17                	jne    802937 <alloc_block_BF+0x27c>
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	68 fc 43 80 00       	push   $0x8043fc
  802928:	68 45 01 00 00       	push   $0x145
  80292d:	68 e1 43 80 00       	push   $0x8043e1
  802932:	e8 21 10 00 00       	call   803958 <_panic>
  802937:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80293d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802940:	89 10                	mov    %edx,(%eax)
  802942:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802945:	8b 00                	mov    (%eax),%eax
  802947:	85 c0                	test   %eax,%eax
  802949:	74 0d                	je     802958 <alloc_block_BF+0x29d>
  80294b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802950:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802953:	89 50 04             	mov    %edx,0x4(%eax)
  802956:	eb 08                	jmp    802960 <alloc_block_BF+0x2a5>
  802958:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295b:	a3 30 50 80 00       	mov    %eax,0x805030
  802960:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802963:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802968:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802972:	a1 38 50 80 00       	mov    0x805038,%eax
  802977:	40                   	inc    %eax
  802978:	a3 38 50 80 00       	mov    %eax,0x805038
  80297d:	e9 dc 00 00 00       	jmp    802a5e <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802985:	8b 00                	mov    (%eax),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	75 65                	jne    8029f0 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80298b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80298f:	75 17                	jne    8029a8 <alloc_block_BF+0x2ed>
  802991:	83 ec 04             	sub    $0x4,%esp
  802994:	68 30 44 80 00       	push   $0x804430
  802999:	68 4a 01 00 00       	push   $0x14a
  80299e:	68 e1 43 80 00       	push   $0x8043e1
  8029a3:	e8 b0 0f 00 00       	call   803958 <_panic>
  8029a8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b1:	89 50 04             	mov    %edx,0x4(%eax)
  8029b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	74 0c                	je     8029ca <alloc_block_BF+0x30f>
  8029be:	a1 30 50 80 00       	mov    0x805030,%eax
  8029c3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029c6:	89 10                	mov    %edx,(%eax)
  8029c8:	eb 08                	jmp    8029d2 <alloc_block_BF+0x317>
  8029ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8029da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8029e8:	40                   	inc    %eax
  8029e9:	a3 38 50 80 00       	mov    %eax,0x805038
  8029ee:	eb 6e                	jmp    802a5e <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f4:	74 06                	je     8029fc <alloc_block_BF+0x341>
  8029f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029fa:	75 17                	jne    802a13 <alloc_block_BF+0x358>
  8029fc:	83 ec 04             	sub    $0x4,%esp
  8029ff:	68 54 44 80 00       	push   $0x804454
  802a04:	68 4f 01 00 00       	push   $0x14f
  802a09:	68 e1 43 80 00       	push   $0x8043e1
  802a0e:	e8 45 0f 00 00       	call   803958 <_panic>
  802a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a16:	8b 10                	mov    (%eax),%edx
  802a18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a1b:	89 10                	mov    %edx,(%eax)
  802a1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a20:	8b 00                	mov    (%eax),%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	74 0b                	je     802a31 <alloc_block_BF+0x376>
  802a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a2e:	89 50 04             	mov    %edx,0x4(%eax)
  802a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a34:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a37:	89 10                	mov    %edx,(%eax)
  802a39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a3f:	89 50 04             	mov    %edx,0x4(%eax)
  802a42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	75 08                	jne    802a53 <alloc_block_BF+0x398>
  802a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a53:	a1 38 50 80 00       	mov    0x805038,%eax
  802a58:	40                   	inc    %eax
  802a59:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a62:	75 17                	jne    802a7b <alloc_block_BF+0x3c0>
  802a64:	83 ec 04             	sub    $0x4,%esp
  802a67:	68 c3 43 80 00       	push   $0x8043c3
  802a6c:	68 51 01 00 00       	push   $0x151
  802a71:	68 e1 43 80 00       	push   $0x8043e1
  802a76:	e8 dd 0e 00 00       	call   803958 <_panic>
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 10                	je     802a94 <alloc_block_BF+0x3d9>
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8c:	8b 52 04             	mov    0x4(%edx),%edx
  802a8f:	89 50 04             	mov    %edx,0x4(%eax)
  802a92:	eb 0b                	jmp    802a9f <alloc_block_BF+0x3e4>
  802a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a97:	8b 40 04             	mov    0x4(%eax),%eax
  802a9a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 0f                	je     802ab8 <alloc_block_BF+0x3fd>
  802aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab2:	8b 12                	mov    (%edx),%edx
  802ab4:	89 10                	mov    %edx,(%eax)
  802ab6:	eb 0a                	jmp    802ac2 <alloc_block_BF+0x407>
  802ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad5:	a1 38 50 80 00       	mov    0x805038,%eax
  802ada:	48                   	dec    %eax
  802adb:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ae0:	83 ec 04             	sub    $0x4,%esp
  802ae3:	6a 00                	push   $0x0
  802ae5:	ff 75 d0             	pushl  -0x30(%ebp)
  802ae8:	ff 75 cc             	pushl  -0x34(%ebp)
  802aeb:	e8 e0 f6 ff ff       	call   8021d0 <set_block_data>
  802af0:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af6:	e9 80 01 00 00       	jmp    802c7b <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802afb:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802aff:	0f 85 9d 00 00 00    	jne    802ba2 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b05:	83 ec 04             	sub    $0x4,%esp
  802b08:	6a 01                	push   $0x1
  802b0a:	ff 75 ec             	pushl  -0x14(%ebp)
  802b0d:	ff 75 f0             	pushl  -0x10(%ebp)
  802b10:	e8 bb f6 ff ff       	call   8021d0 <set_block_data>
  802b15:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b1c:	75 17                	jne    802b35 <alloc_block_BF+0x47a>
  802b1e:	83 ec 04             	sub    $0x4,%esp
  802b21:	68 c3 43 80 00       	push   $0x8043c3
  802b26:	68 58 01 00 00       	push   $0x158
  802b2b:	68 e1 43 80 00       	push   $0x8043e1
  802b30:	e8 23 0e 00 00       	call   803958 <_panic>
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 10                	je     802b4e <alloc_block_BF+0x493>
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b46:	8b 52 04             	mov    0x4(%edx),%edx
  802b49:	89 50 04             	mov    %edx,0x4(%eax)
  802b4c:	eb 0b                	jmp    802b59 <alloc_block_BF+0x49e>
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	8b 40 04             	mov    0x4(%eax),%eax
  802b54:	a3 30 50 80 00       	mov    %eax,0x805030
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	8b 40 04             	mov    0x4(%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 0f                	je     802b72 <alloc_block_BF+0x4b7>
  802b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6c:	8b 12                	mov    (%edx),%edx
  802b6e:	89 10                	mov    %edx,(%eax)
  802b70:	eb 0a                	jmp    802b7c <alloc_block_BF+0x4c1>
  802b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8f:	a1 38 50 80 00       	mov    0x805038,%eax
  802b94:	48                   	dec    %eax
  802b95:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	e9 d9 00 00 00       	jmp    802c7b <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	83 c0 08             	add    $0x8,%eax
  802ba8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bab:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802bb2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bb5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bb8:	01 d0                	add    %edx,%eax
  802bba:	48                   	dec    %eax
  802bbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bbe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bc1:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc6:	f7 75 c4             	divl   -0x3c(%ebp)
  802bc9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bcc:	29 d0                	sub    %edx,%eax
  802bce:	c1 e8 0c             	shr    $0xc,%eax
  802bd1:	83 ec 0c             	sub    $0xc,%esp
  802bd4:	50                   	push   %eax
  802bd5:	e8 49 e7 ff ff       	call   801323 <sbrk>
  802bda:	83 c4 10             	add    $0x10,%esp
  802bdd:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802be0:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802be4:	75 0a                	jne    802bf0 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802be6:	b8 00 00 00 00       	mov    $0x0,%eax
  802beb:	e9 8b 00 00 00       	jmp    802c7b <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bf0:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802bf7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bfa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bfd:	01 d0                	add    %edx,%eax
  802bff:	48                   	dec    %eax
  802c00:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c06:	ba 00 00 00 00       	mov    $0x0,%edx
  802c0b:	f7 75 b8             	divl   -0x48(%ebp)
  802c0e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c11:	29 d0                	sub    %edx,%eax
  802c13:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c16:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c19:	01 d0                	add    %edx,%eax
  802c1b:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c20:	a1 40 50 80 00       	mov    0x805040,%eax
  802c25:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c2b:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c32:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c35:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c38:	01 d0                	add    %edx,%eax
  802c3a:	48                   	dec    %eax
  802c3b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c3e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c41:	ba 00 00 00 00       	mov    $0x0,%edx
  802c46:	f7 75 b0             	divl   -0x50(%ebp)
  802c49:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c4c:	29 d0                	sub    %edx,%eax
  802c4e:	83 ec 04             	sub    $0x4,%esp
  802c51:	6a 01                	push   $0x1
  802c53:	50                   	push   %eax
  802c54:	ff 75 bc             	pushl  -0x44(%ebp)
  802c57:	e8 74 f5 ff ff       	call   8021d0 <set_block_data>
  802c5c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c5f:	83 ec 0c             	sub    $0xc,%esp
  802c62:	ff 75 bc             	pushl  -0x44(%ebp)
  802c65:	e8 36 04 00 00       	call   8030a0 <free_block>
  802c6a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c6d:	83 ec 0c             	sub    $0xc,%esp
  802c70:	ff 75 08             	pushl  0x8(%ebp)
  802c73:	e8 43 fa ff ff       	call   8026bb <alloc_block_BF>
  802c78:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c7b:	c9                   	leave  
  802c7c:	c3                   	ret    

00802c7d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c7d:	55                   	push   %ebp
  802c7e:	89 e5                	mov    %esp,%ebp
  802c80:	53                   	push   %ebx
  802c81:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c96:	74 1e                	je     802cb6 <merging+0x39>
  802c98:	ff 75 08             	pushl  0x8(%ebp)
  802c9b:	e8 df f1 ff ff       	call   801e7f <get_block_size>
  802ca0:	83 c4 04             	add    $0x4,%esp
  802ca3:	89 c2                	mov    %eax,%edx
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	01 d0                	add    %edx,%eax
  802caa:	3b 45 10             	cmp    0x10(%ebp),%eax
  802cad:	75 07                	jne    802cb6 <merging+0x39>
		prev_is_free = 1;
  802caf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802cb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cba:	74 1e                	je     802cda <merging+0x5d>
  802cbc:	ff 75 10             	pushl  0x10(%ebp)
  802cbf:	e8 bb f1 ff ff       	call   801e7f <get_block_size>
  802cc4:	83 c4 04             	add    $0x4,%esp
  802cc7:	89 c2                	mov    %eax,%edx
  802cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  802ccc:	01 d0                	add    %edx,%eax
  802cce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cd1:	75 07                	jne    802cda <merging+0x5d>
		next_is_free = 1;
  802cd3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cde:	0f 84 cc 00 00 00    	je     802db0 <merging+0x133>
  802ce4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce8:	0f 84 c2 00 00 00    	je     802db0 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802cee:	ff 75 08             	pushl  0x8(%ebp)
  802cf1:	e8 89 f1 ff ff       	call   801e7f <get_block_size>
  802cf6:	83 c4 04             	add    $0x4,%esp
  802cf9:	89 c3                	mov    %eax,%ebx
  802cfb:	ff 75 10             	pushl  0x10(%ebp)
  802cfe:	e8 7c f1 ff ff       	call   801e7f <get_block_size>
  802d03:	83 c4 04             	add    $0x4,%esp
  802d06:	01 c3                	add    %eax,%ebx
  802d08:	ff 75 0c             	pushl  0xc(%ebp)
  802d0b:	e8 6f f1 ff ff       	call   801e7f <get_block_size>
  802d10:	83 c4 04             	add    $0x4,%esp
  802d13:	01 d8                	add    %ebx,%eax
  802d15:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d18:	6a 00                	push   $0x0
  802d1a:	ff 75 ec             	pushl  -0x14(%ebp)
  802d1d:	ff 75 08             	pushl  0x8(%ebp)
  802d20:	e8 ab f4 ff ff       	call   8021d0 <set_block_data>
  802d25:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d2c:	75 17                	jne    802d45 <merging+0xc8>
  802d2e:	83 ec 04             	sub    $0x4,%esp
  802d31:	68 c3 43 80 00       	push   $0x8043c3
  802d36:	68 7d 01 00 00       	push   $0x17d
  802d3b:	68 e1 43 80 00       	push   $0x8043e1
  802d40:	e8 13 0c 00 00       	call   803958 <_panic>
  802d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	74 10                	je     802d5e <merging+0xe1>
  802d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d56:	8b 52 04             	mov    0x4(%edx),%edx
  802d59:	89 50 04             	mov    %edx,0x4(%eax)
  802d5c:	eb 0b                	jmp    802d69 <merging+0xec>
  802d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	a3 30 50 80 00       	mov    %eax,0x805030
  802d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6c:	8b 40 04             	mov    0x4(%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	74 0f                	je     802d82 <merging+0x105>
  802d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d7c:	8b 12                	mov    (%edx),%edx
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	eb 0a                	jmp    802d8c <merging+0x10f>
  802d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9f:	a1 38 50 80 00       	mov    0x805038,%eax
  802da4:	48                   	dec    %eax
  802da5:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802daa:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dab:	e9 ea 02 00 00       	jmp    80309a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802db0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db4:	74 3b                	je     802df1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802db6:	83 ec 0c             	sub    $0xc,%esp
  802db9:	ff 75 08             	pushl  0x8(%ebp)
  802dbc:	e8 be f0 ff ff       	call   801e7f <get_block_size>
  802dc1:	83 c4 10             	add    $0x10,%esp
  802dc4:	89 c3                	mov    %eax,%ebx
  802dc6:	83 ec 0c             	sub    $0xc,%esp
  802dc9:	ff 75 10             	pushl  0x10(%ebp)
  802dcc:	e8 ae f0 ff ff       	call   801e7f <get_block_size>
  802dd1:	83 c4 10             	add    $0x10,%esp
  802dd4:	01 d8                	add    %ebx,%eax
  802dd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dd9:	83 ec 04             	sub    $0x4,%esp
  802ddc:	6a 00                	push   $0x0
  802dde:	ff 75 e8             	pushl  -0x18(%ebp)
  802de1:	ff 75 08             	pushl  0x8(%ebp)
  802de4:	e8 e7 f3 ff ff       	call   8021d0 <set_block_data>
  802de9:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dec:	e9 a9 02 00 00       	jmp    80309a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802df1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df5:	0f 84 2d 01 00 00    	je     802f28 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802dfb:	83 ec 0c             	sub    $0xc,%esp
  802dfe:	ff 75 10             	pushl  0x10(%ebp)
  802e01:	e8 79 f0 ff ff       	call   801e7f <get_block_size>
  802e06:	83 c4 10             	add    $0x10,%esp
  802e09:	89 c3                	mov    %eax,%ebx
  802e0b:	83 ec 0c             	sub    $0xc,%esp
  802e0e:	ff 75 0c             	pushl  0xc(%ebp)
  802e11:	e8 69 f0 ff ff       	call   801e7f <get_block_size>
  802e16:	83 c4 10             	add    $0x10,%esp
  802e19:	01 d8                	add    %ebx,%eax
  802e1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e1e:	83 ec 04             	sub    $0x4,%esp
  802e21:	6a 00                	push   $0x0
  802e23:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e26:	ff 75 10             	pushl  0x10(%ebp)
  802e29:	e8 a2 f3 ff ff       	call   8021d0 <set_block_data>
  802e2e:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e31:	8b 45 10             	mov    0x10(%ebp),%eax
  802e34:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e3b:	74 06                	je     802e43 <merging+0x1c6>
  802e3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e41:	75 17                	jne    802e5a <merging+0x1dd>
  802e43:	83 ec 04             	sub    $0x4,%esp
  802e46:	68 88 44 80 00       	push   $0x804488
  802e4b:	68 8d 01 00 00       	push   $0x18d
  802e50:	68 e1 43 80 00       	push   $0x8043e1
  802e55:	e8 fe 0a 00 00       	call   803958 <_panic>
  802e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5d:	8b 50 04             	mov    0x4(%eax),%edx
  802e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e63:	89 50 04             	mov    %edx,0x4(%eax)
  802e66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e6c:	89 10                	mov    %edx,(%eax)
  802e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e71:	8b 40 04             	mov    0x4(%eax),%eax
  802e74:	85 c0                	test   %eax,%eax
  802e76:	74 0d                	je     802e85 <merging+0x208>
  802e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7b:	8b 40 04             	mov    0x4(%eax),%eax
  802e7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	eb 08                	jmp    802e8d <merging+0x210>
  802e85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e88:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e93:	89 50 04             	mov    %edx,0x4(%eax)
  802e96:	a1 38 50 80 00       	mov    0x805038,%eax
  802e9b:	40                   	inc    %eax
  802e9c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802ea1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ea5:	75 17                	jne    802ebe <merging+0x241>
  802ea7:	83 ec 04             	sub    $0x4,%esp
  802eaa:	68 c3 43 80 00       	push   $0x8043c3
  802eaf:	68 8e 01 00 00       	push   $0x18e
  802eb4:	68 e1 43 80 00       	push   $0x8043e1
  802eb9:	e8 9a 0a 00 00       	call   803958 <_panic>
  802ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec1:	8b 00                	mov    (%eax),%eax
  802ec3:	85 c0                	test   %eax,%eax
  802ec5:	74 10                	je     802ed7 <merging+0x25a>
  802ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ecf:	8b 52 04             	mov    0x4(%edx),%edx
  802ed2:	89 50 04             	mov    %edx,0x4(%eax)
  802ed5:	eb 0b                	jmp    802ee2 <merging+0x265>
  802ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eda:	8b 40 04             	mov    0x4(%eax),%eax
  802edd:	a3 30 50 80 00       	mov    %eax,0x805030
  802ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee5:	8b 40 04             	mov    0x4(%eax),%eax
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	74 0f                	je     802efb <merging+0x27e>
  802eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eef:	8b 40 04             	mov    0x4(%eax),%eax
  802ef2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef5:	8b 12                	mov    (%edx),%edx
  802ef7:	89 10                	mov    %edx,(%eax)
  802ef9:	eb 0a                	jmp    802f05 <merging+0x288>
  802efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802efe:	8b 00                	mov    (%eax),%eax
  802f00:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f18:	a1 38 50 80 00       	mov    0x805038,%eax
  802f1d:	48                   	dec    %eax
  802f1e:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f23:	e9 72 01 00 00       	jmp    80309a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f28:	8b 45 10             	mov    0x10(%ebp),%eax
  802f2b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f32:	74 79                	je     802fad <merging+0x330>
  802f34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f38:	74 73                	je     802fad <merging+0x330>
  802f3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3e:	74 06                	je     802f46 <merging+0x2c9>
  802f40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f44:	75 17                	jne    802f5d <merging+0x2e0>
  802f46:	83 ec 04             	sub    $0x4,%esp
  802f49:	68 54 44 80 00       	push   $0x804454
  802f4e:	68 94 01 00 00       	push   $0x194
  802f53:	68 e1 43 80 00       	push   $0x8043e1
  802f58:	e8 fb 09 00 00       	call   803958 <_panic>
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 10                	mov    (%eax),%edx
  802f62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f65:	89 10                	mov    %edx,(%eax)
  802f67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0b                	je     802f7b <merging+0x2fe>
  802f70:	8b 45 08             	mov    0x8(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f78:	89 50 04             	mov    %edx,0x4(%eax)
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f81:	89 10                	mov    %edx,(%eax)
  802f83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f86:	8b 55 08             	mov    0x8(%ebp),%edx
  802f89:	89 50 04             	mov    %edx,0x4(%eax)
  802f8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	85 c0                	test   %eax,%eax
  802f93:	75 08                	jne    802f9d <merging+0x320>
  802f95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f98:	a3 30 50 80 00       	mov    %eax,0x805030
  802f9d:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa2:	40                   	inc    %eax
  802fa3:	a3 38 50 80 00       	mov    %eax,0x805038
  802fa8:	e9 ce 00 00 00       	jmp    80307b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802fad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb1:	74 65                	je     803018 <merging+0x39b>
  802fb3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fb7:	75 17                	jne    802fd0 <merging+0x353>
  802fb9:	83 ec 04             	sub    $0x4,%esp
  802fbc:	68 30 44 80 00       	push   $0x804430
  802fc1:	68 95 01 00 00       	push   $0x195
  802fc6:	68 e1 43 80 00       	push   $0x8043e1
  802fcb:	e8 88 09 00 00       	call   803958 <_panic>
  802fd0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd9:	89 50 04             	mov    %edx,0x4(%eax)
  802fdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdf:	8b 40 04             	mov    0x4(%eax),%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	74 0c                	je     802ff2 <merging+0x375>
  802fe6:	a1 30 50 80 00       	mov    0x805030,%eax
  802feb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fee:	89 10                	mov    %edx,(%eax)
  802ff0:	eb 08                	jmp    802ffa <merging+0x37d>
  802ff2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ffa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ffd:	a3 30 50 80 00       	mov    %eax,0x805030
  803002:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803005:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300b:	a1 38 50 80 00       	mov    0x805038,%eax
  803010:	40                   	inc    %eax
  803011:	a3 38 50 80 00       	mov    %eax,0x805038
  803016:	eb 63                	jmp    80307b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803018:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80301c:	75 17                	jne    803035 <merging+0x3b8>
  80301e:	83 ec 04             	sub    $0x4,%esp
  803021:	68 fc 43 80 00       	push   $0x8043fc
  803026:	68 98 01 00 00       	push   $0x198
  80302b:	68 e1 43 80 00       	push   $0x8043e1
  803030:	e8 23 09 00 00       	call   803958 <_panic>
  803035:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80303b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303e:	89 10                	mov    %edx,(%eax)
  803040:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 0d                	je     803056 <merging+0x3d9>
  803049:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80304e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803051:	89 50 04             	mov    %edx,0x4(%eax)
  803054:	eb 08                	jmp    80305e <merging+0x3e1>
  803056:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803059:	a3 30 50 80 00       	mov    %eax,0x805030
  80305e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803061:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803066:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803069:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803070:	a1 38 50 80 00       	mov    0x805038,%eax
  803075:	40                   	inc    %eax
  803076:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80307b:	83 ec 0c             	sub    $0xc,%esp
  80307e:	ff 75 10             	pushl  0x10(%ebp)
  803081:	e8 f9 ed ff ff       	call   801e7f <get_block_size>
  803086:	83 c4 10             	add    $0x10,%esp
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	6a 00                	push   $0x0
  80308e:	50                   	push   %eax
  80308f:	ff 75 10             	pushl  0x10(%ebp)
  803092:	e8 39 f1 ff ff       	call   8021d0 <set_block_data>
  803097:	83 c4 10             	add    $0x10,%esp
	}
}
  80309a:	90                   	nop
  80309b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80309e:	c9                   	leave  
  80309f:	c3                   	ret    

008030a0 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030a0:	55                   	push   %ebp
  8030a1:	89 e5                	mov    %esp,%ebp
  8030a3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030ae:	a1 30 50 80 00       	mov    0x805030,%eax
  8030b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b6:	73 1b                	jae    8030d3 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030b8:	a1 30 50 80 00       	mov    0x805030,%eax
  8030bd:	83 ec 04             	sub    $0x4,%esp
  8030c0:	ff 75 08             	pushl  0x8(%ebp)
  8030c3:	6a 00                	push   $0x0
  8030c5:	50                   	push   %eax
  8030c6:	e8 b2 fb ff ff       	call   802c7d <merging>
  8030cb:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030ce:	e9 8b 00 00 00       	jmp    80315e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030db:	76 18                	jbe    8030f5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030dd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030e2:	83 ec 04             	sub    $0x4,%esp
  8030e5:	ff 75 08             	pushl  0x8(%ebp)
  8030e8:	50                   	push   %eax
  8030e9:	6a 00                	push   $0x0
  8030eb:	e8 8d fb ff ff       	call   802c7d <merging>
  8030f0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030f3:	eb 69                	jmp    80315e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030f5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030fd:	eb 39                	jmp    803138 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	3b 45 08             	cmp    0x8(%ebp),%eax
  803105:	73 29                	jae    803130 <free_block+0x90>
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	8b 00                	mov    (%eax),%eax
  80310c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310f:	76 1f                	jbe    803130 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803119:	83 ec 04             	sub    $0x4,%esp
  80311c:	ff 75 08             	pushl  0x8(%ebp)
  80311f:	ff 75 f0             	pushl  -0x10(%ebp)
  803122:	ff 75 f4             	pushl  -0xc(%ebp)
  803125:	e8 53 fb ff ff       	call   802c7d <merging>
  80312a:	83 c4 10             	add    $0x10,%esp
			break;
  80312d:	90                   	nop
		}
	}
}
  80312e:	eb 2e                	jmp    80315e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803130:	a1 34 50 80 00       	mov    0x805034,%eax
  803135:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803138:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313c:	74 07                	je     803145 <free_block+0xa5>
  80313e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	eb 05                	jmp    80314a <free_block+0xaa>
  803145:	b8 00 00 00 00       	mov    $0x0,%eax
  80314a:	a3 34 50 80 00       	mov    %eax,0x805034
  80314f:	a1 34 50 80 00       	mov    0x805034,%eax
  803154:	85 c0                	test   %eax,%eax
  803156:	75 a7                	jne    8030ff <free_block+0x5f>
  803158:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315c:	75 a1                	jne    8030ff <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80315e:	90                   	nop
  80315f:	c9                   	leave  
  803160:	c3                   	ret    

00803161 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803161:	55                   	push   %ebp
  803162:	89 e5                	mov    %esp,%ebp
  803164:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803167:	ff 75 08             	pushl  0x8(%ebp)
  80316a:	e8 10 ed ff ff       	call   801e7f <get_block_size>
  80316f:	83 c4 04             	add    $0x4,%esp
  803172:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80317c:	eb 17                	jmp    803195 <copy_data+0x34>
  80317e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803181:	8b 45 0c             	mov    0xc(%ebp),%eax
  803184:	01 c2                	add    %eax,%edx
  803186:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	01 c8                	add    %ecx,%eax
  80318e:	8a 00                	mov    (%eax),%al
  803190:	88 02                	mov    %al,(%edx)
  803192:	ff 45 fc             	incl   -0x4(%ebp)
  803195:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803198:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80319b:	72 e1                	jb     80317e <copy_data+0x1d>
}
  80319d:	90                   	nop
  80319e:	c9                   	leave  
  80319f:	c3                   	ret    

008031a0 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031a0:	55                   	push   %ebp
  8031a1:	89 e5                	mov    %esp,%ebp
  8031a3:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031aa:	75 23                	jne    8031cf <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031b0:	74 13                	je     8031c5 <realloc_block_FF+0x25>
  8031b2:	83 ec 0c             	sub    $0xc,%esp
  8031b5:	ff 75 0c             	pushl  0xc(%ebp)
  8031b8:	e8 42 f0 ff ff       	call   8021ff <alloc_block_FF>
  8031bd:	83 c4 10             	add    $0x10,%esp
  8031c0:	e9 e4 06 00 00       	jmp    8038a9 <realloc_block_FF+0x709>
		return NULL;
  8031c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ca:	e9 da 06 00 00       	jmp    8038a9 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8031cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031d3:	75 18                	jne    8031ed <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031d5:	83 ec 0c             	sub    $0xc,%esp
  8031d8:	ff 75 08             	pushl  0x8(%ebp)
  8031db:	e8 c0 fe ff ff       	call   8030a0 <free_block>
  8031e0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e8:	e9 bc 06 00 00       	jmp    8038a9 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8031ed:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031f1:	77 07                	ja     8031fa <realloc_block_FF+0x5a>
  8031f3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031fd:	83 e0 01             	and    $0x1,%eax
  803200:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803203:	8b 45 0c             	mov    0xc(%ebp),%eax
  803206:	83 c0 08             	add    $0x8,%eax
  803209:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80320c:	83 ec 0c             	sub    $0xc,%esp
  80320f:	ff 75 08             	pushl  0x8(%ebp)
  803212:	e8 68 ec ff ff       	call   801e7f <get_block_size>
  803217:	83 c4 10             	add    $0x10,%esp
  80321a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80321d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803220:	83 e8 08             	sub    $0x8,%eax
  803223:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	83 e8 04             	sub    $0x4,%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	83 e0 fe             	and    $0xfffffffe,%eax
  803231:	89 c2                	mov    %eax,%edx
  803233:	8b 45 08             	mov    0x8(%ebp),%eax
  803236:	01 d0                	add    %edx,%eax
  803238:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80323b:	83 ec 0c             	sub    $0xc,%esp
  80323e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803241:	e8 39 ec ff ff       	call   801e7f <get_block_size>
  803246:	83 c4 10             	add    $0x10,%esp
  803249:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80324c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324f:	83 e8 08             	sub    $0x8,%eax
  803252:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803255:	8b 45 0c             	mov    0xc(%ebp),%eax
  803258:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80325b:	75 08                	jne    803265 <realloc_block_FF+0xc5>
	{
		 return va;
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	e9 44 06 00 00       	jmp    8038a9 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803265:	8b 45 0c             	mov    0xc(%ebp),%eax
  803268:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80326b:	0f 83 d5 03 00 00    	jae    803646 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803274:	2b 45 0c             	sub    0xc(%ebp),%eax
  803277:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80327a:	83 ec 0c             	sub    $0xc,%esp
  80327d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803280:	e8 13 ec ff ff       	call   801e98 <is_free_block>
  803285:	83 c4 10             	add    $0x10,%esp
  803288:	84 c0                	test   %al,%al
  80328a:	0f 84 3b 01 00 00    	je     8033cb <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803290:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803293:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803296:	01 d0                	add    %edx,%eax
  803298:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80329b:	83 ec 04             	sub    $0x4,%esp
  80329e:	6a 01                	push   $0x1
  8032a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8032a3:	ff 75 08             	pushl  0x8(%ebp)
  8032a6:	e8 25 ef ff ff       	call   8021d0 <set_block_data>
  8032ab:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	83 e8 04             	sub    $0x4,%eax
  8032b4:	8b 00                	mov    (%eax),%eax
  8032b6:	83 e0 fe             	and    $0xfffffffe,%eax
  8032b9:	89 c2                	mov    %eax,%edx
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	01 d0                	add    %edx,%eax
  8032c0:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8032c3:	83 ec 04             	sub    $0x4,%esp
  8032c6:	6a 00                	push   $0x0
  8032c8:	ff 75 cc             	pushl  -0x34(%ebp)
  8032cb:	ff 75 c8             	pushl  -0x38(%ebp)
  8032ce:	e8 fd ee ff ff       	call   8021d0 <set_block_data>
  8032d3:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032da:	74 06                	je     8032e2 <realloc_block_FF+0x142>
  8032dc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032e0:	75 17                	jne    8032f9 <realloc_block_FF+0x159>
  8032e2:	83 ec 04             	sub    $0x4,%esp
  8032e5:	68 54 44 80 00       	push   $0x804454
  8032ea:	68 f6 01 00 00       	push   $0x1f6
  8032ef:	68 e1 43 80 00       	push   $0x8043e1
  8032f4:	e8 5f 06 00 00       	call   803958 <_panic>
  8032f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fc:	8b 10                	mov    (%eax),%edx
  8032fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803301:	89 10                	mov    %edx,(%eax)
  803303:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803306:	8b 00                	mov    (%eax),%eax
  803308:	85 c0                	test   %eax,%eax
  80330a:	74 0b                	je     803317 <realloc_block_FF+0x177>
  80330c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330f:	8b 00                	mov    (%eax),%eax
  803311:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803314:	89 50 04             	mov    %edx,0x4(%eax)
  803317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80331d:	89 10                	mov    %edx,(%eax)
  80331f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803322:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803325:	89 50 04             	mov    %edx,0x4(%eax)
  803328:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80332b:	8b 00                	mov    (%eax),%eax
  80332d:	85 c0                	test   %eax,%eax
  80332f:	75 08                	jne    803339 <realloc_block_FF+0x199>
  803331:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803334:	a3 30 50 80 00       	mov    %eax,0x805030
  803339:	a1 38 50 80 00       	mov    0x805038,%eax
  80333e:	40                   	inc    %eax
  80333f:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803344:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803348:	75 17                	jne    803361 <realloc_block_FF+0x1c1>
  80334a:	83 ec 04             	sub    $0x4,%esp
  80334d:	68 c3 43 80 00       	push   $0x8043c3
  803352:	68 f7 01 00 00       	push   $0x1f7
  803357:	68 e1 43 80 00       	push   $0x8043e1
  80335c:	e8 f7 05 00 00       	call   803958 <_panic>
  803361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803364:	8b 00                	mov    (%eax),%eax
  803366:	85 c0                	test   %eax,%eax
  803368:	74 10                	je     80337a <realloc_block_FF+0x1da>
  80336a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803372:	8b 52 04             	mov    0x4(%edx),%edx
  803375:	89 50 04             	mov    %edx,0x4(%eax)
  803378:	eb 0b                	jmp    803385 <realloc_block_FF+0x1e5>
  80337a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337d:	8b 40 04             	mov    0x4(%eax),%eax
  803380:	a3 30 50 80 00       	mov    %eax,0x805030
  803385:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803388:	8b 40 04             	mov    0x4(%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	74 0f                	je     80339e <realloc_block_FF+0x1fe>
  80338f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803392:	8b 40 04             	mov    0x4(%eax),%eax
  803395:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803398:	8b 12                	mov    (%edx),%edx
  80339a:	89 10                	mov    %edx,(%eax)
  80339c:	eb 0a                	jmp    8033a8 <realloc_block_FF+0x208>
  80339e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a1:	8b 00                	mov    (%eax),%eax
  8033a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8033c0:	48                   	dec    %eax
  8033c1:	a3 38 50 80 00       	mov    %eax,0x805038
  8033c6:	e9 73 02 00 00       	jmp    80363e <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8033cb:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033cf:	0f 86 69 02 00 00    	jbe    80363e <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033d5:	83 ec 04             	sub    $0x4,%esp
  8033d8:	6a 01                	push   $0x1
  8033da:	ff 75 f0             	pushl  -0x10(%ebp)
  8033dd:	ff 75 08             	pushl  0x8(%ebp)
  8033e0:	e8 eb ed ff ff       	call   8021d0 <set_block_data>
  8033e5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	83 e8 04             	sub    $0x4,%eax
  8033ee:	8b 00                	mov    (%eax),%eax
  8033f0:	83 e0 fe             	and    $0xfffffffe,%eax
  8033f3:	89 c2                	mov    %eax,%edx
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	01 d0                	add    %edx,%eax
  8033fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803402:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803405:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803409:	75 68                	jne    803473 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80340b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80340f:	75 17                	jne    803428 <realloc_block_FF+0x288>
  803411:	83 ec 04             	sub    $0x4,%esp
  803414:	68 fc 43 80 00       	push   $0x8043fc
  803419:	68 06 02 00 00       	push   $0x206
  80341e:	68 e1 43 80 00       	push   $0x8043e1
  803423:	e8 30 05 00 00       	call   803958 <_panic>
  803428:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80342e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803431:	89 10                	mov    %edx,(%eax)
  803433:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803436:	8b 00                	mov    (%eax),%eax
  803438:	85 c0                	test   %eax,%eax
  80343a:	74 0d                	je     803449 <realloc_block_FF+0x2a9>
  80343c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803441:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803444:	89 50 04             	mov    %edx,0x4(%eax)
  803447:	eb 08                	jmp    803451 <realloc_block_FF+0x2b1>
  803449:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344c:	a3 30 50 80 00       	mov    %eax,0x805030
  803451:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803454:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803459:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803463:	a1 38 50 80 00       	mov    0x805038,%eax
  803468:	40                   	inc    %eax
  803469:	a3 38 50 80 00       	mov    %eax,0x805038
  80346e:	e9 b0 01 00 00       	jmp    803623 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803473:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803478:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80347b:	76 68                	jbe    8034e5 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80347d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803481:	75 17                	jne    80349a <realloc_block_FF+0x2fa>
  803483:	83 ec 04             	sub    $0x4,%esp
  803486:	68 fc 43 80 00       	push   $0x8043fc
  80348b:	68 0b 02 00 00       	push   $0x20b
  803490:	68 e1 43 80 00       	push   $0x8043e1
  803495:	e8 be 04 00 00       	call   803958 <_panic>
  80349a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a3:	89 10                	mov    %edx,(%eax)
  8034a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	74 0d                	je     8034bb <realloc_block_FF+0x31b>
  8034ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034b6:	89 50 04             	mov    %edx,0x4(%eax)
  8034b9:	eb 08                	jmp    8034c3 <realloc_block_FF+0x323>
  8034bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034be:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8034da:	40                   	inc    %eax
  8034db:	a3 38 50 80 00       	mov    %eax,0x805038
  8034e0:	e9 3e 01 00 00       	jmp    803623 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034e5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034ea:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034ed:	73 68                	jae    803557 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034f3:	75 17                	jne    80350c <realloc_block_FF+0x36c>
  8034f5:	83 ec 04             	sub    $0x4,%esp
  8034f8:	68 30 44 80 00       	push   $0x804430
  8034fd:	68 10 02 00 00       	push   $0x210
  803502:	68 e1 43 80 00       	push   $0x8043e1
  803507:	e8 4c 04 00 00       	call   803958 <_panic>
  80350c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803512:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803515:	89 50 04             	mov    %edx,0x4(%eax)
  803518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351b:	8b 40 04             	mov    0x4(%eax),%eax
  80351e:	85 c0                	test   %eax,%eax
  803520:	74 0c                	je     80352e <realloc_block_FF+0x38e>
  803522:	a1 30 50 80 00       	mov    0x805030,%eax
  803527:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80352a:	89 10                	mov    %edx,(%eax)
  80352c:	eb 08                	jmp    803536 <realloc_block_FF+0x396>
  80352e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803531:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803536:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803539:	a3 30 50 80 00       	mov    %eax,0x805030
  80353e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803547:	a1 38 50 80 00       	mov    0x805038,%eax
  80354c:	40                   	inc    %eax
  80354d:	a3 38 50 80 00       	mov    %eax,0x805038
  803552:	e9 cc 00 00 00       	jmp    803623 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80355e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803563:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803566:	e9 8a 00 00 00       	jmp    8035f5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803571:	73 7a                	jae    8035ed <realloc_block_FF+0x44d>
  803573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803576:	8b 00                	mov    (%eax),%eax
  803578:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80357b:	73 70                	jae    8035ed <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80357d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803581:	74 06                	je     803589 <realloc_block_FF+0x3e9>
  803583:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803587:	75 17                	jne    8035a0 <realloc_block_FF+0x400>
  803589:	83 ec 04             	sub    $0x4,%esp
  80358c:	68 54 44 80 00       	push   $0x804454
  803591:	68 1a 02 00 00       	push   $0x21a
  803596:	68 e1 43 80 00       	push   $0x8043e1
  80359b:	e8 b8 03 00 00       	call   803958 <_panic>
  8035a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a3:	8b 10                	mov    (%eax),%edx
  8035a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a8:	89 10                	mov    %edx,(%eax)
  8035aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ad:	8b 00                	mov    (%eax),%eax
  8035af:	85 c0                	test   %eax,%eax
  8035b1:	74 0b                	je     8035be <realloc_block_FF+0x41e>
  8035b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b6:	8b 00                	mov    (%eax),%eax
  8035b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035bb:	89 50 04             	mov    %edx,0x4(%eax)
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035c4:	89 10                	mov    %edx,(%eax)
  8035c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035cc:	89 50 04             	mov    %edx,0x4(%eax)
  8035cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d2:	8b 00                	mov    (%eax),%eax
  8035d4:	85 c0                	test   %eax,%eax
  8035d6:	75 08                	jne    8035e0 <realloc_block_FF+0x440>
  8035d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035db:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e5:	40                   	inc    %eax
  8035e6:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035eb:	eb 36                	jmp    803623 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035ed:	a1 34 50 80 00       	mov    0x805034,%eax
  8035f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f9:	74 07                	je     803602 <realloc_block_FF+0x462>
  8035fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fe:	8b 00                	mov    (%eax),%eax
  803600:	eb 05                	jmp    803607 <realloc_block_FF+0x467>
  803602:	b8 00 00 00 00       	mov    $0x0,%eax
  803607:	a3 34 50 80 00       	mov    %eax,0x805034
  80360c:	a1 34 50 80 00       	mov    0x805034,%eax
  803611:	85 c0                	test   %eax,%eax
  803613:	0f 85 52 ff ff ff    	jne    80356b <realloc_block_FF+0x3cb>
  803619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361d:	0f 85 48 ff ff ff    	jne    80356b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803623:	83 ec 04             	sub    $0x4,%esp
  803626:	6a 00                	push   $0x0
  803628:	ff 75 d8             	pushl  -0x28(%ebp)
  80362b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80362e:	e8 9d eb ff ff       	call   8021d0 <set_block_data>
  803633:	83 c4 10             	add    $0x10,%esp
				return va;
  803636:	8b 45 08             	mov    0x8(%ebp),%eax
  803639:	e9 6b 02 00 00       	jmp    8038a9 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	e9 63 02 00 00       	jmp    8038a9 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803646:	8b 45 0c             	mov    0xc(%ebp),%eax
  803649:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80364c:	0f 86 4d 02 00 00    	jbe    80389f <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803652:	83 ec 0c             	sub    $0xc,%esp
  803655:	ff 75 e4             	pushl  -0x1c(%ebp)
  803658:	e8 3b e8 ff ff       	call   801e98 <is_free_block>
  80365d:	83 c4 10             	add    $0x10,%esp
  803660:	84 c0                	test   %al,%al
  803662:	0f 84 37 02 00 00    	je     80389f <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803668:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80366e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803671:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803674:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803677:	76 38                	jbe    8036b1 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803679:	83 ec 0c             	sub    $0xc,%esp
  80367c:	ff 75 0c             	pushl  0xc(%ebp)
  80367f:	e8 7b eb ff ff       	call   8021ff <alloc_block_FF>
  803684:	83 c4 10             	add    $0x10,%esp
  803687:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80368a:	83 ec 08             	sub    $0x8,%esp
  80368d:	ff 75 c0             	pushl  -0x40(%ebp)
  803690:	ff 75 08             	pushl  0x8(%ebp)
  803693:	e8 c9 fa ff ff       	call   803161 <copy_data>
  803698:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80369b:	83 ec 0c             	sub    $0xc,%esp
  80369e:	ff 75 08             	pushl  0x8(%ebp)
  8036a1:	e8 fa f9 ff ff       	call   8030a0 <free_block>
  8036a6:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036a9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036ac:	e9 f8 01 00 00       	jmp    8038a9 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036b4:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036b7:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8036ba:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8036be:	0f 87 a0 00 00 00    	ja     803764 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036c8:	75 17                	jne    8036e1 <realloc_block_FF+0x541>
  8036ca:	83 ec 04             	sub    $0x4,%esp
  8036cd:	68 c3 43 80 00       	push   $0x8043c3
  8036d2:	68 38 02 00 00       	push   $0x238
  8036d7:	68 e1 43 80 00       	push   $0x8043e1
  8036dc:	e8 77 02 00 00       	call   803958 <_panic>
  8036e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e4:	8b 00                	mov    (%eax),%eax
  8036e6:	85 c0                	test   %eax,%eax
  8036e8:	74 10                	je     8036fa <realloc_block_FF+0x55a>
  8036ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ed:	8b 00                	mov    (%eax),%eax
  8036ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f2:	8b 52 04             	mov    0x4(%edx),%edx
  8036f5:	89 50 04             	mov    %edx,0x4(%eax)
  8036f8:	eb 0b                	jmp    803705 <realloc_block_FF+0x565>
  8036fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fd:	8b 40 04             	mov    0x4(%eax),%eax
  803700:	a3 30 50 80 00       	mov    %eax,0x805030
  803705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803708:	8b 40 04             	mov    0x4(%eax),%eax
  80370b:	85 c0                	test   %eax,%eax
  80370d:	74 0f                	je     80371e <realloc_block_FF+0x57e>
  80370f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803712:	8b 40 04             	mov    0x4(%eax),%eax
  803715:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803718:	8b 12                	mov    (%edx),%edx
  80371a:	89 10                	mov    %edx,(%eax)
  80371c:	eb 0a                	jmp    803728 <realloc_block_FF+0x588>
  80371e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803721:	8b 00                	mov    (%eax),%eax
  803723:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803734:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373b:	a1 38 50 80 00       	mov    0x805038,%eax
  803740:	48                   	dec    %eax
  803741:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803746:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803749:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80374c:	01 d0                	add    %edx,%eax
  80374e:	83 ec 04             	sub    $0x4,%esp
  803751:	6a 01                	push   $0x1
  803753:	50                   	push   %eax
  803754:	ff 75 08             	pushl  0x8(%ebp)
  803757:	e8 74 ea ff ff       	call   8021d0 <set_block_data>
  80375c:	83 c4 10             	add    $0x10,%esp
  80375f:	e9 36 01 00 00       	jmp    80389a <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803764:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803767:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80376a:	01 d0                	add    %edx,%eax
  80376c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80376f:	83 ec 04             	sub    $0x4,%esp
  803772:	6a 01                	push   $0x1
  803774:	ff 75 f0             	pushl  -0x10(%ebp)
  803777:	ff 75 08             	pushl  0x8(%ebp)
  80377a:	e8 51 ea ff ff       	call   8021d0 <set_block_data>
  80377f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803782:	8b 45 08             	mov    0x8(%ebp),%eax
  803785:	83 e8 04             	sub    $0x4,%eax
  803788:	8b 00                	mov    (%eax),%eax
  80378a:	83 e0 fe             	and    $0xfffffffe,%eax
  80378d:	89 c2                	mov    %eax,%edx
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	01 d0                	add    %edx,%eax
  803794:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803797:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80379b:	74 06                	je     8037a3 <realloc_block_FF+0x603>
  80379d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037a1:	75 17                	jne    8037ba <realloc_block_FF+0x61a>
  8037a3:	83 ec 04             	sub    $0x4,%esp
  8037a6:	68 54 44 80 00       	push   $0x804454
  8037ab:	68 44 02 00 00       	push   $0x244
  8037b0:	68 e1 43 80 00       	push   $0x8043e1
  8037b5:	e8 9e 01 00 00       	call   803958 <_panic>
  8037ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bd:	8b 10                	mov    (%eax),%edx
  8037bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c2:	89 10                	mov    %edx,(%eax)
  8037c4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c7:	8b 00                	mov    (%eax),%eax
  8037c9:	85 c0                	test   %eax,%eax
  8037cb:	74 0b                	je     8037d8 <realloc_block_FF+0x638>
  8037cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037d5:	89 50 04             	mov    %edx,0x4(%eax)
  8037d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037db:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037de:	89 10                	mov    %edx,(%eax)
  8037e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037e6:	89 50 04             	mov    %edx,0x4(%eax)
  8037e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037ec:	8b 00                	mov    (%eax),%eax
  8037ee:	85 c0                	test   %eax,%eax
  8037f0:	75 08                	jne    8037fa <realloc_block_FF+0x65a>
  8037f2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8037fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ff:	40                   	inc    %eax
  803800:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803805:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803809:	75 17                	jne    803822 <realloc_block_FF+0x682>
  80380b:	83 ec 04             	sub    $0x4,%esp
  80380e:	68 c3 43 80 00       	push   $0x8043c3
  803813:	68 45 02 00 00       	push   $0x245
  803818:	68 e1 43 80 00       	push   $0x8043e1
  80381d:	e8 36 01 00 00       	call   803958 <_panic>
  803822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	85 c0                	test   %eax,%eax
  803829:	74 10                	je     80383b <realloc_block_FF+0x69b>
  80382b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382e:	8b 00                	mov    (%eax),%eax
  803830:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803833:	8b 52 04             	mov    0x4(%edx),%edx
  803836:	89 50 04             	mov    %edx,0x4(%eax)
  803839:	eb 0b                	jmp    803846 <realloc_block_FF+0x6a6>
  80383b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383e:	8b 40 04             	mov    0x4(%eax),%eax
  803841:	a3 30 50 80 00       	mov    %eax,0x805030
  803846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803849:	8b 40 04             	mov    0x4(%eax),%eax
  80384c:	85 c0                	test   %eax,%eax
  80384e:	74 0f                	je     80385f <realloc_block_FF+0x6bf>
  803850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803853:	8b 40 04             	mov    0x4(%eax),%eax
  803856:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803859:	8b 12                	mov    (%edx),%edx
  80385b:	89 10                	mov    %edx,(%eax)
  80385d:	eb 0a                	jmp    803869 <realloc_block_FF+0x6c9>
  80385f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803862:	8b 00                	mov    (%eax),%eax
  803864:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803875:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80387c:	a1 38 50 80 00       	mov    0x805038,%eax
  803881:	48                   	dec    %eax
  803882:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803887:	83 ec 04             	sub    $0x4,%esp
  80388a:	6a 00                	push   $0x0
  80388c:	ff 75 bc             	pushl  -0x44(%ebp)
  80388f:	ff 75 b8             	pushl  -0x48(%ebp)
  803892:	e8 39 e9 ff ff       	call   8021d0 <set_block_data>
  803897:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80389a:	8b 45 08             	mov    0x8(%ebp),%eax
  80389d:	eb 0a                	jmp    8038a9 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80389f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038a9:	c9                   	leave  
  8038aa:	c3                   	ret    

008038ab <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038ab:	55                   	push   %ebp
  8038ac:	89 e5                	mov    %esp,%ebp
  8038ae:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038b1:	83 ec 04             	sub    $0x4,%esp
  8038b4:	68 c0 44 80 00       	push   $0x8044c0
  8038b9:	68 58 02 00 00       	push   $0x258
  8038be:	68 e1 43 80 00       	push   $0x8043e1
  8038c3:	e8 90 00 00 00       	call   803958 <_panic>

008038c8 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038c8:	55                   	push   %ebp
  8038c9:	89 e5                	mov    %esp,%ebp
  8038cb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038ce:	83 ec 04             	sub    $0x4,%esp
  8038d1:	68 e8 44 80 00       	push   $0x8044e8
  8038d6:	68 61 02 00 00       	push   $0x261
  8038db:	68 e1 43 80 00       	push   $0x8043e1
  8038e0:	e8 73 00 00 00       	call   803958 <_panic>

008038e5 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8038e5:	55                   	push   %ebp
  8038e6:	89 e5                	mov    %esp,%ebp
  8038e8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8038eb:	83 ec 04             	sub    $0x4,%esp
  8038ee:	68 10 45 80 00       	push   $0x804510
  8038f3:	6a 09                	push   $0x9
  8038f5:	68 38 45 80 00       	push   $0x804538
  8038fa:	e8 59 00 00 00       	call   803958 <_panic>

008038ff <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8038ff:	55                   	push   %ebp
  803900:	89 e5                	mov    %esp,%ebp
  803902:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803905:	83 ec 04             	sub    $0x4,%esp
  803908:	68 48 45 80 00       	push   $0x804548
  80390d:	6a 10                	push   $0x10
  80390f:	68 38 45 80 00       	push   $0x804538
  803914:	e8 3f 00 00 00       	call   803958 <_panic>

00803919 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803919:	55                   	push   %ebp
  80391a:	89 e5                	mov    %esp,%ebp
  80391c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80391f:	83 ec 04             	sub    $0x4,%esp
  803922:	68 70 45 80 00       	push   $0x804570
  803927:	6a 18                	push   $0x18
  803929:	68 38 45 80 00       	push   $0x804538
  80392e:	e8 25 00 00 00       	call   803958 <_panic>

00803933 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803933:	55                   	push   %ebp
  803934:	89 e5                	mov    %esp,%ebp
  803936:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803939:	83 ec 04             	sub    $0x4,%esp
  80393c:	68 98 45 80 00       	push   $0x804598
  803941:	6a 20                	push   $0x20
  803943:	68 38 45 80 00       	push   $0x804538
  803948:	e8 0b 00 00 00       	call   803958 <_panic>

0080394d <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80394d:	55                   	push   %ebp
  80394e:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803950:	8b 45 08             	mov    0x8(%ebp),%eax
  803953:	8b 40 10             	mov    0x10(%eax),%eax
}
  803956:	5d                   	pop    %ebp
  803957:	c3                   	ret    

00803958 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803958:	55                   	push   %ebp
  803959:	89 e5                	mov    %esp,%ebp
  80395b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80395e:	8d 45 10             	lea    0x10(%ebp),%eax
  803961:	83 c0 04             	add    $0x4,%eax
  803964:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803967:	a1 60 50 98 00       	mov    0x985060,%eax
  80396c:	85 c0                	test   %eax,%eax
  80396e:	74 16                	je     803986 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803970:	a1 60 50 98 00       	mov    0x985060,%eax
  803975:	83 ec 08             	sub    $0x8,%esp
  803978:	50                   	push   %eax
  803979:	68 c0 45 80 00       	push   $0x8045c0
  80397e:	e8 06 cc ff ff       	call   800589 <cprintf>
  803983:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803986:	a1 00 50 80 00       	mov    0x805000,%eax
  80398b:	ff 75 0c             	pushl  0xc(%ebp)
  80398e:	ff 75 08             	pushl  0x8(%ebp)
  803991:	50                   	push   %eax
  803992:	68 c5 45 80 00       	push   $0x8045c5
  803997:	e8 ed cb ff ff       	call   800589 <cprintf>
  80399c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80399f:	8b 45 10             	mov    0x10(%ebp),%eax
  8039a2:	83 ec 08             	sub    $0x8,%esp
  8039a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8039a8:	50                   	push   %eax
  8039a9:	e8 70 cb ff ff       	call   80051e <vcprintf>
  8039ae:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8039b1:	83 ec 08             	sub    $0x8,%esp
  8039b4:	6a 00                	push   $0x0
  8039b6:	68 e1 45 80 00       	push   $0x8045e1
  8039bb:	e8 5e cb ff ff       	call   80051e <vcprintf>
  8039c0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8039c3:	e8 df ca ff ff       	call   8004a7 <exit>

	// should not return here
	while (1) ;
  8039c8:	eb fe                	jmp    8039c8 <_panic+0x70>

008039ca <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039ca:	55                   	push   %ebp
  8039cb:	89 e5                	mov    %esp,%ebp
  8039cd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8039d5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039de:	39 c2                	cmp    %eax,%edx
  8039e0:	74 14                	je     8039f6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039e2:	83 ec 04             	sub    $0x4,%esp
  8039e5:	68 e4 45 80 00       	push   $0x8045e4
  8039ea:	6a 26                	push   $0x26
  8039ec:	68 30 46 80 00       	push   $0x804630
  8039f1:	e8 62 ff ff ff       	call   803958 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a04:	e9 c5 00 00 00       	jmp    803ace <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a0c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a13:	8b 45 08             	mov    0x8(%ebp),%eax
  803a16:	01 d0                	add    %edx,%eax
  803a18:	8b 00                	mov    (%eax),%eax
  803a1a:	85 c0                	test   %eax,%eax
  803a1c:	75 08                	jne    803a26 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a1e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a21:	e9 a5 00 00 00       	jmp    803acb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a26:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a34:	eb 69                	jmp    803a9f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a36:	a1 20 50 80 00       	mov    0x805020,%eax
  803a3b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a41:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a44:	89 d0                	mov    %edx,%eax
  803a46:	01 c0                	add    %eax,%eax
  803a48:	01 d0                	add    %edx,%eax
  803a4a:	c1 e0 03             	shl    $0x3,%eax
  803a4d:	01 c8                	add    %ecx,%eax
  803a4f:	8a 40 04             	mov    0x4(%eax),%al
  803a52:	84 c0                	test   %al,%al
  803a54:	75 46                	jne    803a9c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a56:	a1 20 50 80 00       	mov    0x805020,%eax
  803a5b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a64:	89 d0                	mov    %edx,%eax
  803a66:	01 c0                	add    %eax,%eax
  803a68:	01 d0                	add    %edx,%eax
  803a6a:	c1 e0 03             	shl    $0x3,%eax
  803a6d:	01 c8                	add    %ecx,%eax
  803a6f:	8b 00                	mov    (%eax),%eax
  803a71:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a7c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a81:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a88:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8b:	01 c8                	add    %ecx,%eax
  803a8d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a8f:	39 c2                	cmp    %eax,%edx
  803a91:	75 09                	jne    803a9c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a93:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a9a:	eb 15                	jmp    803ab1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a9c:	ff 45 e8             	incl   -0x18(%ebp)
  803a9f:	a1 20 50 80 00       	mov    0x805020,%eax
  803aa4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aad:	39 c2                	cmp    %eax,%edx
  803aaf:	77 85                	ja     803a36 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803ab1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ab5:	75 14                	jne    803acb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803ab7:	83 ec 04             	sub    $0x4,%esp
  803aba:	68 3c 46 80 00       	push   $0x80463c
  803abf:	6a 3a                	push   $0x3a
  803ac1:	68 30 46 80 00       	push   $0x804630
  803ac6:	e8 8d fe ff ff       	call   803958 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803acb:	ff 45 f0             	incl   -0x10(%ebp)
  803ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ad4:	0f 8c 2f ff ff ff    	jl     803a09 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ada:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ae1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803ae8:	eb 26                	jmp    803b10 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803aea:	a1 20 50 80 00       	mov    0x805020,%eax
  803aef:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803af5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803af8:	89 d0                	mov    %edx,%eax
  803afa:	01 c0                	add    %eax,%eax
  803afc:	01 d0                	add    %edx,%eax
  803afe:	c1 e0 03             	shl    $0x3,%eax
  803b01:	01 c8                	add    %ecx,%eax
  803b03:	8a 40 04             	mov    0x4(%eax),%al
  803b06:	3c 01                	cmp    $0x1,%al
  803b08:	75 03                	jne    803b0d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b0a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b0d:	ff 45 e0             	incl   -0x20(%ebp)
  803b10:	a1 20 50 80 00       	mov    0x805020,%eax
  803b15:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b1e:	39 c2                	cmp    %eax,%edx
  803b20:	77 c8                	ja     803aea <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b25:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b28:	74 14                	je     803b3e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b2a:	83 ec 04             	sub    $0x4,%esp
  803b2d:	68 90 46 80 00       	push   $0x804690
  803b32:	6a 44                	push   $0x44
  803b34:	68 30 46 80 00       	push   $0x804630
  803b39:	e8 1a fe ff ff       	call   803958 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b3e:	90                   	nop
  803b3f:	c9                   	leave  
  803b40:	c3                   	ret    
  803b41:	66 90                	xchg   %ax,%ax
  803b43:	90                   	nop

00803b44 <__udivdi3>:
  803b44:	55                   	push   %ebp
  803b45:	57                   	push   %edi
  803b46:	56                   	push   %esi
  803b47:	53                   	push   %ebx
  803b48:	83 ec 1c             	sub    $0x1c,%esp
  803b4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b5b:	89 ca                	mov    %ecx,%edx
  803b5d:	89 f8                	mov    %edi,%eax
  803b5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b63:	85 f6                	test   %esi,%esi
  803b65:	75 2d                	jne    803b94 <__udivdi3+0x50>
  803b67:	39 cf                	cmp    %ecx,%edi
  803b69:	77 65                	ja     803bd0 <__udivdi3+0x8c>
  803b6b:	89 fd                	mov    %edi,%ebp
  803b6d:	85 ff                	test   %edi,%edi
  803b6f:	75 0b                	jne    803b7c <__udivdi3+0x38>
  803b71:	b8 01 00 00 00       	mov    $0x1,%eax
  803b76:	31 d2                	xor    %edx,%edx
  803b78:	f7 f7                	div    %edi
  803b7a:	89 c5                	mov    %eax,%ebp
  803b7c:	31 d2                	xor    %edx,%edx
  803b7e:	89 c8                	mov    %ecx,%eax
  803b80:	f7 f5                	div    %ebp
  803b82:	89 c1                	mov    %eax,%ecx
  803b84:	89 d8                	mov    %ebx,%eax
  803b86:	f7 f5                	div    %ebp
  803b88:	89 cf                	mov    %ecx,%edi
  803b8a:	89 fa                	mov    %edi,%edx
  803b8c:	83 c4 1c             	add    $0x1c,%esp
  803b8f:	5b                   	pop    %ebx
  803b90:	5e                   	pop    %esi
  803b91:	5f                   	pop    %edi
  803b92:	5d                   	pop    %ebp
  803b93:	c3                   	ret    
  803b94:	39 ce                	cmp    %ecx,%esi
  803b96:	77 28                	ja     803bc0 <__udivdi3+0x7c>
  803b98:	0f bd fe             	bsr    %esi,%edi
  803b9b:	83 f7 1f             	xor    $0x1f,%edi
  803b9e:	75 40                	jne    803be0 <__udivdi3+0x9c>
  803ba0:	39 ce                	cmp    %ecx,%esi
  803ba2:	72 0a                	jb     803bae <__udivdi3+0x6a>
  803ba4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ba8:	0f 87 9e 00 00 00    	ja     803c4c <__udivdi3+0x108>
  803bae:	b8 01 00 00 00       	mov    $0x1,%eax
  803bb3:	89 fa                	mov    %edi,%edx
  803bb5:	83 c4 1c             	add    $0x1c,%esp
  803bb8:	5b                   	pop    %ebx
  803bb9:	5e                   	pop    %esi
  803bba:	5f                   	pop    %edi
  803bbb:	5d                   	pop    %ebp
  803bbc:	c3                   	ret    
  803bbd:	8d 76 00             	lea    0x0(%esi),%esi
  803bc0:	31 ff                	xor    %edi,%edi
  803bc2:	31 c0                	xor    %eax,%eax
  803bc4:	89 fa                	mov    %edi,%edx
  803bc6:	83 c4 1c             	add    $0x1c,%esp
  803bc9:	5b                   	pop    %ebx
  803bca:	5e                   	pop    %esi
  803bcb:	5f                   	pop    %edi
  803bcc:	5d                   	pop    %ebp
  803bcd:	c3                   	ret    
  803bce:	66 90                	xchg   %ax,%ax
  803bd0:	89 d8                	mov    %ebx,%eax
  803bd2:	f7 f7                	div    %edi
  803bd4:	31 ff                	xor    %edi,%edi
  803bd6:	89 fa                	mov    %edi,%edx
  803bd8:	83 c4 1c             	add    $0x1c,%esp
  803bdb:	5b                   	pop    %ebx
  803bdc:	5e                   	pop    %esi
  803bdd:	5f                   	pop    %edi
  803bde:	5d                   	pop    %ebp
  803bdf:	c3                   	ret    
  803be0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803be5:	89 eb                	mov    %ebp,%ebx
  803be7:	29 fb                	sub    %edi,%ebx
  803be9:	89 f9                	mov    %edi,%ecx
  803beb:	d3 e6                	shl    %cl,%esi
  803bed:	89 c5                	mov    %eax,%ebp
  803bef:	88 d9                	mov    %bl,%cl
  803bf1:	d3 ed                	shr    %cl,%ebp
  803bf3:	89 e9                	mov    %ebp,%ecx
  803bf5:	09 f1                	or     %esi,%ecx
  803bf7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bfb:	89 f9                	mov    %edi,%ecx
  803bfd:	d3 e0                	shl    %cl,%eax
  803bff:	89 c5                	mov    %eax,%ebp
  803c01:	89 d6                	mov    %edx,%esi
  803c03:	88 d9                	mov    %bl,%cl
  803c05:	d3 ee                	shr    %cl,%esi
  803c07:	89 f9                	mov    %edi,%ecx
  803c09:	d3 e2                	shl    %cl,%edx
  803c0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c0f:	88 d9                	mov    %bl,%cl
  803c11:	d3 e8                	shr    %cl,%eax
  803c13:	09 c2                	or     %eax,%edx
  803c15:	89 d0                	mov    %edx,%eax
  803c17:	89 f2                	mov    %esi,%edx
  803c19:	f7 74 24 0c          	divl   0xc(%esp)
  803c1d:	89 d6                	mov    %edx,%esi
  803c1f:	89 c3                	mov    %eax,%ebx
  803c21:	f7 e5                	mul    %ebp
  803c23:	39 d6                	cmp    %edx,%esi
  803c25:	72 19                	jb     803c40 <__udivdi3+0xfc>
  803c27:	74 0b                	je     803c34 <__udivdi3+0xf0>
  803c29:	89 d8                	mov    %ebx,%eax
  803c2b:	31 ff                	xor    %edi,%edi
  803c2d:	e9 58 ff ff ff       	jmp    803b8a <__udivdi3+0x46>
  803c32:	66 90                	xchg   %ax,%ax
  803c34:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c38:	89 f9                	mov    %edi,%ecx
  803c3a:	d3 e2                	shl    %cl,%edx
  803c3c:	39 c2                	cmp    %eax,%edx
  803c3e:	73 e9                	jae    803c29 <__udivdi3+0xe5>
  803c40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c43:	31 ff                	xor    %edi,%edi
  803c45:	e9 40 ff ff ff       	jmp    803b8a <__udivdi3+0x46>
  803c4a:	66 90                	xchg   %ax,%ax
  803c4c:	31 c0                	xor    %eax,%eax
  803c4e:	e9 37 ff ff ff       	jmp    803b8a <__udivdi3+0x46>
  803c53:	90                   	nop

00803c54 <__umoddi3>:
  803c54:	55                   	push   %ebp
  803c55:	57                   	push   %edi
  803c56:	56                   	push   %esi
  803c57:	53                   	push   %ebx
  803c58:	83 ec 1c             	sub    $0x1c,%esp
  803c5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c73:	89 f3                	mov    %esi,%ebx
  803c75:	89 fa                	mov    %edi,%edx
  803c77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c7b:	89 34 24             	mov    %esi,(%esp)
  803c7e:	85 c0                	test   %eax,%eax
  803c80:	75 1a                	jne    803c9c <__umoddi3+0x48>
  803c82:	39 f7                	cmp    %esi,%edi
  803c84:	0f 86 a2 00 00 00    	jbe    803d2c <__umoddi3+0xd8>
  803c8a:	89 c8                	mov    %ecx,%eax
  803c8c:	89 f2                	mov    %esi,%edx
  803c8e:	f7 f7                	div    %edi
  803c90:	89 d0                	mov    %edx,%eax
  803c92:	31 d2                	xor    %edx,%edx
  803c94:	83 c4 1c             	add    $0x1c,%esp
  803c97:	5b                   	pop    %ebx
  803c98:	5e                   	pop    %esi
  803c99:	5f                   	pop    %edi
  803c9a:	5d                   	pop    %ebp
  803c9b:	c3                   	ret    
  803c9c:	39 f0                	cmp    %esi,%eax
  803c9e:	0f 87 ac 00 00 00    	ja     803d50 <__umoddi3+0xfc>
  803ca4:	0f bd e8             	bsr    %eax,%ebp
  803ca7:	83 f5 1f             	xor    $0x1f,%ebp
  803caa:	0f 84 ac 00 00 00    	je     803d5c <__umoddi3+0x108>
  803cb0:	bf 20 00 00 00       	mov    $0x20,%edi
  803cb5:	29 ef                	sub    %ebp,%edi
  803cb7:	89 fe                	mov    %edi,%esi
  803cb9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cbd:	89 e9                	mov    %ebp,%ecx
  803cbf:	d3 e0                	shl    %cl,%eax
  803cc1:	89 d7                	mov    %edx,%edi
  803cc3:	89 f1                	mov    %esi,%ecx
  803cc5:	d3 ef                	shr    %cl,%edi
  803cc7:	09 c7                	or     %eax,%edi
  803cc9:	89 e9                	mov    %ebp,%ecx
  803ccb:	d3 e2                	shl    %cl,%edx
  803ccd:	89 14 24             	mov    %edx,(%esp)
  803cd0:	89 d8                	mov    %ebx,%eax
  803cd2:	d3 e0                	shl    %cl,%eax
  803cd4:	89 c2                	mov    %eax,%edx
  803cd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cda:	d3 e0                	shl    %cl,%eax
  803cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ce0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ce4:	89 f1                	mov    %esi,%ecx
  803ce6:	d3 e8                	shr    %cl,%eax
  803ce8:	09 d0                	or     %edx,%eax
  803cea:	d3 eb                	shr    %cl,%ebx
  803cec:	89 da                	mov    %ebx,%edx
  803cee:	f7 f7                	div    %edi
  803cf0:	89 d3                	mov    %edx,%ebx
  803cf2:	f7 24 24             	mull   (%esp)
  803cf5:	89 c6                	mov    %eax,%esi
  803cf7:	89 d1                	mov    %edx,%ecx
  803cf9:	39 d3                	cmp    %edx,%ebx
  803cfb:	0f 82 87 00 00 00    	jb     803d88 <__umoddi3+0x134>
  803d01:	0f 84 91 00 00 00    	je     803d98 <__umoddi3+0x144>
  803d07:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d0b:	29 f2                	sub    %esi,%edx
  803d0d:	19 cb                	sbb    %ecx,%ebx
  803d0f:	89 d8                	mov    %ebx,%eax
  803d11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d15:	d3 e0                	shl    %cl,%eax
  803d17:	89 e9                	mov    %ebp,%ecx
  803d19:	d3 ea                	shr    %cl,%edx
  803d1b:	09 d0                	or     %edx,%eax
  803d1d:	89 e9                	mov    %ebp,%ecx
  803d1f:	d3 eb                	shr    %cl,%ebx
  803d21:	89 da                	mov    %ebx,%edx
  803d23:	83 c4 1c             	add    $0x1c,%esp
  803d26:	5b                   	pop    %ebx
  803d27:	5e                   	pop    %esi
  803d28:	5f                   	pop    %edi
  803d29:	5d                   	pop    %ebp
  803d2a:	c3                   	ret    
  803d2b:	90                   	nop
  803d2c:	89 fd                	mov    %edi,%ebp
  803d2e:	85 ff                	test   %edi,%edi
  803d30:	75 0b                	jne    803d3d <__umoddi3+0xe9>
  803d32:	b8 01 00 00 00       	mov    $0x1,%eax
  803d37:	31 d2                	xor    %edx,%edx
  803d39:	f7 f7                	div    %edi
  803d3b:	89 c5                	mov    %eax,%ebp
  803d3d:	89 f0                	mov    %esi,%eax
  803d3f:	31 d2                	xor    %edx,%edx
  803d41:	f7 f5                	div    %ebp
  803d43:	89 c8                	mov    %ecx,%eax
  803d45:	f7 f5                	div    %ebp
  803d47:	89 d0                	mov    %edx,%eax
  803d49:	e9 44 ff ff ff       	jmp    803c92 <__umoddi3+0x3e>
  803d4e:	66 90                	xchg   %ax,%ax
  803d50:	89 c8                	mov    %ecx,%eax
  803d52:	89 f2                	mov    %esi,%edx
  803d54:	83 c4 1c             	add    $0x1c,%esp
  803d57:	5b                   	pop    %ebx
  803d58:	5e                   	pop    %esi
  803d59:	5f                   	pop    %edi
  803d5a:	5d                   	pop    %ebp
  803d5b:	c3                   	ret    
  803d5c:	3b 04 24             	cmp    (%esp),%eax
  803d5f:	72 06                	jb     803d67 <__umoddi3+0x113>
  803d61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d65:	77 0f                	ja     803d76 <__umoddi3+0x122>
  803d67:	89 f2                	mov    %esi,%edx
  803d69:	29 f9                	sub    %edi,%ecx
  803d6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d6f:	89 14 24             	mov    %edx,(%esp)
  803d72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d76:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d7a:	8b 14 24             	mov    (%esp),%edx
  803d7d:	83 c4 1c             	add    $0x1c,%esp
  803d80:	5b                   	pop    %ebx
  803d81:	5e                   	pop    %esi
  803d82:	5f                   	pop    %edi
  803d83:	5d                   	pop    %ebp
  803d84:	c3                   	ret    
  803d85:	8d 76 00             	lea    0x0(%esi),%esi
  803d88:	2b 04 24             	sub    (%esp),%eax
  803d8b:	19 fa                	sbb    %edi,%edx
  803d8d:	89 d1                	mov    %edx,%ecx
  803d8f:	89 c6                	mov    %eax,%esi
  803d91:	e9 71 ff ff ff       	jmp    803d07 <__umoddi3+0xb3>
  803d96:	66 90                	xchg   %ax,%ax
  803d98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d9c:	72 ea                	jb     803d88 <__umoddi3+0x134>
  803d9e:	89 d9                	mov    %ebx,%ecx
  803da0:	e9 62 ff ff ff       	jmp    803d07 <__umoddi3+0xb3>
