
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 17 05 00 00       	call   80054d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 ba 1c 00 00       	call   801cfd <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 e4 1c 00 00       	call   801d2f <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  80004e:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 80 3f 80 00       	push   $0x803f80
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 74 3a 00 00       	call   803ad6 <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 86 3f 80 00       	push   $0x803f86
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 5d 3a 00 00       	call   803ad6 <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 c8             	pushl  -0x38(%ebp)
  800082:	e8 69 3a 00 00       	call   803af0 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80008a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800091:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  800098:	83 ec 08             	sub    $0x8,%esp
  80009b:	68 8f 3f 80 00       	push   $0x803f8f
  8000a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a3:	e8 2b 18 00 00       	call   8018d3 <sget>
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	68 93 3f 80 00       	push   $0x803f93
  8000b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b9:	e8 15 18 00 00       	call   8018d3 <sget>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000c7:	8b 00                	mov    (%eax),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	6a 00                	push   $0x0
  8000d1:	50                   	push   %eax
  8000d2:	68 9b 3f 80 00       	push   $0x803f9b
  8000d7:	e8 52 17 00 00       	call   80182e <smalloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000e9:	eb 25                	jmp    800110 <_main+0xd8>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80010d:	ff 45 f4             	incl   -0xc(%ebp)
  800110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800113:	8b 00                	mov    (%eax),%eax
  800115:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800118:	7f d1                	jg     8000eb <_main+0xb3>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  80011a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80011d:	8b 00                	mov    (%eax),%eax
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	8d 55 b0             	lea    -0x50(%ebp),%edx
  800125:	52                   	push   %edx
  800126:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800129:	52                   	push   %edx
  80012a:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80012d:	52                   	push   %edx
  80012e:	8d 55 bc             	lea    -0x44(%ebp),%edx
  800131:	52                   	push   %edx
  800132:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800135:	52                   	push   %edx
  800136:	50                   	push   %eax
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	e8 56 02 00 00       	call   800395 <ArrayStats>
  80013f:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	68 a4 3f 80 00       	push   $0x803fa4
  80014a:	e8 11 06 00 00       	call   800760 <cprintf>
  80014f:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 c9 3f 80 00       	push   $0x803fc9
  80015e:	e8 cb 16 00 00       	call   80182e <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 ce 3f 80 00       	push   $0x803fce
  80017d:	e8 ac 16 00 00       	call   80182e <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 d2 3f 80 00       	push   $0x803fd2
  80019c:	e8 8d 16 00 00       	call   80182e <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 d6 3f 80 00       	push   $0x803fd6
  8001bb:	e8 6e 16 00 00       	call   80182e <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	6a 00                	push   $0x0
  8001d3:	6a 04                	push   $0x4
  8001d5:	68 da 3f 80 00       	push   $0x803fda
  8001da:	e8 4f 16 00 00       	call   80182e <smalloc>
  8001df:	83 c4 10             	add    $0x10,%esp
  8001e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8001e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001eb:	89 10                	mov    %edx,(%eax)

	signal_semaphore(finished);
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	ff 75 c4             	pushl  -0x3c(%ebp)
  8001f3:	e8 12 39 00 00       	call   803b0a <signal_semaphore>
  8001f8:	83 c4 10             	add    $0x10,%esp

}
  8001fb:	90                   	nop
  8001fc:	c9                   	leave  
  8001fd:	c3                   	ret    

008001fe <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  800204:	8b 45 10             	mov    0x10(%ebp),%eax
  800207:	8d 50 ff             	lea    -0x1(%eax),%edx
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	48                   	dec    %eax
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	6a 00                	push   $0x0
  800215:	ff 75 0c             	pushl  0xc(%ebp)
  800218:	ff 75 08             	pushl  0x8(%ebp)
  80021b:	e8 05 00 00 00       	call   800225 <QSort>
  800220:	83 c4 20             	add    $0x20,%esp
}
  800223:	c9                   	leave  
  800224:	c3                   	ret    

00800225 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80022b:	8b 45 10             	mov    0x10(%ebp),%eax
  80022e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800231:	7c 16                	jl     800249 <QSort+0x24>
  800233:	8b 45 14             	mov    0x14(%ebp),%eax
  800236:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80023d:	8b 45 08             	mov    0x8(%ebp),%eax
  800240:	01 d0                	add    %edx,%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	e9 4a 01 00 00       	jmp    800393 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800249:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	e8 0d 1b 00 00       	call   801d62 <sys_get_virtual_time>
  800255:	83 c4 0c             	add    $0xc,%esp
  800258:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80025b:	8b 55 14             	mov    0x14(%ebp),%edx
  80025e:	2b 55 10             	sub    0x10(%ebp),%edx
  800261:	89 d1                	mov    %edx,%ecx
  800263:	ba 00 00 00 00       	mov    $0x0,%edx
  800268:	f7 f1                	div    %ecx
  80026a:	8b 45 10             	mov    0x10(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800272:	83 ec 04             	sub    $0x4,%esp
  800275:	ff 75 ec             	pushl  -0x14(%ebp)
  800278:	ff 75 10             	pushl  0x10(%ebp)
  80027b:	ff 75 08             	pushl  0x8(%ebp)
  80027e:	e8 77 02 00 00       	call   8004fa <Swap>
  800283:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800286:	8b 45 10             	mov    0x10(%ebp),%eax
  800289:	40                   	inc    %eax
  80028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028d:	8b 45 14             	mov    0x14(%ebp),%eax
  800290:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800293:	e9 80 00 00 00       	jmp    800318 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800298:	ff 45 f4             	incl   -0xc(%ebp)
  80029b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029e:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a1:	7f 2b                	jg     8002ce <QSort+0xa9>
  8002a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b0:	01 d0                	add    %edx,%eax
  8002b2:	8b 10                	mov    (%eax),%edx
  8002b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	01 c8                	add    %ecx,%eax
  8002c3:	8b 00                	mov    (%eax),%eax
  8002c5:	39 c2                	cmp    %eax,%edx
  8002c7:	7d cf                	jge    800298 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002c9:	eb 03                	jmp    8002ce <QSort+0xa9>
  8002cb:	ff 4d f0             	decl   -0x10(%ebp)
  8002ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d4:	7e 26                	jle    8002fc <QSort+0xd7>
  8002d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	8b 10                	mov    (%eax),%edx
  8002e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f4:	01 c8                	add    %ecx,%eax
  8002f6:	8b 00                	mov    (%eax),%eax
  8002f8:	39 c2                	cmp    %eax,%edx
  8002fa:	7e cf                	jle    8002cb <QSort+0xa6>

		if (i <= j)
  8002fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800302:	7f 14                	jg     800318 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 f4             	pushl  -0xc(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 e5 01 00 00       	call   8004fa <Swap>
  800315:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	0f 8e 77 ff ff ff    	jle    80029b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800324:	83 ec 04             	sub    $0x4,%esp
  800327:	ff 75 f0             	pushl  -0x10(%ebp)
  80032a:	ff 75 10             	pushl  0x10(%ebp)
  80032d:	ff 75 08             	pushl  0x8(%ebp)
  800330:	e8 c5 01 00 00       	call   8004fa <Swap>
  800335:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800338:	8b 45 18             	mov    0x18(%ebp),%eax
  80033b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80033e:	75 13                	jne    800353 <QSort+0x12e>
		return Elements[kIndex] ;
  800340:	8b 45 18             	mov    0x18(%ebp),%eax
  800343:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034a:	8b 45 08             	mov    0x8(%ebp),%eax
  80034d:	01 d0                	add    %edx,%eax
  80034f:	8b 00                	mov    (%eax),%eax
  800351:	eb 40                	jmp    800393 <QSort+0x16e>
	else if (kIndex < j)
  800353:	8b 45 18             	mov    0x18(%ebp),%eax
  800356:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800359:	7d 1e                	jge    800379 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80035b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035e:	48                   	dec    %eax
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 18             	pushl  0x18(%ebp)
  800365:	50                   	push   %eax
  800366:	ff 75 10             	pushl  0x10(%ebp)
  800369:	ff 75 0c             	pushl  0xc(%ebp)
  80036c:	ff 75 08             	pushl  0x8(%ebp)
  80036f:	e8 b1 fe ff ff       	call   800225 <QSort>
  800374:	83 c4 20             	add    $0x20,%esp
  800377:	eb 1a                	jmp    800393 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	ff 75 18             	pushl  0x18(%ebp)
  80037f:	ff 75 14             	pushl  0x14(%ebp)
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	ff 75 0c             	pushl  0xc(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 95 fe ff ff       	call   800225 <QSort>
  800390:	83 c4 20             	add    $0x20,%esp
}
  800393:	c9                   	leave  
  800394:	c3                   	ret    

00800395 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	53                   	push   %ebx
  800399:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80039c:	8b 45 10             	mov    0x10(%ebp),%eax
  80039f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  8003a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003a8:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  8003ae:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003b1:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  8003b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003be:	e9 80 00 00 00       	jmp    800443 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c6:	8b 10                	mov    (%eax),%edx
  8003c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003cb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	01 c8                	add    %ecx,%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	01 c2                	add    %eax,%edx
  8003db:	8b 45 10             	mov    0x10(%ebp),%eax
  8003de:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	01 d0                	add    %edx,%eax
  8003ef:	8b 10                	mov    (%eax),%edx
  8003f1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	7d 16                	jge    800410 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	01 d0                	add    %edx,%eax
  800409:	8b 10                	mov    (%eax),%edx
  80040b:	8b 45 18             	mov    0x18(%ebp),%eax
  80040e:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  800410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800413:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	8b 10                	mov    (%eax),%edx
  800421:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800424:	8b 00                	mov    (%eax),%eax
  800426:	39 c2                	cmp    %eax,%edx
  800428:	7e 16                	jle    800440 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80042a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80042d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800434:	8b 45 08             	mov    0x8(%ebp),%eax
  800437:	01 d0                	add    %edx,%eax
  800439:	8b 10                	mov    (%eax),%edx
  80043b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80043e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800440:	ff 45 f4             	incl   -0xc(%ebp)
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800449:	0f 8c 74 ff ff ff    	jl     8003c3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80044f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800452:	89 c2                	mov    %eax,%edx
  800454:	c1 ea 1f             	shr    $0x1f,%edx
  800457:	01 d0                	add    %edx,%eax
  800459:	d1 f8                	sar    %eax
  80045b:	83 ec 04             	sub    $0x4,%esp
  80045e:	50                   	push   %eax
  80045f:	ff 75 0c             	pushl  0xc(%ebp)
  800462:	ff 75 08             	pushl  0x8(%ebp)
  800465:	e8 94 fd ff ff       	call   8001fe <KthElement>
  80046a:	83 c4 10             	add    $0x10,%esp
  80046d:	89 c2                	mov    %eax,%edx
  80046f:	8b 45 20             	mov    0x20(%ebp),%eax
  800472:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800474:	8b 45 10             	mov    0x10(%ebp),%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	99                   	cltd   
  80047a:	f7 7d 0c             	idivl  0xc(%ebp)
  80047d:	89 c2                	mov    %eax,%edx
  80047f:	8b 45 10             	mov    0x10(%ebp),%eax
  800482:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80048d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800494:	eb 46                	jmp    8004dc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	8b 10                	mov    (%eax),%edx
  80049b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	01 c8                	add    %ecx,%eax
  8004aa:	8b 08                	mov    (%eax),%ecx
  8004ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	89 cb                	mov    %ecx,%ebx
  8004b3:	29 c3                	sub    %eax,%ebx
  8004b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c2:	01 c8                	add    %ecx,%eax
  8004c4:	8b 08                	mov    (%eax),%ecx
  8004c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c9:	8b 00                	mov    (%eax),%eax
  8004cb:	29 c1                	sub    %eax,%ecx
  8004cd:	89 c8                	mov    %ecx,%eax
  8004cf:	0f af c3             	imul   %ebx,%eax
  8004d2:	01 c2                	add    %eax,%edx
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d9:	ff 45 f4             	incl   -0xc(%ebp)
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004e2:	7c b2                	jl     800496 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e7:	8b 00                	mov    (%eax),%eax
  8004e9:	99                   	cltd   
  8004ea:	f7 7d 0c             	idivl  0xc(%ebp)
  8004ed:	89 c2                	mov    %eax,%edx
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	89 10                	mov    %edx,(%eax)
}
  8004f4:	90                   	nop
  8004f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800500:	8b 45 0c             	mov    0xc(%ebp),%eax
  800503:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050a:	8b 45 08             	mov    0x8(%ebp),%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800514:	8b 45 0c             	mov    0xc(%ebp),%eax
  800517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	01 c2                	add    %eax,%edx
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800536:	8b 45 10             	mov    0x10(%ebp),%eax
  800539:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	01 c2                	add    %eax,%edx
  800545:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800548:	89 02                	mov    %eax,(%edx)
}
  80054a:	90                   	nop
  80054b:	c9                   	leave  
  80054c:	c3                   	ret    

0080054d <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80054d:	55                   	push   %ebp
  80054e:	89 e5                	mov    %esp,%ebp
  800550:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800553:	e8 be 17 00 00       	call   801d16 <sys_getenvindex>
  800558:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80055b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80055e:	89 d0                	mov    %edx,%eax
  800560:	c1 e0 03             	shl    $0x3,%eax
  800563:	01 d0                	add    %edx,%eax
  800565:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80056c:	01 c8                	add    %ecx,%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800579:	01 c8                	add    %ecx,%eax
  80057b:	01 d0                	add    %edx,%eax
  80057d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800582:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800587:	a1 20 50 80 00       	mov    0x805020,%eax
  80058c:	8a 40 20             	mov    0x20(%eax),%al
  80058f:	84 c0                	test   %al,%al
  800591:	74 0d                	je     8005a0 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800593:	a1 20 50 80 00       	mov    0x805020,%eax
  800598:	83 c0 20             	add    $0x20,%eax
  80059b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005a4:	7e 0a                	jle    8005b0 <libmain+0x63>
		binaryname = argv[0];
  8005a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	ff 75 0c             	pushl  0xc(%ebp)
  8005b6:	ff 75 08             	pushl  0x8(%ebp)
  8005b9:	e8 7a fa ff ff       	call   800038 <_main>
  8005be:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8005c1:	e8 d4 14 00 00       	call   801a9a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8005c6:	83 ec 0c             	sub    $0xc,%esp
  8005c9:	68 f8 3f 80 00       	push   $0x803ff8
  8005ce:	e8 8d 01 00 00       	call   800760 <cprintf>
  8005d3:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005db:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e6:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	52                   	push   %edx
  8005f0:	50                   	push   %eax
  8005f1:	68 20 40 80 00       	push   $0x804020
  8005f6:	e8 65 01 00 00       	call   800760 <cprintf>
  8005fb:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800603:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800609:	a1 20 50 80 00       	mov    0x805020,%eax
  80060e:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800614:	a1 20 50 80 00       	mov    0x805020,%eax
  800619:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80061f:	51                   	push   %ecx
  800620:	52                   	push   %edx
  800621:	50                   	push   %eax
  800622:	68 48 40 80 00       	push   $0x804048
  800627:	e8 34 01 00 00       	call   800760 <cprintf>
  80062c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80062f:	a1 20 50 80 00       	mov    0x805020,%eax
  800634:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	50                   	push   %eax
  80063e:	68 a0 40 80 00       	push   $0x8040a0
  800643:	e8 18 01 00 00       	call   800760 <cprintf>
  800648:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	68 f8 3f 80 00       	push   $0x803ff8
  800653:	e8 08 01 00 00       	call   800760 <cprintf>
  800658:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80065b:	e8 54 14 00 00       	call   801ab4 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800660:	e8 19 00 00 00       	call   80067e <exit>
}
  800665:	90                   	nop
  800666:	c9                   	leave  
  800667:	c3                   	ret    

00800668 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
  80066b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80066e:	83 ec 0c             	sub    $0xc,%esp
  800671:	6a 00                	push   $0x0
  800673:	e8 6a 16 00 00       	call   801ce2 <sys_destroy_env>
  800678:	83 c4 10             	add    $0x10,%esp
}
  80067b:	90                   	nop
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <exit>:

void
exit(void)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800684:	e8 bf 16 00 00       	call   801d48 <sys_exit_env>
}
  800689:	90                   	nop
  80068a:	c9                   	leave  
  80068b:	c3                   	ret    

0080068c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80068c:	55                   	push   %ebp
  80068d:	89 e5                	mov    %esp,%ebp
  80068f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800692:	8b 45 0c             	mov    0xc(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	8d 48 01             	lea    0x1(%eax),%ecx
  80069a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069d:	89 0a                	mov    %ecx,(%edx)
  80069f:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a2:	88 d1                	mov    %dl,%cl
  8006a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b5:	75 2c                	jne    8006e3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006b7:	a0 28 50 80 00       	mov    0x805028,%al
  8006bc:	0f b6 c0             	movzbl %al,%eax
  8006bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c2:	8b 12                	mov    (%edx),%edx
  8006c4:	89 d1                	mov    %edx,%ecx
  8006c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c9:	83 c2 08             	add    $0x8,%edx
  8006cc:	83 ec 04             	sub    $0x4,%esp
  8006cf:	50                   	push   %eax
  8006d0:	51                   	push   %ecx
  8006d1:	52                   	push   %edx
  8006d2:	e8 81 13 00 00       	call   801a58 <sys_cputs>
  8006d7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e6:	8b 40 04             	mov    0x4(%eax),%eax
  8006e9:	8d 50 01             	lea    0x1(%eax),%edx
  8006ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ef:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f2:	90                   	nop
  8006f3:	c9                   	leave  
  8006f4:	c3                   	ret    

008006f5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800705:	00 00 00 
	b.cnt = 0;
  800708:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	ff 75 08             	pushl  0x8(%ebp)
  800718:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071e:	50                   	push   %eax
  80071f:	68 8c 06 80 00       	push   $0x80068c
  800724:	e8 11 02 00 00       	call   80093a <vprintfmt>
  800729:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80072c:	a0 28 50 80 00       	mov    0x805028,%al
  800731:	0f b6 c0             	movzbl %al,%eax
  800734:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	50                   	push   %eax
  80073e:	52                   	push   %edx
  80073f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800745:	83 c0 08             	add    $0x8,%eax
  800748:	50                   	push   %eax
  800749:	e8 0a 13 00 00       	call   801a58 <sys_cputs>
  80074e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800751:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800758:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80075e:	c9                   	leave  
  80075f:	c3                   	ret    

00800760 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800766:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  80076d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800770:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	ff 75 f4             	pushl  -0xc(%ebp)
  80077c:	50                   	push   %eax
  80077d:	e8 73 ff ff ff       	call   8006f5 <vcprintf>
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800788:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800793:	e8 02 13 00 00       	call   801a9a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800798:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a7:	50                   	push   %eax
  8007a8:	e8 48 ff ff ff       	call   8006f5 <vcprintf>
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007b3:	e8 fc 12 00 00       	call   801ab4 <sys_unlock_cons>
	return cnt;
  8007b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007bb:	c9                   	leave  
  8007bc:	c3                   	ret    

008007bd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	53                   	push   %ebx
  8007c1:	83 ec 14             	sub    $0x14,%esp
  8007c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8007d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007db:	77 55                	ja     800832 <printnum+0x75>
  8007dd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007e0:	72 05                	jb     8007e7 <printnum+0x2a>
  8007e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007e5:	77 4b                	ja     800832 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007ea:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f5:	52                   	push   %edx
  8007f6:	50                   	push   %eax
  8007f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8007fd:	e8 16 35 00 00       	call   803d18 <__udivdi3>
  800802:	83 c4 10             	add    $0x10,%esp
  800805:	83 ec 04             	sub    $0x4,%esp
  800808:	ff 75 20             	pushl  0x20(%ebp)
  80080b:	53                   	push   %ebx
  80080c:	ff 75 18             	pushl  0x18(%ebp)
  80080f:	52                   	push   %edx
  800810:	50                   	push   %eax
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 08             	pushl  0x8(%ebp)
  800817:	e8 a1 ff ff ff       	call   8007bd <printnum>
  80081c:	83 c4 20             	add    $0x20,%esp
  80081f:	eb 1a                	jmp    80083b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	ff 75 20             	pushl  0x20(%ebp)
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800832:	ff 4d 1c             	decl   0x1c(%ebp)
  800835:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800839:	7f e6                	jg     800821 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80083b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80083e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800849:	53                   	push   %ebx
  80084a:	51                   	push   %ecx
  80084b:	52                   	push   %edx
  80084c:	50                   	push   %eax
  80084d:	e8 d6 35 00 00       	call   803e28 <__umoddi3>
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	05 d4 42 80 00       	add    $0x8042d4,%eax
  80085a:	8a 00                	mov    (%eax),%al
  80085c:	0f be c0             	movsbl %al,%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
}
  80086e:	90                   	nop
  80086f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800872:	c9                   	leave  
  800873:	c3                   	ret    

00800874 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800877:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80087b:	7e 1c                	jle    800899 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	8d 50 08             	lea    0x8(%eax),%edx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	89 10                	mov    %edx,(%eax)
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	83 e8 08             	sub    $0x8,%eax
  800892:	8b 50 04             	mov    0x4(%eax),%edx
  800895:	8b 00                	mov    (%eax),%eax
  800897:	eb 40                	jmp    8008d9 <getuint+0x65>
	else if (lflag)
  800899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80089d:	74 1e                	je     8008bd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	8d 50 04             	lea    0x4(%eax),%edx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	89 10                	mov    %edx,(%eax)
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	83 e8 04             	sub    $0x4,%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bb:	eb 1c                	jmp    8008d9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	8d 50 04             	lea    0x4(%eax),%edx
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	89 10                	mov    %edx,(%eax)
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	83 e8 04             	sub    $0x4,%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008de:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008e2:	7e 1c                	jle    800900 <getint+0x25>
		return va_arg(*ap, long long);
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	8d 50 08             	lea    0x8(%eax),%edx
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	89 10                	mov    %edx,(%eax)
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	83 e8 08             	sub    $0x8,%eax
  8008f9:	8b 50 04             	mov    0x4(%eax),%edx
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	eb 38                	jmp    800938 <getint+0x5d>
	else if (lflag)
  800900:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800904:	74 1a                	je     800920 <getint+0x45>
		return va_arg(*ap, long);
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	8d 50 04             	lea    0x4(%eax),%edx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	89 10                	mov    %edx,(%eax)
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	83 e8 04             	sub    $0x4,%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	99                   	cltd   
  80091e:	eb 18                	jmp    800938 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	8d 50 04             	lea    0x4(%eax),%edx
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	89 10                	mov    %edx,(%eax)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	83 e8 04             	sub    $0x4,%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	99                   	cltd   
}
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	56                   	push   %esi
  80093e:	53                   	push   %ebx
  80093f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800942:	eb 17                	jmp    80095b <vprintfmt+0x21>
			if (ch == '\0')
  800944:	85 db                	test   %ebx,%ebx
  800946:	0f 84 c1 03 00 00    	je     800d0d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	53                   	push   %ebx
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	ff d0                	call   *%eax
  800958:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095b:	8b 45 10             	mov    0x10(%ebp),%eax
  80095e:	8d 50 01             	lea    0x1(%eax),%edx
  800961:	89 55 10             	mov    %edx,0x10(%ebp)
  800964:	8a 00                	mov    (%eax),%al
  800966:	0f b6 d8             	movzbl %al,%ebx
  800969:	83 fb 25             	cmp    $0x25,%ebx
  80096c:	75 d6                	jne    800944 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80096e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800972:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800979:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800980:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800987:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80098e:	8b 45 10             	mov    0x10(%ebp),%eax
  800991:	8d 50 01             	lea    0x1(%eax),%edx
  800994:	89 55 10             	mov    %edx,0x10(%ebp)
  800997:	8a 00                	mov    (%eax),%al
  800999:	0f b6 d8             	movzbl %al,%ebx
  80099c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80099f:	83 f8 5b             	cmp    $0x5b,%eax
  8009a2:	0f 87 3d 03 00 00    	ja     800ce5 <vprintfmt+0x3ab>
  8009a8:	8b 04 85 f8 42 80 00 	mov    0x8042f8(,%eax,4),%eax
  8009af:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009b1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009b5:	eb d7                	jmp    80098e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009bb:	eb d1                	jmp    80098e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c7:	89 d0                	mov    %edx,%eax
  8009c9:	c1 e0 02             	shl    $0x2,%eax
  8009cc:	01 d0                	add    %edx,%eax
  8009ce:	01 c0                	add    %eax,%eax
  8009d0:	01 d8                	add    %ebx,%eax
  8009d2:	83 e8 30             	sub    $0x30,%eax
  8009d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009db:	8a 00                	mov    (%eax),%al
  8009dd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009e0:	83 fb 2f             	cmp    $0x2f,%ebx
  8009e3:	7e 3e                	jle    800a23 <vprintfmt+0xe9>
  8009e5:	83 fb 39             	cmp    $0x39,%ebx
  8009e8:	7f 39                	jg     800a23 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ea:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ed:	eb d5                	jmp    8009c4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f2:	83 c0 04             	add    $0x4,%eax
  8009f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fb:	83 e8 04             	sub    $0x4,%eax
  8009fe:	8b 00                	mov    (%eax),%eax
  800a00:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a03:	eb 1f                	jmp    800a24 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a09:	79 83                	jns    80098e <vprintfmt+0x54>
				width = 0;
  800a0b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a12:	e9 77 ff ff ff       	jmp    80098e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a17:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a1e:	e9 6b ff ff ff       	jmp    80098e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a23:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a28:	0f 89 60 ff ff ff    	jns    80098e <vprintfmt+0x54>
				width = precision, precision = -1;
  800a2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a34:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a3b:	e9 4e ff ff ff       	jmp    80098e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a40:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a43:	e9 46 ff ff ff       	jmp    80098e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	83 c0 04             	add    $0x4,%eax
  800a4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a51:	8b 45 14             	mov    0x14(%ebp),%eax
  800a54:	83 e8 04             	sub    $0x4,%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	50                   	push   %eax
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	ff d0                	call   *%eax
  800a65:	83 c4 10             	add    $0x10,%esp
			break;
  800a68:	e9 9b 02 00 00       	jmp    800d08 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 c0 04             	add    $0x4,%eax
  800a73:	89 45 14             	mov    %eax,0x14(%ebp)
  800a76:	8b 45 14             	mov    0x14(%ebp),%eax
  800a79:	83 e8 04             	sub    $0x4,%eax
  800a7c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a7e:	85 db                	test   %ebx,%ebx
  800a80:	79 02                	jns    800a84 <vprintfmt+0x14a>
				err = -err;
  800a82:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a84:	83 fb 64             	cmp    $0x64,%ebx
  800a87:	7f 0b                	jg     800a94 <vprintfmt+0x15a>
  800a89:	8b 34 9d 40 41 80 00 	mov    0x804140(,%ebx,4),%esi
  800a90:	85 f6                	test   %esi,%esi
  800a92:	75 19                	jne    800aad <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a94:	53                   	push   %ebx
  800a95:	68 e5 42 80 00       	push   $0x8042e5
  800a9a:	ff 75 0c             	pushl  0xc(%ebp)
  800a9d:	ff 75 08             	pushl  0x8(%ebp)
  800aa0:	e8 70 02 00 00       	call   800d15 <printfmt>
  800aa5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa8:	e9 5b 02 00 00       	jmp    800d08 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aad:	56                   	push   %esi
  800aae:	68 ee 42 80 00       	push   $0x8042ee
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	ff 75 08             	pushl  0x8(%ebp)
  800ab9:	e8 57 02 00 00       	call   800d15 <printfmt>
  800abe:	83 c4 10             	add    $0x10,%esp
			break;
  800ac1:	e9 42 02 00 00       	jmp    800d08 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	83 c0 04             	add    $0x4,%eax
  800acc:	89 45 14             	mov    %eax,0x14(%ebp)
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	83 e8 04             	sub    $0x4,%eax
  800ad5:	8b 30                	mov    (%eax),%esi
  800ad7:	85 f6                	test   %esi,%esi
  800ad9:	75 05                	jne    800ae0 <vprintfmt+0x1a6>
				p = "(null)";
  800adb:	be f1 42 80 00       	mov    $0x8042f1,%esi
			if (width > 0 && padc != '-')
  800ae0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae4:	7e 6d                	jle    800b53 <vprintfmt+0x219>
  800ae6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aea:	74 67                	je     800b53 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	50                   	push   %eax
  800af3:	56                   	push   %esi
  800af4:	e8 1e 03 00 00       	call   800e17 <strnlen>
  800af9:	83 c4 10             	add    $0x10,%esp
  800afc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aff:	eb 16                	jmp    800b17 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b01:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	50                   	push   %eax
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	ff d0                	call   *%eax
  800b11:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b14:	ff 4d e4             	decl   -0x1c(%ebp)
  800b17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1b:	7f e4                	jg     800b01 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b1d:	eb 34                	jmp    800b53 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b23:	74 1c                	je     800b41 <vprintfmt+0x207>
  800b25:	83 fb 1f             	cmp    $0x1f,%ebx
  800b28:	7e 05                	jle    800b2f <vprintfmt+0x1f5>
  800b2a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b2d:	7e 12                	jle    800b41 <vprintfmt+0x207>
					putch('?', putdat);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	6a 3f                	push   $0x3f
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	ff d0                	call   *%eax
  800b3c:	83 c4 10             	add    $0x10,%esp
  800b3f:	eb 0f                	jmp    800b50 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	53                   	push   %ebx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b50:	ff 4d e4             	decl   -0x1c(%ebp)
  800b53:	89 f0                	mov    %esi,%eax
  800b55:	8d 70 01             	lea    0x1(%eax),%esi
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	0f be d8             	movsbl %al,%ebx
  800b5d:	85 db                	test   %ebx,%ebx
  800b5f:	74 24                	je     800b85 <vprintfmt+0x24b>
  800b61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b65:	78 b8                	js     800b1f <vprintfmt+0x1e5>
  800b67:	ff 4d e0             	decl   -0x20(%ebp)
  800b6a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b6e:	79 af                	jns    800b1f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b70:	eb 13                	jmp    800b85 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b72:	83 ec 08             	sub    $0x8,%esp
  800b75:	ff 75 0c             	pushl  0xc(%ebp)
  800b78:	6a 20                	push   $0x20
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	ff d0                	call   *%eax
  800b7f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b82:	ff 4d e4             	decl   -0x1c(%ebp)
  800b85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b89:	7f e7                	jg     800b72 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b8b:	e9 78 01 00 00       	jmp    800d08 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 e8             	pushl  -0x18(%ebp)
  800b96:	8d 45 14             	lea    0x14(%ebp),%eax
  800b99:	50                   	push   %eax
  800b9a:	e8 3c fd ff ff       	call   8008db <getint>
  800b9f:	83 c4 10             	add    $0x10,%esp
  800ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bae:	85 d2                	test   %edx,%edx
  800bb0:	79 23                	jns    800bd5 <vprintfmt+0x29b>
				putch('-', putdat);
  800bb2:	83 ec 08             	sub    $0x8,%esp
  800bb5:	ff 75 0c             	pushl  0xc(%ebp)
  800bb8:	6a 2d                	push   $0x2d
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc8:	f7 d8                	neg    %eax
  800bca:	83 d2 00             	adc    $0x0,%edx
  800bcd:	f7 da                	neg    %edx
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bd5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdc:	e9 bc 00 00 00       	jmp    800c9d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800be1:	83 ec 08             	sub    $0x8,%esp
  800be4:	ff 75 e8             	pushl  -0x18(%ebp)
  800be7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bea:	50                   	push   %eax
  800beb:	e8 84 fc ff ff       	call   800874 <getuint>
  800bf0:	83 c4 10             	add    $0x10,%esp
  800bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bf9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c00:	e9 98 00 00 00       	jmp    800c9d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	6a 58                	push   $0x58
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	ff d0                	call   *%eax
  800c12:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c15:	83 ec 08             	sub    $0x8,%esp
  800c18:	ff 75 0c             	pushl  0xc(%ebp)
  800c1b:	6a 58                	push   $0x58
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	ff d0                	call   *%eax
  800c22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c25:	83 ec 08             	sub    $0x8,%esp
  800c28:	ff 75 0c             	pushl  0xc(%ebp)
  800c2b:	6a 58                	push   $0x58
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	ff d0                	call   *%eax
  800c32:	83 c4 10             	add    $0x10,%esp
			break;
  800c35:	e9 ce 00 00 00       	jmp    800d08 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 30                	push   $0x30
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	6a 78                	push   $0x78
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	ff d0                	call   *%eax
  800c57:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5d:	83 c0 04             	add    $0x4,%eax
  800c60:	89 45 14             	mov    %eax,0x14(%ebp)
  800c63:	8b 45 14             	mov    0x14(%ebp),%eax
  800c66:	83 e8 04             	sub    $0x4,%eax
  800c69:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c7c:	eb 1f                	jmp    800c9d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 e8             	pushl  -0x18(%ebp)
  800c84:	8d 45 14             	lea    0x14(%ebp),%eax
  800c87:	50                   	push   %eax
  800c88:	e8 e7 fb ff ff       	call   800874 <getuint>
  800c8d:	83 c4 10             	add    $0x10,%esp
  800c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c93:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c96:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c9d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca4:	83 ec 04             	sub    $0x4,%esp
  800ca7:	52                   	push   %edx
  800ca8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cab:	50                   	push   %eax
  800cac:	ff 75 f4             	pushl  -0xc(%ebp)
  800caf:	ff 75 f0             	pushl  -0x10(%ebp)
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	ff 75 08             	pushl  0x8(%ebp)
  800cb8:	e8 00 fb ff ff       	call   8007bd <printnum>
  800cbd:	83 c4 20             	add    $0x20,%esp
			break;
  800cc0:	eb 46                	jmp    800d08 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cc2:	83 ec 08             	sub    $0x8,%esp
  800cc5:	ff 75 0c             	pushl  0xc(%ebp)
  800cc8:	53                   	push   %ebx
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	ff d0                	call   *%eax
  800cce:	83 c4 10             	add    $0x10,%esp
			break;
  800cd1:	eb 35                	jmp    800d08 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cd3:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800cda:	eb 2c                	jmp    800d08 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cdc:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800ce3:	eb 23                	jmp    800d08 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce5:	83 ec 08             	sub    $0x8,%esp
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	6a 25                	push   $0x25
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	ff d0                	call   *%eax
  800cf2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf5:	ff 4d 10             	decl   0x10(%ebp)
  800cf8:	eb 03                	jmp    800cfd <vprintfmt+0x3c3>
  800cfa:	ff 4d 10             	decl   0x10(%ebp)
  800cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800d00:	48                   	dec    %eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	3c 25                	cmp    $0x25,%al
  800d05:	75 f3                	jne    800cfa <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d07:	90                   	nop
		}
	}
  800d08:	e9 35 fc ff ff       	jmp    800942 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d0d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d1b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1e:	83 c0 04             	add    $0x4,%eax
  800d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	ff 75 f4             	pushl  -0xc(%ebp)
  800d2a:	50                   	push   %eax
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	ff 75 08             	pushl  0x8(%ebp)
  800d31:	e8 04 fc ff ff       	call   80093a <vprintfmt>
  800d36:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d39:	90                   	nop
  800d3a:	c9                   	leave  
  800d3b:	c3                   	ret    

00800d3c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	8b 40 08             	mov    0x8(%eax),%eax
  800d45:	8d 50 01             	lea    0x1(%eax),%edx
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8b 10                	mov    (%eax),%edx
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d56:	8b 40 04             	mov    0x4(%eax),%eax
  800d59:	39 c2                	cmp    %eax,%edx
  800d5b:	73 12                	jae    800d6f <sprintputch+0x33>
		*b->buf++ = ch;
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	8b 00                	mov    (%eax),%eax
  800d62:	8d 48 01             	lea    0x1(%eax),%ecx
  800d65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d68:	89 0a                	mov    %ecx,(%edx)
  800d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6d:	88 10                	mov    %dl,(%eax)
}
  800d6f:	90                   	nop
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    

00800d72 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	01 d0                	add    %edx,%eax
  800d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d97:	74 06                	je     800d9f <vsnprintf+0x2d>
  800d99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9d:	7f 07                	jg     800da6 <vsnprintf+0x34>
		return -E_INVAL;
  800d9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800da4:	eb 20                	jmp    800dc6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da6:	ff 75 14             	pushl  0x14(%ebp)
  800da9:	ff 75 10             	pushl  0x10(%ebp)
  800dac:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800daf:	50                   	push   %eax
  800db0:	68 3c 0d 80 00       	push   $0x800d3c
  800db5:	e8 80 fb ff ff       	call   80093a <vprintfmt>
  800dba:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dce:	8d 45 10             	lea    0x10(%ebp),%eax
  800dd1:	83 c0 04             	add    $0x4,%eax
  800dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dda:	ff 75 f4             	pushl  -0xc(%ebp)
  800ddd:	50                   	push   %eax
  800dde:	ff 75 0c             	pushl  0xc(%ebp)
  800de1:	ff 75 08             	pushl  0x8(%ebp)
  800de4:	e8 89 ff ff ff       	call   800d72 <vsnprintf>
  800de9:	83 c4 10             	add    $0x10,%esp
  800dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800def:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e01:	eb 06                	jmp    800e09 <strlen+0x15>
		n++;
  800e03:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e06:	ff 45 08             	incl   0x8(%ebp)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	84 c0                	test   %al,%al
  800e10:	75 f1                	jne    800e03 <strlen+0xf>
		n++;
	return n;
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e24:	eb 09                	jmp    800e2f <strnlen+0x18>
		n++;
  800e26:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	ff 4d 0c             	decl   0xc(%ebp)
  800e2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e33:	74 09                	je     800e3e <strnlen+0x27>
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8a 00                	mov    (%eax),%al
  800e3a:	84 c0                	test   %al,%al
  800e3c:	75 e8                	jne    800e26 <strnlen+0xf>
		n++;
	return n;
  800e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e4f:	90                   	nop
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8d 50 01             	lea    0x1(%eax),%edx
  800e56:	89 55 08             	mov    %edx,0x8(%ebp)
  800e59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e62:	8a 12                	mov    (%edx),%dl
  800e64:	88 10                	mov    %dl,(%eax)
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	84 c0                	test   %al,%al
  800e6a:	75 e4                	jne    800e50 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e84:	eb 1f                	jmp    800ea5 <strncpy+0x34>
		*dst++ = *src;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8d 50 01             	lea    0x1(%eax),%edx
  800e8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e92:	8a 12                	mov    (%edx),%dl
  800e94:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	84 c0                	test   %al,%al
  800e9d:	74 03                	je     800ea2 <strncpy+0x31>
			src++;
  800e9f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ea2:	ff 45 fc             	incl   -0x4(%ebp)
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eab:	72 d9                	jb     800e86 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eb0:	c9                   	leave  
  800eb1:	c3                   	ret    

00800eb2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ebe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec2:	74 30                	je     800ef4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ec4:	eb 16                	jmp    800edc <strlcpy+0x2a>
			*dst++ = *src++;
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8d 50 01             	lea    0x1(%eax),%edx
  800ecc:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed8:	8a 12                	mov    (%edx),%dl
  800eda:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800edc:	ff 4d 10             	decl   0x10(%ebp)
  800edf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee3:	74 09                	je     800eee <strlcpy+0x3c>
  800ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 d8                	jne    800ec6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efa:	29 c2                	sub    %eax,%edx
  800efc:	89 d0                	mov    %edx,%eax
}
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    

00800f00 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f03:	eb 06                	jmp    800f0b <strcmp+0xb>
		p++, q++;
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	84 c0                	test   %al,%al
  800f12:	74 0e                	je     800f22 <strcmp+0x22>
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 10                	mov    (%eax),%dl
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	38 c2                	cmp    %al,%dl
  800f20:	74 e3                	je     800f05 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	0f b6 d0             	movzbl %al,%edx
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	0f b6 c0             	movzbl %al,%eax
  800f32:	29 c2                	sub    %eax,%edx
  800f34:	89 d0                	mov    %edx,%eax
}
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f3b:	eb 09                	jmp    800f46 <strncmp+0xe>
		n--, p++, q++;
  800f3d:	ff 4d 10             	decl   0x10(%ebp)
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4a:	74 17                	je     800f63 <strncmp+0x2b>
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	84 c0                	test   %al,%al
  800f53:	74 0e                	je     800f63 <strncmp+0x2b>
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 10                	mov    (%eax),%dl
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	38 c2                	cmp    %al,%dl
  800f61:	74 da                	je     800f3d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f67:	75 07                	jne    800f70 <strncmp+0x38>
		return 0;
  800f69:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6e:	eb 14                	jmp    800f84 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	0f b6 d0             	movzbl %al,%edx
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	0f b6 c0             	movzbl %al,%eax
  800f80:	29 c2                	sub    %eax,%edx
  800f82:	89 d0                	mov    %edx,%eax
}
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f92:	eb 12                	jmp    800fa6 <strchr+0x20>
		if (*s == c)
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f9c:	75 05                	jne    800fa3 <strchr+0x1d>
			return (char *) s;
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	eb 11                	jmp    800fb4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa3:	ff 45 08             	incl   0x8(%ebp)
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	84 c0                	test   %al,%al
  800fad:	75 e5                	jne    800f94 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800faf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    

00800fb6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 04             	sub    $0x4,%esp
  800fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc2:	eb 0d                	jmp    800fd1 <strfind+0x1b>
		if (*s == c)
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fcc:	74 0e                	je     800fdc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fce:	ff 45 08             	incl   0x8(%ebp)
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	84 c0                	test   %al,%al
  800fd8:	75 ea                	jne    800fc4 <strfind+0xe>
  800fda:	eb 01                	jmp    800fdd <strfind+0x27>
		if (*s == c)
			break;
  800fdc:	90                   	nop
	return (char *) s;
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe0:	c9                   	leave  
  800fe1:	c3                   	ret    

00800fe2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ff4:	eb 0e                	jmp    801004 <memset+0x22>
		*p++ = c;
  800ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff9:	8d 50 01             	lea    0x1(%eax),%edx
  800ffc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801002:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801004:	ff 4d f8             	decl   -0x8(%ebp)
  801007:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80100b:	79 e9                	jns    800ff6 <memset+0x14>
		*p++ = c;

	return v;
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801010:	c9                   	leave  
  801011:	c3                   	ret    

00801012 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801024:	eb 16                	jmp    80103c <memcpy+0x2a>
		*d++ = *s++;
  801026:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801029:	8d 50 01             	lea    0x1(%eax),%edx
  80102c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801032:	8d 4a 01             	lea    0x1(%edx),%ecx
  801035:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801038:	8a 12                	mov    (%edx),%dl
  80103a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80103c:	8b 45 10             	mov    0x10(%ebp),%eax
  80103f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801042:	89 55 10             	mov    %edx,0x10(%ebp)
  801045:	85 c0                	test   %eax,%eax
  801047:	75 dd                	jne    801026 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104c:	c9                   	leave  
  80104d:	c3                   	ret    

0080104e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801060:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801063:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801066:	73 50                	jae    8010b8 <memmove+0x6a>
  801068:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80106b:	8b 45 10             	mov    0x10(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801073:	76 43                	jbe    8010b8 <memmove+0x6a>
		s += n;
  801075:	8b 45 10             	mov    0x10(%ebp),%eax
  801078:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80107b:	8b 45 10             	mov    0x10(%ebp),%eax
  80107e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801081:	eb 10                	jmp    801093 <memmove+0x45>
			*--d = *--s;
  801083:	ff 4d f8             	decl   -0x8(%ebp)
  801086:	ff 4d fc             	decl   -0x4(%ebp)
  801089:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108c:	8a 10                	mov    (%eax),%dl
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	8d 50 ff             	lea    -0x1(%eax),%edx
  801099:	89 55 10             	mov    %edx,0x10(%ebp)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 e3                	jne    801083 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010a0:	eb 23                	jmp    8010c5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a5:	8d 50 01             	lea    0x1(%eax),%edx
  8010a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b4:	8a 12                	mov    (%edx),%dl
  8010b6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010be:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	75 dd                	jne    8010a2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010dc:	eb 2a                	jmp    801108 <memcmp+0x3e>
		if (*s1 != *s2)
  8010de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e1:	8a 10                	mov    (%eax),%dl
  8010e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	38 c2                	cmp    %al,%dl
  8010ea:	74 16                	je     801102 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	0f b6 d0             	movzbl %al,%edx
  8010f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	0f b6 c0             	movzbl %al,%eax
  8010fc:	29 c2                	sub    %eax,%edx
  8010fe:	89 d0                	mov    %edx,%eax
  801100:	eb 18                	jmp    80111a <memcmp+0x50>
		s1++, s2++;
  801102:	ff 45 fc             	incl   -0x4(%ebp)
  801105:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801108:	8b 45 10             	mov    0x10(%ebp),%eax
  80110b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110e:	89 55 10             	mov    %edx,0x10(%ebp)
  801111:	85 c0                	test   %eax,%eax
  801113:	75 c9                	jne    8010de <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801122:	8b 55 08             	mov    0x8(%ebp),%edx
  801125:	8b 45 10             	mov    0x10(%ebp),%eax
  801128:	01 d0                	add    %edx,%eax
  80112a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80112d:	eb 15                	jmp    801144 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	0f b6 d0             	movzbl %al,%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	0f b6 c0             	movzbl %al,%eax
  80113d:	39 c2                	cmp    %eax,%edx
  80113f:	74 0d                	je     80114e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801141:	ff 45 08             	incl   0x8(%ebp)
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80114a:	72 e3                	jb     80112f <memfind+0x13>
  80114c:	eb 01                	jmp    80114f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80114e:	90                   	nop
	return (void *) s;
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    

00801154 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80115a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801161:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801168:	eb 03                	jmp    80116d <strtol+0x19>
		s++;
  80116a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 20                	cmp    $0x20,%al
  801174:	74 f4                	je     80116a <strtol+0x16>
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 09                	cmp    $0x9,%al
  80117d:	74 eb                	je     80116a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 2b                	cmp    $0x2b,%al
  801186:	75 05                	jne    80118d <strtol+0x39>
		s++;
  801188:	ff 45 08             	incl   0x8(%ebp)
  80118b:	eb 13                	jmp    8011a0 <strtol+0x4c>
	else if (*s == '-')
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 2d                	cmp    $0x2d,%al
  801194:	75 0a                	jne    8011a0 <strtol+0x4c>
		s++, neg = 1;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a4:	74 06                	je     8011ac <strtol+0x58>
  8011a6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011aa:	75 20                	jne    8011cc <strtol+0x78>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	3c 30                	cmp    $0x30,%al
  8011b3:	75 17                	jne    8011cc <strtol+0x78>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	40                   	inc    %eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	3c 78                	cmp    $0x78,%al
  8011bd:	75 0d                	jne    8011cc <strtol+0x78>
		s += 2, base = 16;
  8011bf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011ca:	eb 28                	jmp    8011f4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d0:	75 15                	jne    8011e7 <strtol+0x93>
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	3c 30                	cmp    $0x30,%al
  8011d9:	75 0c                	jne    8011e7 <strtol+0x93>
		s++, base = 8;
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011e5:	eb 0d                	jmp    8011f4 <strtol+0xa0>
	else if (base == 0)
  8011e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011eb:	75 07                	jne    8011f4 <strtol+0xa0>
		base = 10;
  8011ed:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3c 2f                	cmp    $0x2f,%al
  8011fb:	7e 19                	jle    801216 <strtol+0xc2>
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3c 39                	cmp    $0x39,%al
  801204:	7f 10                	jg     801216 <strtol+0xc2>
			dig = *s - '0';
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	0f be c0             	movsbl %al,%eax
  80120e:	83 e8 30             	sub    $0x30,%eax
  801211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801214:	eb 42                	jmp    801258 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	3c 60                	cmp    $0x60,%al
  80121d:	7e 19                	jle    801238 <strtol+0xe4>
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 7a                	cmp    $0x7a,%al
  801226:	7f 10                	jg     801238 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	0f be c0             	movsbl %al,%eax
  801230:	83 e8 57             	sub    $0x57,%eax
  801233:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801236:	eb 20                	jmp    801258 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	3c 40                	cmp    $0x40,%al
  80123f:	7e 39                	jle    80127a <strtol+0x126>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	3c 5a                	cmp    $0x5a,%al
  801248:	7f 30                	jg     80127a <strtol+0x126>
			dig = *s - 'A' + 10;
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	0f be c0             	movsbl %al,%eax
  801252:	83 e8 37             	sub    $0x37,%eax
  801255:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80125e:	7d 19                	jge    801279 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801260:	ff 45 08             	incl   0x8(%ebp)
  801263:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801266:	0f af 45 10          	imul   0x10(%ebp),%eax
  80126a:	89 c2                	mov    %eax,%edx
  80126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126f:	01 d0                	add    %edx,%eax
  801271:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801274:	e9 7b ff ff ff       	jmp    8011f4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801279:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80127a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127e:	74 08                	je     801288 <strtol+0x134>
		*endptr = (char *) s;
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	8b 55 08             	mov    0x8(%ebp),%edx
  801286:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801288:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80128c:	74 07                	je     801295 <strtol+0x141>
  80128e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801291:	f7 d8                	neg    %eax
  801293:	eb 03                	jmp    801298 <strtol+0x144>
  801295:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <ltostr>:

void
ltostr(long value, char *str)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b2:	79 13                	jns    8012c7 <ltostr+0x2d>
	{
		neg = 1;
  8012b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012c1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012c4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012cf:	99                   	cltd   
  8012d0:	f7 f9                	idiv   %ecx
  8012d2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d8:	8d 50 01             	lea    0x1(%eax),%edx
  8012db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012de:	89 c2                	mov    %eax,%edx
  8012e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e3:	01 d0                	add    %edx,%eax
  8012e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012e8:	83 c2 30             	add    $0x30,%edx
  8012eb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f5:	f7 e9                	imul   %ecx
  8012f7:	c1 fa 02             	sar    $0x2,%edx
  8012fa:	89 c8                	mov    %ecx,%eax
  8012fc:	c1 f8 1f             	sar    $0x1f,%eax
  8012ff:	29 c2                	sub    %eax,%edx
  801301:	89 d0                	mov    %edx,%eax
  801303:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801306:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80130a:	75 bb                	jne    8012c7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80130c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801313:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801316:	48                   	dec    %eax
  801317:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80131a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80131e:	74 3d                	je     80135d <ltostr+0xc3>
		start = 1 ;
  801320:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801327:	eb 34                	jmp    80135d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	01 d0                	add    %edx,%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	01 c2                	add    %eax,%edx
  80133e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 c8                	add    %ecx,%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80134a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80134d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801350:	01 c2                	add    %eax,%edx
  801352:	8a 45 eb             	mov    -0x15(%ebp),%al
  801355:	88 02                	mov    %al,(%edx)
		start++ ;
  801357:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80135a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801360:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801363:	7c c4                	jl     801329 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801365:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	01 d0                	add    %edx,%eax
  80136d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801370:	90                   	nop
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	e8 73 fa ff ff       	call   800df4 <strlen>
  801381:	83 c4 04             	add    $0x4,%esp
  801384:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801387:	ff 75 0c             	pushl  0xc(%ebp)
  80138a:	e8 65 fa ff ff       	call   800df4 <strlen>
  80138f:	83 c4 04             	add    $0x4,%esp
  801392:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801395:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80139c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a3:	eb 17                	jmp    8013bc <strcconcat+0x49>
		final[s] = str1[s] ;
  8013a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ab:	01 c2                	add    %eax,%edx
  8013ad:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	01 c8                	add    %ecx,%eax
  8013b5:	8a 00                	mov    (%eax),%al
  8013b7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013b9:	ff 45 fc             	incl   -0x4(%ebp)
  8013bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013c2:	7c e1                	jl     8013a5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013d2:	eb 1f                	jmp    8013f3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d7:	8d 50 01             	lea    0x1(%eax),%edx
  8013da:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013dd:	89 c2                	mov    %eax,%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ea:	01 c8                	add    %ecx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f0:	ff 45 f8             	incl   -0x8(%ebp)
  8013f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f9:	7c d9                	jl     8013d4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801401:	01 d0                	add    %edx,%eax
  801403:	c6 00 00             	movb   $0x0,(%eax)
}
  801406:	90                   	nop
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80140c:	8b 45 14             	mov    0x14(%ebp),%eax
  80140f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801415:	8b 45 14             	mov    0x14(%ebp),%eax
  801418:	8b 00                	mov    (%eax),%eax
  80141a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801421:	8b 45 10             	mov    0x10(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80142c:	eb 0c                	jmp    80143a <strsplit+0x31>
			*string++ = 0;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8d 50 01             	lea    0x1(%eax),%edx
  801434:	89 55 08             	mov    %edx,0x8(%ebp)
  801437:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	8a 00                	mov    (%eax),%al
  80143f:	84 c0                	test   %al,%al
  801441:	74 18                	je     80145b <strsplit+0x52>
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	0f be c0             	movsbl %al,%eax
  80144b:	50                   	push   %eax
  80144c:	ff 75 0c             	pushl  0xc(%ebp)
  80144f:	e8 32 fb ff ff       	call   800f86 <strchr>
  801454:	83 c4 08             	add    $0x8,%esp
  801457:	85 c0                	test   %eax,%eax
  801459:	75 d3                	jne    80142e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	84 c0                	test   %al,%al
  801462:	74 5a                	je     8014be <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801464:	8b 45 14             	mov    0x14(%ebp),%eax
  801467:	8b 00                	mov    (%eax),%eax
  801469:	83 f8 0f             	cmp    $0xf,%eax
  80146c:	75 07                	jne    801475 <strsplit+0x6c>
		{
			return 0;
  80146e:	b8 00 00 00 00       	mov    $0x0,%eax
  801473:	eb 66                	jmp    8014db <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801475:	8b 45 14             	mov    0x14(%ebp),%eax
  801478:	8b 00                	mov    (%eax),%eax
  80147a:	8d 48 01             	lea    0x1(%eax),%ecx
  80147d:	8b 55 14             	mov    0x14(%ebp),%edx
  801480:	89 0a                	mov    %ecx,(%edx)
  801482:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801489:	8b 45 10             	mov    0x10(%ebp),%eax
  80148c:	01 c2                	add    %eax,%edx
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801493:	eb 03                	jmp    801498 <strsplit+0x8f>
			string++;
  801495:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	84 c0                	test   %al,%al
  80149f:	74 8b                	je     80142c <strsplit+0x23>
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f be c0             	movsbl %al,%eax
  8014a9:	50                   	push   %eax
  8014aa:	ff 75 0c             	pushl  0xc(%ebp)
  8014ad:	e8 d4 fa ff ff       	call   800f86 <strchr>
  8014b2:	83 c4 08             	add    $0x8,%esp
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	74 dc                	je     801495 <strsplit+0x8c>
			string++;
	}
  8014b9:	e9 6e ff ff ff       	jmp    80142c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014be:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c2:	8b 00                	mov    (%eax),%eax
  8014c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ce:	01 d0                	add    %edx,%eax
  8014d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	68 68 44 80 00       	push   $0x804468
  8014eb:	68 3f 01 00 00       	push   $0x13f
  8014f0:	68 8a 44 80 00       	push   $0x80448a
  8014f5:	e8 35 26 00 00       	call   803b2f <_panic>

008014fa <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801500:	83 ec 0c             	sub    $0xc,%esp
  801503:	ff 75 08             	pushl  0x8(%ebp)
  801506:	e8 f8 0a 00 00       	call   802003 <sys_sbrk>
  80150b:	83 c4 10             	add    $0x10,%esp
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801516:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151a:	75 0a                	jne    801526 <malloc+0x16>
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
  801521:	e9 07 02 00 00       	jmp    80172d <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801526:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80152d:	8b 55 08             	mov    0x8(%ebp),%edx
  801530:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801533:	01 d0                	add    %edx,%eax
  801535:	48                   	dec    %eax
  801536:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801539:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80153c:	ba 00 00 00 00       	mov    $0x0,%edx
  801541:	f7 75 dc             	divl   -0x24(%ebp)
  801544:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801547:	29 d0                	sub    %edx,%eax
  801549:	c1 e8 0c             	shr    $0xc,%eax
  80154c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80154f:	a1 20 50 80 00       	mov    0x805020,%eax
  801554:	8b 40 78             	mov    0x78(%eax),%eax
  801557:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80155c:	29 c2                	sub    %eax,%edx
  80155e:	89 d0                	mov    %edx,%eax
  801560:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801563:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801566:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80156b:	c1 e8 0c             	shr    $0xc,%eax
  80156e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801578:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80157f:	77 42                	ja     8015c3 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801581:	e8 01 09 00 00       	call   801e87 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801586:	85 c0                	test   %eax,%eax
  801588:	74 16                	je     8015a0 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  80158a:	83 ec 0c             	sub    $0xc,%esp
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 41 0e 00 00       	call   8023d6 <alloc_block_FF>
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159b:	e9 8a 01 00 00       	jmp    80172a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8015a0:	e8 13 09 00 00       	call   801eb8 <sys_isUHeapPlacementStrategyBESTFIT>
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	0f 84 7d 01 00 00    	je     80172a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8015ad:	83 ec 0c             	sub    $0xc,%esp
  8015b0:	ff 75 08             	pushl  0x8(%ebp)
  8015b3:	e8 da 12 00 00       	call   802892 <alloc_block_BF>
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015be:	e9 67 01 00 00       	jmp    80172a <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8015c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8015c6:	48                   	dec    %eax
  8015c7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8015ca:	0f 86 53 01 00 00    	jbe    801723 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8015d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8015d5:	8b 40 78             	mov    0x78(%eax),%eax
  8015d8:	05 00 10 00 00       	add    $0x1000,%eax
  8015dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8015e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8015e7:	e9 de 00 00 00       	jmp    8016ca <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8015ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8015f1:	8b 40 78             	mov    0x78(%eax),%eax
  8015f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f7:	29 c2                	sub    %eax,%edx
  8015f9:	89 d0                	mov    %edx,%eax
  8015fb:	2d 00 10 00 00       	sub    $0x1000,%eax
  801600:	c1 e8 0c             	shr    $0xc,%eax
  801603:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80160a:	85 c0                	test   %eax,%eax
  80160c:	0f 85 ab 00 00 00    	jne    8016bd <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	05 00 10 00 00       	add    $0x1000,%eax
  80161a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80161d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  801624:	eb 47                	jmp    80166d <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801626:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80162d:	76 0a                	jbe    801639 <malloc+0x129>
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
  801634:	e9 f4 00 00 00       	jmp    80172d <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801639:	a1 20 50 80 00       	mov    0x805020,%eax
  80163e:	8b 40 78             	mov    0x78(%eax),%eax
  801641:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801644:	29 c2                	sub    %eax,%edx
  801646:	89 d0                	mov    %edx,%eax
  801648:	2d 00 10 00 00       	sub    $0x1000,%eax
  80164d:	c1 e8 0c             	shr    $0xc,%eax
  801650:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801657:	85 c0                	test   %eax,%eax
  801659:	74 08                	je     801663 <malloc+0x153>
					{
						
						i = j;
  80165b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801661:	eb 5a                	jmp    8016bd <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801663:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80166a:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  80166d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801670:	48                   	dec    %eax
  801671:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801674:	77 b0                	ja     801626 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801676:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  80167d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801684:	eb 2f                	jmp    8016b5 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801686:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801689:	c1 e0 0c             	shl    $0xc,%eax
  80168c:	89 c2                	mov    %eax,%edx
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	01 c2                	add    %eax,%edx
  801693:	a1 20 50 80 00       	mov    0x805020,%eax
  801698:	8b 40 78             	mov    0x78(%eax),%eax
  80169b:	29 c2                	sub    %eax,%edx
  80169d:	89 d0                	mov    %edx,%eax
  80169f:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016a4:	c1 e8 0c             	shr    $0xc,%eax
  8016a7:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  8016ae:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8016b2:	ff 45 e0             	incl   -0x20(%ebp)
  8016b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8016bb:	72 c9                	jb     801686 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  8016bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016c1:	75 16                	jne    8016d9 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8016c3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8016ca:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8016d1:	0f 86 15 ff ff ff    	jbe    8015ec <malloc+0xdc>
  8016d7:	eb 01                	jmp    8016da <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  8016d9:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8016da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016de:	75 07                	jne    8016e7 <malloc+0x1d7>
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e5:	eb 46                	jmp    80172d <malloc+0x21d>
		ptr = (void*)i;
  8016e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8016ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8016f2:	8b 40 78             	mov    0x78(%eax),%eax
  8016f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f8:	29 c2                	sub    %eax,%edx
  8016fa:	89 d0                	mov    %edx,%eax
  8016fc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801701:	c1 e8 0c             	shr    $0xc,%eax
  801704:	89 c2                	mov    %eax,%edx
  801706:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801709:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	ff 75 08             	pushl  0x8(%ebp)
  801716:	ff 75 f0             	pushl  -0x10(%ebp)
  801719:	e8 1c 09 00 00       	call   80203a <sys_allocate_user_mem>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	eb 07                	jmp    80172a <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801723:	b8 00 00 00 00       	mov    $0x0,%eax
  801728:	eb 03                	jmp    80172d <malloc+0x21d>
	}
	return ptr;
  80172a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801735:	a1 20 50 80 00       	mov    0x805020,%eax
  80173a:	8b 40 78             	mov    0x78(%eax),%eax
  80173d:	05 00 10 00 00       	add    $0x1000,%eax
  801742:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801745:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80174c:	a1 20 50 80 00       	mov    0x805020,%eax
  801751:	8b 50 78             	mov    0x78(%eax),%edx
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	39 c2                	cmp    %eax,%edx
  801759:	76 24                	jbe    80177f <free+0x50>
		size = get_block_size(va);
  80175b:	83 ec 0c             	sub    $0xc,%esp
  80175e:	ff 75 08             	pushl  0x8(%ebp)
  801761:	e8 f0 08 00 00       	call   802056 <get_block_size>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	e8 00 1b 00 00       	call   803277 <free_block>
  801777:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80177a:	e9 ac 00 00 00       	jmp    80182b <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801785:	0f 82 89 00 00 00    	jb     801814 <free+0xe5>
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801793:	77 7f                	ja     801814 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801795:	8b 55 08             	mov    0x8(%ebp),%edx
  801798:	a1 20 50 80 00       	mov    0x805020,%eax
  80179d:	8b 40 78             	mov    0x78(%eax),%eax
  8017a0:	29 c2                	sub    %eax,%edx
  8017a2:	89 d0                	mov    %edx,%eax
  8017a4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017a9:	c1 e8 0c             	shr    $0xc,%eax
  8017ac:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  8017b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8017b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b9:	c1 e0 0c             	shl    $0xc,%eax
  8017bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8017bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8017c6:	eb 42                	jmp    80180a <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cb:	c1 e0 0c             	shl    $0xc,%eax
  8017ce:	89 c2                	mov    %eax,%edx
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	01 c2                	add    %eax,%edx
  8017d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8017da:	8b 40 78             	mov    0x78(%eax),%eax
  8017dd:	29 c2                	sub    %eax,%edx
  8017df:	89 d0                	mov    %edx,%eax
  8017e1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017e6:	c1 e8 0c             	shr    $0xc,%eax
  8017e9:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  8017f0:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8017f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	83 ec 08             	sub    $0x8,%esp
  8017fd:	52                   	push   %edx
  8017fe:	50                   	push   %eax
  8017ff:	e8 1a 08 00 00       	call   80201e <sys_free_user_mem>
  801804:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801807:	ff 45 f4             	incl   -0xc(%ebp)
  80180a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801810:	72 b6                	jb     8017c8 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801812:	eb 17                	jmp    80182b <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 98 44 80 00       	push   $0x804498
  80181c:	68 87 00 00 00       	push   $0x87
  801821:	68 c2 44 80 00       	push   $0x8044c2
  801826:	e8 04 23 00 00       	call   803b2f <_panic>
	}
}
  80182b:	90                   	nop
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 28             	sub    $0x28,%esp
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80183a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80183e:	75 0a                	jne    80184a <smalloc+0x1c>
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	e9 87 00 00 00       	jmp    8018d1 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80184a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801850:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801857:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185d:	39 d0                	cmp    %edx,%eax
  80185f:	73 02                	jae    801863 <smalloc+0x35>
  801861:	89 d0                	mov    %edx,%eax
  801863:	83 ec 0c             	sub    $0xc,%esp
  801866:	50                   	push   %eax
  801867:	e8 a4 fc ff ff       	call   801510 <malloc>
  80186c:	83 c4 10             	add    $0x10,%esp
  80186f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801872:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801876:	75 07                	jne    80187f <smalloc+0x51>
  801878:	b8 00 00 00 00       	mov    $0x0,%eax
  80187d:	eb 52                	jmp    8018d1 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80187f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801883:	ff 75 ec             	pushl  -0x14(%ebp)
  801886:	50                   	push   %eax
  801887:	ff 75 0c             	pushl  0xc(%ebp)
  80188a:	ff 75 08             	pushl  0x8(%ebp)
  80188d:	e8 93 03 00 00       	call   801c25 <sys_createSharedObject>
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801898:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80189c:	74 06                	je     8018a4 <smalloc+0x76>
  80189e:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8018a2:	75 07                	jne    8018ab <smalloc+0x7d>
  8018a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a9:	eb 26                	jmp    8018d1 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8018ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8018b3:	8b 40 78             	mov    0x78(%eax),%eax
  8018b6:	29 c2                	sub    %eax,%edx
  8018b8:	89 d0                	mov    %edx,%eax
  8018ba:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018bf:	c1 e8 0c             	shr    $0xc,%eax
  8018c2:	89 c2                	mov    %eax,%edx
  8018c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c7:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8018ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	e8 68 03 00 00       	call   801c4f <sys_getSizeOfSharedObject>
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8018ed:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018f1:	75 07                	jne    8018fa <sget+0x27>
  8018f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f8:	eb 7f                	jmp    801979 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8018fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801900:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801907:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80190a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190d:	39 d0                	cmp    %edx,%eax
  80190f:	73 02                	jae    801913 <sget+0x40>
  801911:	89 d0                	mov    %edx,%eax
  801913:	83 ec 0c             	sub    $0xc,%esp
  801916:	50                   	push   %eax
  801917:	e8 f4 fb ff ff       	call   801510 <malloc>
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801922:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801926:	75 07                	jne    80192f <sget+0x5c>
  801928:	b8 00 00 00 00       	mov    $0x0,%eax
  80192d:	eb 4a                	jmp    801979 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	ff 75 e8             	pushl  -0x18(%ebp)
  801935:	ff 75 0c             	pushl  0xc(%ebp)
  801938:	ff 75 08             	pushl  0x8(%ebp)
  80193b:	e8 2c 03 00 00       	call   801c6c <sys_getSharedObject>
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801946:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801949:	a1 20 50 80 00       	mov    0x805020,%eax
  80194e:	8b 40 78             	mov    0x78(%eax),%eax
  801951:	29 c2                	sub    %eax,%edx
  801953:	89 d0                	mov    %edx,%eax
  801955:	2d 00 10 00 00       	sub    $0x1000,%eax
  80195a:	c1 e8 0c             	shr    $0xc,%eax
  80195d:	89 c2                	mov    %eax,%edx
  80195f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801962:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801969:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80196d:	75 07                	jne    801976 <sget+0xa3>
  80196f:	b8 00 00 00 00       	mov    $0x0,%eax
  801974:	eb 03                	jmp    801979 <sget+0xa6>
	return ptr;
  801976:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801981:	8b 55 08             	mov    0x8(%ebp),%edx
  801984:	a1 20 50 80 00       	mov    0x805020,%eax
  801989:	8b 40 78             	mov    0x78(%eax),%eax
  80198c:	29 c2                	sub    %eax,%edx
  80198e:	89 d0                	mov    %edx,%eax
  801990:	2d 00 10 00 00       	sub    $0x1000,%eax
  801995:	c1 e8 0c             	shr    $0xc,%eax
  801998:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80199f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	ff 75 08             	pushl  0x8(%ebp)
  8019a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ab:	e8 db 02 00 00       	call   801c8b <sys_freeSharedObject>
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8019b6:	90                   	nop
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	68 d0 44 80 00       	push   $0x8044d0
  8019c7:	68 e4 00 00 00       	push   $0xe4
  8019cc:	68 c2 44 80 00       	push   $0x8044c2
  8019d1:	e8 59 21 00 00       	call   803b2f <_panic>

008019d6 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019dc:	83 ec 04             	sub    $0x4,%esp
  8019df:	68 f6 44 80 00       	push   $0x8044f6
  8019e4:	68 f0 00 00 00       	push   $0xf0
  8019e9:	68 c2 44 80 00       	push   $0x8044c2
  8019ee:	e8 3c 21 00 00       	call   803b2f <_panic>

008019f3 <shrink>:

}
void shrink(uint32 newSize)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019f9:	83 ec 04             	sub    $0x4,%esp
  8019fc:	68 f6 44 80 00       	push   $0x8044f6
  801a01:	68 f5 00 00 00       	push   $0xf5
  801a06:	68 c2 44 80 00       	push   $0x8044c2
  801a0b:	e8 1f 21 00 00       	call   803b2f <_panic>

00801a10 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	68 f6 44 80 00       	push   $0x8044f6
  801a1e:	68 fa 00 00 00       	push   $0xfa
  801a23:	68 c2 44 80 00       	push   $0x8044c2
  801a28:	e8 02 21 00 00       	call   803b2f <_panic>

00801a2d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	57                   	push   %edi
  801a31:	56                   	push   %esi
  801a32:	53                   	push   %ebx
  801a33:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a42:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a45:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a48:	cd 30                	int    $0x30
  801a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a50:	83 c4 10             	add    $0x10,%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5f                   	pop    %edi
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    

00801a58 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a64:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	52                   	push   %edx
  801a70:	ff 75 0c             	pushl  0xc(%ebp)
  801a73:	50                   	push   %eax
  801a74:	6a 00                	push   $0x0
  801a76:	e8 b2 ff ff ff       	call   801a2d <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	90                   	nop
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 02                	push   $0x2
  801a90:	e8 98 ff ff ff       	call   801a2d <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 03                	push   $0x3
  801aa9:	e8 7f ff ff ff       	call   801a2d <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	90                   	nop
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 04                	push   $0x4
  801ac3:	e8 65 ff ff ff       	call   801a2d <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	90                   	nop
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	52                   	push   %edx
  801ade:	50                   	push   %eax
  801adf:	6a 08                	push   $0x8
  801ae1:	e8 47 ff ff ff       	call   801a2d <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801af0:	8b 75 18             	mov    0x18(%ebp),%esi
  801af3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	56                   	push   %esi
  801b00:	53                   	push   %ebx
  801b01:	51                   	push   %ecx
  801b02:	52                   	push   %edx
  801b03:	50                   	push   %eax
  801b04:	6a 09                	push   $0x9
  801b06:	e8 22 ff ff ff       	call   801a2d <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5d                   	pop    %ebp
  801b14:	c3                   	ret    

00801b15 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	50                   	push   %eax
  801b26:	6a 0a                	push   $0xa
  801b28:	e8 00 ff ff ff       	call   801a2d <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	ff 75 08             	pushl  0x8(%ebp)
  801b41:	6a 0b                	push   $0xb
  801b43:	e8 e5 fe ff ff       	call   801a2d <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 0c                	push   $0xc
  801b5c:	e8 cc fe ff ff       	call   801a2d <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 0d                	push   $0xd
  801b75:	e8 b3 fe ff ff       	call   801a2d <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 0e                	push   $0xe
  801b8e:	e8 9a fe ff ff       	call   801a2d <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 0f                	push   $0xf
  801ba7:	e8 81 fe ff ff       	call   801a2d <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	ff 75 08             	pushl  0x8(%ebp)
  801bbf:	6a 10                	push   $0x10
  801bc1:	e8 67 fe ff ff       	call   801a2d <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 11                	push   $0x11
  801bda:	e8 4e fe ff ff       	call   801a2d <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	90                   	nop
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_cputc>:

void
sys_cputc(const char c)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 04             	sub    $0x4,%esp
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bf1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	50                   	push   %eax
  801bfe:	6a 01                	push   $0x1
  801c00:	e8 28 fe ff ff       	call   801a2d <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	90                   	nop
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 14                	push   $0x14
  801c1a:	e8 0e fe ff ff       	call   801a2d <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	90                   	nop
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c31:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c34:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	51                   	push   %ecx
  801c3e:	52                   	push   %edx
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	50                   	push   %eax
  801c43:	6a 15                	push   $0x15
  801c45:	e8 e3 fd ff ff       	call   801a2d <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	52                   	push   %edx
  801c5f:	50                   	push   %eax
  801c60:	6a 16                	push   $0x16
  801c62:	e8 c6 fd ff ff       	call   801a2d <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	51                   	push   %ecx
  801c7d:	52                   	push   %edx
  801c7e:	50                   	push   %eax
  801c7f:	6a 17                	push   $0x17
  801c81:	e8 a7 fd ff ff       	call   801a2d <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	52                   	push   %edx
  801c9b:	50                   	push   %eax
  801c9c:	6a 18                	push   $0x18
  801c9e:	e8 8a fd ff ff       	call   801a2d <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	ff 75 14             	pushl  0x14(%ebp)
  801cb3:	ff 75 10             	pushl  0x10(%ebp)
  801cb6:	ff 75 0c             	pushl  0xc(%ebp)
  801cb9:	50                   	push   %eax
  801cba:	6a 19                	push   $0x19
  801cbc:	e8 6c fd ff ff       	call   801a2d <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	50                   	push   %eax
  801cd5:	6a 1a                	push   $0x1a
  801cd7:	e8 51 fd ff ff       	call   801a2d <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	90                   	nop
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	50                   	push   %eax
  801cf1:	6a 1b                	push   $0x1b
  801cf3:	e8 35 fd ff ff       	call   801a2d <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 05                	push   $0x5
  801d0c:	e8 1c fd ff ff       	call   801a2d <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 06                	push   $0x6
  801d25:	e8 03 fd ff ff       	call   801a2d <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 07                	push   $0x7
  801d3e:	e8 ea fc ff ff       	call   801a2d <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_exit_env>:


void sys_exit_env(void)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 1c                	push   $0x1c
  801d57:	e8 d1 fc ff ff       	call   801a2d <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	90                   	nop
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d68:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d6b:	8d 50 04             	lea    0x4(%eax),%edx
  801d6e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	52                   	push   %edx
  801d78:	50                   	push   %eax
  801d79:	6a 1d                	push   $0x1d
  801d7b:	e8 ad fc ff ff       	call   801a2d <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return result;
  801d83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d8c:	89 01                	mov    %eax,(%ecx)
  801d8e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	c9                   	leave  
  801d95:	c2 04 00             	ret    $0x4

00801d98 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	ff 75 10             	pushl  0x10(%ebp)
  801da2:	ff 75 0c             	pushl  0xc(%ebp)
  801da5:	ff 75 08             	pushl  0x8(%ebp)
  801da8:	6a 13                	push   $0x13
  801daa:	e8 7e fc ff ff       	call   801a2d <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
	return ;
  801db2:	90                   	nop
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 1e                	push   $0x1e
  801dc4:	e8 64 fc ff ff       	call   801a2d <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 04             	sub    $0x4,%esp
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dda:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	50                   	push   %eax
  801de7:	6a 1f                	push   $0x1f
  801de9:	e8 3f fc ff ff       	call   801a2d <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
	return ;
  801df1:	90                   	nop
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <rsttst>:
void rsttst()
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 21                	push   $0x21
  801e03:	e8 25 fc ff ff       	call   801a2d <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0b:	90                   	nop
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	8b 45 14             	mov    0x14(%ebp),%eax
  801e17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e1a:	8b 55 18             	mov    0x18(%ebp),%edx
  801e1d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e21:	52                   	push   %edx
  801e22:	50                   	push   %eax
  801e23:	ff 75 10             	pushl  0x10(%ebp)
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	ff 75 08             	pushl  0x8(%ebp)
  801e2c:	6a 20                	push   $0x20
  801e2e:	e8 fa fb ff ff       	call   801a2d <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
	return ;
  801e36:	90                   	nop
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <chktst>:
void chktst(uint32 n)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	ff 75 08             	pushl  0x8(%ebp)
  801e47:	6a 22                	push   $0x22
  801e49:	e8 df fb ff ff       	call   801a2d <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e51:	90                   	nop
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <inctst>:

void inctst()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 23                	push   $0x23
  801e63:	e8 c5 fb ff ff       	call   801a2d <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6b:	90                   	nop
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <gettst>:
uint32 gettst()
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 24                	push   $0x24
  801e7d:	e8 ab fb ff ff       	call   801a2d <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 25                	push   $0x25
  801e99:	e8 8f fb ff ff       	call   801a2d <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
  801ea1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ea4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ea8:	75 07                	jne    801eb1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801eaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801eaf:	eb 05                	jmp    801eb6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 25                	push   $0x25
  801eca:	e8 5e fb ff ff       	call   801a2d <syscall>
  801ecf:	83 c4 18             	add    $0x18,%esp
  801ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ed5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ed9:	75 07                	jne    801ee2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801edb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee0:	eb 05                	jmp    801ee7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 25                	push   $0x25
  801efb:	e8 2d fb ff ff       	call   801a2d <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
  801f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f06:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f0a:	75 07                	jne    801f13 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f11:	eb 05                	jmp    801f18 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 25                	push   $0x25
  801f2c:	e8 fc fa ff ff       	call   801a2d <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
  801f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f37:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f3b:	75 07                	jne    801f44 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f42:	eb 05                	jmp    801f49 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	ff 75 08             	pushl  0x8(%ebp)
  801f59:	6a 26                	push   $0x26
  801f5b:	e8 cd fa ff ff       	call   801a2d <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
	return ;
  801f63:	90                   	nop
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f6a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	6a 00                	push   $0x0
  801f78:	53                   	push   %ebx
  801f79:	51                   	push   %ecx
  801f7a:	52                   	push   %edx
  801f7b:	50                   	push   %eax
  801f7c:	6a 27                	push   $0x27
  801f7e:	e8 aa fa ff ff       	call   801a2d <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	52                   	push   %edx
  801f9b:	50                   	push   %eax
  801f9c:	6a 28                	push   $0x28
  801f9e:	e8 8a fa ff ff       	call   801a2d <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	6a 00                	push   $0x0
  801fb6:	51                   	push   %ecx
  801fb7:	ff 75 10             	pushl  0x10(%ebp)
  801fba:	52                   	push   %edx
  801fbb:	50                   	push   %eax
  801fbc:	6a 29                	push   $0x29
  801fbe:	e8 6a fa ff ff       	call   801a2d <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	ff 75 10             	pushl  0x10(%ebp)
  801fd2:	ff 75 0c             	pushl  0xc(%ebp)
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	6a 12                	push   $0x12
  801fda:	e8 4e fa ff ff       	call   801a2d <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe2:	90                   	nop
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	52                   	push   %edx
  801ff5:	50                   	push   %eax
  801ff6:	6a 2a                	push   $0x2a
  801ff8:	e8 30 fa ff ff       	call   801a2d <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
	return;
  802000:	90                   	nop
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	50                   	push   %eax
  802012:	6a 2b                	push   $0x2b
  802014:	e8 14 fa ff ff       	call   801a2d <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	ff 75 0c             	pushl  0xc(%ebp)
  80202a:	ff 75 08             	pushl  0x8(%ebp)
  80202d:	6a 2c                	push   $0x2c
  80202f:	e8 f9 f9 ff ff       	call   801a2d <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
	return;
  802037:	90                   	nop
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	ff 75 0c             	pushl  0xc(%ebp)
  802046:	ff 75 08             	pushl  0x8(%ebp)
  802049:	6a 2d                	push   $0x2d
  80204b:	e8 dd f9 ff ff       	call   801a2d <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
	return;
  802053:	90                   	nop
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	83 e8 04             	sub    $0x4,%eax
  802062:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802065:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802068:	8b 00                	mov    (%eax),%eax
  80206a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	83 e8 04             	sub    $0x4,%eax
  80207b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80207e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802081:	8b 00                	mov    (%eax),%eax
  802083:	83 e0 01             	and    $0x1,%eax
  802086:	85 c0                	test   %eax,%eax
  802088:	0f 94 c0             	sete   %al
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802093:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80209a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209d:	83 f8 02             	cmp    $0x2,%eax
  8020a0:	74 2b                	je     8020cd <alloc_block+0x40>
  8020a2:	83 f8 02             	cmp    $0x2,%eax
  8020a5:	7f 07                	jg     8020ae <alloc_block+0x21>
  8020a7:	83 f8 01             	cmp    $0x1,%eax
  8020aa:	74 0e                	je     8020ba <alloc_block+0x2d>
  8020ac:	eb 58                	jmp    802106 <alloc_block+0x79>
  8020ae:	83 f8 03             	cmp    $0x3,%eax
  8020b1:	74 2d                	je     8020e0 <alloc_block+0x53>
  8020b3:	83 f8 04             	cmp    $0x4,%eax
  8020b6:	74 3b                	je     8020f3 <alloc_block+0x66>
  8020b8:	eb 4c                	jmp    802106 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020ba:	83 ec 0c             	sub    $0xc,%esp
  8020bd:	ff 75 08             	pushl  0x8(%ebp)
  8020c0:	e8 11 03 00 00       	call   8023d6 <alloc_block_FF>
  8020c5:	83 c4 10             	add    $0x10,%esp
  8020c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020cb:	eb 4a                	jmp    802117 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020cd:	83 ec 0c             	sub    $0xc,%esp
  8020d0:	ff 75 08             	pushl  0x8(%ebp)
  8020d3:	e8 c7 19 00 00       	call   803a9f <alloc_block_NF>
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020de:	eb 37                	jmp    802117 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020e0:	83 ec 0c             	sub    $0xc,%esp
  8020e3:	ff 75 08             	pushl  0x8(%ebp)
  8020e6:	e8 a7 07 00 00       	call   802892 <alloc_block_BF>
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f1:	eb 24                	jmp    802117 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020f3:	83 ec 0c             	sub    $0xc,%esp
  8020f6:	ff 75 08             	pushl  0x8(%ebp)
  8020f9:	e8 84 19 00 00       	call   803a82 <alloc_block_WF>
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802104:	eb 11                	jmp    802117 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	68 08 45 80 00       	push   $0x804508
  80210e:	e8 4d e6 ff ff       	call   800760 <cprintf>
  802113:	83 c4 10             	add    $0x10,%esp
		break;
  802116:	90                   	nop
	}
	return va;
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	53                   	push   %ebx
  802120:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	68 28 45 80 00       	push   $0x804528
  80212b:	e8 30 e6 ff ff       	call   800760 <cprintf>
  802130:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802133:	83 ec 0c             	sub    $0xc,%esp
  802136:	68 53 45 80 00       	push   $0x804553
  80213b:	e8 20 e6 ff ff       	call   800760 <cprintf>
  802140:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802149:	eb 37                	jmp    802182 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	ff 75 f4             	pushl  -0xc(%ebp)
  802151:	e8 19 ff ff ff       	call   80206f <is_free_block>
  802156:	83 c4 10             	add    $0x10,%esp
  802159:	0f be d8             	movsbl %al,%ebx
  80215c:	83 ec 0c             	sub    $0xc,%esp
  80215f:	ff 75 f4             	pushl  -0xc(%ebp)
  802162:	e8 ef fe ff ff       	call   802056 <get_block_size>
  802167:	83 c4 10             	add    $0x10,%esp
  80216a:	83 ec 04             	sub    $0x4,%esp
  80216d:	53                   	push   %ebx
  80216e:	50                   	push   %eax
  80216f:	68 6b 45 80 00       	push   $0x80456b
  802174:	e8 e7 e5 ff ff       	call   800760 <cprintf>
  802179:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80217c:	8b 45 10             	mov    0x10(%ebp),%eax
  80217f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802182:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802186:	74 07                	je     80218f <print_blocks_list+0x73>
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	8b 00                	mov    (%eax),%eax
  80218d:	eb 05                	jmp    802194 <print_blocks_list+0x78>
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
  802194:	89 45 10             	mov    %eax,0x10(%ebp)
  802197:	8b 45 10             	mov    0x10(%ebp),%eax
  80219a:	85 c0                	test   %eax,%eax
  80219c:	75 ad                	jne    80214b <print_blocks_list+0x2f>
  80219e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a2:	75 a7                	jne    80214b <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021a4:	83 ec 0c             	sub    $0xc,%esp
  8021a7:	68 28 45 80 00       	push   $0x804528
  8021ac:	e8 af e5 ff ff       	call   800760 <cprintf>
  8021b1:	83 c4 10             	add    $0x10,%esp

}
  8021b4:	90                   	nop
  8021b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c3:	83 e0 01             	and    $0x1,%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	74 03                	je     8021cd <initialize_dynamic_allocator+0x13>
  8021ca:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021d1:	0f 84 c7 01 00 00    	je     80239e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021d7:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8021de:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8021e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e7:	01 d0                	add    %edx,%eax
  8021e9:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8021ee:	0f 87 ad 01 00 00    	ja     8023a1 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	0f 89 a5 01 00 00    	jns    8023a4 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8021ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802202:	8b 45 0c             	mov    0xc(%ebp),%eax
  802205:	01 d0                	add    %edx,%eax
  802207:	83 e8 04             	sub    $0x4,%eax
  80220a:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80220f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802216:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80221b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221e:	e9 87 00 00 00       	jmp    8022aa <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802227:	75 14                	jne    80223d <initialize_dynamic_allocator+0x83>
  802229:	83 ec 04             	sub    $0x4,%esp
  80222c:	68 83 45 80 00       	push   $0x804583
  802231:	6a 79                	push   $0x79
  802233:	68 a1 45 80 00       	push   $0x8045a1
  802238:	e8 f2 18 00 00       	call   803b2f <_panic>
  80223d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802240:	8b 00                	mov    (%eax),%eax
  802242:	85 c0                	test   %eax,%eax
  802244:	74 10                	je     802256 <initialize_dynamic_allocator+0x9c>
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	8b 00                	mov    (%eax),%eax
  80224b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224e:	8b 52 04             	mov    0x4(%edx),%edx
  802251:	89 50 04             	mov    %edx,0x4(%eax)
  802254:	eb 0b                	jmp    802261 <initialize_dynamic_allocator+0xa7>
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	8b 40 04             	mov    0x4(%eax),%eax
  80225c:	a3 30 50 80 00       	mov    %eax,0x805030
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	8b 40 04             	mov    0x4(%eax),%eax
  802267:	85 c0                	test   %eax,%eax
  802269:	74 0f                	je     80227a <initialize_dynamic_allocator+0xc0>
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 40 04             	mov    0x4(%eax),%eax
  802271:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802274:	8b 12                	mov    (%edx),%edx
  802276:	89 10                	mov    %edx,(%eax)
  802278:	eb 0a                	jmp    802284 <initialize_dynamic_allocator+0xca>
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	8b 00                	mov    (%eax),%eax
  80227f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802297:	a1 38 50 80 00       	mov    0x805038,%eax
  80229c:	48                   	dec    %eax
  80229d:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8022a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ae:	74 07                	je     8022b7 <initialize_dynamic_allocator+0xfd>
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 00                	mov    (%eax),%eax
  8022b5:	eb 05                	jmp    8022bc <initialize_dynamic_allocator+0x102>
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	a3 34 50 80 00       	mov    %eax,0x805034
  8022c1:	a1 34 50 80 00       	mov    0x805034,%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	0f 85 55 ff ff ff    	jne    802223 <initialize_dynamic_allocator+0x69>
  8022ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d2:	0f 85 4b ff ff ff    	jne    802223 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8022e7:	a1 44 50 80 00       	mov    0x805044,%eax
  8022ec:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8022f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8022f6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	83 c0 08             	add    $0x8,%eax
  802302:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	83 c0 04             	add    $0x4,%eax
  80230b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230e:	83 ea 08             	sub    $0x8,%edx
  802311:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802313:	8b 55 0c             	mov    0xc(%ebp),%edx
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	01 d0                	add    %edx,%eax
  80231b:	83 e8 08             	sub    $0x8,%eax
  80231e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802321:	83 ea 08             	sub    $0x8,%edx
  802324:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802329:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80232f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802332:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802339:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80233d:	75 17                	jne    802356 <initialize_dynamic_allocator+0x19c>
  80233f:	83 ec 04             	sub    $0x4,%esp
  802342:	68 bc 45 80 00       	push   $0x8045bc
  802347:	68 90 00 00 00       	push   $0x90
  80234c:	68 a1 45 80 00       	push   $0x8045a1
  802351:	e8 d9 17 00 00       	call   803b2f <_panic>
  802356:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80235c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235f:	89 10                	mov    %edx,(%eax)
  802361:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802364:	8b 00                	mov    (%eax),%eax
  802366:	85 c0                	test   %eax,%eax
  802368:	74 0d                	je     802377 <initialize_dynamic_allocator+0x1bd>
  80236a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80236f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802372:	89 50 04             	mov    %edx,0x4(%eax)
  802375:	eb 08                	jmp    80237f <initialize_dynamic_allocator+0x1c5>
  802377:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237a:	a3 30 50 80 00       	mov    %eax,0x805030
  80237f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802382:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802387:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802391:	a1 38 50 80 00       	mov    0x805038,%eax
  802396:	40                   	inc    %eax
  802397:	a3 38 50 80 00       	mov    %eax,0x805038
  80239c:	eb 07                	jmp    8023a5 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80239e:	90                   	nop
  80239f:	eb 04                	jmp    8023a5 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023a1:	90                   	nop
  8023a2:	eb 01                	jmp    8023a5 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023a4:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ad:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b9:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	83 e8 04             	sub    $0x4,%eax
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	83 e0 fe             	and    $0xfffffffe,%eax
  8023c6:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	01 c2                	add    %eax,%edx
  8023ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d1:	89 02                	mov    %eax,(%edx)
}
  8023d3:	90                   	nop
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    

008023d6 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	83 e0 01             	and    $0x1,%eax
  8023e2:	85 c0                	test   %eax,%eax
  8023e4:	74 03                	je     8023e9 <alloc_block_FF+0x13>
  8023e6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8023e9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8023ed:	77 07                	ja     8023f6 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8023ef:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8023f6:	a1 24 50 80 00       	mov    0x805024,%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	75 73                	jne    802472 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	83 c0 10             	add    $0x10,%eax
  802405:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802408:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80240f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802412:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802415:	01 d0                	add    %edx,%eax
  802417:	48                   	dec    %eax
  802418:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80241b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80241e:	ba 00 00 00 00       	mov    $0x0,%edx
  802423:	f7 75 ec             	divl   -0x14(%ebp)
  802426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802429:	29 d0                	sub    %edx,%eax
  80242b:	c1 e8 0c             	shr    $0xc,%eax
  80242e:	83 ec 0c             	sub    $0xc,%esp
  802431:	50                   	push   %eax
  802432:	e8 c3 f0 ff ff       	call   8014fa <sbrk>
  802437:	83 c4 10             	add    $0x10,%esp
  80243a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80243d:	83 ec 0c             	sub    $0xc,%esp
  802440:	6a 00                	push   $0x0
  802442:	e8 b3 f0 ff ff       	call   8014fa <sbrk>
  802447:	83 c4 10             	add    $0x10,%esp
  80244a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80244d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802450:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802453:	83 ec 08             	sub    $0x8,%esp
  802456:	50                   	push   %eax
  802457:	ff 75 e4             	pushl  -0x1c(%ebp)
  80245a:	e8 5b fd ff ff       	call   8021ba <initialize_dynamic_allocator>
  80245f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802462:	83 ec 0c             	sub    $0xc,%esp
  802465:	68 df 45 80 00       	push   $0x8045df
  80246a:	e8 f1 e2 ff ff       	call   800760 <cprintf>
  80246f:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802472:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802476:	75 0a                	jne    802482 <alloc_block_FF+0xac>
	        return NULL;
  802478:	b8 00 00 00 00       	mov    $0x0,%eax
  80247d:	e9 0e 04 00 00       	jmp    802890 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802489:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80248e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802491:	e9 f3 02 00 00       	jmp    802789 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80249c:	83 ec 0c             	sub    $0xc,%esp
  80249f:	ff 75 bc             	pushl  -0x44(%ebp)
  8024a2:	e8 af fb ff ff       	call   802056 <get_block_size>
  8024a7:	83 c4 10             	add    $0x10,%esp
  8024aa:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	83 c0 08             	add    $0x8,%eax
  8024b3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024b6:	0f 87 c5 02 00 00    	ja     802781 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	83 c0 18             	add    $0x18,%eax
  8024c2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024c5:	0f 87 19 02 00 00    	ja     8026e4 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8024d1:	83 e8 08             	sub    $0x8,%eax
  8024d4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	8d 50 08             	lea    0x8(%eax),%edx
  8024dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024e0:	01 d0                	add    %edx,%eax
  8024e2:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	83 c0 08             	add    $0x8,%eax
  8024eb:	83 ec 04             	sub    $0x4,%esp
  8024ee:	6a 01                	push   $0x1
  8024f0:	50                   	push   %eax
  8024f1:	ff 75 bc             	pushl  -0x44(%ebp)
  8024f4:	e8 ae fe ff ff       	call   8023a7 <set_block_data>
  8024f9:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	8b 40 04             	mov    0x4(%eax),%eax
  802502:	85 c0                	test   %eax,%eax
  802504:	75 68                	jne    80256e <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802506:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80250a:	75 17                	jne    802523 <alloc_block_FF+0x14d>
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	68 bc 45 80 00       	push   $0x8045bc
  802514:	68 d7 00 00 00       	push   $0xd7
  802519:	68 a1 45 80 00       	push   $0x8045a1
  80251e:	e8 0c 16 00 00       	call   803b2f <_panic>
  802523:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802529:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252c:	89 10                	mov    %edx,(%eax)
  80252e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802531:	8b 00                	mov    (%eax),%eax
  802533:	85 c0                	test   %eax,%eax
  802535:	74 0d                	je     802544 <alloc_block_FF+0x16e>
  802537:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80253c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80253f:	89 50 04             	mov    %edx,0x4(%eax)
  802542:	eb 08                	jmp    80254c <alloc_block_FF+0x176>
  802544:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802547:	a3 30 50 80 00       	mov    %eax,0x805030
  80254c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802554:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802557:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255e:	a1 38 50 80 00       	mov    0x805038,%eax
  802563:	40                   	inc    %eax
  802564:	a3 38 50 80 00       	mov    %eax,0x805038
  802569:	e9 dc 00 00 00       	jmp    80264a <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 00                	mov    (%eax),%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	75 65                	jne    8025dc <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802577:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80257b:	75 17                	jne    802594 <alloc_block_FF+0x1be>
  80257d:	83 ec 04             	sub    $0x4,%esp
  802580:	68 f0 45 80 00       	push   $0x8045f0
  802585:	68 db 00 00 00       	push   $0xdb
  80258a:	68 a1 45 80 00       	push   $0x8045a1
  80258f:	e8 9b 15 00 00       	call   803b2f <_panic>
  802594:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80259a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80259d:	89 50 04             	mov    %edx,0x4(%eax)
  8025a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	74 0c                	je     8025b6 <alloc_block_FF+0x1e0>
  8025aa:	a1 30 50 80 00       	mov    0x805030,%eax
  8025af:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025b2:	89 10                	mov    %edx,(%eax)
  8025b4:	eb 08                	jmp    8025be <alloc_block_FF+0x1e8>
  8025b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8025d4:	40                   	inc    %eax
  8025d5:	a3 38 50 80 00       	mov    %eax,0x805038
  8025da:	eb 6e                	jmp    80264a <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8025dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e0:	74 06                	je     8025e8 <alloc_block_FF+0x212>
  8025e2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025e6:	75 17                	jne    8025ff <alloc_block_FF+0x229>
  8025e8:	83 ec 04             	sub    $0x4,%esp
  8025eb:	68 14 46 80 00       	push   $0x804614
  8025f0:	68 df 00 00 00       	push   $0xdf
  8025f5:	68 a1 45 80 00       	push   $0x8045a1
  8025fa:	e8 30 15 00 00       	call   803b2f <_panic>
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 10                	mov    (%eax),%edx
  802604:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802607:	89 10                	mov    %edx,(%eax)
  802609:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260c:	8b 00                	mov    (%eax),%eax
  80260e:	85 c0                	test   %eax,%eax
  802610:	74 0b                	je     80261d <alloc_block_FF+0x247>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80261a:	89 50 04             	mov    %edx,0x4(%eax)
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802623:	89 10                	mov    %edx,(%eax)
  802625:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262b:	89 50 04             	mov    %edx,0x4(%eax)
  80262e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	75 08                	jne    80263f <alloc_block_FF+0x269>
  802637:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80263a:	a3 30 50 80 00       	mov    %eax,0x805030
  80263f:	a1 38 50 80 00       	mov    0x805038,%eax
  802644:	40                   	inc    %eax
  802645:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80264a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264e:	75 17                	jne    802667 <alloc_block_FF+0x291>
  802650:	83 ec 04             	sub    $0x4,%esp
  802653:	68 83 45 80 00       	push   $0x804583
  802658:	68 e1 00 00 00       	push   $0xe1
  80265d:	68 a1 45 80 00       	push   $0x8045a1
  802662:	e8 c8 14 00 00       	call   803b2f <_panic>
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	74 10                	je     802680 <alloc_block_FF+0x2aa>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802678:	8b 52 04             	mov    0x4(%edx),%edx
  80267b:	89 50 04             	mov    %edx,0x4(%eax)
  80267e:	eb 0b                	jmp    80268b <alloc_block_FF+0x2b5>
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 40 04             	mov    0x4(%eax),%eax
  802686:	a3 30 50 80 00       	mov    %eax,0x805030
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 40 04             	mov    0x4(%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 0f                	je     8026a4 <alloc_block_FF+0x2ce>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 40 04             	mov    0x4(%eax),%eax
  80269b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269e:	8b 12                	mov    (%edx),%edx
  8026a0:	89 10                	mov    %edx,(%eax)
  8026a2:	eb 0a                	jmp    8026ae <alloc_block_FF+0x2d8>
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8026c6:	48                   	dec    %eax
  8026c7:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	6a 00                	push   $0x0
  8026d1:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026d4:	ff 75 b0             	pushl  -0x50(%ebp)
  8026d7:	e8 cb fc ff ff       	call   8023a7 <set_block_data>
  8026dc:	83 c4 10             	add    $0x10,%esp
  8026df:	e9 95 00 00 00       	jmp    802779 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	6a 01                	push   $0x1
  8026e9:	ff 75 b8             	pushl  -0x48(%ebp)
  8026ec:	ff 75 bc             	pushl  -0x44(%ebp)
  8026ef:	e8 b3 fc ff ff       	call   8023a7 <set_block_data>
  8026f4:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8026f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fb:	75 17                	jne    802714 <alloc_block_FF+0x33e>
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	68 83 45 80 00       	push   $0x804583
  802705:	68 e8 00 00 00       	push   $0xe8
  80270a:	68 a1 45 80 00       	push   $0x8045a1
  80270f:	e8 1b 14 00 00       	call   803b2f <_panic>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	85 c0                	test   %eax,%eax
  80271b:	74 10                	je     80272d <alloc_block_FF+0x357>
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	8b 00                	mov    (%eax),%eax
  802722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802725:	8b 52 04             	mov    0x4(%edx),%edx
  802728:	89 50 04             	mov    %edx,0x4(%eax)
  80272b:	eb 0b                	jmp    802738 <alloc_block_FF+0x362>
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 40 04             	mov    0x4(%eax),%eax
  802733:	a3 30 50 80 00       	mov    %eax,0x805030
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 40 04             	mov    0x4(%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	74 0f                	je     802751 <alloc_block_FF+0x37b>
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 04             	mov    0x4(%eax),%eax
  802748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274b:	8b 12                	mov    (%edx),%edx
  80274d:	89 10                	mov    %edx,(%eax)
  80274f:	eb 0a                	jmp    80275b <alloc_block_FF+0x385>
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276e:	a1 38 50 80 00       	mov    0x805038,%eax
  802773:	48                   	dec    %eax
  802774:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802779:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80277c:	e9 0f 01 00 00       	jmp    802890 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802781:	a1 34 50 80 00       	mov    0x805034,%eax
  802786:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802789:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278d:	74 07                	je     802796 <alloc_block_FF+0x3c0>
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 00                	mov    (%eax),%eax
  802794:	eb 05                	jmp    80279b <alloc_block_FF+0x3c5>
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
  80279b:	a3 34 50 80 00       	mov    %eax,0x805034
  8027a0:	a1 34 50 80 00       	mov    0x805034,%eax
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	0f 85 e9 fc ff ff    	jne    802496 <alloc_block_FF+0xc0>
  8027ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b1:	0f 85 df fc ff ff    	jne    802496 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	83 c0 08             	add    $0x8,%eax
  8027bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027c0:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027cd:	01 d0                	add    %edx,%eax
  8027cf:	48                   	dec    %eax
  8027d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8027db:	f7 75 d8             	divl   -0x28(%ebp)
  8027de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027e1:	29 d0                	sub    %edx,%eax
  8027e3:	c1 e8 0c             	shr    $0xc,%eax
  8027e6:	83 ec 0c             	sub    $0xc,%esp
  8027e9:	50                   	push   %eax
  8027ea:	e8 0b ed ff ff       	call   8014fa <sbrk>
  8027ef:	83 c4 10             	add    $0x10,%esp
  8027f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8027f5:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027f9:	75 0a                	jne    802805 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8027fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802800:	e9 8b 00 00 00       	jmp    802890 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802805:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80280c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80280f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802812:	01 d0                	add    %edx,%eax
  802814:	48                   	dec    %eax
  802815:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802818:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80281b:	ba 00 00 00 00       	mov    $0x0,%edx
  802820:	f7 75 cc             	divl   -0x34(%ebp)
  802823:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802826:	29 d0                	sub    %edx,%eax
  802828:	8d 50 fc             	lea    -0x4(%eax),%edx
  80282b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80282e:	01 d0                	add    %edx,%eax
  802830:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802835:	a1 40 50 80 00       	mov    0x805040,%eax
  80283a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802840:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802847:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80284a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80284d:	01 d0                	add    %edx,%eax
  80284f:	48                   	dec    %eax
  802850:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802853:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802856:	ba 00 00 00 00       	mov    $0x0,%edx
  80285b:	f7 75 c4             	divl   -0x3c(%ebp)
  80285e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802861:	29 d0                	sub    %edx,%eax
  802863:	83 ec 04             	sub    $0x4,%esp
  802866:	6a 01                	push   $0x1
  802868:	50                   	push   %eax
  802869:	ff 75 d0             	pushl  -0x30(%ebp)
  80286c:	e8 36 fb ff ff       	call   8023a7 <set_block_data>
  802871:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802874:	83 ec 0c             	sub    $0xc,%esp
  802877:	ff 75 d0             	pushl  -0x30(%ebp)
  80287a:	e8 f8 09 00 00       	call   803277 <free_block>
  80287f:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802882:	83 ec 0c             	sub    $0xc,%esp
  802885:	ff 75 08             	pushl  0x8(%ebp)
  802888:	e8 49 fb ff ff       	call   8023d6 <alloc_block_FF>
  80288d:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802890:	c9                   	leave  
  802891:	c3                   	ret    

00802892 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	83 e0 01             	and    $0x1,%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	74 03                	je     8028a5 <alloc_block_BF+0x13>
  8028a2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028a5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028a9:	77 07                	ja     8028b2 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028ab:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	75 73                	jne    80292e <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	83 c0 10             	add    $0x10,%eax
  8028c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028c4:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d1:	01 d0                	add    %edx,%eax
  8028d3:	48                   	dec    %eax
  8028d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028da:	ba 00 00 00 00       	mov    $0x0,%edx
  8028df:	f7 75 e0             	divl   -0x20(%ebp)
  8028e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028e5:	29 d0                	sub    %edx,%eax
  8028e7:	c1 e8 0c             	shr    $0xc,%eax
  8028ea:	83 ec 0c             	sub    $0xc,%esp
  8028ed:	50                   	push   %eax
  8028ee:	e8 07 ec ff ff       	call   8014fa <sbrk>
  8028f3:	83 c4 10             	add    $0x10,%esp
  8028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028f9:	83 ec 0c             	sub    $0xc,%esp
  8028fc:	6a 00                	push   $0x0
  8028fe:	e8 f7 eb ff ff       	call   8014fa <sbrk>
  802903:	83 c4 10             	add    $0x10,%esp
  802906:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802909:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80290c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80290f:	83 ec 08             	sub    $0x8,%esp
  802912:	50                   	push   %eax
  802913:	ff 75 d8             	pushl  -0x28(%ebp)
  802916:	e8 9f f8 ff ff       	call   8021ba <initialize_dynamic_allocator>
  80291b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80291e:	83 ec 0c             	sub    $0xc,%esp
  802921:	68 df 45 80 00       	push   $0x8045df
  802926:	e8 35 de ff ff       	call   800760 <cprintf>
  80292b:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80292e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802935:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80293c:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802943:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80294a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80294f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802952:	e9 1d 01 00 00       	jmp    802a74 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80295d:	83 ec 0c             	sub    $0xc,%esp
  802960:	ff 75 a8             	pushl  -0x58(%ebp)
  802963:	e8 ee f6 ff ff       	call   802056 <get_block_size>
  802968:	83 c4 10             	add    $0x10,%esp
  80296b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	83 c0 08             	add    $0x8,%eax
  802974:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802977:	0f 87 ef 00 00 00    	ja     802a6c <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	83 c0 18             	add    $0x18,%eax
  802983:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802986:	77 1d                	ja     8029a5 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802988:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80298e:	0f 86 d8 00 00 00    	jbe    802a6c <alloc_block_BF+0x1da>
				{
					best_va = va;
  802994:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802997:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80299a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80299d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029a0:	e9 c7 00 00 00       	jmp    802a6c <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	83 c0 08             	add    $0x8,%eax
  8029ab:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029ae:	0f 85 9d 00 00 00    	jne    802a51 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029b4:	83 ec 04             	sub    $0x4,%esp
  8029b7:	6a 01                	push   $0x1
  8029b9:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029bc:	ff 75 a8             	pushl  -0x58(%ebp)
  8029bf:	e8 e3 f9 ff ff       	call   8023a7 <set_block_data>
  8029c4:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cb:	75 17                	jne    8029e4 <alloc_block_BF+0x152>
  8029cd:	83 ec 04             	sub    $0x4,%esp
  8029d0:	68 83 45 80 00       	push   $0x804583
  8029d5:	68 2c 01 00 00       	push   $0x12c
  8029da:	68 a1 45 80 00       	push   $0x8045a1
  8029df:	e8 4b 11 00 00       	call   803b2f <_panic>
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 10                	je     8029fd <alloc_block_BF+0x16b>
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f5:	8b 52 04             	mov    0x4(%edx),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	eb 0b                	jmp    802a08 <alloc_block_BF+0x176>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	a3 30 50 80 00       	mov    %eax,0x805030
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0f                	je     802a21 <alloc_block_BF+0x18f>
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 04             	mov    0x4(%eax),%eax
  802a18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1b:	8b 12                	mov    (%edx),%edx
  802a1d:	89 10                	mov    %edx,(%eax)
  802a1f:	eb 0a                	jmp    802a2b <alloc_block_BF+0x199>
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3e:	a1 38 50 80 00       	mov    0x805038,%eax
  802a43:	48                   	dec    %eax
  802a44:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a49:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a4c:	e9 01 04 00 00       	jmp    802e52 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a54:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a57:	76 13                	jbe    802a6c <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a59:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a60:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a66:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a69:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a6c:	a1 34 50 80 00       	mov    0x805034,%eax
  802a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a78:	74 07                	je     802a81 <alloc_block_BF+0x1ef>
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 00                	mov    (%eax),%eax
  802a7f:	eb 05                	jmp    802a86 <alloc_block_BF+0x1f4>
  802a81:	b8 00 00 00 00       	mov    $0x0,%eax
  802a86:	a3 34 50 80 00       	mov    %eax,0x805034
  802a8b:	a1 34 50 80 00       	mov    0x805034,%eax
  802a90:	85 c0                	test   %eax,%eax
  802a92:	0f 85 bf fe ff ff    	jne    802957 <alloc_block_BF+0xc5>
  802a98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9c:	0f 85 b5 fe ff ff    	jne    802957 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802aa2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa6:	0f 84 26 02 00 00    	je     802cd2 <alloc_block_BF+0x440>
  802aac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ab0:	0f 85 1c 02 00 00    	jne    802cd2 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab9:	2b 45 08             	sub    0x8(%ebp),%eax
  802abc:	83 e8 08             	sub    $0x8,%eax
  802abf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	8d 50 08             	lea    0x8(%eax),%edx
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	01 d0                	add    %edx,%eax
  802acd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	83 c0 08             	add    $0x8,%eax
  802ad6:	83 ec 04             	sub    $0x4,%esp
  802ad9:	6a 01                	push   $0x1
  802adb:	50                   	push   %eax
  802adc:	ff 75 f0             	pushl  -0x10(%ebp)
  802adf:	e8 c3 f8 ff ff       	call   8023a7 <set_block_data>
  802ae4:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	75 68                	jne    802b59 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802af1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802af5:	75 17                	jne    802b0e <alloc_block_BF+0x27c>
  802af7:	83 ec 04             	sub    $0x4,%esp
  802afa:	68 bc 45 80 00       	push   $0x8045bc
  802aff:	68 45 01 00 00       	push   $0x145
  802b04:	68 a1 45 80 00       	push   $0x8045a1
  802b09:	e8 21 10 00 00       	call   803b2f <_panic>
  802b0e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b17:	89 10                	mov    %edx,(%eax)
  802b19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1c:	8b 00                	mov    (%eax),%eax
  802b1e:	85 c0                	test   %eax,%eax
  802b20:	74 0d                	je     802b2f <alloc_block_BF+0x29d>
  802b22:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b27:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b2a:	89 50 04             	mov    %edx,0x4(%eax)
  802b2d:	eb 08                	jmp    802b37 <alloc_block_BF+0x2a5>
  802b2f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b32:	a3 30 50 80 00       	mov    %eax,0x805030
  802b37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b49:	a1 38 50 80 00       	mov    0x805038,%eax
  802b4e:	40                   	inc    %eax
  802b4f:	a3 38 50 80 00       	mov    %eax,0x805038
  802b54:	e9 dc 00 00 00       	jmp    802c35 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	75 65                	jne    802bc7 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b62:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b66:	75 17                	jne    802b7f <alloc_block_BF+0x2ed>
  802b68:	83 ec 04             	sub    $0x4,%esp
  802b6b:	68 f0 45 80 00       	push   $0x8045f0
  802b70:	68 4a 01 00 00       	push   $0x14a
  802b75:	68 a1 45 80 00       	push   $0x8045a1
  802b7a:	e8 b0 0f 00 00       	call   803b2f <_panic>
  802b7f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b88:	89 50 04             	mov    %edx,0x4(%eax)
  802b8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8e:	8b 40 04             	mov    0x4(%eax),%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	74 0c                	je     802ba1 <alloc_block_BF+0x30f>
  802b95:	a1 30 50 80 00       	mov    0x805030,%eax
  802b9a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b9d:	89 10                	mov    %edx,(%eax)
  802b9f:	eb 08                	jmp    802ba9 <alloc_block_BF+0x317>
  802ba1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ba9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bac:	a3 30 50 80 00       	mov    %eax,0x805030
  802bb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bba:	a1 38 50 80 00       	mov    0x805038,%eax
  802bbf:	40                   	inc    %eax
  802bc0:	a3 38 50 80 00       	mov    %eax,0x805038
  802bc5:	eb 6e                	jmp    802c35 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802bc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bcb:	74 06                	je     802bd3 <alloc_block_BF+0x341>
  802bcd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bd1:	75 17                	jne    802bea <alloc_block_BF+0x358>
  802bd3:	83 ec 04             	sub    $0x4,%esp
  802bd6:	68 14 46 80 00       	push   $0x804614
  802bdb:	68 4f 01 00 00       	push   $0x14f
  802be0:	68 a1 45 80 00       	push   $0x8045a1
  802be5:	e8 45 0f 00 00       	call   803b2f <_panic>
  802bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bed:	8b 10                	mov    (%eax),%edx
  802bef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf2:	89 10                	mov    %edx,(%eax)
  802bf4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	74 0b                	je     802c08 <alloc_block_BF+0x376>
  802bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c05:	89 50 04             	mov    %edx,0x4(%eax)
  802c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c0e:	89 10                	mov    %edx,(%eax)
  802c10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c16:	89 50 04             	mov    %edx,0x4(%eax)
  802c19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	75 08                	jne    802c2a <alloc_block_BF+0x398>
  802c22:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c25:	a3 30 50 80 00       	mov    %eax,0x805030
  802c2a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c2f:	40                   	inc    %eax
  802c30:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c39:	75 17                	jne    802c52 <alloc_block_BF+0x3c0>
  802c3b:	83 ec 04             	sub    $0x4,%esp
  802c3e:	68 83 45 80 00       	push   $0x804583
  802c43:	68 51 01 00 00       	push   $0x151
  802c48:	68 a1 45 80 00       	push   $0x8045a1
  802c4d:	e8 dd 0e 00 00       	call   803b2f <_panic>
  802c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 10                	je     802c6b <alloc_block_BF+0x3d9>
  802c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c63:	8b 52 04             	mov    0x4(%edx),%edx
  802c66:	89 50 04             	mov    %edx,0x4(%eax)
  802c69:	eb 0b                	jmp    802c76 <alloc_block_BF+0x3e4>
  802c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6e:	8b 40 04             	mov    0x4(%eax),%eax
  802c71:	a3 30 50 80 00       	mov    %eax,0x805030
  802c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 0f                	je     802c8f <alloc_block_BF+0x3fd>
  802c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c89:	8b 12                	mov    (%edx),%edx
  802c8b:	89 10                	mov    %edx,(%eax)
  802c8d:	eb 0a                	jmp    802c99 <alloc_block_BF+0x407>
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
			set_block_data(new_block_va, remaining_size, 0);
  802cb7:	83 ec 04             	sub    $0x4,%esp
  802cba:	6a 00                	push   $0x0
  802cbc:	ff 75 d0             	pushl  -0x30(%ebp)
  802cbf:	ff 75 cc             	pushl  -0x34(%ebp)
  802cc2:	e8 e0 f6 ff ff       	call   8023a7 <set_block_data>
  802cc7:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccd:	e9 80 01 00 00       	jmp    802e52 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802cd2:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802cd6:	0f 85 9d 00 00 00    	jne    802d79 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802cdc:	83 ec 04             	sub    $0x4,%esp
  802cdf:	6a 01                	push   $0x1
  802ce1:	ff 75 ec             	pushl  -0x14(%ebp)
  802ce4:	ff 75 f0             	pushl  -0x10(%ebp)
  802ce7:	e8 bb f6 ff ff       	call   8023a7 <set_block_data>
  802cec:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802cef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf3:	75 17                	jne    802d0c <alloc_block_BF+0x47a>
  802cf5:	83 ec 04             	sub    $0x4,%esp
  802cf8:	68 83 45 80 00       	push   $0x804583
  802cfd:	68 58 01 00 00       	push   $0x158
  802d02:	68 a1 45 80 00       	push   $0x8045a1
  802d07:	e8 23 0e 00 00       	call   803b2f <_panic>
  802d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0f:	8b 00                	mov    (%eax),%eax
  802d11:	85 c0                	test   %eax,%eax
  802d13:	74 10                	je     802d25 <alloc_block_BF+0x493>
  802d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d18:	8b 00                	mov    (%eax),%eax
  802d1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1d:	8b 52 04             	mov    0x4(%edx),%edx
  802d20:	89 50 04             	mov    %edx,0x4(%eax)
  802d23:	eb 0b                	jmp    802d30 <alloc_block_BF+0x49e>
  802d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d28:	8b 40 04             	mov    0x4(%eax),%eax
  802d2b:	a3 30 50 80 00       	mov    %eax,0x805030
  802d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d33:	8b 40 04             	mov    0x4(%eax),%eax
  802d36:	85 c0                	test   %eax,%eax
  802d38:	74 0f                	je     802d49 <alloc_block_BF+0x4b7>
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d43:	8b 12                	mov    (%edx),%edx
  802d45:	89 10                	mov    %edx,(%eax)
  802d47:	eb 0a                	jmp    802d53 <alloc_block_BF+0x4c1>
  802d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d66:	a1 38 50 80 00       	mov    0x805038,%eax
  802d6b:	48                   	dec    %eax
  802d6c:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d74:	e9 d9 00 00 00       	jmp    802e52 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	83 c0 08             	add    $0x8,%eax
  802d7f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d82:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d89:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d8c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d8f:	01 d0                	add    %edx,%eax
  802d91:	48                   	dec    %eax
  802d92:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d95:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d98:	ba 00 00 00 00       	mov    $0x0,%edx
  802d9d:	f7 75 c4             	divl   -0x3c(%ebp)
  802da0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802da3:	29 d0                	sub    %edx,%eax
  802da5:	c1 e8 0c             	shr    $0xc,%eax
  802da8:	83 ec 0c             	sub    $0xc,%esp
  802dab:	50                   	push   %eax
  802dac:	e8 49 e7 ff ff       	call   8014fa <sbrk>
  802db1:	83 c4 10             	add    $0x10,%esp
  802db4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802db7:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802dbb:	75 0a                	jne    802dc7 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc2:	e9 8b 00 00 00       	jmp    802e52 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802dc7:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802dce:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dd1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802dd4:	01 d0                	add    %edx,%eax
  802dd6:	48                   	dec    %eax
  802dd7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802dda:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ddd:	ba 00 00 00 00       	mov    $0x0,%edx
  802de2:	f7 75 b8             	divl   -0x48(%ebp)
  802de5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802de8:	29 d0                	sub    %edx,%eax
  802dea:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ded:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802df0:	01 d0                	add    %edx,%eax
  802df2:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802df7:	a1 40 50 80 00       	mov    0x805040,%eax
  802dfc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e02:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e09:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e0c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e0f:	01 d0                	add    %edx,%eax
  802e11:	48                   	dec    %eax
  802e12:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e15:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e18:	ba 00 00 00 00       	mov    $0x0,%edx
  802e1d:	f7 75 b0             	divl   -0x50(%ebp)
  802e20:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e23:	29 d0                	sub    %edx,%eax
  802e25:	83 ec 04             	sub    $0x4,%esp
  802e28:	6a 01                	push   $0x1
  802e2a:	50                   	push   %eax
  802e2b:	ff 75 bc             	pushl  -0x44(%ebp)
  802e2e:	e8 74 f5 ff ff       	call   8023a7 <set_block_data>
  802e33:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e36:	83 ec 0c             	sub    $0xc,%esp
  802e39:	ff 75 bc             	pushl  -0x44(%ebp)
  802e3c:	e8 36 04 00 00       	call   803277 <free_block>
  802e41:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e44:	83 ec 0c             	sub    $0xc,%esp
  802e47:	ff 75 08             	pushl  0x8(%ebp)
  802e4a:	e8 43 fa ff ff       	call   802892 <alloc_block_BF>
  802e4f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e52:	c9                   	leave  
  802e53:	c3                   	ret    

00802e54 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e54:	55                   	push   %ebp
  802e55:	89 e5                	mov    %esp,%ebp
  802e57:	53                   	push   %ebx
  802e58:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6d:	74 1e                	je     802e8d <merging+0x39>
  802e6f:	ff 75 08             	pushl  0x8(%ebp)
  802e72:	e8 df f1 ff ff       	call   802056 <get_block_size>
  802e77:	83 c4 04             	add    $0x4,%esp
  802e7a:	89 c2                	mov    %eax,%edx
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	01 d0                	add    %edx,%eax
  802e81:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e84:	75 07                	jne    802e8d <merging+0x39>
		prev_is_free = 1;
  802e86:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e91:	74 1e                	je     802eb1 <merging+0x5d>
  802e93:	ff 75 10             	pushl  0x10(%ebp)
  802e96:	e8 bb f1 ff ff       	call   802056 <get_block_size>
  802e9b:	83 c4 04             	add    $0x4,%esp
  802e9e:	89 c2                	mov    %eax,%edx
  802ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ea3:	01 d0                	add    %edx,%eax
  802ea5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ea8:	75 07                	jne    802eb1 <merging+0x5d>
		next_is_free = 1;
  802eaa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb5:	0f 84 cc 00 00 00    	je     802f87 <merging+0x133>
  802ebb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ebf:	0f 84 c2 00 00 00    	je     802f87 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ec5:	ff 75 08             	pushl  0x8(%ebp)
  802ec8:	e8 89 f1 ff ff       	call   802056 <get_block_size>
  802ecd:	83 c4 04             	add    $0x4,%esp
  802ed0:	89 c3                	mov    %eax,%ebx
  802ed2:	ff 75 10             	pushl  0x10(%ebp)
  802ed5:	e8 7c f1 ff ff       	call   802056 <get_block_size>
  802eda:	83 c4 04             	add    $0x4,%esp
  802edd:	01 c3                	add    %eax,%ebx
  802edf:	ff 75 0c             	pushl  0xc(%ebp)
  802ee2:	e8 6f f1 ff ff       	call   802056 <get_block_size>
  802ee7:	83 c4 04             	add    $0x4,%esp
  802eea:	01 d8                	add    %ebx,%eax
  802eec:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802eef:	6a 00                	push   $0x0
  802ef1:	ff 75 ec             	pushl  -0x14(%ebp)
  802ef4:	ff 75 08             	pushl  0x8(%ebp)
  802ef7:	e8 ab f4 ff ff       	call   8023a7 <set_block_data>
  802efc:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802eff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f03:	75 17                	jne    802f1c <merging+0xc8>
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	68 83 45 80 00       	push   $0x804583
  802f0d:	68 7d 01 00 00       	push   $0x17d
  802f12:	68 a1 45 80 00       	push   $0x8045a1
  802f17:	e8 13 0c 00 00       	call   803b2f <_panic>
  802f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	85 c0                	test   %eax,%eax
  802f23:	74 10                	je     802f35 <merging+0xe1>
  802f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2d:	8b 52 04             	mov    0x4(%edx),%edx
  802f30:	89 50 04             	mov    %edx,0x4(%eax)
  802f33:	eb 0b                	jmp    802f40 <merging+0xec>
  802f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f38:	8b 40 04             	mov    0x4(%eax),%eax
  802f3b:	a3 30 50 80 00       	mov    %eax,0x805030
  802f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f43:	8b 40 04             	mov    0x4(%eax),%eax
  802f46:	85 c0                	test   %eax,%eax
  802f48:	74 0f                	je     802f59 <merging+0x105>
  802f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4d:	8b 40 04             	mov    0x4(%eax),%eax
  802f50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f53:	8b 12                	mov    (%edx),%edx
  802f55:	89 10                	mov    %edx,(%eax)
  802f57:	eb 0a                	jmp    802f63 <merging+0x10f>
  802f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f76:	a1 38 50 80 00       	mov    0x805038,%eax
  802f7b:	48                   	dec    %eax
  802f7c:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f81:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f82:	e9 ea 02 00 00       	jmp    803271 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8b:	74 3b                	je     802fc8 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f8d:	83 ec 0c             	sub    $0xc,%esp
  802f90:	ff 75 08             	pushl  0x8(%ebp)
  802f93:	e8 be f0 ff ff       	call   802056 <get_block_size>
  802f98:	83 c4 10             	add    $0x10,%esp
  802f9b:	89 c3                	mov    %eax,%ebx
  802f9d:	83 ec 0c             	sub    $0xc,%esp
  802fa0:	ff 75 10             	pushl  0x10(%ebp)
  802fa3:	e8 ae f0 ff ff       	call   802056 <get_block_size>
  802fa8:	83 c4 10             	add    $0x10,%esp
  802fab:	01 d8                	add    %ebx,%eax
  802fad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fb0:	83 ec 04             	sub    $0x4,%esp
  802fb3:	6a 00                	push   $0x0
  802fb5:	ff 75 e8             	pushl  -0x18(%ebp)
  802fb8:	ff 75 08             	pushl  0x8(%ebp)
  802fbb:	e8 e7 f3 ff ff       	call   8023a7 <set_block_data>
  802fc0:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fc3:	e9 a9 02 00 00       	jmp    803271 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802fc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fcc:	0f 84 2d 01 00 00    	je     8030ff <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802fd2:	83 ec 0c             	sub    $0xc,%esp
  802fd5:	ff 75 10             	pushl  0x10(%ebp)
  802fd8:	e8 79 f0 ff ff       	call   802056 <get_block_size>
  802fdd:	83 c4 10             	add    $0x10,%esp
  802fe0:	89 c3                	mov    %eax,%ebx
  802fe2:	83 ec 0c             	sub    $0xc,%esp
  802fe5:	ff 75 0c             	pushl  0xc(%ebp)
  802fe8:	e8 69 f0 ff ff       	call   802056 <get_block_size>
  802fed:	83 c4 10             	add    $0x10,%esp
  802ff0:	01 d8                	add    %ebx,%eax
  802ff2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ff5:	83 ec 04             	sub    $0x4,%esp
  802ff8:	6a 00                	push   $0x0
  802ffa:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ffd:	ff 75 10             	pushl  0x10(%ebp)
  803000:	e8 a2 f3 ff ff       	call   8023a7 <set_block_data>
  803005:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803008:	8b 45 10             	mov    0x10(%ebp),%eax
  80300b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80300e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803012:	74 06                	je     80301a <merging+0x1c6>
  803014:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803018:	75 17                	jne    803031 <merging+0x1dd>
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	68 48 46 80 00       	push   $0x804648
  803022:	68 8d 01 00 00       	push   $0x18d
  803027:	68 a1 45 80 00       	push   $0x8045a1
  80302c:	e8 fe 0a 00 00       	call   803b2f <_panic>
  803031:	8b 45 0c             	mov    0xc(%ebp),%eax
  803034:	8b 50 04             	mov    0x4(%eax),%edx
  803037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303a:	89 50 04             	mov    %edx,0x4(%eax)
  80303d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803040:	8b 55 0c             	mov    0xc(%ebp),%edx
  803043:	89 10                	mov    %edx,(%eax)
  803045:	8b 45 0c             	mov    0xc(%ebp),%eax
  803048:	8b 40 04             	mov    0x4(%eax),%eax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	74 0d                	je     80305c <merging+0x208>
  80304f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803052:	8b 40 04             	mov    0x4(%eax),%eax
  803055:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803058:	89 10                	mov    %edx,(%eax)
  80305a:	eb 08                	jmp    803064 <merging+0x210>
  80305c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80305f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803064:	8b 45 0c             	mov    0xc(%ebp),%eax
  803067:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80306a:	89 50 04             	mov    %edx,0x4(%eax)
  80306d:	a1 38 50 80 00       	mov    0x805038,%eax
  803072:	40                   	inc    %eax
  803073:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803078:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80307c:	75 17                	jne    803095 <merging+0x241>
  80307e:	83 ec 04             	sub    $0x4,%esp
  803081:	68 83 45 80 00       	push   $0x804583
  803086:	68 8e 01 00 00       	push   $0x18e
  80308b:	68 a1 45 80 00       	push   $0x8045a1
  803090:	e8 9a 0a 00 00       	call   803b2f <_panic>
  803095:	8b 45 0c             	mov    0xc(%ebp),%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	85 c0                	test   %eax,%eax
  80309c:	74 10                	je     8030ae <merging+0x25a>
  80309e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a6:	8b 52 04             	mov    0x4(%edx),%edx
  8030a9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ac:	eb 0b                	jmp    8030b9 <merging+0x265>
  8030ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b1:	8b 40 04             	mov    0x4(%eax),%eax
  8030b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8030b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030bc:	8b 40 04             	mov    0x4(%eax),%eax
  8030bf:	85 c0                	test   %eax,%eax
  8030c1:	74 0f                	je     8030d2 <merging+0x27e>
  8030c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c6:	8b 40 04             	mov    0x4(%eax),%eax
  8030c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030cc:	8b 12                	mov    (%edx),%edx
  8030ce:	89 10                	mov    %edx,(%eax)
  8030d0:	eb 0a                	jmp    8030dc <merging+0x288>
  8030d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d5:	8b 00                	mov    (%eax),%eax
  8030d7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8030f4:	48                   	dec    %eax
  8030f5:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030fa:	e9 72 01 00 00       	jmp    803271 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8030ff:	8b 45 10             	mov    0x10(%ebp),%eax
  803102:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803109:	74 79                	je     803184 <merging+0x330>
  80310b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80310f:	74 73                	je     803184 <merging+0x330>
  803111:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803115:	74 06                	je     80311d <merging+0x2c9>
  803117:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80311b:	75 17                	jne    803134 <merging+0x2e0>
  80311d:	83 ec 04             	sub    $0x4,%esp
  803120:	68 14 46 80 00       	push   $0x804614
  803125:	68 94 01 00 00       	push   $0x194
  80312a:	68 a1 45 80 00       	push   $0x8045a1
  80312f:	e8 fb 09 00 00       	call   803b2f <_panic>
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	8b 10                	mov    (%eax),%edx
  803139:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313c:	89 10                	mov    %edx,(%eax)
  80313e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	74 0b                	je     803152 <merging+0x2fe>
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	8b 00                	mov    (%eax),%eax
  80314c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80314f:	89 50 04             	mov    %edx,0x4(%eax)
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803158:	89 10                	mov    %edx,(%eax)
  80315a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315d:	8b 55 08             	mov    0x8(%ebp),%edx
  803160:	89 50 04             	mov    %edx,0x4(%eax)
  803163:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803166:	8b 00                	mov    (%eax),%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	75 08                	jne    803174 <merging+0x320>
  80316c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316f:	a3 30 50 80 00       	mov    %eax,0x805030
  803174:	a1 38 50 80 00       	mov    0x805038,%eax
  803179:	40                   	inc    %eax
  80317a:	a3 38 50 80 00       	mov    %eax,0x805038
  80317f:	e9 ce 00 00 00       	jmp    803252 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803184:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803188:	74 65                	je     8031ef <merging+0x39b>
  80318a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80318e:	75 17                	jne    8031a7 <merging+0x353>
  803190:	83 ec 04             	sub    $0x4,%esp
  803193:	68 f0 45 80 00       	push   $0x8045f0
  803198:	68 95 01 00 00       	push   $0x195
  80319d:	68 a1 45 80 00       	push   $0x8045a1
  8031a2:	e8 88 09 00 00       	call   803b2f <_panic>
  8031a7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b0:	89 50 04             	mov    %edx,0x4(%eax)
  8031b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b6:	8b 40 04             	mov    0x4(%eax),%eax
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	74 0c                	je     8031c9 <merging+0x375>
  8031bd:	a1 30 50 80 00       	mov    0x805030,%eax
  8031c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031c5:	89 10                	mov    %edx,(%eax)
  8031c7:	eb 08                	jmp    8031d1 <merging+0x37d>
  8031c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8031d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8031e7:	40                   	inc    %eax
  8031e8:	a3 38 50 80 00       	mov    %eax,0x805038
  8031ed:	eb 63                	jmp    803252 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8031ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031f3:	75 17                	jne    80320c <merging+0x3b8>
  8031f5:	83 ec 04             	sub    $0x4,%esp
  8031f8:	68 bc 45 80 00       	push   $0x8045bc
  8031fd:	68 98 01 00 00       	push   $0x198
  803202:	68 a1 45 80 00       	push   $0x8045a1
  803207:	e8 23 09 00 00       	call   803b2f <_panic>
  80320c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803212:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803215:	89 10                	mov    %edx,(%eax)
  803217:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321a:	8b 00                	mov    (%eax),%eax
  80321c:	85 c0                	test   %eax,%eax
  80321e:	74 0d                	je     80322d <merging+0x3d9>
  803220:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803225:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803228:	89 50 04             	mov    %edx,0x4(%eax)
  80322b:	eb 08                	jmp    803235 <merging+0x3e1>
  80322d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803230:	a3 30 50 80 00       	mov    %eax,0x805030
  803235:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803238:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80323d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803240:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803247:	a1 38 50 80 00       	mov    0x805038,%eax
  80324c:	40                   	inc    %eax
  80324d:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803252:	83 ec 0c             	sub    $0xc,%esp
  803255:	ff 75 10             	pushl  0x10(%ebp)
  803258:	e8 f9 ed ff ff       	call   802056 <get_block_size>
  80325d:	83 c4 10             	add    $0x10,%esp
  803260:	83 ec 04             	sub    $0x4,%esp
  803263:	6a 00                	push   $0x0
  803265:	50                   	push   %eax
  803266:	ff 75 10             	pushl  0x10(%ebp)
  803269:	e8 39 f1 ff ff       	call   8023a7 <set_block_data>
  80326e:	83 c4 10             	add    $0x10,%esp
	}
}
  803271:	90                   	nop
  803272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803275:	c9                   	leave  
  803276:	c3                   	ret    

00803277 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803277:	55                   	push   %ebp
  803278:	89 e5                	mov    %esp,%ebp
  80327a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80327d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803282:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803285:	a1 30 50 80 00       	mov    0x805030,%eax
  80328a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80328d:	73 1b                	jae    8032aa <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80328f:	a1 30 50 80 00       	mov    0x805030,%eax
  803294:	83 ec 04             	sub    $0x4,%esp
  803297:	ff 75 08             	pushl  0x8(%ebp)
  80329a:	6a 00                	push   $0x0
  80329c:	50                   	push   %eax
  80329d:	e8 b2 fb ff ff       	call   802e54 <merging>
  8032a2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032a5:	e9 8b 00 00 00       	jmp    803335 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8032aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032b2:	76 18                	jbe    8032cc <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8032b4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032b9:	83 ec 04             	sub    $0x4,%esp
  8032bc:	ff 75 08             	pushl  0x8(%ebp)
  8032bf:	50                   	push   %eax
  8032c0:	6a 00                	push   $0x0
  8032c2:	e8 8d fb ff ff       	call   802e54 <merging>
  8032c7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032ca:	eb 69                	jmp    803335 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032cc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d4:	eb 39                	jmp    80330f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032dc:	73 29                	jae    803307 <free_block+0x90>
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032e6:	76 1f                	jbe    803307 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	ff 75 08             	pushl  0x8(%ebp)
  8032f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8032f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8032fc:	e8 53 fb ff ff       	call   802e54 <merging>
  803301:	83 c4 10             	add    $0x10,%esp
			break;
  803304:	90                   	nop
		}
	}
}
  803305:	eb 2e                	jmp    803335 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803307:	a1 34 50 80 00       	mov    0x805034,%eax
  80330c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80330f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803313:	74 07                	je     80331c <free_block+0xa5>
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	eb 05                	jmp    803321 <free_block+0xaa>
  80331c:	b8 00 00 00 00       	mov    $0x0,%eax
  803321:	a3 34 50 80 00       	mov    %eax,0x805034
  803326:	a1 34 50 80 00       	mov    0x805034,%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	75 a7                	jne    8032d6 <free_block+0x5f>
  80332f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803333:	75 a1                	jne    8032d6 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803335:	90                   	nop
  803336:	c9                   	leave  
  803337:	c3                   	ret    

00803338 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803338:	55                   	push   %ebp
  803339:	89 e5                	mov    %esp,%ebp
  80333b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80333e:	ff 75 08             	pushl  0x8(%ebp)
  803341:	e8 10 ed ff ff       	call   802056 <get_block_size>
  803346:	83 c4 04             	add    $0x4,%esp
  803349:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80334c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803353:	eb 17                	jmp    80336c <copy_data+0x34>
  803355:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803358:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335b:	01 c2                	add    %eax,%edx
  80335d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	01 c8                	add    %ecx,%eax
  803365:	8a 00                	mov    (%eax),%al
  803367:	88 02                	mov    %al,(%edx)
  803369:	ff 45 fc             	incl   -0x4(%ebp)
  80336c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80336f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803372:	72 e1                	jb     803355 <copy_data+0x1d>
}
  803374:	90                   	nop
  803375:	c9                   	leave  
  803376:	c3                   	ret    

00803377 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803377:	55                   	push   %ebp
  803378:	89 e5                	mov    %esp,%ebp
  80337a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80337d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803381:	75 23                	jne    8033a6 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803383:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803387:	74 13                	je     80339c <realloc_block_FF+0x25>
  803389:	83 ec 0c             	sub    $0xc,%esp
  80338c:	ff 75 0c             	pushl  0xc(%ebp)
  80338f:	e8 42 f0 ff ff       	call   8023d6 <alloc_block_FF>
  803394:	83 c4 10             	add    $0x10,%esp
  803397:	e9 e4 06 00 00       	jmp    803a80 <realloc_block_FF+0x709>
		return NULL;
  80339c:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a1:	e9 da 06 00 00       	jmp    803a80 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8033a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033aa:	75 18                	jne    8033c4 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8033ac:	83 ec 0c             	sub    $0xc,%esp
  8033af:	ff 75 08             	pushl  0x8(%ebp)
  8033b2:	e8 c0 fe ff ff       	call   803277 <free_block>
  8033b7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bf:	e9 bc 06 00 00       	jmp    803a80 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8033c4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033c8:	77 07                	ja     8033d1 <realloc_block_FF+0x5a>
  8033ca:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d4:	83 e0 01             	and    $0x1,%eax
  8033d7:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8033da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033dd:	83 c0 08             	add    $0x8,%eax
  8033e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8033e3:	83 ec 0c             	sub    $0xc,%esp
  8033e6:	ff 75 08             	pushl  0x8(%ebp)
  8033e9:	e8 68 ec ff ff       	call   802056 <get_block_size>
  8033ee:	83 c4 10             	add    $0x10,%esp
  8033f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f7:	83 e8 08             	sub    $0x8,%eax
  8033fa:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	83 e8 04             	sub    $0x4,%eax
  803403:	8b 00                	mov    (%eax),%eax
  803405:	83 e0 fe             	and    $0xfffffffe,%eax
  803408:	89 c2                	mov    %eax,%edx
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	01 d0                	add    %edx,%eax
  80340f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803412:	83 ec 0c             	sub    $0xc,%esp
  803415:	ff 75 e4             	pushl  -0x1c(%ebp)
  803418:	e8 39 ec ff ff       	call   802056 <get_block_size>
  80341d:	83 c4 10             	add    $0x10,%esp
  803420:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803426:	83 e8 08             	sub    $0x8,%eax
  803429:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80342c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80342f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803432:	75 08                	jne    80343c <realloc_block_FF+0xc5>
	{
		 return va;
  803434:	8b 45 08             	mov    0x8(%ebp),%eax
  803437:	e9 44 06 00 00       	jmp    803a80 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80343c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803442:	0f 83 d5 03 00 00    	jae    80381d <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80344e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803451:	83 ec 0c             	sub    $0xc,%esp
  803454:	ff 75 e4             	pushl  -0x1c(%ebp)
  803457:	e8 13 ec ff ff       	call   80206f <is_free_block>
  80345c:	83 c4 10             	add    $0x10,%esp
  80345f:	84 c0                	test   %al,%al
  803461:	0f 84 3b 01 00 00    	je     8035a2 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803467:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80346a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80346d:	01 d0                	add    %edx,%eax
  80346f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803472:	83 ec 04             	sub    $0x4,%esp
  803475:	6a 01                	push   $0x1
  803477:	ff 75 f0             	pushl  -0x10(%ebp)
  80347a:	ff 75 08             	pushl  0x8(%ebp)
  80347d:	e8 25 ef ff ff       	call   8023a7 <set_block_data>
  803482:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	83 e8 04             	sub    $0x4,%eax
  80348b:	8b 00                	mov    (%eax),%eax
  80348d:	83 e0 fe             	and    $0xfffffffe,%eax
  803490:	89 c2                	mov    %eax,%edx
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	01 d0                	add    %edx,%eax
  803497:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80349a:	83 ec 04             	sub    $0x4,%esp
  80349d:	6a 00                	push   $0x0
  80349f:	ff 75 cc             	pushl  -0x34(%ebp)
  8034a2:	ff 75 c8             	pushl  -0x38(%ebp)
  8034a5:	e8 fd ee ff ff       	call   8023a7 <set_block_data>
  8034aa:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034b1:	74 06                	je     8034b9 <realloc_block_FF+0x142>
  8034b3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034b7:	75 17                	jne    8034d0 <realloc_block_FF+0x159>
  8034b9:	83 ec 04             	sub    $0x4,%esp
  8034bc:	68 14 46 80 00       	push   $0x804614
  8034c1:	68 f6 01 00 00       	push   $0x1f6
  8034c6:	68 a1 45 80 00       	push   $0x8045a1
  8034cb:	e8 5f 06 00 00       	call   803b2f <_panic>
  8034d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d3:	8b 10                	mov    (%eax),%edx
  8034d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034d8:	89 10                	mov    %edx,(%eax)
  8034da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	74 0b                	je     8034ee <realloc_block_FF+0x177>
  8034e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e6:	8b 00                	mov    (%eax),%eax
  8034e8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034eb:	89 50 04             	mov    %edx,0x4(%eax)
  8034ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034f4:	89 10                	mov    %edx,(%eax)
  8034f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034fc:	89 50 04             	mov    %edx,0x4(%eax)
  8034ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	85 c0                	test   %eax,%eax
  803506:	75 08                	jne    803510 <realloc_block_FF+0x199>
  803508:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80350b:	a3 30 50 80 00       	mov    %eax,0x805030
  803510:	a1 38 50 80 00       	mov    0x805038,%eax
  803515:	40                   	inc    %eax
  803516:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80351b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80351f:	75 17                	jne    803538 <realloc_block_FF+0x1c1>
  803521:	83 ec 04             	sub    $0x4,%esp
  803524:	68 83 45 80 00       	push   $0x804583
  803529:	68 f7 01 00 00       	push   $0x1f7
  80352e:	68 a1 45 80 00       	push   $0x8045a1
  803533:	e8 f7 05 00 00       	call   803b2f <_panic>
  803538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353b:	8b 00                	mov    (%eax),%eax
  80353d:	85 c0                	test   %eax,%eax
  80353f:	74 10                	je     803551 <realloc_block_FF+0x1da>
  803541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803544:	8b 00                	mov    (%eax),%eax
  803546:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803549:	8b 52 04             	mov    0x4(%edx),%edx
  80354c:	89 50 04             	mov    %edx,0x4(%eax)
  80354f:	eb 0b                	jmp    80355c <realloc_block_FF+0x1e5>
  803551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803554:	8b 40 04             	mov    0x4(%eax),%eax
  803557:	a3 30 50 80 00       	mov    %eax,0x805030
  80355c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355f:	8b 40 04             	mov    0x4(%eax),%eax
  803562:	85 c0                	test   %eax,%eax
  803564:	74 0f                	je     803575 <realloc_block_FF+0x1fe>
  803566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803569:	8b 40 04             	mov    0x4(%eax),%eax
  80356c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80356f:	8b 12                	mov    (%edx),%edx
  803571:	89 10                	mov    %edx,(%eax)
  803573:	eb 0a                	jmp    80357f <realloc_block_FF+0x208>
  803575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803578:	8b 00                	mov    (%eax),%eax
  80357a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80357f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803582:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803592:	a1 38 50 80 00       	mov    0x805038,%eax
  803597:	48                   	dec    %eax
  803598:	a3 38 50 80 00       	mov    %eax,0x805038
  80359d:	e9 73 02 00 00       	jmp    803815 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8035a2:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8035a6:	0f 86 69 02 00 00    	jbe    803815 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8035ac:	83 ec 04             	sub    $0x4,%esp
  8035af:	6a 01                	push   $0x1
  8035b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8035b4:	ff 75 08             	pushl  0x8(%ebp)
  8035b7:	e8 eb ed ff ff       	call   8023a7 <set_block_data>
  8035bc:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	83 e8 04             	sub    $0x4,%eax
  8035c5:	8b 00                	mov    (%eax),%eax
  8035c7:	83 e0 fe             	and    $0xfffffffe,%eax
  8035ca:	89 c2                	mov    %eax,%edx
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	01 d0                	add    %edx,%eax
  8035d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8035dc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8035e0:	75 68                	jne    80364a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035e2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035e6:	75 17                	jne    8035ff <realloc_block_FF+0x288>
  8035e8:	83 ec 04             	sub    $0x4,%esp
  8035eb:	68 bc 45 80 00       	push   $0x8045bc
  8035f0:	68 06 02 00 00       	push   $0x206
  8035f5:	68 a1 45 80 00       	push   $0x8045a1
  8035fa:	e8 30 05 00 00       	call   803b2f <_panic>
  8035ff:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803605:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803608:	89 10                	mov    %edx,(%eax)
  80360a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360d:	8b 00                	mov    (%eax),%eax
  80360f:	85 c0                	test   %eax,%eax
  803611:	74 0d                	je     803620 <realloc_block_FF+0x2a9>
  803613:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803618:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80361b:	89 50 04             	mov    %edx,0x4(%eax)
  80361e:	eb 08                	jmp    803628 <realloc_block_FF+0x2b1>
  803620:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803623:	a3 30 50 80 00       	mov    %eax,0x805030
  803628:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803630:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803633:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363a:	a1 38 50 80 00       	mov    0x805038,%eax
  80363f:	40                   	inc    %eax
  803640:	a3 38 50 80 00       	mov    %eax,0x805038
  803645:	e9 b0 01 00 00       	jmp    8037fa <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80364a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80364f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803652:	76 68                	jbe    8036bc <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803654:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803658:	75 17                	jne    803671 <realloc_block_FF+0x2fa>
  80365a:	83 ec 04             	sub    $0x4,%esp
  80365d:	68 bc 45 80 00       	push   $0x8045bc
  803662:	68 0b 02 00 00       	push   $0x20b
  803667:	68 a1 45 80 00       	push   $0x8045a1
  80366c:	e8 be 04 00 00       	call   803b2f <_panic>
  803671:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803677:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367a:	89 10                	mov    %edx,(%eax)
  80367c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367f:	8b 00                	mov    (%eax),%eax
  803681:	85 c0                	test   %eax,%eax
  803683:	74 0d                	je     803692 <realloc_block_FF+0x31b>
  803685:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80368a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80368d:	89 50 04             	mov    %edx,0x4(%eax)
  803690:	eb 08                	jmp    80369a <realloc_block_FF+0x323>
  803692:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803695:	a3 30 50 80 00       	mov    %eax,0x805030
  80369a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b1:	40                   	inc    %eax
  8036b2:	a3 38 50 80 00       	mov    %eax,0x805038
  8036b7:	e9 3e 01 00 00       	jmp    8037fa <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036bc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036c1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036c4:	73 68                	jae    80372e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036ca:	75 17                	jne    8036e3 <realloc_block_FF+0x36c>
  8036cc:	83 ec 04             	sub    $0x4,%esp
  8036cf:	68 f0 45 80 00       	push   $0x8045f0
  8036d4:	68 10 02 00 00       	push   $0x210
  8036d9:	68 a1 45 80 00       	push   $0x8045a1
  8036de:	e8 4c 04 00 00       	call   803b2f <_panic>
  8036e3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ec:	89 50 04             	mov    %edx,0x4(%eax)
  8036ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f2:	8b 40 04             	mov    0x4(%eax),%eax
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	74 0c                	je     803705 <realloc_block_FF+0x38e>
  8036f9:	a1 30 50 80 00       	mov    0x805030,%eax
  8036fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803701:	89 10                	mov    %edx,(%eax)
  803703:	eb 08                	jmp    80370d <realloc_block_FF+0x396>
  803705:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803708:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80370d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803710:	a3 30 50 80 00       	mov    %eax,0x805030
  803715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803718:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371e:	a1 38 50 80 00       	mov    0x805038,%eax
  803723:	40                   	inc    %eax
  803724:	a3 38 50 80 00       	mov    %eax,0x805038
  803729:	e9 cc 00 00 00       	jmp    8037fa <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80372e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803735:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80373a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80373d:	e9 8a 00 00 00       	jmp    8037cc <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803745:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803748:	73 7a                	jae    8037c4 <realloc_block_FF+0x44d>
  80374a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374d:	8b 00                	mov    (%eax),%eax
  80374f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803752:	73 70                	jae    8037c4 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803758:	74 06                	je     803760 <realloc_block_FF+0x3e9>
  80375a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80375e:	75 17                	jne    803777 <realloc_block_FF+0x400>
  803760:	83 ec 04             	sub    $0x4,%esp
  803763:	68 14 46 80 00       	push   $0x804614
  803768:	68 1a 02 00 00       	push   $0x21a
  80376d:	68 a1 45 80 00       	push   $0x8045a1
  803772:	e8 b8 03 00 00       	call   803b2f <_panic>
  803777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377a:	8b 10                	mov    (%eax),%edx
  80377c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80377f:	89 10                	mov    %edx,(%eax)
  803781:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803784:	8b 00                	mov    (%eax),%eax
  803786:	85 c0                	test   %eax,%eax
  803788:	74 0b                	je     803795 <realloc_block_FF+0x41e>
  80378a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378d:	8b 00                	mov    (%eax),%eax
  80378f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803792:	89 50 04             	mov    %edx,0x4(%eax)
  803795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803798:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80379b:	89 10                	mov    %edx,(%eax)
  80379d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a3:	89 50 04             	mov    %edx,0x4(%eax)
  8037a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a9:	8b 00                	mov    (%eax),%eax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	75 08                	jne    8037b7 <realloc_block_FF+0x440>
  8037af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8037b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8037bc:	40                   	inc    %eax
  8037bd:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8037c2:	eb 36                	jmp    8037fa <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037c4:	a1 34 50 80 00       	mov    0x805034,%eax
  8037c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d0:	74 07                	je     8037d9 <realloc_block_FF+0x462>
  8037d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d5:	8b 00                	mov    (%eax),%eax
  8037d7:	eb 05                	jmp    8037de <realloc_block_FF+0x467>
  8037d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037de:	a3 34 50 80 00       	mov    %eax,0x805034
  8037e3:	a1 34 50 80 00       	mov    0x805034,%eax
  8037e8:	85 c0                	test   %eax,%eax
  8037ea:	0f 85 52 ff ff ff    	jne    803742 <realloc_block_FF+0x3cb>
  8037f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f4:	0f 85 48 ff ff ff    	jne    803742 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8037fa:	83 ec 04             	sub    $0x4,%esp
  8037fd:	6a 00                	push   $0x0
  8037ff:	ff 75 d8             	pushl  -0x28(%ebp)
  803802:	ff 75 d4             	pushl  -0x2c(%ebp)
  803805:	e8 9d eb ff ff       	call   8023a7 <set_block_data>
  80380a:	83 c4 10             	add    $0x10,%esp
				return va;
  80380d:	8b 45 08             	mov    0x8(%ebp),%eax
  803810:	e9 6b 02 00 00       	jmp    803a80 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803815:	8b 45 08             	mov    0x8(%ebp),%eax
  803818:	e9 63 02 00 00       	jmp    803a80 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80381d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803820:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803823:	0f 86 4d 02 00 00    	jbe    803a76 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803829:	83 ec 0c             	sub    $0xc,%esp
  80382c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80382f:	e8 3b e8 ff ff       	call   80206f <is_free_block>
  803834:	83 c4 10             	add    $0x10,%esp
  803837:	84 c0                	test   %al,%al
  803839:	0f 84 37 02 00 00    	je     803a76 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80383f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803842:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803845:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803848:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80384b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80384e:	76 38                	jbe    803888 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803850:	83 ec 0c             	sub    $0xc,%esp
  803853:	ff 75 0c             	pushl  0xc(%ebp)
  803856:	e8 7b eb ff ff       	call   8023d6 <alloc_block_FF>
  80385b:	83 c4 10             	add    $0x10,%esp
  80385e:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803861:	83 ec 08             	sub    $0x8,%esp
  803864:	ff 75 c0             	pushl  -0x40(%ebp)
  803867:	ff 75 08             	pushl  0x8(%ebp)
  80386a:	e8 c9 fa ff ff       	call   803338 <copy_data>
  80386f:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803872:	83 ec 0c             	sub    $0xc,%esp
  803875:	ff 75 08             	pushl  0x8(%ebp)
  803878:	e8 fa f9 ff ff       	call   803277 <free_block>
  80387d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803880:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803883:	e9 f8 01 00 00       	jmp    803a80 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803888:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80388b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80388e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803891:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803895:	0f 87 a0 00 00 00    	ja     80393b <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80389b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80389f:	75 17                	jne    8038b8 <realloc_block_FF+0x541>
  8038a1:	83 ec 04             	sub    $0x4,%esp
  8038a4:	68 83 45 80 00       	push   $0x804583
  8038a9:	68 38 02 00 00       	push   $0x238
  8038ae:	68 a1 45 80 00       	push   $0x8045a1
  8038b3:	e8 77 02 00 00       	call   803b2f <_panic>
  8038b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bb:	8b 00                	mov    (%eax),%eax
  8038bd:	85 c0                	test   %eax,%eax
  8038bf:	74 10                	je     8038d1 <realloc_block_FF+0x55a>
  8038c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c4:	8b 00                	mov    (%eax),%eax
  8038c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c9:	8b 52 04             	mov    0x4(%edx),%edx
  8038cc:	89 50 04             	mov    %edx,0x4(%eax)
  8038cf:	eb 0b                	jmp    8038dc <realloc_block_FF+0x565>
  8038d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d4:	8b 40 04             	mov    0x4(%eax),%eax
  8038d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8038dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038df:	8b 40 04             	mov    0x4(%eax),%eax
  8038e2:	85 c0                	test   %eax,%eax
  8038e4:	74 0f                	je     8038f5 <realloc_block_FF+0x57e>
  8038e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e9:	8b 40 04             	mov    0x4(%eax),%eax
  8038ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ef:	8b 12                	mov    (%edx),%edx
  8038f1:	89 10                	mov    %edx,(%eax)
  8038f3:	eb 0a                	jmp    8038ff <realloc_block_FF+0x588>
  8038f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f8:	8b 00                	mov    (%eax),%eax
  8038fa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803902:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803908:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803912:	a1 38 50 80 00       	mov    0x805038,%eax
  803917:	48                   	dec    %eax
  803918:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80391d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803923:	01 d0                	add    %edx,%eax
  803925:	83 ec 04             	sub    $0x4,%esp
  803928:	6a 01                	push   $0x1
  80392a:	50                   	push   %eax
  80392b:	ff 75 08             	pushl  0x8(%ebp)
  80392e:	e8 74 ea ff ff       	call   8023a7 <set_block_data>
  803933:	83 c4 10             	add    $0x10,%esp
  803936:	e9 36 01 00 00       	jmp    803a71 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80393b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80393e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803941:	01 d0                	add    %edx,%eax
  803943:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803946:	83 ec 04             	sub    $0x4,%esp
  803949:	6a 01                	push   $0x1
  80394b:	ff 75 f0             	pushl  -0x10(%ebp)
  80394e:	ff 75 08             	pushl  0x8(%ebp)
  803951:	e8 51 ea ff ff       	call   8023a7 <set_block_data>
  803956:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803959:	8b 45 08             	mov    0x8(%ebp),%eax
  80395c:	83 e8 04             	sub    $0x4,%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	83 e0 fe             	and    $0xfffffffe,%eax
  803964:	89 c2                	mov    %eax,%edx
  803966:	8b 45 08             	mov    0x8(%ebp),%eax
  803969:	01 d0                	add    %edx,%eax
  80396b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80396e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803972:	74 06                	je     80397a <realloc_block_FF+0x603>
  803974:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803978:	75 17                	jne    803991 <realloc_block_FF+0x61a>
  80397a:	83 ec 04             	sub    $0x4,%esp
  80397d:	68 14 46 80 00       	push   $0x804614
  803982:	68 44 02 00 00       	push   $0x244
  803987:	68 a1 45 80 00       	push   $0x8045a1
  80398c:	e8 9e 01 00 00       	call   803b2f <_panic>
  803991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803994:	8b 10                	mov    (%eax),%edx
  803996:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803999:	89 10                	mov    %edx,(%eax)
  80399b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80399e:	8b 00                	mov    (%eax),%eax
  8039a0:	85 c0                	test   %eax,%eax
  8039a2:	74 0b                	je     8039af <realloc_block_FF+0x638>
  8039a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039ac:	89 50 04             	mov    %edx,0x4(%eax)
  8039af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039b5:	89 10                	mov    %edx,(%eax)
  8039b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039bd:	89 50 04             	mov    %edx,0x4(%eax)
  8039c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039c3:	8b 00                	mov    (%eax),%eax
  8039c5:	85 c0                	test   %eax,%eax
  8039c7:	75 08                	jne    8039d1 <realloc_block_FF+0x65a>
  8039c9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8039d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8039d6:	40                   	inc    %eax
  8039d7:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039e0:	75 17                	jne    8039f9 <realloc_block_FF+0x682>
  8039e2:	83 ec 04             	sub    $0x4,%esp
  8039e5:	68 83 45 80 00       	push   $0x804583
  8039ea:	68 45 02 00 00       	push   $0x245
  8039ef:	68 a1 45 80 00       	push   $0x8045a1
  8039f4:	e8 36 01 00 00       	call   803b2f <_panic>
  8039f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fc:	8b 00                	mov    (%eax),%eax
  8039fe:	85 c0                	test   %eax,%eax
  803a00:	74 10                	je     803a12 <realloc_block_FF+0x69b>
  803a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a05:	8b 00                	mov    (%eax),%eax
  803a07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a0a:	8b 52 04             	mov    0x4(%edx),%edx
  803a0d:	89 50 04             	mov    %edx,0x4(%eax)
  803a10:	eb 0b                	jmp    803a1d <realloc_block_FF+0x6a6>
  803a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a15:	8b 40 04             	mov    0x4(%eax),%eax
  803a18:	a3 30 50 80 00       	mov    %eax,0x805030
  803a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a20:	8b 40 04             	mov    0x4(%eax),%eax
  803a23:	85 c0                	test   %eax,%eax
  803a25:	74 0f                	je     803a36 <realloc_block_FF+0x6bf>
  803a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2a:	8b 40 04             	mov    0x4(%eax),%eax
  803a2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a30:	8b 12                	mov    (%edx),%edx
  803a32:	89 10                	mov    %edx,(%eax)
  803a34:	eb 0a                	jmp    803a40 <realloc_block_FF+0x6c9>
  803a36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a39:	8b 00                	mov    (%eax),%eax
  803a3b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a53:	a1 38 50 80 00       	mov    0x805038,%eax
  803a58:	48                   	dec    %eax
  803a59:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a5e:	83 ec 04             	sub    $0x4,%esp
  803a61:	6a 00                	push   $0x0
  803a63:	ff 75 bc             	pushl  -0x44(%ebp)
  803a66:	ff 75 b8             	pushl  -0x48(%ebp)
  803a69:	e8 39 e9 ff ff       	call   8023a7 <set_block_data>
  803a6e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a71:	8b 45 08             	mov    0x8(%ebp),%eax
  803a74:	eb 0a                	jmp    803a80 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a76:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a80:	c9                   	leave  
  803a81:	c3                   	ret    

00803a82 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a82:	55                   	push   %ebp
  803a83:	89 e5                	mov    %esp,%ebp
  803a85:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a88:	83 ec 04             	sub    $0x4,%esp
  803a8b:	68 80 46 80 00       	push   $0x804680
  803a90:	68 58 02 00 00       	push   $0x258
  803a95:	68 a1 45 80 00       	push   $0x8045a1
  803a9a:	e8 90 00 00 00       	call   803b2f <_panic>

00803a9f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a9f:	55                   	push   %ebp
  803aa0:	89 e5                	mov    %esp,%ebp
  803aa2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803aa5:	83 ec 04             	sub    $0x4,%esp
  803aa8:	68 a8 46 80 00       	push   $0x8046a8
  803aad:	68 61 02 00 00       	push   $0x261
  803ab2:	68 a1 45 80 00       	push   $0x8045a1
  803ab7:	e8 73 00 00 00       	call   803b2f <_panic>

00803abc <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803abc:	55                   	push   %ebp
  803abd:	89 e5                	mov    %esp,%ebp
  803abf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803ac2:	83 ec 04             	sub    $0x4,%esp
  803ac5:	68 d0 46 80 00       	push   $0x8046d0
  803aca:	6a 09                	push   $0x9
  803acc:	68 f8 46 80 00       	push   $0x8046f8
  803ad1:	e8 59 00 00 00       	call   803b2f <_panic>

00803ad6 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803ad6:	55                   	push   %ebp
  803ad7:	89 e5                	mov    %esp,%ebp
  803ad9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803adc:	83 ec 04             	sub    $0x4,%esp
  803adf:	68 08 47 80 00       	push   $0x804708
  803ae4:	6a 10                	push   $0x10
  803ae6:	68 f8 46 80 00       	push   $0x8046f8
  803aeb:	e8 3f 00 00 00       	call   803b2f <_panic>

00803af0 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803af0:	55                   	push   %ebp
  803af1:	89 e5                	mov    %esp,%ebp
  803af3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803af6:	83 ec 04             	sub    $0x4,%esp
  803af9:	68 30 47 80 00       	push   $0x804730
  803afe:	6a 18                	push   $0x18
  803b00:	68 f8 46 80 00       	push   $0x8046f8
  803b05:	e8 25 00 00 00       	call   803b2f <_panic>

00803b0a <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803b0a:	55                   	push   %ebp
  803b0b:	89 e5                	mov    %esp,%ebp
  803b0d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803b10:	83 ec 04             	sub    $0x4,%esp
  803b13:	68 58 47 80 00       	push   $0x804758
  803b18:	6a 20                	push   $0x20
  803b1a:	68 f8 46 80 00       	push   $0x8046f8
  803b1f:	e8 0b 00 00 00       	call   803b2f <_panic>

00803b24 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803b24:	55                   	push   %ebp
  803b25:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803b27:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2a:	8b 40 10             	mov    0x10(%eax),%eax
}
  803b2d:	5d                   	pop    %ebp
  803b2e:	c3                   	ret    

00803b2f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803b2f:	55                   	push   %ebp
  803b30:	89 e5                	mov    %esp,%ebp
  803b32:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803b35:	8d 45 10             	lea    0x10(%ebp),%eax
  803b38:	83 c0 04             	add    $0x4,%eax
  803b3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803b3e:	a1 60 50 98 00       	mov    0x985060,%eax
  803b43:	85 c0                	test   %eax,%eax
  803b45:	74 16                	je     803b5d <_panic+0x2e>
		cprintf("%s: ", argv0);
  803b47:	a1 60 50 98 00       	mov    0x985060,%eax
  803b4c:	83 ec 08             	sub    $0x8,%esp
  803b4f:	50                   	push   %eax
  803b50:	68 80 47 80 00       	push   $0x804780
  803b55:	e8 06 cc ff ff       	call   800760 <cprintf>
  803b5a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803b5d:	a1 00 50 80 00       	mov    0x805000,%eax
  803b62:	ff 75 0c             	pushl  0xc(%ebp)
  803b65:	ff 75 08             	pushl  0x8(%ebp)
  803b68:	50                   	push   %eax
  803b69:	68 85 47 80 00       	push   $0x804785
  803b6e:	e8 ed cb ff ff       	call   800760 <cprintf>
  803b73:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803b76:	8b 45 10             	mov    0x10(%ebp),%eax
  803b79:	83 ec 08             	sub    $0x8,%esp
  803b7c:	ff 75 f4             	pushl  -0xc(%ebp)
  803b7f:	50                   	push   %eax
  803b80:	e8 70 cb ff ff       	call   8006f5 <vcprintf>
  803b85:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803b88:	83 ec 08             	sub    $0x8,%esp
  803b8b:	6a 00                	push   $0x0
  803b8d:	68 a1 47 80 00       	push   $0x8047a1
  803b92:	e8 5e cb ff ff       	call   8006f5 <vcprintf>
  803b97:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803b9a:	e8 df ca ff ff       	call   80067e <exit>

	// should not return here
	while (1) ;
  803b9f:	eb fe                	jmp    803b9f <_panic+0x70>

00803ba1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803ba1:	55                   	push   %ebp
  803ba2:	89 e5                	mov    %esp,%ebp
  803ba4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803ba7:	a1 20 50 80 00       	mov    0x805020,%eax
  803bac:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb5:	39 c2                	cmp    %eax,%edx
  803bb7:	74 14                	je     803bcd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803bb9:	83 ec 04             	sub    $0x4,%esp
  803bbc:	68 a4 47 80 00       	push   $0x8047a4
  803bc1:	6a 26                	push   $0x26
  803bc3:	68 f0 47 80 00       	push   $0x8047f0
  803bc8:	e8 62 ff ff ff       	call   803b2f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803bcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803bd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803bdb:	e9 c5 00 00 00       	jmp    803ca5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803be3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803bea:	8b 45 08             	mov    0x8(%ebp),%eax
  803bed:	01 d0                	add    %edx,%eax
  803bef:	8b 00                	mov    (%eax),%eax
  803bf1:	85 c0                	test   %eax,%eax
  803bf3:	75 08                	jne    803bfd <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803bf5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803bf8:	e9 a5 00 00 00       	jmp    803ca2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803bfd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803c0b:	eb 69                	jmp    803c76 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803c0d:	a1 20 50 80 00       	mov    0x805020,%eax
  803c12:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c1b:	89 d0                	mov    %edx,%eax
  803c1d:	01 c0                	add    %eax,%eax
  803c1f:	01 d0                	add    %edx,%eax
  803c21:	c1 e0 03             	shl    $0x3,%eax
  803c24:	01 c8                	add    %ecx,%eax
  803c26:	8a 40 04             	mov    0x4(%eax),%al
  803c29:	84 c0                	test   %al,%al
  803c2b:	75 46                	jne    803c73 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803c2d:	a1 20 50 80 00       	mov    0x805020,%eax
  803c32:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c38:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c3b:	89 d0                	mov    %edx,%eax
  803c3d:	01 c0                	add    %eax,%eax
  803c3f:	01 d0                	add    %edx,%eax
  803c41:	c1 e0 03             	shl    $0x3,%eax
  803c44:	01 c8                	add    %ecx,%eax
  803c46:	8b 00                	mov    (%eax),%eax
  803c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803c4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803c53:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c58:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c62:	01 c8                	add    %ecx,%eax
  803c64:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803c66:	39 c2                	cmp    %eax,%edx
  803c68:	75 09                	jne    803c73 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803c6a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803c71:	eb 15                	jmp    803c88 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c73:	ff 45 e8             	incl   -0x18(%ebp)
  803c76:	a1 20 50 80 00       	mov    0x805020,%eax
  803c7b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c84:	39 c2                	cmp    %eax,%edx
  803c86:	77 85                	ja     803c0d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803c88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c8c:	75 14                	jne    803ca2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803c8e:	83 ec 04             	sub    $0x4,%esp
  803c91:	68 fc 47 80 00       	push   $0x8047fc
  803c96:	6a 3a                	push   $0x3a
  803c98:	68 f0 47 80 00       	push   $0x8047f0
  803c9d:	e8 8d fe ff ff       	call   803b2f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803ca2:	ff 45 f0             	incl   -0x10(%ebp)
  803ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803cab:	0f 8c 2f ff ff ff    	jl     803be0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803cb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803cb8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803cbf:	eb 26                	jmp    803ce7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803cc1:	a1 20 50 80 00       	mov    0x805020,%eax
  803cc6:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ccc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ccf:	89 d0                	mov    %edx,%eax
  803cd1:	01 c0                	add    %eax,%eax
  803cd3:	01 d0                	add    %edx,%eax
  803cd5:	c1 e0 03             	shl    $0x3,%eax
  803cd8:	01 c8                	add    %ecx,%eax
  803cda:	8a 40 04             	mov    0x4(%eax),%al
  803cdd:	3c 01                	cmp    $0x1,%al
  803cdf:	75 03                	jne    803ce4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803ce1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ce4:	ff 45 e0             	incl   -0x20(%ebp)
  803ce7:	a1 20 50 80 00       	mov    0x805020,%eax
  803cec:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cf5:	39 c2                	cmp    %eax,%edx
  803cf7:	77 c8                	ja     803cc1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803cff:	74 14                	je     803d15 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803d01:	83 ec 04             	sub    $0x4,%esp
  803d04:	68 50 48 80 00       	push   $0x804850
  803d09:	6a 44                	push   $0x44
  803d0b:	68 f0 47 80 00       	push   $0x8047f0
  803d10:	e8 1a fe ff ff       	call   803b2f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803d15:	90                   	nop
  803d16:	c9                   	leave  
  803d17:	c3                   	ret    

00803d18 <__udivdi3>:
  803d18:	55                   	push   %ebp
  803d19:	57                   	push   %edi
  803d1a:	56                   	push   %esi
  803d1b:	53                   	push   %ebx
  803d1c:	83 ec 1c             	sub    $0x1c,%esp
  803d1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d2f:	89 ca                	mov    %ecx,%edx
  803d31:	89 f8                	mov    %edi,%eax
  803d33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d37:	85 f6                	test   %esi,%esi
  803d39:	75 2d                	jne    803d68 <__udivdi3+0x50>
  803d3b:	39 cf                	cmp    %ecx,%edi
  803d3d:	77 65                	ja     803da4 <__udivdi3+0x8c>
  803d3f:	89 fd                	mov    %edi,%ebp
  803d41:	85 ff                	test   %edi,%edi
  803d43:	75 0b                	jne    803d50 <__udivdi3+0x38>
  803d45:	b8 01 00 00 00       	mov    $0x1,%eax
  803d4a:	31 d2                	xor    %edx,%edx
  803d4c:	f7 f7                	div    %edi
  803d4e:	89 c5                	mov    %eax,%ebp
  803d50:	31 d2                	xor    %edx,%edx
  803d52:	89 c8                	mov    %ecx,%eax
  803d54:	f7 f5                	div    %ebp
  803d56:	89 c1                	mov    %eax,%ecx
  803d58:	89 d8                	mov    %ebx,%eax
  803d5a:	f7 f5                	div    %ebp
  803d5c:	89 cf                	mov    %ecx,%edi
  803d5e:	89 fa                	mov    %edi,%edx
  803d60:	83 c4 1c             	add    $0x1c,%esp
  803d63:	5b                   	pop    %ebx
  803d64:	5e                   	pop    %esi
  803d65:	5f                   	pop    %edi
  803d66:	5d                   	pop    %ebp
  803d67:	c3                   	ret    
  803d68:	39 ce                	cmp    %ecx,%esi
  803d6a:	77 28                	ja     803d94 <__udivdi3+0x7c>
  803d6c:	0f bd fe             	bsr    %esi,%edi
  803d6f:	83 f7 1f             	xor    $0x1f,%edi
  803d72:	75 40                	jne    803db4 <__udivdi3+0x9c>
  803d74:	39 ce                	cmp    %ecx,%esi
  803d76:	72 0a                	jb     803d82 <__udivdi3+0x6a>
  803d78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d7c:	0f 87 9e 00 00 00    	ja     803e20 <__udivdi3+0x108>
  803d82:	b8 01 00 00 00       	mov    $0x1,%eax
  803d87:	89 fa                	mov    %edi,%edx
  803d89:	83 c4 1c             	add    $0x1c,%esp
  803d8c:	5b                   	pop    %ebx
  803d8d:	5e                   	pop    %esi
  803d8e:	5f                   	pop    %edi
  803d8f:	5d                   	pop    %ebp
  803d90:	c3                   	ret    
  803d91:	8d 76 00             	lea    0x0(%esi),%esi
  803d94:	31 ff                	xor    %edi,%edi
  803d96:	31 c0                	xor    %eax,%eax
  803d98:	89 fa                	mov    %edi,%edx
  803d9a:	83 c4 1c             	add    $0x1c,%esp
  803d9d:	5b                   	pop    %ebx
  803d9e:	5e                   	pop    %esi
  803d9f:	5f                   	pop    %edi
  803da0:	5d                   	pop    %ebp
  803da1:	c3                   	ret    
  803da2:	66 90                	xchg   %ax,%ax
  803da4:	89 d8                	mov    %ebx,%eax
  803da6:	f7 f7                	div    %edi
  803da8:	31 ff                	xor    %edi,%edi
  803daa:	89 fa                	mov    %edi,%edx
  803dac:	83 c4 1c             	add    $0x1c,%esp
  803daf:	5b                   	pop    %ebx
  803db0:	5e                   	pop    %esi
  803db1:	5f                   	pop    %edi
  803db2:	5d                   	pop    %ebp
  803db3:	c3                   	ret    
  803db4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803db9:	89 eb                	mov    %ebp,%ebx
  803dbb:	29 fb                	sub    %edi,%ebx
  803dbd:	89 f9                	mov    %edi,%ecx
  803dbf:	d3 e6                	shl    %cl,%esi
  803dc1:	89 c5                	mov    %eax,%ebp
  803dc3:	88 d9                	mov    %bl,%cl
  803dc5:	d3 ed                	shr    %cl,%ebp
  803dc7:	89 e9                	mov    %ebp,%ecx
  803dc9:	09 f1                	or     %esi,%ecx
  803dcb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803dcf:	89 f9                	mov    %edi,%ecx
  803dd1:	d3 e0                	shl    %cl,%eax
  803dd3:	89 c5                	mov    %eax,%ebp
  803dd5:	89 d6                	mov    %edx,%esi
  803dd7:	88 d9                	mov    %bl,%cl
  803dd9:	d3 ee                	shr    %cl,%esi
  803ddb:	89 f9                	mov    %edi,%ecx
  803ddd:	d3 e2                	shl    %cl,%edx
  803ddf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803de3:	88 d9                	mov    %bl,%cl
  803de5:	d3 e8                	shr    %cl,%eax
  803de7:	09 c2                	or     %eax,%edx
  803de9:	89 d0                	mov    %edx,%eax
  803deb:	89 f2                	mov    %esi,%edx
  803ded:	f7 74 24 0c          	divl   0xc(%esp)
  803df1:	89 d6                	mov    %edx,%esi
  803df3:	89 c3                	mov    %eax,%ebx
  803df5:	f7 e5                	mul    %ebp
  803df7:	39 d6                	cmp    %edx,%esi
  803df9:	72 19                	jb     803e14 <__udivdi3+0xfc>
  803dfb:	74 0b                	je     803e08 <__udivdi3+0xf0>
  803dfd:	89 d8                	mov    %ebx,%eax
  803dff:	31 ff                	xor    %edi,%edi
  803e01:	e9 58 ff ff ff       	jmp    803d5e <__udivdi3+0x46>
  803e06:	66 90                	xchg   %ax,%ax
  803e08:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e0c:	89 f9                	mov    %edi,%ecx
  803e0e:	d3 e2                	shl    %cl,%edx
  803e10:	39 c2                	cmp    %eax,%edx
  803e12:	73 e9                	jae    803dfd <__udivdi3+0xe5>
  803e14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e17:	31 ff                	xor    %edi,%edi
  803e19:	e9 40 ff ff ff       	jmp    803d5e <__udivdi3+0x46>
  803e1e:	66 90                	xchg   %ax,%ax
  803e20:	31 c0                	xor    %eax,%eax
  803e22:	e9 37 ff ff ff       	jmp    803d5e <__udivdi3+0x46>
  803e27:	90                   	nop

00803e28 <__umoddi3>:
  803e28:	55                   	push   %ebp
  803e29:	57                   	push   %edi
  803e2a:	56                   	push   %esi
  803e2b:	53                   	push   %ebx
  803e2c:	83 ec 1c             	sub    $0x1c,%esp
  803e2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e33:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e47:	89 f3                	mov    %esi,%ebx
  803e49:	89 fa                	mov    %edi,%edx
  803e4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e4f:	89 34 24             	mov    %esi,(%esp)
  803e52:	85 c0                	test   %eax,%eax
  803e54:	75 1a                	jne    803e70 <__umoddi3+0x48>
  803e56:	39 f7                	cmp    %esi,%edi
  803e58:	0f 86 a2 00 00 00    	jbe    803f00 <__umoddi3+0xd8>
  803e5e:	89 c8                	mov    %ecx,%eax
  803e60:	89 f2                	mov    %esi,%edx
  803e62:	f7 f7                	div    %edi
  803e64:	89 d0                	mov    %edx,%eax
  803e66:	31 d2                	xor    %edx,%edx
  803e68:	83 c4 1c             	add    $0x1c,%esp
  803e6b:	5b                   	pop    %ebx
  803e6c:	5e                   	pop    %esi
  803e6d:	5f                   	pop    %edi
  803e6e:	5d                   	pop    %ebp
  803e6f:	c3                   	ret    
  803e70:	39 f0                	cmp    %esi,%eax
  803e72:	0f 87 ac 00 00 00    	ja     803f24 <__umoddi3+0xfc>
  803e78:	0f bd e8             	bsr    %eax,%ebp
  803e7b:	83 f5 1f             	xor    $0x1f,%ebp
  803e7e:	0f 84 ac 00 00 00    	je     803f30 <__umoddi3+0x108>
  803e84:	bf 20 00 00 00       	mov    $0x20,%edi
  803e89:	29 ef                	sub    %ebp,%edi
  803e8b:	89 fe                	mov    %edi,%esi
  803e8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e91:	89 e9                	mov    %ebp,%ecx
  803e93:	d3 e0                	shl    %cl,%eax
  803e95:	89 d7                	mov    %edx,%edi
  803e97:	89 f1                	mov    %esi,%ecx
  803e99:	d3 ef                	shr    %cl,%edi
  803e9b:	09 c7                	or     %eax,%edi
  803e9d:	89 e9                	mov    %ebp,%ecx
  803e9f:	d3 e2                	shl    %cl,%edx
  803ea1:	89 14 24             	mov    %edx,(%esp)
  803ea4:	89 d8                	mov    %ebx,%eax
  803ea6:	d3 e0                	shl    %cl,%eax
  803ea8:	89 c2                	mov    %eax,%edx
  803eaa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eae:	d3 e0                	shl    %cl,%eax
  803eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803eb4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eb8:	89 f1                	mov    %esi,%ecx
  803eba:	d3 e8                	shr    %cl,%eax
  803ebc:	09 d0                	or     %edx,%eax
  803ebe:	d3 eb                	shr    %cl,%ebx
  803ec0:	89 da                	mov    %ebx,%edx
  803ec2:	f7 f7                	div    %edi
  803ec4:	89 d3                	mov    %edx,%ebx
  803ec6:	f7 24 24             	mull   (%esp)
  803ec9:	89 c6                	mov    %eax,%esi
  803ecb:	89 d1                	mov    %edx,%ecx
  803ecd:	39 d3                	cmp    %edx,%ebx
  803ecf:	0f 82 87 00 00 00    	jb     803f5c <__umoddi3+0x134>
  803ed5:	0f 84 91 00 00 00    	je     803f6c <__umoddi3+0x144>
  803edb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803edf:	29 f2                	sub    %esi,%edx
  803ee1:	19 cb                	sbb    %ecx,%ebx
  803ee3:	89 d8                	mov    %ebx,%eax
  803ee5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ee9:	d3 e0                	shl    %cl,%eax
  803eeb:	89 e9                	mov    %ebp,%ecx
  803eed:	d3 ea                	shr    %cl,%edx
  803eef:	09 d0                	or     %edx,%eax
  803ef1:	89 e9                	mov    %ebp,%ecx
  803ef3:	d3 eb                	shr    %cl,%ebx
  803ef5:	89 da                	mov    %ebx,%edx
  803ef7:	83 c4 1c             	add    $0x1c,%esp
  803efa:	5b                   	pop    %ebx
  803efb:	5e                   	pop    %esi
  803efc:	5f                   	pop    %edi
  803efd:	5d                   	pop    %ebp
  803efe:	c3                   	ret    
  803eff:	90                   	nop
  803f00:	89 fd                	mov    %edi,%ebp
  803f02:	85 ff                	test   %edi,%edi
  803f04:	75 0b                	jne    803f11 <__umoddi3+0xe9>
  803f06:	b8 01 00 00 00       	mov    $0x1,%eax
  803f0b:	31 d2                	xor    %edx,%edx
  803f0d:	f7 f7                	div    %edi
  803f0f:	89 c5                	mov    %eax,%ebp
  803f11:	89 f0                	mov    %esi,%eax
  803f13:	31 d2                	xor    %edx,%edx
  803f15:	f7 f5                	div    %ebp
  803f17:	89 c8                	mov    %ecx,%eax
  803f19:	f7 f5                	div    %ebp
  803f1b:	89 d0                	mov    %edx,%eax
  803f1d:	e9 44 ff ff ff       	jmp    803e66 <__umoddi3+0x3e>
  803f22:	66 90                	xchg   %ax,%ax
  803f24:	89 c8                	mov    %ecx,%eax
  803f26:	89 f2                	mov    %esi,%edx
  803f28:	83 c4 1c             	add    $0x1c,%esp
  803f2b:	5b                   	pop    %ebx
  803f2c:	5e                   	pop    %esi
  803f2d:	5f                   	pop    %edi
  803f2e:	5d                   	pop    %ebp
  803f2f:	c3                   	ret    
  803f30:	3b 04 24             	cmp    (%esp),%eax
  803f33:	72 06                	jb     803f3b <__umoddi3+0x113>
  803f35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f39:	77 0f                	ja     803f4a <__umoddi3+0x122>
  803f3b:	89 f2                	mov    %esi,%edx
  803f3d:	29 f9                	sub    %edi,%ecx
  803f3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f43:	89 14 24             	mov    %edx,(%esp)
  803f46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f4e:	8b 14 24             	mov    (%esp),%edx
  803f51:	83 c4 1c             	add    $0x1c,%esp
  803f54:	5b                   	pop    %ebx
  803f55:	5e                   	pop    %esi
  803f56:	5f                   	pop    %edi
  803f57:	5d                   	pop    %ebp
  803f58:	c3                   	ret    
  803f59:	8d 76 00             	lea    0x0(%esi),%esi
  803f5c:	2b 04 24             	sub    (%esp),%eax
  803f5f:	19 fa                	sbb    %edi,%edx
  803f61:	89 d1                	mov    %edx,%ecx
  803f63:	89 c6                	mov    %eax,%esi
  803f65:	e9 71 ff ff ff       	jmp    803edb <__umoddi3+0xb3>
  803f6a:	66 90                	xchg   %ax,%ax
  803f6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f70:	72 ea                	jb     803f5c <__umoddi3+0x134>
  803f72:	89 d9                	mov    %ebx,%ecx
  803f74:	e9 62 ff ff ff       	jmp    803edb <__umoddi3+0xb3>
