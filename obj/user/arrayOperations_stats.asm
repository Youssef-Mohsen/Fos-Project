
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
  800054:	68 80 41 80 00       	push   $0x804180
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 6a 3b 00 00       	call   803bcc <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 86 41 80 00       	push   $0x804186
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 53 3b 00 00       	call   803bcc <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 c8             	pushl  -0x38(%ebp)
  800082:	e8 90 3b 00 00       	call   803c17 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80008a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800091:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  800098:	83 ec 08             	sub    $0x8,%esp
  80009b:	68 8f 41 80 00       	push   $0x80418f
  8000a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a3:	e8 2b 18 00 00       	call   8018d3 <sget>
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	68 93 41 80 00       	push   $0x804193
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
  8000d2:	68 9b 41 80 00       	push   $0x80419b
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
  800145:	68 a4 41 80 00       	push   $0x8041a4
  80014a:	e8 11 06 00 00       	call   800760 <cprintf>
  80014f:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 c9 41 80 00       	push   $0x8041c9
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
  800178:	68 ce 41 80 00       	push   $0x8041ce
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
  800197:	68 d2 41 80 00       	push   $0x8041d2
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
  8001b6:	68 d6 41 80 00       	push   $0x8041d6
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
  8001d5:	68 da 41 80 00       	push   $0x8041da
  8001da:	e8 4f 16 00 00       	call   80182e <smalloc>
  8001df:	83 c4 10             	add    $0x10,%esp
  8001e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8001e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001eb:	89 10                	mov    %edx,(%eax)

	signal_semaphore(finished);
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	ff 75 c4             	pushl  -0x3c(%ebp)
  8001f3:	e8 a1 3a 00 00       	call   803c99 <signal_semaphore>
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
  8005c9:	68 f8 41 80 00       	push   $0x8041f8
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
  8005f1:	68 20 42 80 00       	push   $0x804220
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
  800622:	68 48 42 80 00       	push   $0x804248
  800627:	e8 34 01 00 00       	call   800760 <cprintf>
  80062c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80062f:	a1 20 50 80 00       	mov    0x805020,%eax
  800634:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	50                   	push   %eax
  80063e:	68 a0 42 80 00       	push   $0x8042a0
  800643:	e8 18 01 00 00       	call   800760 <cprintf>
  800648:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	68 f8 41 80 00       	push   $0x8041f8
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
  8007fd:	e8 fe 36 00 00       	call   803f00 <__udivdi3>
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
  80084d:	e8 be 37 00 00       	call   804010 <__umoddi3>
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	05 d4 44 80 00       	add    $0x8044d4,%eax
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
  8009a8:	8b 04 85 f8 44 80 00 	mov    0x8044f8(,%eax,4),%eax
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
  800a89:	8b 34 9d 40 43 80 00 	mov    0x804340(,%ebx,4),%esi
  800a90:	85 f6                	test   %esi,%esi
  800a92:	75 19                	jne    800aad <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a94:	53                   	push   %ebx
  800a95:	68 e5 44 80 00       	push   $0x8044e5
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
  800aae:	68 ee 44 80 00       	push   $0x8044ee
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
  800adb:	be f1 44 80 00       	mov    $0x8044f1,%esi
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
  8014e6:	68 68 46 80 00       	push   $0x804668
  8014eb:	68 3f 01 00 00       	push   $0x13f
  8014f0:	68 8a 46 80 00       	push   $0x80468a
  8014f5:	e8 1c 28 00 00       	call   803d16 <_panic>

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
  801590:	e8 dd 0e 00 00       	call   802472 <alloc_block_FF>
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
  8015b3:	e8 76 13 00 00       	call   80292e <alloc_block_BF>
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
  801761:	e8 8c 09 00 00       	call   8020f2 <get_block_size>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	e8 9c 1b 00 00       	call   803313 <free_block>
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
  801817:	68 98 46 80 00       	push   $0x804698
  80181c:	68 87 00 00 00       	push   $0x87
  801821:	68 c2 46 80 00       	push   $0x8046c2
  801826:	e8 eb 24 00 00       	call   803d16 <_panic>
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
  8019c2:	68 d0 46 80 00       	push   $0x8046d0
  8019c7:	68 e4 00 00 00       	push   $0xe4
  8019cc:	68 c2 46 80 00       	push   $0x8046c2
  8019d1:	e8 40 23 00 00       	call   803d16 <_panic>

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
  8019df:	68 f6 46 80 00       	push   $0x8046f6
  8019e4:	68 f0 00 00 00       	push   $0xf0
  8019e9:	68 c2 46 80 00       	push   $0x8046c2
  8019ee:	e8 23 23 00 00       	call   803d16 <_panic>

008019f3 <shrink>:

}
void shrink(uint32 newSize)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019f9:	83 ec 04             	sub    $0x4,%esp
  8019fc:	68 f6 46 80 00       	push   $0x8046f6
  801a01:	68 f5 00 00 00       	push   $0xf5
  801a06:	68 c2 46 80 00       	push   $0x8046c2
  801a0b:	e8 06 23 00 00       	call   803d16 <_panic>

00801a10 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	68 f6 46 80 00       	push   $0x8046f6
  801a1e:	68 fa 00 00 00       	push   $0xfa
  801a23:	68 c2 46 80 00       	push   $0x8046c2
  801a28:	e8 e9 22 00 00       	call   803d16 <_panic>

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

00802056 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 2e                	push   $0x2e
  802068:	e8 c0 f9 ff ff       	call   801a2d <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
  802070:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802073:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	50                   	push   %eax
  802087:	6a 2f                	push   $0x2f
  802089:	e8 9f f9 ff ff       	call   801a2d <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
	return;
  802091:	90                   	nop
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	52                   	push   %edx
  8020a4:	50                   	push   %eax
  8020a5:	6a 30                	push   $0x30
  8020a7:	e8 81 f9 ff ff       	call   801a2d <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
	return;
  8020af:	90                   	nop
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	50                   	push   %eax
  8020c4:	6a 31                	push   $0x31
  8020c6:	e8 62 f9 ff ff       	call   801a2d <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
  8020ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8020d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	50                   	push   %eax
  8020e5:	6a 32                	push   $0x32
  8020e7:	e8 41 f9 ff ff       	call   801a2d <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
	return;
  8020ef:	90                   	nop
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	83 e8 04             	sub    $0x4,%eax
  8020fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802101:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802104:	8b 00                	mov    (%eax),%eax
  802106:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	83 e8 04             	sub    $0x4,%eax
  802117:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80211a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211d:	8b 00                	mov    (%eax),%eax
  80211f:	83 e0 01             	and    $0x1,%eax
  802122:	85 c0                	test   %eax,%eax
  802124:	0f 94 c0             	sete   %al
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80212f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802136:	8b 45 0c             	mov    0xc(%ebp),%eax
  802139:	83 f8 02             	cmp    $0x2,%eax
  80213c:	74 2b                	je     802169 <alloc_block+0x40>
  80213e:	83 f8 02             	cmp    $0x2,%eax
  802141:	7f 07                	jg     80214a <alloc_block+0x21>
  802143:	83 f8 01             	cmp    $0x1,%eax
  802146:	74 0e                	je     802156 <alloc_block+0x2d>
  802148:	eb 58                	jmp    8021a2 <alloc_block+0x79>
  80214a:	83 f8 03             	cmp    $0x3,%eax
  80214d:	74 2d                	je     80217c <alloc_block+0x53>
  80214f:	83 f8 04             	cmp    $0x4,%eax
  802152:	74 3b                	je     80218f <alloc_block+0x66>
  802154:	eb 4c                	jmp    8021a2 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	ff 75 08             	pushl  0x8(%ebp)
  80215c:	e8 11 03 00 00       	call   802472 <alloc_block_FF>
  802161:	83 c4 10             	add    $0x10,%esp
  802164:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802167:	eb 4a                	jmp    8021b3 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802169:	83 ec 0c             	sub    $0xc,%esp
  80216c:	ff 75 08             	pushl  0x8(%ebp)
  80216f:	e8 c7 19 00 00       	call   803b3b <alloc_block_NF>
  802174:	83 c4 10             	add    $0x10,%esp
  802177:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80217a:	eb 37                	jmp    8021b3 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	ff 75 08             	pushl  0x8(%ebp)
  802182:	e8 a7 07 00 00       	call   80292e <alloc_block_BF>
  802187:	83 c4 10             	add    $0x10,%esp
  80218a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80218d:	eb 24                	jmp    8021b3 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80218f:	83 ec 0c             	sub    $0xc,%esp
  802192:	ff 75 08             	pushl  0x8(%ebp)
  802195:	e8 84 19 00 00       	call   803b1e <alloc_block_WF>
  80219a:	83 c4 10             	add    $0x10,%esp
  80219d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021a0:	eb 11                	jmp    8021b3 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8021a2:	83 ec 0c             	sub    $0xc,%esp
  8021a5:	68 08 47 80 00       	push   $0x804708
  8021aa:	e8 b1 e5 ff ff       	call   800760 <cprintf>
  8021af:	83 c4 10             	add    $0x10,%esp
		break;
  8021b2:	90                   	nop
	}
	return va;
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	53                   	push   %ebx
  8021bc:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021bf:	83 ec 0c             	sub    $0xc,%esp
  8021c2:	68 28 47 80 00       	push   $0x804728
  8021c7:	e8 94 e5 ff ff       	call   800760 <cprintf>
  8021cc:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021cf:	83 ec 0c             	sub    $0xc,%esp
  8021d2:	68 53 47 80 00       	push   $0x804753
  8021d7:	e8 84 e5 ff ff       	call   800760 <cprintf>
  8021dc:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e5:	eb 37                	jmp    80221e <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021e7:	83 ec 0c             	sub    $0xc,%esp
  8021ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ed:	e8 19 ff ff ff       	call   80210b <is_free_block>
  8021f2:	83 c4 10             	add    $0x10,%esp
  8021f5:	0f be d8             	movsbl %al,%ebx
  8021f8:	83 ec 0c             	sub    $0xc,%esp
  8021fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8021fe:	e8 ef fe ff ff       	call   8020f2 <get_block_size>
  802203:	83 c4 10             	add    $0x10,%esp
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	53                   	push   %ebx
  80220a:	50                   	push   %eax
  80220b:	68 6b 47 80 00       	push   $0x80476b
  802210:	e8 4b e5 ff ff       	call   800760 <cprintf>
  802215:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802218:	8b 45 10             	mov    0x10(%ebp),%eax
  80221b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802222:	74 07                	je     80222b <print_blocks_list+0x73>
  802224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802227:	8b 00                	mov    (%eax),%eax
  802229:	eb 05                	jmp    802230 <print_blocks_list+0x78>
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
  802230:	89 45 10             	mov    %eax,0x10(%ebp)
  802233:	8b 45 10             	mov    0x10(%ebp),%eax
  802236:	85 c0                	test   %eax,%eax
  802238:	75 ad                	jne    8021e7 <print_blocks_list+0x2f>
  80223a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223e:	75 a7                	jne    8021e7 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802240:	83 ec 0c             	sub    $0xc,%esp
  802243:	68 28 47 80 00       	push   $0x804728
  802248:	e8 13 e5 ff ff       	call   800760 <cprintf>
  80224d:	83 c4 10             	add    $0x10,%esp

}
  802250:	90                   	nop
  802251:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80225c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225f:	83 e0 01             	and    $0x1,%eax
  802262:	85 c0                	test   %eax,%eax
  802264:	74 03                	je     802269 <initialize_dynamic_allocator+0x13>
  802266:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802269:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80226d:	0f 84 c7 01 00 00    	je     80243a <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802273:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80227a:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80227d:	8b 55 08             	mov    0x8(%ebp),%edx
  802280:	8b 45 0c             	mov    0xc(%ebp),%eax
  802283:	01 d0                	add    %edx,%eax
  802285:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80228a:	0f 87 ad 01 00 00    	ja     80243d <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	85 c0                	test   %eax,%eax
  802295:	0f 89 a5 01 00 00    	jns    802440 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80229b:	8b 55 08             	mov    0x8(%ebp),%edx
  80229e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a1:	01 d0                	add    %edx,%eax
  8022a3:	83 e8 04             	sub    $0x4,%eax
  8022a6:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022b2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ba:	e9 87 00 00 00       	jmp    802346 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c3:	75 14                	jne    8022d9 <initialize_dynamic_allocator+0x83>
  8022c5:	83 ec 04             	sub    $0x4,%esp
  8022c8:	68 83 47 80 00       	push   $0x804783
  8022cd:	6a 79                	push   $0x79
  8022cf:	68 a1 47 80 00       	push   $0x8047a1
  8022d4:	e8 3d 1a 00 00       	call   803d16 <_panic>
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	74 10                	je     8022f2 <initialize_dynamic_allocator+0x9c>
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 00                	mov    (%eax),%eax
  8022e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ea:	8b 52 04             	mov    0x4(%edx),%edx
  8022ed:	89 50 04             	mov    %edx,0x4(%eax)
  8022f0:	eb 0b                	jmp    8022fd <initialize_dynamic_allocator+0xa7>
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 40 04             	mov    0x4(%eax),%eax
  8022f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 40 04             	mov    0x4(%eax),%eax
  802303:	85 c0                	test   %eax,%eax
  802305:	74 0f                	je     802316 <initialize_dynamic_allocator+0xc0>
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 40 04             	mov    0x4(%eax),%eax
  80230d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802310:	8b 12                	mov    (%edx),%edx
  802312:	89 10                	mov    %edx,(%eax)
  802314:	eb 0a                	jmp    802320 <initialize_dynamic_allocator+0xca>
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 00                	mov    (%eax),%eax
  80231b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802333:	a1 38 50 80 00       	mov    0x805038,%eax
  802338:	48                   	dec    %eax
  802339:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80233e:	a1 34 50 80 00       	mov    0x805034,%eax
  802343:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802346:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234a:	74 07                	je     802353 <initialize_dynamic_allocator+0xfd>
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	eb 05                	jmp    802358 <initialize_dynamic_allocator+0x102>
  802353:	b8 00 00 00 00       	mov    $0x0,%eax
  802358:	a3 34 50 80 00       	mov    %eax,0x805034
  80235d:	a1 34 50 80 00       	mov    0x805034,%eax
  802362:	85 c0                	test   %eax,%eax
  802364:	0f 85 55 ff ff ff    	jne    8022bf <initialize_dynamic_allocator+0x69>
  80236a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236e:	0f 85 4b ff ff ff    	jne    8022bf <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80237a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802383:	a1 44 50 80 00       	mov    0x805044,%eax
  802388:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80238d:	a1 40 50 80 00       	mov    0x805040,%eax
  802392:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	83 c0 08             	add    $0x8,%eax
  80239e:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	83 c0 04             	add    $0x4,%eax
  8023a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023aa:	83 ea 08             	sub    $0x8,%edx
  8023ad:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	01 d0                	add    %edx,%eax
  8023b7:	83 e8 08             	sub    $0x8,%eax
  8023ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023bd:	83 ea 08             	sub    $0x8,%edx
  8023c0:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023d9:	75 17                	jne    8023f2 <initialize_dynamic_allocator+0x19c>
  8023db:	83 ec 04             	sub    $0x4,%esp
  8023de:	68 bc 47 80 00       	push   $0x8047bc
  8023e3:	68 90 00 00 00       	push   $0x90
  8023e8:	68 a1 47 80 00       	push   $0x8047a1
  8023ed:	e8 24 19 00 00       	call   803d16 <_panic>
  8023f2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fb:	89 10                	mov    %edx,(%eax)
  8023fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	74 0d                	je     802413 <initialize_dynamic_allocator+0x1bd>
  802406:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80240b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80240e:	89 50 04             	mov    %edx,0x4(%eax)
  802411:	eb 08                	jmp    80241b <initialize_dynamic_allocator+0x1c5>
  802413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802416:	a3 30 50 80 00       	mov    %eax,0x805030
  80241b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802426:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80242d:	a1 38 50 80 00       	mov    0x805038,%eax
  802432:	40                   	inc    %eax
  802433:	a3 38 50 80 00       	mov    %eax,0x805038
  802438:	eb 07                	jmp    802441 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80243a:	90                   	nop
  80243b:	eb 04                	jmp    802441 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80243d:	90                   	nop
  80243e:	eb 01                	jmp    802441 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802440:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802446:	8b 45 10             	mov    0x10(%ebp),%eax
  802449:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802452:	8b 45 0c             	mov    0xc(%ebp),%eax
  802455:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	83 e8 04             	sub    $0x4,%eax
  80245d:	8b 00                	mov    (%eax),%eax
  80245f:	83 e0 fe             	and    $0xfffffffe,%eax
  802462:	8d 50 f8             	lea    -0x8(%eax),%edx
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	01 c2                	add    %eax,%edx
  80246a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246d:	89 02                	mov    %eax,(%edx)
}
  80246f:	90                   	nop
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    

00802472 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	83 e0 01             	and    $0x1,%eax
  80247e:	85 c0                	test   %eax,%eax
  802480:	74 03                	je     802485 <alloc_block_FF+0x13>
  802482:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802485:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802489:	77 07                	ja     802492 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80248b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802492:	a1 24 50 80 00       	mov    0x805024,%eax
  802497:	85 c0                	test   %eax,%eax
  802499:	75 73                	jne    80250e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	83 c0 10             	add    $0x10,%eax
  8024a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024a4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b1:	01 d0                	add    %edx,%eax
  8024b3:	48                   	dec    %eax
  8024b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8024bf:	f7 75 ec             	divl   -0x14(%ebp)
  8024c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c5:	29 d0                	sub    %edx,%eax
  8024c7:	c1 e8 0c             	shr    $0xc,%eax
  8024ca:	83 ec 0c             	sub    $0xc,%esp
  8024cd:	50                   	push   %eax
  8024ce:	e8 27 f0 ff ff       	call   8014fa <sbrk>
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024d9:	83 ec 0c             	sub    $0xc,%esp
  8024dc:	6a 00                	push   $0x0
  8024de:	e8 17 f0 ff ff       	call   8014fa <sbrk>
  8024e3:	83 c4 10             	add    $0x10,%esp
  8024e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ec:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024ef:	83 ec 08             	sub    $0x8,%esp
  8024f2:	50                   	push   %eax
  8024f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024f6:	e8 5b fd ff ff       	call   802256 <initialize_dynamic_allocator>
  8024fb:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024fe:	83 ec 0c             	sub    $0xc,%esp
  802501:	68 df 47 80 00       	push   $0x8047df
  802506:	e8 55 e2 ff ff       	call   800760 <cprintf>
  80250b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80250e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802512:	75 0a                	jne    80251e <alloc_block_FF+0xac>
	        return NULL;
  802514:	b8 00 00 00 00       	mov    $0x0,%eax
  802519:	e9 0e 04 00 00       	jmp    80292c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80251e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802525:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80252a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252d:	e9 f3 02 00 00       	jmp    802825 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802538:	83 ec 0c             	sub    $0xc,%esp
  80253b:	ff 75 bc             	pushl  -0x44(%ebp)
  80253e:	e8 af fb ff ff       	call   8020f2 <get_block_size>
  802543:	83 c4 10             	add    $0x10,%esp
  802546:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802549:	8b 45 08             	mov    0x8(%ebp),%eax
  80254c:	83 c0 08             	add    $0x8,%eax
  80254f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802552:	0f 87 c5 02 00 00    	ja     80281d <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	83 c0 18             	add    $0x18,%eax
  80255e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802561:	0f 87 19 02 00 00    	ja     802780 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802567:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80256a:	2b 45 08             	sub    0x8(%ebp),%eax
  80256d:	83 e8 08             	sub    $0x8,%eax
  802570:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	8d 50 08             	lea    0x8(%eax),%edx
  802579:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80257c:	01 d0                	add    %edx,%eax
  80257e:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	83 c0 08             	add    $0x8,%eax
  802587:	83 ec 04             	sub    $0x4,%esp
  80258a:	6a 01                	push   $0x1
  80258c:	50                   	push   %eax
  80258d:	ff 75 bc             	pushl  -0x44(%ebp)
  802590:	e8 ae fe ff ff       	call   802443 <set_block_data>
  802595:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	75 68                	jne    80260a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025a2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025a6:	75 17                	jne    8025bf <alloc_block_FF+0x14d>
  8025a8:	83 ec 04             	sub    $0x4,%esp
  8025ab:	68 bc 47 80 00       	push   $0x8047bc
  8025b0:	68 d7 00 00 00       	push   $0xd7
  8025b5:	68 a1 47 80 00       	push   $0x8047a1
  8025ba:	e8 57 17 00 00       	call   803d16 <_panic>
  8025bf:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c8:	89 10                	mov    %edx,(%eax)
  8025ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025cd:	8b 00                	mov    (%eax),%eax
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	74 0d                	je     8025e0 <alloc_block_FF+0x16e>
  8025d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025d8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025db:	89 50 04             	mov    %edx,0x4(%eax)
  8025de:	eb 08                	jmp    8025e8 <alloc_block_FF+0x176>
  8025e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8025e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025eb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8025ff:	40                   	inc    %eax
  802600:	a3 38 50 80 00       	mov    %eax,0x805038
  802605:	e9 dc 00 00 00       	jmp    8026e6 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	75 65                	jne    802678 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802613:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802617:	75 17                	jne    802630 <alloc_block_FF+0x1be>
  802619:	83 ec 04             	sub    $0x4,%esp
  80261c:	68 f0 47 80 00       	push   $0x8047f0
  802621:	68 db 00 00 00       	push   $0xdb
  802626:	68 a1 47 80 00       	push   $0x8047a1
  80262b:	e8 e6 16 00 00       	call   803d16 <_panic>
  802630:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802636:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802639:	89 50 04             	mov    %edx,0x4(%eax)
  80263c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80263f:	8b 40 04             	mov    0x4(%eax),%eax
  802642:	85 c0                	test   %eax,%eax
  802644:	74 0c                	je     802652 <alloc_block_FF+0x1e0>
  802646:	a1 30 50 80 00       	mov    0x805030,%eax
  80264b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80264e:	89 10                	mov    %edx,(%eax)
  802650:	eb 08                	jmp    80265a <alloc_block_FF+0x1e8>
  802652:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802655:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80265a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80265d:	a3 30 50 80 00       	mov    %eax,0x805030
  802662:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802665:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266b:	a1 38 50 80 00       	mov    0x805038,%eax
  802670:	40                   	inc    %eax
  802671:	a3 38 50 80 00       	mov    %eax,0x805038
  802676:	eb 6e                	jmp    8026e6 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	74 06                	je     802684 <alloc_block_FF+0x212>
  80267e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802682:	75 17                	jne    80269b <alloc_block_FF+0x229>
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	68 14 48 80 00       	push   $0x804814
  80268c:	68 df 00 00 00       	push   $0xdf
  802691:	68 a1 47 80 00       	push   $0x8047a1
  802696:	e8 7b 16 00 00       	call   803d16 <_panic>
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 10                	mov    (%eax),%edx
  8026a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a3:	89 10                	mov    %edx,(%eax)
  8026a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	74 0b                	je     8026b9 <alloc_block_FF+0x247>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026b6:	89 50 04             	mov    %edx,0x4(%eax)
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026bf:	89 10                	mov    %edx,(%eax)
  8026c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026cd:	8b 00                	mov    (%eax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	75 08                	jne    8026db <alloc_block_FF+0x269>
  8026d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8026db:	a1 38 50 80 00       	mov    0x805038,%eax
  8026e0:	40                   	inc    %eax
  8026e1:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ea:	75 17                	jne    802703 <alloc_block_FF+0x291>
  8026ec:	83 ec 04             	sub    $0x4,%esp
  8026ef:	68 83 47 80 00       	push   $0x804783
  8026f4:	68 e1 00 00 00       	push   $0xe1
  8026f9:	68 a1 47 80 00       	push   $0x8047a1
  8026fe:	e8 13 16 00 00       	call   803d16 <_panic>
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 00                	mov    (%eax),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 10                	je     80271c <alloc_block_FF+0x2aa>
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802714:	8b 52 04             	mov    0x4(%edx),%edx
  802717:	89 50 04             	mov    %edx,0x4(%eax)
  80271a:	eb 0b                	jmp    802727 <alloc_block_FF+0x2b5>
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 40 04             	mov    0x4(%eax),%eax
  802722:	a3 30 50 80 00       	mov    %eax,0x805030
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 40 04             	mov    0x4(%eax),%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	74 0f                	je     802740 <alloc_block_FF+0x2ce>
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273a:	8b 12                	mov    (%edx),%edx
  80273c:	89 10                	mov    %edx,(%eax)
  80273e:	eb 0a                	jmp    80274a <alloc_block_FF+0x2d8>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275d:	a1 38 50 80 00       	mov    0x805038,%eax
  802762:	48                   	dec    %eax
  802763:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	6a 00                	push   $0x0
  80276d:	ff 75 b4             	pushl  -0x4c(%ebp)
  802770:	ff 75 b0             	pushl  -0x50(%ebp)
  802773:	e8 cb fc ff ff       	call   802443 <set_block_data>
  802778:	83 c4 10             	add    $0x10,%esp
  80277b:	e9 95 00 00 00       	jmp    802815 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802780:	83 ec 04             	sub    $0x4,%esp
  802783:	6a 01                	push   $0x1
  802785:	ff 75 b8             	pushl  -0x48(%ebp)
  802788:	ff 75 bc             	pushl  -0x44(%ebp)
  80278b:	e8 b3 fc ff ff       	call   802443 <set_block_data>
  802790:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802797:	75 17                	jne    8027b0 <alloc_block_FF+0x33e>
  802799:	83 ec 04             	sub    $0x4,%esp
  80279c:	68 83 47 80 00       	push   $0x804783
  8027a1:	68 e8 00 00 00       	push   $0xe8
  8027a6:	68 a1 47 80 00       	push   $0x8047a1
  8027ab:	e8 66 15 00 00       	call   803d16 <_panic>
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 00                	mov    (%eax),%eax
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	74 10                	je     8027c9 <alloc_block_FF+0x357>
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 00                	mov    (%eax),%eax
  8027be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c1:	8b 52 04             	mov    0x4(%edx),%edx
  8027c4:	89 50 04             	mov    %edx,0x4(%eax)
  8027c7:	eb 0b                	jmp    8027d4 <alloc_block_FF+0x362>
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 40 04             	mov    0x4(%eax),%eax
  8027cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 40 04             	mov    0x4(%eax),%eax
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	74 0f                	je     8027ed <alloc_block_FF+0x37b>
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 40 04             	mov    0x4(%eax),%eax
  8027e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e7:	8b 12                	mov    (%edx),%edx
  8027e9:	89 10                	mov    %edx,(%eax)
  8027eb:	eb 0a                	jmp    8027f7 <alloc_block_FF+0x385>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280a:	a1 38 50 80 00       	mov    0x805038,%eax
  80280f:	48                   	dec    %eax
  802810:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802815:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802818:	e9 0f 01 00 00       	jmp    80292c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80281d:	a1 34 50 80 00       	mov    0x805034,%eax
  802822:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802829:	74 07                	je     802832 <alloc_block_FF+0x3c0>
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 00                	mov    (%eax),%eax
  802830:	eb 05                	jmp    802837 <alloc_block_FF+0x3c5>
  802832:	b8 00 00 00 00       	mov    $0x0,%eax
  802837:	a3 34 50 80 00       	mov    %eax,0x805034
  80283c:	a1 34 50 80 00       	mov    0x805034,%eax
  802841:	85 c0                	test   %eax,%eax
  802843:	0f 85 e9 fc ff ff    	jne    802532 <alloc_block_FF+0xc0>
  802849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284d:	0f 85 df fc ff ff    	jne    802532 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802853:	8b 45 08             	mov    0x8(%ebp),%eax
  802856:	83 c0 08             	add    $0x8,%eax
  802859:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80285c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802863:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802866:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802869:	01 d0                	add    %edx,%eax
  80286b:	48                   	dec    %eax
  80286c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80286f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802872:	ba 00 00 00 00       	mov    $0x0,%edx
  802877:	f7 75 d8             	divl   -0x28(%ebp)
  80287a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80287d:	29 d0                	sub    %edx,%eax
  80287f:	c1 e8 0c             	shr    $0xc,%eax
  802882:	83 ec 0c             	sub    $0xc,%esp
  802885:	50                   	push   %eax
  802886:	e8 6f ec ff ff       	call   8014fa <sbrk>
  80288b:	83 c4 10             	add    $0x10,%esp
  80288e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802891:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802895:	75 0a                	jne    8028a1 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802897:	b8 00 00 00 00       	mov    $0x0,%eax
  80289c:	e9 8b 00 00 00       	jmp    80292c <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8028a1:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ae:	01 d0                	add    %edx,%eax
  8028b0:	48                   	dec    %eax
  8028b1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028bc:	f7 75 cc             	divl   -0x34(%ebp)
  8028bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028c2:	29 d0                	sub    %edx,%eax
  8028c4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028ca:	01 d0                	add    %edx,%eax
  8028cc:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028d1:	a1 40 50 80 00       	mov    0x805040,%eax
  8028d6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028dc:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028e9:	01 d0                	add    %edx,%eax
  8028eb:	48                   	dec    %eax
  8028ec:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f7:	f7 75 c4             	divl   -0x3c(%ebp)
  8028fa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028fd:	29 d0                	sub    %edx,%eax
  8028ff:	83 ec 04             	sub    $0x4,%esp
  802902:	6a 01                	push   $0x1
  802904:	50                   	push   %eax
  802905:	ff 75 d0             	pushl  -0x30(%ebp)
  802908:	e8 36 fb ff ff       	call   802443 <set_block_data>
  80290d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802910:	83 ec 0c             	sub    $0xc,%esp
  802913:	ff 75 d0             	pushl  -0x30(%ebp)
  802916:	e8 f8 09 00 00       	call   803313 <free_block>
  80291b:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80291e:	83 ec 0c             	sub    $0xc,%esp
  802921:	ff 75 08             	pushl  0x8(%ebp)
  802924:	e8 49 fb ff ff       	call   802472 <alloc_block_FF>
  802929:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80292c:	c9                   	leave  
  80292d:	c3                   	ret    

0080292e <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80292e:	55                   	push   %ebp
  80292f:	89 e5                	mov    %esp,%ebp
  802931:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802934:	8b 45 08             	mov    0x8(%ebp),%eax
  802937:	83 e0 01             	and    $0x1,%eax
  80293a:	85 c0                	test   %eax,%eax
  80293c:	74 03                	je     802941 <alloc_block_BF+0x13>
  80293e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802941:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802945:	77 07                	ja     80294e <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802947:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80294e:	a1 24 50 80 00       	mov    0x805024,%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	75 73                	jne    8029ca <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	83 c0 10             	add    $0x10,%eax
  80295d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802960:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802967:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80296a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80296d:	01 d0                	add    %edx,%eax
  80296f:	48                   	dec    %eax
  802970:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802973:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802976:	ba 00 00 00 00       	mov    $0x0,%edx
  80297b:	f7 75 e0             	divl   -0x20(%ebp)
  80297e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802981:	29 d0                	sub    %edx,%eax
  802983:	c1 e8 0c             	shr    $0xc,%eax
  802986:	83 ec 0c             	sub    $0xc,%esp
  802989:	50                   	push   %eax
  80298a:	e8 6b eb ff ff       	call   8014fa <sbrk>
  80298f:	83 c4 10             	add    $0x10,%esp
  802992:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802995:	83 ec 0c             	sub    $0xc,%esp
  802998:	6a 00                	push   $0x0
  80299a:	e8 5b eb ff ff       	call   8014fa <sbrk>
  80299f:	83 c4 10             	add    $0x10,%esp
  8029a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029a8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029ab:	83 ec 08             	sub    $0x8,%esp
  8029ae:	50                   	push   %eax
  8029af:	ff 75 d8             	pushl  -0x28(%ebp)
  8029b2:	e8 9f f8 ff ff       	call   802256 <initialize_dynamic_allocator>
  8029b7:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029ba:	83 ec 0c             	sub    $0xc,%esp
  8029bd:	68 df 47 80 00       	push   $0x8047df
  8029c2:	e8 99 dd ff ff       	call   800760 <cprintf>
  8029c7:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029d8:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029e6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ee:	e9 1d 01 00 00       	jmp    802b10 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8029f9:	83 ec 0c             	sub    $0xc,%esp
  8029fc:	ff 75 a8             	pushl  -0x58(%ebp)
  8029ff:	e8 ee f6 ff ff       	call   8020f2 <get_block_size>
  802a04:	83 c4 10             	add    $0x10,%esp
  802a07:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	83 c0 08             	add    $0x8,%eax
  802a10:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a13:	0f 87 ef 00 00 00    	ja     802b08 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a19:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1c:	83 c0 18             	add    $0x18,%eax
  802a1f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a22:	77 1d                	ja     802a41 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a27:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a2a:	0f 86 d8 00 00 00    	jbe    802b08 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a30:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a36:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a3c:	e9 c7 00 00 00       	jmp    802b08 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	83 c0 08             	add    $0x8,%eax
  802a47:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a4a:	0f 85 9d 00 00 00    	jne    802aed <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	6a 01                	push   $0x1
  802a55:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a58:	ff 75 a8             	pushl  -0x58(%ebp)
  802a5b:	e8 e3 f9 ff ff       	call   802443 <set_block_data>
  802a60:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a67:	75 17                	jne    802a80 <alloc_block_BF+0x152>
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	68 83 47 80 00       	push   $0x804783
  802a71:	68 2c 01 00 00       	push   $0x12c
  802a76:	68 a1 47 80 00       	push   $0x8047a1
  802a7b:	e8 96 12 00 00       	call   803d16 <_panic>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 10                	je     802a99 <alloc_block_BF+0x16b>
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a91:	8b 52 04             	mov    0x4(%edx),%edx
  802a94:	89 50 04             	mov    %edx,0x4(%eax)
  802a97:	eb 0b                	jmp    802aa4 <alloc_block_BF+0x176>
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 04             	mov    0x4(%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 0f                	je     802abd <alloc_block_BF+0x18f>
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 40 04             	mov    0x4(%eax),%eax
  802ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab7:	8b 12                	mov    (%edx),%edx
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	eb 0a                	jmp    802ac7 <alloc_block_BF+0x199>
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ada:	a1 38 50 80 00       	mov    0x805038,%eax
  802adf:	48                   	dec    %eax
  802ae0:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802ae5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ae8:	e9 01 04 00 00       	jmp    802eee <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802af3:	76 13                	jbe    802b08 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802af5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802afc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802b02:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b05:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b08:	a1 34 50 80 00       	mov    0x805034,%eax
  802b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b14:	74 07                	je     802b1d <alloc_block_BF+0x1ef>
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 00                	mov    (%eax),%eax
  802b1b:	eb 05                	jmp    802b22 <alloc_block_BF+0x1f4>
  802b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b22:	a3 34 50 80 00       	mov    %eax,0x805034
  802b27:	a1 34 50 80 00       	mov    0x805034,%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	0f 85 bf fe ff ff    	jne    8029f3 <alloc_block_BF+0xc5>
  802b34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b38:	0f 85 b5 fe ff ff    	jne    8029f3 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b42:	0f 84 26 02 00 00    	je     802d6e <alloc_block_BF+0x440>
  802b48:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b4c:	0f 85 1c 02 00 00    	jne    802d6e <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	2b 45 08             	sub    0x8(%ebp),%eax
  802b58:	83 e8 08             	sub    $0x8,%eax
  802b5b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	8d 50 08             	lea    0x8(%eax),%edx
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	01 d0                	add    %edx,%eax
  802b69:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	83 c0 08             	add    $0x8,%eax
  802b72:	83 ec 04             	sub    $0x4,%esp
  802b75:	6a 01                	push   $0x1
  802b77:	50                   	push   %eax
  802b78:	ff 75 f0             	pushl  -0x10(%ebp)
  802b7b:	e8 c3 f8 ff ff       	call   802443 <set_block_data>
  802b80:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	75 68                	jne    802bf5 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b8d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b91:	75 17                	jne    802baa <alloc_block_BF+0x27c>
  802b93:	83 ec 04             	sub    $0x4,%esp
  802b96:	68 bc 47 80 00       	push   $0x8047bc
  802b9b:	68 45 01 00 00       	push   $0x145
  802ba0:	68 a1 47 80 00       	push   $0x8047a1
  802ba5:	e8 6c 11 00 00       	call   803d16 <_panic>
  802baa:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802bb0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb3:	89 10                	mov    %edx,(%eax)
  802bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb8:	8b 00                	mov    (%eax),%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	74 0d                	je     802bcb <alloc_block_BF+0x29d>
  802bbe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bc3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bc6:	89 50 04             	mov    %edx,0x4(%eax)
  802bc9:	eb 08                	jmp    802bd3 <alloc_block_BF+0x2a5>
  802bcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bce:	a3 30 50 80 00       	mov    %eax,0x805030
  802bd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bdb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be5:	a1 38 50 80 00       	mov    0x805038,%eax
  802bea:	40                   	inc    %eax
  802beb:	a3 38 50 80 00       	mov    %eax,0x805038
  802bf0:	e9 dc 00 00 00       	jmp    802cd1 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	75 65                	jne    802c63 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bfe:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c02:	75 17                	jne    802c1b <alloc_block_BF+0x2ed>
  802c04:	83 ec 04             	sub    $0x4,%esp
  802c07:	68 f0 47 80 00       	push   $0x8047f0
  802c0c:	68 4a 01 00 00       	push   $0x14a
  802c11:	68 a1 47 80 00       	push   $0x8047a1
  802c16:	e8 fb 10 00 00       	call   803d16 <_panic>
  802c1b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c24:	89 50 04             	mov    %edx,0x4(%eax)
  802c27:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2a:	8b 40 04             	mov    0x4(%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 0c                	je     802c3d <alloc_block_BF+0x30f>
  802c31:	a1 30 50 80 00       	mov    0x805030,%eax
  802c36:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c39:	89 10                	mov    %edx,(%eax)
  802c3b:	eb 08                	jmp    802c45 <alloc_block_BF+0x317>
  802c3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c40:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c45:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c48:	a3 30 50 80 00       	mov    %eax,0x805030
  802c4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c56:	a1 38 50 80 00       	mov    0x805038,%eax
  802c5b:	40                   	inc    %eax
  802c5c:	a3 38 50 80 00       	mov    %eax,0x805038
  802c61:	eb 6e                	jmp    802cd1 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c67:	74 06                	je     802c6f <alloc_block_BF+0x341>
  802c69:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c6d:	75 17                	jne    802c86 <alloc_block_BF+0x358>
  802c6f:	83 ec 04             	sub    $0x4,%esp
  802c72:	68 14 48 80 00       	push   $0x804814
  802c77:	68 4f 01 00 00       	push   $0x14f
  802c7c:	68 a1 47 80 00       	push   $0x8047a1
  802c81:	e8 90 10 00 00       	call   803d16 <_panic>
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	8b 10                	mov    (%eax),%edx
  802c8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c8e:	89 10                	mov    %edx,(%eax)
  802c90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	85 c0                	test   %eax,%eax
  802c97:	74 0b                	je     802ca4 <alloc_block_BF+0x376>
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ca1:	89 50 04             	mov    %edx,0x4(%eax)
  802ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802caa:	89 10                	mov    %edx,(%eax)
  802cac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802caf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb2:	89 50 04             	mov    %edx,0x4(%eax)
  802cb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb8:	8b 00                	mov    (%eax),%eax
  802cba:	85 c0                	test   %eax,%eax
  802cbc:	75 08                	jne    802cc6 <alloc_block_BF+0x398>
  802cbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc1:	a3 30 50 80 00       	mov    %eax,0x805030
  802cc6:	a1 38 50 80 00       	mov    0x805038,%eax
  802ccb:	40                   	inc    %eax
  802ccc:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802cd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd5:	75 17                	jne    802cee <alloc_block_BF+0x3c0>
  802cd7:	83 ec 04             	sub    $0x4,%esp
  802cda:	68 83 47 80 00       	push   $0x804783
  802cdf:	68 51 01 00 00       	push   $0x151
  802ce4:	68 a1 47 80 00       	push   $0x8047a1
  802ce9:	e8 28 10 00 00       	call   803d16 <_panic>
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	74 10                	je     802d07 <alloc_block_BF+0x3d9>
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cff:	8b 52 04             	mov    0x4(%edx),%edx
  802d02:	89 50 04             	mov    %edx,0x4(%eax)
  802d05:	eb 0b                	jmp    802d12 <alloc_block_BF+0x3e4>
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	8b 40 04             	mov    0x4(%eax),%eax
  802d0d:	a3 30 50 80 00       	mov    %eax,0x805030
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0f                	je     802d2b <alloc_block_BF+0x3fd>
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	8b 40 04             	mov    0x4(%eax),%eax
  802d22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d25:	8b 12                	mov    (%edx),%edx
  802d27:	89 10                	mov    %edx,(%eax)
  802d29:	eb 0a                	jmp    802d35 <alloc_block_BF+0x407>
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
			set_block_data(new_block_va, remaining_size, 0);
  802d53:	83 ec 04             	sub    $0x4,%esp
  802d56:	6a 00                	push   $0x0
  802d58:	ff 75 d0             	pushl  -0x30(%ebp)
  802d5b:	ff 75 cc             	pushl  -0x34(%ebp)
  802d5e:	e8 e0 f6 ff ff       	call   802443 <set_block_data>
  802d63:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	e9 80 01 00 00       	jmp    802eee <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802d6e:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d72:	0f 85 9d 00 00 00    	jne    802e15 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	6a 01                	push   $0x1
  802d7d:	ff 75 ec             	pushl  -0x14(%ebp)
  802d80:	ff 75 f0             	pushl  -0x10(%ebp)
  802d83:	e8 bb f6 ff ff       	call   802443 <set_block_data>
  802d88:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8f:	75 17                	jne    802da8 <alloc_block_BF+0x47a>
  802d91:	83 ec 04             	sub    $0x4,%esp
  802d94:	68 83 47 80 00       	push   $0x804783
  802d99:	68 58 01 00 00       	push   $0x158
  802d9e:	68 a1 47 80 00       	push   $0x8047a1
  802da3:	e8 6e 0f 00 00       	call   803d16 <_panic>
  802da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	74 10                	je     802dc1 <alloc_block_BF+0x493>
  802db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db9:	8b 52 04             	mov    0x4(%edx),%edx
  802dbc:	89 50 04             	mov    %edx,0x4(%eax)
  802dbf:	eb 0b                	jmp    802dcc <alloc_block_BF+0x49e>
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc4:	8b 40 04             	mov    0x4(%eax),%eax
  802dc7:	a3 30 50 80 00       	mov    %eax,0x805030
  802dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcf:	8b 40 04             	mov    0x4(%eax),%eax
  802dd2:	85 c0                	test   %eax,%eax
  802dd4:	74 0f                	je     802de5 <alloc_block_BF+0x4b7>
  802dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd9:	8b 40 04             	mov    0x4(%eax),%eax
  802ddc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddf:	8b 12                	mov    (%edx),%edx
  802de1:	89 10                	mov    %edx,(%eax)
  802de3:	eb 0a                	jmp    802def <alloc_block_BF+0x4c1>
  802de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e02:	a1 38 50 80 00       	mov    0x805038,%eax
  802e07:	48                   	dec    %eax
  802e08:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e10:	e9 d9 00 00 00       	jmp    802eee <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	83 c0 08             	add    $0x8,%eax
  802e1b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e1e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e25:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e28:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e2b:	01 d0                	add    %edx,%eax
  802e2d:	48                   	dec    %eax
  802e2e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e31:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e34:	ba 00 00 00 00       	mov    $0x0,%edx
  802e39:	f7 75 c4             	divl   -0x3c(%ebp)
  802e3c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e3f:	29 d0                	sub    %edx,%eax
  802e41:	c1 e8 0c             	shr    $0xc,%eax
  802e44:	83 ec 0c             	sub    $0xc,%esp
  802e47:	50                   	push   %eax
  802e48:	e8 ad e6 ff ff       	call   8014fa <sbrk>
  802e4d:	83 c4 10             	add    $0x10,%esp
  802e50:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e53:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e57:	75 0a                	jne    802e63 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e59:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5e:	e9 8b 00 00 00       	jmp    802eee <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e63:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e6a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e70:	01 d0                	add    %edx,%eax
  802e72:	48                   	dec    %eax
  802e73:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e76:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e79:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7e:	f7 75 b8             	divl   -0x48(%ebp)
  802e81:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e84:	29 d0                	sub    %edx,%eax
  802e86:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e89:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e8c:	01 d0                	add    %edx,%eax
  802e8e:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e93:	a1 40 50 80 00       	mov    0x805040,%eax
  802e98:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e9e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ea5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ea8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802eab:	01 d0                	add    %edx,%eax
  802ead:	48                   	dec    %eax
  802eae:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802eb1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb9:	f7 75 b0             	divl   -0x50(%ebp)
  802ebc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ebf:	29 d0                	sub    %edx,%eax
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	6a 01                	push   $0x1
  802ec6:	50                   	push   %eax
  802ec7:	ff 75 bc             	pushl  -0x44(%ebp)
  802eca:	e8 74 f5 ff ff       	call   802443 <set_block_data>
  802ecf:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ed2:	83 ec 0c             	sub    $0xc,%esp
  802ed5:	ff 75 bc             	pushl  -0x44(%ebp)
  802ed8:	e8 36 04 00 00       	call   803313 <free_block>
  802edd:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ee0:	83 ec 0c             	sub    $0xc,%esp
  802ee3:	ff 75 08             	pushl  0x8(%ebp)
  802ee6:	e8 43 fa ff ff       	call   80292e <alloc_block_BF>
  802eeb:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802eee:	c9                   	leave  
  802eef:	c3                   	ret    

00802ef0 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802ef0:	55                   	push   %ebp
  802ef1:	89 e5                	mov    %esp,%ebp
  802ef3:	53                   	push   %ebx
  802ef4:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ef7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802efe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f09:	74 1e                	je     802f29 <merging+0x39>
  802f0b:	ff 75 08             	pushl  0x8(%ebp)
  802f0e:	e8 df f1 ff ff       	call   8020f2 <get_block_size>
  802f13:	83 c4 04             	add    $0x4,%esp
  802f16:	89 c2                	mov    %eax,%edx
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	01 d0                	add    %edx,%eax
  802f1d:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f20:	75 07                	jne    802f29 <merging+0x39>
		prev_is_free = 1;
  802f22:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f2d:	74 1e                	je     802f4d <merging+0x5d>
  802f2f:	ff 75 10             	pushl  0x10(%ebp)
  802f32:	e8 bb f1 ff ff       	call   8020f2 <get_block_size>
  802f37:	83 c4 04             	add    $0x4,%esp
  802f3a:	89 c2                	mov    %eax,%edx
  802f3c:	8b 45 10             	mov    0x10(%ebp),%eax
  802f3f:	01 d0                	add    %edx,%eax
  802f41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f44:	75 07                	jne    802f4d <merging+0x5d>
		next_is_free = 1;
  802f46:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f51:	0f 84 cc 00 00 00    	je     803023 <merging+0x133>
  802f57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5b:	0f 84 c2 00 00 00    	je     803023 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f61:	ff 75 08             	pushl  0x8(%ebp)
  802f64:	e8 89 f1 ff ff       	call   8020f2 <get_block_size>
  802f69:	83 c4 04             	add    $0x4,%esp
  802f6c:	89 c3                	mov    %eax,%ebx
  802f6e:	ff 75 10             	pushl  0x10(%ebp)
  802f71:	e8 7c f1 ff ff       	call   8020f2 <get_block_size>
  802f76:	83 c4 04             	add    $0x4,%esp
  802f79:	01 c3                	add    %eax,%ebx
  802f7b:	ff 75 0c             	pushl  0xc(%ebp)
  802f7e:	e8 6f f1 ff ff       	call   8020f2 <get_block_size>
  802f83:	83 c4 04             	add    $0x4,%esp
  802f86:	01 d8                	add    %ebx,%eax
  802f88:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f8b:	6a 00                	push   $0x0
  802f8d:	ff 75 ec             	pushl  -0x14(%ebp)
  802f90:	ff 75 08             	pushl  0x8(%ebp)
  802f93:	e8 ab f4 ff ff       	call   802443 <set_block_data>
  802f98:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f9f:	75 17                	jne    802fb8 <merging+0xc8>
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	68 83 47 80 00       	push   $0x804783
  802fa9:	68 7d 01 00 00       	push   $0x17d
  802fae:	68 a1 47 80 00       	push   $0x8047a1
  802fb3:	e8 5e 0d 00 00       	call   803d16 <_panic>
  802fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	74 10                	je     802fd1 <merging+0xe1>
  802fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc9:	8b 52 04             	mov    0x4(%edx),%edx
  802fcc:	89 50 04             	mov    %edx,0x4(%eax)
  802fcf:	eb 0b                	jmp    802fdc <merging+0xec>
  802fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	a3 30 50 80 00       	mov    %eax,0x805030
  802fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdf:	8b 40 04             	mov    0x4(%eax),%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	74 0f                	je     802ff5 <merging+0x105>
  802fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe9:	8b 40 04             	mov    0x4(%eax),%eax
  802fec:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fef:	8b 12                	mov    (%edx),%edx
  802ff1:	89 10                	mov    %edx,(%eax)
  802ff3:	eb 0a                	jmp    802fff <merging+0x10f>
  802ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803002:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803012:	a1 38 50 80 00       	mov    0x805038,%eax
  803017:	48                   	dec    %eax
  803018:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80301d:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80301e:	e9 ea 02 00 00       	jmp    80330d <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803023:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803027:	74 3b                	je     803064 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803029:	83 ec 0c             	sub    $0xc,%esp
  80302c:	ff 75 08             	pushl  0x8(%ebp)
  80302f:	e8 be f0 ff ff       	call   8020f2 <get_block_size>
  803034:	83 c4 10             	add    $0x10,%esp
  803037:	89 c3                	mov    %eax,%ebx
  803039:	83 ec 0c             	sub    $0xc,%esp
  80303c:	ff 75 10             	pushl  0x10(%ebp)
  80303f:	e8 ae f0 ff ff       	call   8020f2 <get_block_size>
  803044:	83 c4 10             	add    $0x10,%esp
  803047:	01 d8                	add    %ebx,%eax
  803049:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80304c:	83 ec 04             	sub    $0x4,%esp
  80304f:	6a 00                	push   $0x0
  803051:	ff 75 e8             	pushl  -0x18(%ebp)
  803054:	ff 75 08             	pushl  0x8(%ebp)
  803057:	e8 e7 f3 ff ff       	call   802443 <set_block_data>
  80305c:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80305f:	e9 a9 02 00 00       	jmp    80330d <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803064:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803068:	0f 84 2d 01 00 00    	je     80319b <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80306e:	83 ec 0c             	sub    $0xc,%esp
  803071:	ff 75 10             	pushl  0x10(%ebp)
  803074:	e8 79 f0 ff ff       	call   8020f2 <get_block_size>
  803079:	83 c4 10             	add    $0x10,%esp
  80307c:	89 c3                	mov    %eax,%ebx
  80307e:	83 ec 0c             	sub    $0xc,%esp
  803081:	ff 75 0c             	pushl  0xc(%ebp)
  803084:	e8 69 f0 ff ff       	call   8020f2 <get_block_size>
  803089:	83 c4 10             	add    $0x10,%esp
  80308c:	01 d8                	add    %ebx,%eax
  80308e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803091:	83 ec 04             	sub    $0x4,%esp
  803094:	6a 00                	push   $0x0
  803096:	ff 75 e4             	pushl  -0x1c(%ebp)
  803099:	ff 75 10             	pushl  0x10(%ebp)
  80309c:	e8 a2 f3 ff ff       	call   802443 <set_block_data>
  8030a1:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8030a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030ae:	74 06                	je     8030b6 <merging+0x1c6>
  8030b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030b4:	75 17                	jne    8030cd <merging+0x1dd>
  8030b6:	83 ec 04             	sub    $0x4,%esp
  8030b9:	68 48 48 80 00       	push   $0x804848
  8030be:	68 8d 01 00 00       	push   $0x18d
  8030c3:	68 a1 47 80 00       	push   $0x8047a1
  8030c8:	e8 49 0c 00 00       	call   803d16 <_panic>
  8030cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d0:	8b 50 04             	mov    0x4(%eax),%edx
  8030d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d6:	89 50 04             	mov    %edx,0x4(%eax)
  8030d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030df:	89 10                	mov    %edx,(%eax)
  8030e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e4:	8b 40 04             	mov    0x4(%eax),%eax
  8030e7:	85 c0                	test   %eax,%eax
  8030e9:	74 0d                	je     8030f8 <merging+0x208>
  8030eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ee:	8b 40 04             	mov    0x4(%eax),%eax
  8030f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030f4:	89 10                	mov    %edx,(%eax)
  8030f6:	eb 08                	jmp    803100 <merging+0x210>
  8030f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803100:	8b 45 0c             	mov    0xc(%ebp),%eax
  803103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	a1 38 50 80 00       	mov    0x805038,%eax
  80310e:	40                   	inc    %eax
  80310f:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803114:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803118:	75 17                	jne    803131 <merging+0x241>
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	68 83 47 80 00       	push   $0x804783
  803122:	68 8e 01 00 00       	push   $0x18e
  803127:	68 a1 47 80 00       	push   $0x8047a1
  80312c:	e8 e5 0b 00 00       	call   803d16 <_panic>
  803131:	8b 45 0c             	mov    0xc(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	85 c0                	test   %eax,%eax
  803138:	74 10                	je     80314a <merging+0x25a>
  80313a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313d:	8b 00                	mov    (%eax),%eax
  80313f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803142:	8b 52 04             	mov    0x4(%edx),%edx
  803145:	89 50 04             	mov    %edx,0x4(%eax)
  803148:	eb 0b                	jmp    803155 <merging+0x265>
  80314a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314d:	8b 40 04             	mov    0x4(%eax),%eax
  803150:	a3 30 50 80 00       	mov    %eax,0x805030
  803155:	8b 45 0c             	mov    0xc(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	74 0f                	je     80316e <merging+0x27e>
  80315f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803162:	8b 40 04             	mov    0x4(%eax),%eax
  803165:	8b 55 0c             	mov    0xc(%ebp),%edx
  803168:	8b 12                	mov    (%edx),%edx
  80316a:	89 10                	mov    %edx,(%eax)
  80316c:	eb 0a                	jmp    803178 <merging+0x288>
  80316e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803181:	8b 45 0c             	mov    0xc(%ebp),%eax
  803184:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318b:	a1 38 50 80 00       	mov    0x805038,%eax
  803190:	48                   	dec    %eax
  803191:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803196:	e9 72 01 00 00       	jmp    80330d <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80319b:	8b 45 10             	mov    0x10(%ebp),%eax
  80319e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a5:	74 79                	je     803220 <merging+0x330>
  8031a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031ab:	74 73                	je     803220 <merging+0x330>
  8031ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b1:	74 06                	je     8031b9 <merging+0x2c9>
  8031b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031b7:	75 17                	jne    8031d0 <merging+0x2e0>
  8031b9:	83 ec 04             	sub    $0x4,%esp
  8031bc:	68 14 48 80 00       	push   $0x804814
  8031c1:	68 94 01 00 00       	push   $0x194
  8031c6:	68 a1 47 80 00       	push   $0x8047a1
  8031cb:	e8 46 0b 00 00       	call   803d16 <_panic>
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	8b 10                	mov    (%eax),%edx
  8031d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d8:	89 10                	mov    %edx,(%eax)
  8031da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	85 c0                	test   %eax,%eax
  8031e1:	74 0b                	je     8031ee <merging+0x2fe>
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031eb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031f4:	89 10                	mov    %edx,(%eax)
  8031f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031fc:	89 50 04             	mov    %edx,0x4(%eax)
  8031ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	85 c0                	test   %eax,%eax
  803206:	75 08                	jne    803210 <merging+0x320>
  803208:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80320b:	a3 30 50 80 00       	mov    %eax,0x805030
  803210:	a1 38 50 80 00       	mov    0x805038,%eax
  803215:	40                   	inc    %eax
  803216:	a3 38 50 80 00       	mov    %eax,0x805038
  80321b:	e9 ce 00 00 00       	jmp    8032ee <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803220:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803224:	74 65                	je     80328b <merging+0x39b>
  803226:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80322a:	75 17                	jne    803243 <merging+0x353>
  80322c:	83 ec 04             	sub    $0x4,%esp
  80322f:	68 f0 47 80 00       	push   $0x8047f0
  803234:	68 95 01 00 00       	push   $0x195
  803239:	68 a1 47 80 00       	push   $0x8047a1
  80323e:	e8 d3 0a 00 00       	call   803d16 <_panic>
  803243:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803249:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80324c:	89 50 04             	mov    %edx,0x4(%eax)
  80324f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803252:	8b 40 04             	mov    0x4(%eax),%eax
  803255:	85 c0                	test   %eax,%eax
  803257:	74 0c                	je     803265 <merging+0x375>
  803259:	a1 30 50 80 00       	mov    0x805030,%eax
  80325e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803261:	89 10                	mov    %edx,(%eax)
  803263:	eb 08                	jmp    80326d <merging+0x37d>
  803265:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803268:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80326d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803270:	a3 30 50 80 00       	mov    %eax,0x805030
  803275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803278:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327e:	a1 38 50 80 00       	mov    0x805038,%eax
  803283:	40                   	inc    %eax
  803284:	a3 38 50 80 00       	mov    %eax,0x805038
  803289:	eb 63                	jmp    8032ee <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80328b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80328f:	75 17                	jne    8032a8 <merging+0x3b8>
  803291:	83 ec 04             	sub    $0x4,%esp
  803294:	68 bc 47 80 00       	push   $0x8047bc
  803299:	68 98 01 00 00       	push   $0x198
  80329e:	68 a1 47 80 00       	push   $0x8047a1
  8032a3:	e8 6e 0a 00 00       	call   803d16 <_panic>
  8032a8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b1:	89 10                	mov    %edx,(%eax)
  8032b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	74 0d                	je     8032c9 <merging+0x3d9>
  8032bc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032c4:	89 50 04             	mov    %edx,0x4(%eax)
  8032c7:	eb 08                	jmp    8032d1 <merging+0x3e1>
  8032c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8032d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8032e8:	40                   	inc    %eax
  8032e9:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8032ee:	83 ec 0c             	sub    $0xc,%esp
  8032f1:	ff 75 10             	pushl  0x10(%ebp)
  8032f4:	e8 f9 ed ff ff       	call   8020f2 <get_block_size>
  8032f9:	83 c4 10             	add    $0x10,%esp
  8032fc:	83 ec 04             	sub    $0x4,%esp
  8032ff:	6a 00                	push   $0x0
  803301:	50                   	push   %eax
  803302:	ff 75 10             	pushl  0x10(%ebp)
  803305:	e8 39 f1 ff ff       	call   802443 <set_block_data>
  80330a:	83 c4 10             	add    $0x10,%esp
	}
}
  80330d:	90                   	nop
  80330e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803311:	c9                   	leave  
  803312:	c3                   	ret    

00803313 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803313:	55                   	push   %ebp
  803314:	89 e5                	mov    %esp,%ebp
  803316:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803319:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80331e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803321:	a1 30 50 80 00       	mov    0x805030,%eax
  803326:	3b 45 08             	cmp    0x8(%ebp),%eax
  803329:	73 1b                	jae    803346 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80332b:	a1 30 50 80 00       	mov    0x805030,%eax
  803330:	83 ec 04             	sub    $0x4,%esp
  803333:	ff 75 08             	pushl  0x8(%ebp)
  803336:	6a 00                	push   $0x0
  803338:	50                   	push   %eax
  803339:	e8 b2 fb ff ff       	call   802ef0 <merging>
  80333e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803341:	e9 8b 00 00 00       	jmp    8033d1 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803346:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80334b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80334e:	76 18                	jbe    803368 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803350:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	ff 75 08             	pushl  0x8(%ebp)
  80335b:	50                   	push   %eax
  80335c:	6a 00                	push   $0x0
  80335e:	e8 8d fb ff ff       	call   802ef0 <merging>
  803363:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803366:	eb 69                	jmp    8033d1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803368:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80336d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803370:	eb 39                	jmp    8033ab <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	3b 45 08             	cmp    0x8(%ebp),%eax
  803378:	73 29                	jae    8033a3 <free_block+0x90>
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803382:	76 1f                	jbe    8033a3 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	8b 00                	mov    (%eax),%eax
  803389:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80338c:	83 ec 04             	sub    $0x4,%esp
  80338f:	ff 75 08             	pushl  0x8(%ebp)
  803392:	ff 75 f0             	pushl  -0x10(%ebp)
  803395:	ff 75 f4             	pushl  -0xc(%ebp)
  803398:	e8 53 fb ff ff       	call   802ef0 <merging>
  80339d:	83 c4 10             	add    $0x10,%esp
			break;
  8033a0:	90                   	nop
		}
	}
}
  8033a1:	eb 2e                	jmp    8033d1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033a3:	a1 34 50 80 00       	mov    0x805034,%eax
  8033a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033af:	74 07                	je     8033b8 <free_block+0xa5>
  8033b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b4:	8b 00                	mov    (%eax),%eax
  8033b6:	eb 05                	jmp    8033bd <free_block+0xaa>
  8033b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bd:	a3 34 50 80 00       	mov    %eax,0x805034
  8033c2:	a1 34 50 80 00       	mov    0x805034,%eax
  8033c7:	85 c0                	test   %eax,%eax
  8033c9:	75 a7                	jne    803372 <free_block+0x5f>
  8033cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033cf:	75 a1                	jne    803372 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033d1:	90                   	nop
  8033d2:	c9                   	leave  
  8033d3:	c3                   	ret    

008033d4 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033d4:	55                   	push   %ebp
  8033d5:	89 e5                	mov    %esp,%ebp
  8033d7:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033da:	ff 75 08             	pushl  0x8(%ebp)
  8033dd:	e8 10 ed ff ff       	call   8020f2 <get_block_size>
  8033e2:	83 c4 04             	add    $0x4,%esp
  8033e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033ef:	eb 17                	jmp    803408 <copy_data+0x34>
  8033f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f7:	01 c2                	add    %eax,%edx
  8033f9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	01 c8                	add    %ecx,%eax
  803401:	8a 00                	mov    (%eax),%al
  803403:	88 02                	mov    %al,(%edx)
  803405:	ff 45 fc             	incl   -0x4(%ebp)
  803408:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80340b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80340e:	72 e1                	jb     8033f1 <copy_data+0x1d>
}
  803410:	90                   	nop
  803411:	c9                   	leave  
  803412:	c3                   	ret    

00803413 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803413:	55                   	push   %ebp
  803414:	89 e5                	mov    %esp,%ebp
  803416:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341d:	75 23                	jne    803442 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80341f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803423:	74 13                	je     803438 <realloc_block_FF+0x25>
  803425:	83 ec 0c             	sub    $0xc,%esp
  803428:	ff 75 0c             	pushl  0xc(%ebp)
  80342b:	e8 42 f0 ff ff       	call   802472 <alloc_block_FF>
  803430:	83 c4 10             	add    $0x10,%esp
  803433:	e9 e4 06 00 00       	jmp    803b1c <realloc_block_FF+0x709>
		return NULL;
  803438:	b8 00 00 00 00       	mov    $0x0,%eax
  80343d:	e9 da 06 00 00       	jmp    803b1c <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803442:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803446:	75 18                	jne    803460 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803448:	83 ec 0c             	sub    $0xc,%esp
  80344b:	ff 75 08             	pushl  0x8(%ebp)
  80344e:	e8 c0 fe ff ff       	call   803313 <free_block>
  803453:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803456:	b8 00 00 00 00       	mov    $0x0,%eax
  80345b:	e9 bc 06 00 00       	jmp    803b1c <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803460:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803464:	77 07                	ja     80346d <realloc_block_FF+0x5a>
  803466:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80346d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803470:	83 e0 01             	and    $0x1,%eax
  803473:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803476:	8b 45 0c             	mov    0xc(%ebp),%eax
  803479:	83 c0 08             	add    $0x8,%eax
  80347c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80347f:	83 ec 0c             	sub    $0xc,%esp
  803482:	ff 75 08             	pushl  0x8(%ebp)
  803485:	e8 68 ec ff ff       	call   8020f2 <get_block_size>
  80348a:	83 c4 10             	add    $0x10,%esp
  80348d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803490:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803493:	83 e8 08             	sub    $0x8,%eax
  803496:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	83 e8 04             	sub    $0x4,%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	83 e0 fe             	and    $0xfffffffe,%eax
  8034a4:	89 c2                	mov    %eax,%edx
  8034a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a9:	01 d0                	add    %edx,%eax
  8034ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034ae:	83 ec 0c             	sub    $0xc,%esp
  8034b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034b4:	e8 39 ec ff ff       	call   8020f2 <get_block_size>
  8034b9:	83 c4 10             	add    $0x10,%esp
  8034bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c2:	83 e8 08             	sub    $0x8,%eax
  8034c5:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034cb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034ce:	75 08                	jne    8034d8 <realloc_block_FF+0xc5>
	{
		 return va;
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	e9 44 06 00 00       	jmp    803b1c <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8034d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034db:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034de:	0f 83 d5 03 00 00    	jae    8038b9 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e7:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034ed:	83 ec 0c             	sub    $0xc,%esp
  8034f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034f3:	e8 13 ec ff ff       	call   80210b <is_free_block>
  8034f8:	83 c4 10             	add    $0x10,%esp
  8034fb:	84 c0                	test   %al,%al
  8034fd:	0f 84 3b 01 00 00    	je     80363e <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803503:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803506:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803509:	01 d0                	add    %edx,%eax
  80350b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80350e:	83 ec 04             	sub    $0x4,%esp
  803511:	6a 01                	push   $0x1
  803513:	ff 75 f0             	pushl  -0x10(%ebp)
  803516:	ff 75 08             	pushl  0x8(%ebp)
  803519:	e8 25 ef ff ff       	call   802443 <set_block_data>
  80351e:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	83 e8 04             	sub    $0x4,%eax
  803527:	8b 00                	mov    (%eax),%eax
  803529:	83 e0 fe             	and    $0xfffffffe,%eax
  80352c:	89 c2                	mov    %eax,%edx
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	01 d0                	add    %edx,%eax
  803533:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803536:	83 ec 04             	sub    $0x4,%esp
  803539:	6a 00                	push   $0x0
  80353b:	ff 75 cc             	pushl  -0x34(%ebp)
  80353e:	ff 75 c8             	pushl  -0x38(%ebp)
  803541:	e8 fd ee ff ff       	call   802443 <set_block_data>
  803546:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803549:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80354d:	74 06                	je     803555 <realloc_block_FF+0x142>
  80354f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803553:	75 17                	jne    80356c <realloc_block_FF+0x159>
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	68 14 48 80 00       	push   $0x804814
  80355d:	68 f6 01 00 00       	push   $0x1f6
  803562:	68 a1 47 80 00       	push   $0x8047a1
  803567:	e8 aa 07 00 00       	call   803d16 <_panic>
  80356c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356f:	8b 10                	mov    (%eax),%edx
  803571:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803574:	89 10                	mov    %edx,(%eax)
  803576:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803579:	8b 00                	mov    (%eax),%eax
  80357b:	85 c0                	test   %eax,%eax
  80357d:	74 0b                	je     80358a <realloc_block_FF+0x177>
  80357f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803582:	8b 00                	mov    (%eax),%eax
  803584:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803587:	89 50 04             	mov    %edx,0x4(%eax)
  80358a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803590:	89 10                	mov    %edx,(%eax)
  803592:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803595:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803598:	89 50 04             	mov    %edx,0x4(%eax)
  80359b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	85 c0                	test   %eax,%eax
  8035a2:	75 08                	jne    8035ac <realloc_block_FF+0x199>
  8035a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b1:	40                   	inc    %eax
  8035b2:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035bb:	75 17                	jne    8035d4 <realloc_block_FF+0x1c1>
  8035bd:	83 ec 04             	sub    $0x4,%esp
  8035c0:	68 83 47 80 00       	push   $0x804783
  8035c5:	68 f7 01 00 00       	push   $0x1f7
  8035ca:	68 a1 47 80 00       	push   $0x8047a1
  8035cf:	e8 42 07 00 00       	call   803d16 <_panic>
  8035d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d7:	8b 00                	mov    (%eax),%eax
  8035d9:	85 c0                	test   %eax,%eax
  8035db:	74 10                	je     8035ed <realloc_block_FF+0x1da>
  8035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e0:	8b 00                	mov    (%eax),%eax
  8035e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035e5:	8b 52 04             	mov    0x4(%edx),%edx
  8035e8:	89 50 04             	mov    %edx,0x4(%eax)
  8035eb:	eb 0b                	jmp    8035f8 <realloc_block_FF+0x1e5>
  8035ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f0:	8b 40 04             	mov    0x4(%eax),%eax
  8035f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8035f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fb:	8b 40 04             	mov    0x4(%eax),%eax
  8035fe:	85 c0                	test   %eax,%eax
  803600:	74 0f                	je     803611 <realloc_block_FF+0x1fe>
  803602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803605:	8b 40 04             	mov    0x4(%eax),%eax
  803608:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80360b:	8b 12                	mov    (%edx),%edx
  80360d:	89 10                	mov    %edx,(%eax)
  80360f:	eb 0a                	jmp    80361b <realloc_block_FF+0x208>
  803611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803614:	8b 00                	mov    (%eax),%eax
  803616:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80361b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803627:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362e:	a1 38 50 80 00       	mov    0x805038,%eax
  803633:	48                   	dec    %eax
  803634:	a3 38 50 80 00       	mov    %eax,0x805038
  803639:	e9 73 02 00 00       	jmp    8038b1 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80363e:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803642:	0f 86 69 02 00 00    	jbe    8038b1 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803648:	83 ec 04             	sub    $0x4,%esp
  80364b:	6a 01                	push   $0x1
  80364d:	ff 75 f0             	pushl  -0x10(%ebp)
  803650:	ff 75 08             	pushl  0x8(%ebp)
  803653:	e8 eb ed ff ff       	call   802443 <set_block_data>
  803658:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	83 e8 04             	sub    $0x4,%eax
  803661:	8b 00                	mov    (%eax),%eax
  803663:	83 e0 fe             	and    $0xfffffffe,%eax
  803666:	89 c2                	mov    %eax,%edx
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	01 d0                	add    %edx,%eax
  80366d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803670:	a1 38 50 80 00       	mov    0x805038,%eax
  803675:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803678:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80367c:	75 68                	jne    8036e6 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80367e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803682:	75 17                	jne    80369b <realloc_block_FF+0x288>
  803684:	83 ec 04             	sub    $0x4,%esp
  803687:	68 bc 47 80 00       	push   $0x8047bc
  80368c:	68 06 02 00 00       	push   $0x206
  803691:	68 a1 47 80 00       	push   $0x8047a1
  803696:	e8 7b 06 00 00       	call   803d16 <_panic>
  80369b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a4:	89 10                	mov    %edx,(%eax)
  8036a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a9:	8b 00                	mov    (%eax),%eax
  8036ab:	85 c0                	test   %eax,%eax
  8036ad:	74 0d                	je     8036bc <realloc_block_FF+0x2a9>
  8036af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036b7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ba:	eb 08                	jmp    8036c4 <realloc_block_FF+0x2b1>
  8036bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8036c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8036db:	40                   	inc    %eax
  8036dc:	a3 38 50 80 00       	mov    %eax,0x805038
  8036e1:	e9 b0 01 00 00       	jmp    803896 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036e6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036eb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036ee:	76 68                	jbe    803758 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036f4:	75 17                	jne    80370d <realloc_block_FF+0x2fa>
  8036f6:	83 ec 04             	sub    $0x4,%esp
  8036f9:	68 bc 47 80 00       	push   $0x8047bc
  8036fe:	68 0b 02 00 00       	push   $0x20b
  803703:	68 a1 47 80 00       	push   $0x8047a1
  803708:	e8 09 06 00 00       	call   803d16 <_panic>
  80370d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803713:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803716:	89 10                	mov    %edx,(%eax)
  803718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371b:	8b 00                	mov    (%eax),%eax
  80371d:	85 c0                	test   %eax,%eax
  80371f:	74 0d                	je     80372e <realloc_block_FF+0x31b>
  803721:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803726:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803729:	89 50 04             	mov    %edx,0x4(%eax)
  80372c:	eb 08                	jmp    803736 <realloc_block_FF+0x323>
  80372e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803731:	a3 30 50 80 00       	mov    %eax,0x805030
  803736:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803739:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80373e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803741:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803748:	a1 38 50 80 00       	mov    0x805038,%eax
  80374d:	40                   	inc    %eax
  80374e:	a3 38 50 80 00       	mov    %eax,0x805038
  803753:	e9 3e 01 00 00       	jmp    803896 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803758:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80375d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803760:	73 68                	jae    8037ca <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803762:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803766:	75 17                	jne    80377f <realloc_block_FF+0x36c>
  803768:	83 ec 04             	sub    $0x4,%esp
  80376b:	68 f0 47 80 00       	push   $0x8047f0
  803770:	68 10 02 00 00       	push   $0x210
  803775:	68 a1 47 80 00       	push   $0x8047a1
  80377a:	e8 97 05 00 00       	call   803d16 <_panic>
  80377f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803785:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803788:	89 50 04             	mov    %edx,0x4(%eax)
  80378b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80378e:	8b 40 04             	mov    0x4(%eax),%eax
  803791:	85 c0                	test   %eax,%eax
  803793:	74 0c                	je     8037a1 <realloc_block_FF+0x38e>
  803795:	a1 30 50 80 00       	mov    0x805030,%eax
  80379a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80379d:	89 10                	mov    %edx,(%eax)
  80379f:	eb 08                	jmp    8037a9 <realloc_block_FF+0x396>
  8037a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8037b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8037bf:	40                   	inc    %eax
  8037c0:	a3 38 50 80 00       	mov    %eax,0x805038
  8037c5:	e9 cc 00 00 00       	jmp    803896 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037d9:	e9 8a 00 00 00       	jmp    803868 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037e4:	73 7a                	jae    803860 <realloc_block_FF+0x44d>
  8037e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e9:	8b 00                	mov    (%eax),%eax
  8037eb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037ee:	73 70                	jae    803860 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f4:	74 06                	je     8037fc <realloc_block_FF+0x3e9>
  8037f6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037fa:	75 17                	jne    803813 <realloc_block_FF+0x400>
  8037fc:	83 ec 04             	sub    $0x4,%esp
  8037ff:	68 14 48 80 00       	push   $0x804814
  803804:	68 1a 02 00 00       	push   $0x21a
  803809:	68 a1 47 80 00       	push   $0x8047a1
  80380e:	e8 03 05 00 00       	call   803d16 <_panic>
  803813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803816:	8b 10                	mov    (%eax),%edx
  803818:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80381b:	89 10                	mov    %edx,(%eax)
  80381d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803820:	8b 00                	mov    (%eax),%eax
  803822:	85 c0                	test   %eax,%eax
  803824:	74 0b                	je     803831 <realloc_block_FF+0x41e>
  803826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803829:	8b 00                	mov    (%eax),%eax
  80382b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80382e:	89 50 04             	mov    %edx,0x4(%eax)
  803831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803834:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803837:	89 10                	mov    %edx,(%eax)
  803839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80383f:	89 50 04             	mov    %edx,0x4(%eax)
  803842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803845:	8b 00                	mov    (%eax),%eax
  803847:	85 c0                	test   %eax,%eax
  803849:	75 08                	jne    803853 <realloc_block_FF+0x440>
  80384b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80384e:	a3 30 50 80 00       	mov    %eax,0x805030
  803853:	a1 38 50 80 00       	mov    0x805038,%eax
  803858:	40                   	inc    %eax
  803859:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80385e:	eb 36                	jmp    803896 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803860:	a1 34 50 80 00       	mov    0x805034,%eax
  803865:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80386c:	74 07                	je     803875 <realloc_block_FF+0x462>
  80386e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	eb 05                	jmp    80387a <realloc_block_FF+0x467>
  803875:	b8 00 00 00 00       	mov    $0x0,%eax
  80387a:	a3 34 50 80 00       	mov    %eax,0x805034
  80387f:	a1 34 50 80 00       	mov    0x805034,%eax
  803884:	85 c0                	test   %eax,%eax
  803886:	0f 85 52 ff ff ff    	jne    8037de <realloc_block_FF+0x3cb>
  80388c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803890:	0f 85 48 ff ff ff    	jne    8037de <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803896:	83 ec 04             	sub    $0x4,%esp
  803899:	6a 00                	push   $0x0
  80389b:	ff 75 d8             	pushl  -0x28(%ebp)
  80389e:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038a1:	e8 9d eb ff ff       	call   802443 <set_block_data>
  8038a6:	83 c4 10             	add    $0x10,%esp
				return va;
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	e9 6b 02 00 00       	jmp    803b1c <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8038b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b4:	e9 63 02 00 00       	jmp    803b1c <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8038b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038bc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038bf:	0f 86 4d 02 00 00    	jbe    803b12 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8038c5:	83 ec 0c             	sub    $0xc,%esp
  8038c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038cb:	e8 3b e8 ff ff       	call   80210b <is_free_block>
  8038d0:	83 c4 10             	add    $0x10,%esp
  8038d3:	84 c0                	test   %al,%al
  8038d5:	0f 84 37 02 00 00    	je     803b12 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038de:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038e7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038ea:	76 38                	jbe    803924 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038ec:	83 ec 0c             	sub    $0xc,%esp
  8038ef:	ff 75 0c             	pushl  0xc(%ebp)
  8038f2:	e8 7b eb ff ff       	call   802472 <alloc_block_FF>
  8038f7:	83 c4 10             	add    $0x10,%esp
  8038fa:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8038fd:	83 ec 08             	sub    $0x8,%esp
  803900:	ff 75 c0             	pushl  -0x40(%ebp)
  803903:	ff 75 08             	pushl  0x8(%ebp)
  803906:	e8 c9 fa ff ff       	call   8033d4 <copy_data>
  80390b:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80390e:	83 ec 0c             	sub    $0xc,%esp
  803911:	ff 75 08             	pushl  0x8(%ebp)
  803914:	e8 fa f9 ff ff       	call   803313 <free_block>
  803919:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80391c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80391f:	e9 f8 01 00 00       	jmp    803b1c <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803924:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803927:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80392a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80392d:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803931:	0f 87 a0 00 00 00    	ja     8039d7 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803937:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80393b:	75 17                	jne    803954 <realloc_block_FF+0x541>
  80393d:	83 ec 04             	sub    $0x4,%esp
  803940:	68 83 47 80 00       	push   $0x804783
  803945:	68 38 02 00 00       	push   $0x238
  80394a:	68 a1 47 80 00       	push   $0x8047a1
  80394f:	e8 c2 03 00 00       	call   803d16 <_panic>
  803954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803957:	8b 00                	mov    (%eax),%eax
  803959:	85 c0                	test   %eax,%eax
  80395b:	74 10                	je     80396d <realloc_block_FF+0x55a>
  80395d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803960:	8b 00                	mov    (%eax),%eax
  803962:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803965:	8b 52 04             	mov    0x4(%edx),%edx
  803968:	89 50 04             	mov    %edx,0x4(%eax)
  80396b:	eb 0b                	jmp    803978 <realloc_block_FF+0x565>
  80396d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803970:	8b 40 04             	mov    0x4(%eax),%eax
  803973:	a3 30 50 80 00       	mov    %eax,0x805030
  803978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397b:	8b 40 04             	mov    0x4(%eax),%eax
  80397e:	85 c0                	test   %eax,%eax
  803980:	74 0f                	je     803991 <realloc_block_FF+0x57e>
  803982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803985:	8b 40 04             	mov    0x4(%eax),%eax
  803988:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80398b:	8b 12                	mov    (%edx),%edx
  80398d:	89 10                	mov    %edx,(%eax)
  80398f:	eb 0a                	jmp    80399b <realloc_block_FF+0x588>
  803991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803994:	8b 00                	mov    (%eax),%eax
  803996:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80399b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8039b3:	48                   	dec    %eax
  8039b4:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039bf:	01 d0                	add    %edx,%eax
  8039c1:	83 ec 04             	sub    $0x4,%esp
  8039c4:	6a 01                	push   $0x1
  8039c6:	50                   	push   %eax
  8039c7:	ff 75 08             	pushl  0x8(%ebp)
  8039ca:	e8 74 ea ff ff       	call   802443 <set_block_data>
  8039cf:	83 c4 10             	add    $0x10,%esp
  8039d2:	e9 36 01 00 00       	jmp    803b0d <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039dd:	01 d0                	add    %edx,%eax
  8039df:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039e2:	83 ec 04             	sub    $0x4,%esp
  8039e5:	6a 01                	push   $0x1
  8039e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8039ea:	ff 75 08             	pushl  0x8(%ebp)
  8039ed:	e8 51 ea ff ff       	call   802443 <set_block_data>
  8039f2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f8:	83 e8 04             	sub    $0x4,%eax
  8039fb:	8b 00                	mov    (%eax),%eax
  8039fd:	83 e0 fe             	and    $0xfffffffe,%eax
  803a00:	89 c2                	mov    %eax,%edx
  803a02:	8b 45 08             	mov    0x8(%ebp),%eax
  803a05:	01 d0                	add    %edx,%eax
  803a07:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a0e:	74 06                	je     803a16 <realloc_block_FF+0x603>
  803a10:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a14:	75 17                	jne    803a2d <realloc_block_FF+0x61a>
  803a16:	83 ec 04             	sub    $0x4,%esp
  803a19:	68 14 48 80 00       	push   $0x804814
  803a1e:	68 44 02 00 00       	push   $0x244
  803a23:	68 a1 47 80 00       	push   $0x8047a1
  803a28:	e8 e9 02 00 00       	call   803d16 <_panic>
  803a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a30:	8b 10                	mov    (%eax),%edx
  803a32:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a35:	89 10                	mov    %edx,(%eax)
  803a37:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a3a:	8b 00                	mov    (%eax),%eax
  803a3c:	85 c0                	test   %eax,%eax
  803a3e:	74 0b                	je     803a4b <realloc_block_FF+0x638>
  803a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a43:	8b 00                	mov    (%eax),%eax
  803a45:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a48:	89 50 04             	mov    %edx,0x4(%eax)
  803a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a51:	89 10                	mov    %edx,(%eax)
  803a53:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a59:	89 50 04             	mov    %edx,0x4(%eax)
  803a5c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a5f:	8b 00                	mov    (%eax),%eax
  803a61:	85 c0                	test   %eax,%eax
  803a63:	75 08                	jne    803a6d <realloc_block_FF+0x65a>
  803a65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a68:	a3 30 50 80 00       	mov    %eax,0x805030
  803a6d:	a1 38 50 80 00       	mov    0x805038,%eax
  803a72:	40                   	inc    %eax
  803a73:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a7c:	75 17                	jne    803a95 <realloc_block_FF+0x682>
  803a7e:	83 ec 04             	sub    $0x4,%esp
  803a81:	68 83 47 80 00       	push   $0x804783
  803a86:	68 45 02 00 00       	push   $0x245
  803a8b:	68 a1 47 80 00       	push   $0x8047a1
  803a90:	e8 81 02 00 00       	call   803d16 <_panic>
  803a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a98:	8b 00                	mov    (%eax),%eax
  803a9a:	85 c0                	test   %eax,%eax
  803a9c:	74 10                	je     803aae <realloc_block_FF+0x69b>
  803a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa1:	8b 00                	mov    (%eax),%eax
  803aa3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aa6:	8b 52 04             	mov    0x4(%edx),%edx
  803aa9:	89 50 04             	mov    %edx,0x4(%eax)
  803aac:	eb 0b                	jmp    803ab9 <realloc_block_FF+0x6a6>
  803aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab1:	8b 40 04             	mov    0x4(%eax),%eax
  803ab4:	a3 30 50 80 00       	mov    %eax,0x805030
  803ab9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abc:	8b 40 04             	mov    0x4(%eax),%eax
  803abf:	85 c0                	test   %eax,%eax
  803ac1:	74 0f                	je     803ad2 <realloc_block_FF+0x6bf>
  803ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac6:	8b 40 04             	mov    0x4(%eax),%eax
  803ac9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803acc:	8b 12                	mov    (%edx),%edx
  803ace:	89 10                	mov    %edx,(%eax)
  803ad0:	eb 0a                	jmp    803adc <realloc_block_FF+0x6c9>
  803ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad5:	8b 00                	mov    (%eax),%eax
  803ad7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803adf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aef:	a1 38 50 80 00       	mov    0x805038,%eax
  803af4:	48                   	dec    %eax
  803af5:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803afa:	83 ec 04             	sub    $0x4,%esp
  803afd:	6a 00                	push   $0x0
  803aff:	ff 75 bc             	pushl  -0x44(%ebp)
  803b02:	ff 75 b8             	pushl  -0x48(%ebp)
  803b05:	e8 39 e9 ff ff       	call   802443 <set_block_data>
  803b0a:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b10:	eb 0a                	jmp    803b1c <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b12:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b19:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b1c:	c9                   	leave  
  803b1d:	c3                   	ret    

00803b1e <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b1e:	55                   	push   %ebp
  803b1f:	89 e5                	mov    %esp,%ebp
  803b21:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b24:	83 ec 04             	sub    $0x4,%esp
  803b27:	68 80 48 80 00       	push   $0x804880
  803b2c:	68 58 02 00 00       	push   $0x258
  803b31:	68 a1 47 80 00       	push   $0x8047a1
  803b36:	e8 db 01 00 00       	call   803d16 <_panic>

00803b3b <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b3b:	55                   	push   %ebp
  803b3c:	89 e5                	mov    %esp,%ebp
  803b3e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b41:	83 ec 04             	sub    $0x4,%esp
  803b44:	68 a8 48 80 00       	push   $0x8048a8
  803b49:	68 61 02 00 00       	push   $0x261
  803b4e:	68 a1 47 80 00       	push   $0x8047a1
  803b53:	e8 be 01 00 00       	call   803d16 <_panic>

00803b58 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803b58:	55                   	push   %ebp
  803b59:	89 e5                	mov    %esp,%ebp
  803b5b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  803b5e:	83 ec 04             	sub    $0x4,%esp
  803b61:	6a 01                	push   $0x1
  803b63:	6a 04                	push   $0x4
  803b65:	ff 75 0c             	pushl  0xc(%ebp)
  803b68:	e8 c1 dc ff ff       	call   80182e <smalloc>
  803b6d:	83 c4 10             	add    $0x10,%esp
  803b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  803b73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b77:	75 14                	jne    803b8d <create_semaphore+0x35>
  803b79:	83 ec 04             	sub    $0x4,%esp
  803b7c:	68 ce 48 80 00       	push   $0x8048ce
  803b81:	6a 0d                	push   $0xd
  803b83:	68 eb 48 80 00       	push   $0x8048eb
  803b88:	e8 89 01 00 00       	call   803d16 <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b90:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  803b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b96:	8b 00                	mov    (%eax),%eax
  803b98:	8b 55 10             	mov    0x10(%ebp),%edx
  803b9b:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  803b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ba1:	8b 00                	mov    (%eax),%eax
  803ba3:	83 ec 0c             	sub    $0xc,%esp
  803ba6:	50                   	push   %eax
  803ba7:	e8 cc e4 ff ff       	call   802078 <sys_init_queue>
  803bac:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  803baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bb2:	8b 00                	mov    (%eax),%eax
  803bb4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  803bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bc1:	8b 12                	mov    (%edx),%edx
  803bc3:	89 10                	mov    %edx,(%eax)
}
  803bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc8:	c9                   	leave  
  803bc9:	c2 04 00             	ret    $0x4

00803bcc <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803bcc:	55                   	push   %ebp
  803bcd:	89 e5                	mov    %esp,%ebp
  803bcf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  803bd2:	83 ec 08             	sub    $0x8,%esp
  803bd5:	ff 75 10             	pushl  0x10(%ebp)
  803bd8:	ff 75 0c             	pushl  0xc(%ebp)
  803bdb:	e8 f3 dc ff ff       	call   8018d3 <sget>
  803be0:	83 c4 10             	add    $0x10,%esp
  803be3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  803be6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bea:	75 14                	jne    803c00 <get_semaphore+0x34>
  803bec:	83 ec 04             	sub    $0x4,%esp
  803bef:	68 fb 48 80 00       	push   $0x8048fb
  803bf4:	6a 1f                	push   $0x1f
  803bf6:	68 eb 48 80 00       	push   $0x8048eb
  803bfb:	e8 16 01 00 00       	call   803d16 <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  803c06:	8b 45 08             	mov    0x8(%ebp),%eax
  803c09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c0c:	8b 12                	mov    (%edx),%edx
  803c0e:	89 10                	mov    %edx,(%eax)
}
  803c10:	8b 45 08             	mov    0x8(%ebp),%eax
  803c13:	c9                   	leave  
  803c14:	c2 04 00             	ret    $0x4

00803c17 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803c17:	55                   	push   %ebp
  803c18:	89 e5                	mov    %esp,%ebp
  803c1a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  803c1d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  803c24:	8b 45 08             	mov    0x8(%ebp),%eax
  803c27:	83 c0 14             	add    $0x14,%eax
  803c2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c30:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803c33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c39:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803c3c:	f0 87 02             	lock xchg %eax,(%edx)
  803c3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803c42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c46:	75 dc                	jne    803c24 <wait_semaphore+0xd>

		    sem.semdata->count--;
  803c48:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4b:	8b 50 10             	mov    0x10(%eax),%edx
  803c4e:	4a                   	dec    %edx
  803c4f:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  803c52:	8b 45 08             	mov    0x8(%ebp),%eax
  803c55:	8b 40 10             	mov    0x10(%eax),%eax
  803c58:	85 c0                	test   %eax,%eax
  803c5a:	79 30                	jns    803c8c <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  803c5c:	e8 f5 e3 ff ff       	call   802056 <sys_get_cpu_process>
  803c61:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  803c64:	8b 45 08             	mov    0x8(%ebp),%eax
  803c67:	83 ec 08             	sub    $0x8,%esp
  803c6a:	ff 75 f0             	pushl  -0x10(%ebp)
  803c6d:	50                   	push   %eax
  803c6e:	e8 21 e4 ff ff       	call   802094 <sys_enqueue>
  803c73:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  803c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c79:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  803c80:	8b 45 08             	mov    0x8(%ebp),%eax
  803c83:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  803c8a:	eb 0a                	jmp    803c96 <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  803c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  803c96:	90                   	nop
  803c97:	c9                   	leave  
  803c98:	c3                   	ret    

00803c99 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  803c99:	55                   	push   %ebp
  803c9a:	89 e5                	mov    %esp,%ebp
  803c9c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  803c9f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  803ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca9:	83 c0 14             	add    $0x14,%eax
  803cac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803cb5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cbb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803cbe:	f0 87 02             	lock xchg %eax,(%edx)
  803cc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803cc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cc8:	75 dc                	jne    803ca6 <signal_semaphore+0xd>
	    sem.semdata->count++;
  803cca:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccd:	8b 50 10             	mov    0x10(%eax),%edx
  803cd0:	42                   	inc    %edx
  803cd1:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  803cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd7:	8b 40 10             	mov    0x10(%eax),%eax
  803cda:	85 c0                	test   %eax,%eax
  803cdc:	7f 20                	jg     803cfe <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  803cde:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce1:	83 ec 0c             	sub    $0xc,%esp
  803ce4:	50                   	push   %eax
  803ce5:	e8 c8 e3 ff ff       	call   8020b2 <sys_dequeue>
  803cea:	83 c4 10             	add    $0x10,%esp
  803ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  803cf0:	83 ec 0c             	sub    $0xc,%esp
  803cf3:	ff 75 f0             	pushl  -0x10(%ebp)
  803cf6:	e8 db e3 ff ff       	call   8020d6 <sys_sched_insert_ready>
  803cfb:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  803cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  803d01:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803d08:	90                   	nop
  803d09:	c9                   	leave  
  803d0a:	c3                   	ret    

00803d0b <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  803d0b:	55                   	push   %ebp
  803d0c:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d11:	8b 40 10             	mov    0x10(%eax),%eax
}
  803d14:	5d                   	pop    %ebp
  803d15:	c3                   	ret    

00803d16 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803d16:	55                   	push   %ebp
  803d17:	89 e5                	mov    %esp,%ebp
  803d19:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803d1c:	8d 45 10             	lea    0x10(%ebp),%eax
  803d1f:	83 c0 04             	add    $0x4,%eax
  803d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803d25:	a1 60 50 98 00       	mov    0x985060,%eax
  803d2a:	85 c0                	test   %eax,%eax
  803d2c:	74 16                	je     803d44 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803d2e:	a1 60 50 98 00       	mov    0x985060,%eax
  803d33:	83 ec 08             	sub    $0x8,%esp
  803d36:	50                   	push   %eax
  803d37:	68 1c 49 80 00       	push   $0x80491c
  803d3c:	e8 1f ca ff ff       	call   800760 <cprintf>
  803d41:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803d44:	a1 00 50 80 00       	mov    0x805000,%eax
  803d49:	ff 75 0c             	pushl  0xc(%ebp)
  803d4c:	ff 75 08             	pushl  0x8(%ebp)
  803d4f:	50                   	push   %eax
  803d50:	68 21 49 80 00       	push   $0x804921
  803d55:	e8 06 ca ff ff       	call   800760 <cprintf>
  803d5a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  803d60:	83 ec 08             	sub    $0x8,%esp
  803d63:	ff 75 f4             	pushl  -0xc(%ebp)
  803d66:	50                   	push   %eax
  803d67:	e8 89 c9 ff ff       	call   8006f5 <vcprintf>
  803d6c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803d6f:	83 ec 08             	sub    $0x8,%esp
  803d72:	6a 00                	push   $0x0
  803d74:	68 3d 49 80 00       	push   $0x80493d
  803d79:	e8 77 c9 ff ff       	call   8006f5 <vcprintf>
  803d7e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803d81:	e8 f8 c8 ff ff       	call   80067e <exit>

	// should not return here
	while (1) ;
  803d86:	eb fe                	jmp    803d86 <_panic+0x70>

00803d88 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803d88:	55                   	push   %ebp
  803d89:	89 e5                	mov    %esp,%ebp
  803d8b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803d8e:	a1 20 50 80 00       	mov    0x805020,%eax
  803d93:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d9c:	39 c2                	cmp    %eax,%edx
  803d9e:	74 14                	je     803db4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803da0:	83 ec 04             	sub    $0x4,%esp
  803da3:	68 40 49 80 00       	push   $0x804940
  803da8:	6a 26                	push   $0x26
  803daa:	68 8c 49 80 00       	push   $0x80498c
  803daf:	e8 62 ff ff ff       	call   803d16 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803db4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803dbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803dc2:	e9 c5 00 00 00       	jmp    803e8c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd4:	01 d0                	add    %edx,%eax
  803dd6:	8b 00                	mov    (%eax),%eax
  803dd8:	85 c0                	test   %eax,%eax
  803dda:	75 08                	jne    803de4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803ddc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803ddf:	e9 a5 00 00 00       	jmp    803e89 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803de4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803deb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803df2:	eb 69                	jmp    803e5d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803df4:	a1 20 50 80 00       	mov    0x805020,%eax
  803df9:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803dff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e02:	89 d0                	mov    %edx,%eax
  803e04:	01 c0                	add    %eax,%eax
  803e06:	01 d0                	add    %edx,%eax
  803e08:	c1 e0 03             	shl    $0x3,%eax
  803e0b:	01 c8                	add    %ecx,%eax
  803e0d:	8a 40 04             	mov    0x4(%eax),%al
  803e10:	84 c0                	test   %al,%al
  803e12:	75 46                	jne    803e5a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803e14:	a1 20 50 80 00       	mov    0x805020,%eax
  803e19:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803e1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e22:	89 d0                	mov    %edx,%eax
  803e24:	01 c0                	add    %eax,%eax
  803e26:	01 d0                	add    %edx,%eax
  803e28:	c1 e0 03             	shl    $0x3,%eax
  803e2b:	01 c8                	add    %ecx,%eax
  803e2d:	8b 00                	mov    (%eax),%eax
  803e2f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803e32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803e3a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e3f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803e46:	8b 45 08             	mov    0x8(%ebp),%eax
  803e49:	01 c8                	add    %ecx,%eax
  803e4b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803e4d:	39 c2                	cmp    %eax,%edx
  803e4f:	75 09                	jne    803e5a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803e51:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803e58:	eb 15                	jmp    803e6f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803e5a:	ff 45 e8             	incl   -0x18(%ebp)
  803e5d:	a1 20 50 80 00       	mov    0x805020,%eax
  803e62:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803e68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e6b:	39 c2                	cmp    %eax,%edx
  803e6d:	77 85                	ja     803df4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803e6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e73:	75 14                	jne    803e89 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803e75:	83 ec 04             	sub    $0x4,%esp
  803e78:	68 98 49 80 00       	push   $0x804998
  803e7d:	6a 3a                	push   $0x3a
  803e7f:	68 8c 49 80 00       	push   $0x80498c
  803e84:	e8 8d fe ff ff       	call   803d16 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803e89:	ff 45 f0             	incl   -0x10(%ebp)
  803e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e8f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803e92:	0f 8c 2f ff ff ff    	jl     803dc7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803e98:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803e9f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803ea6:	eb 26                	jmp    803ece <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803ea8:	a1 20 50 80 00       	mov    0x805020,%eax
  803ead:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803eb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803eb6:	89 d0                	mov    %edx,%eax
  803eb8:	01 c0                	add    %eax,%eax
  803eba:	01 d0                	add    %edx,%eax
  803ebc:	c1 e0 03             	shl    $0x3,%eax
  803ebf:	01 c8                	add    %ecx,%eax
  803ec1:	8a 40 04             	mov    0x4(%eax),%al
  803ec4:	3c 01                	cmp    $0x1,%al
  803ec6:	75 03                	jne    803ecb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803ec8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ecb:	ff 45 e0             	incl   -0x20(%ebp)
  803ece:	a1 20 50 80 00       	mov    0x805020,%eax
  803ed3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803edc:	39 c2                	cmp    %eax,%edx
  803ede:	77 c8                	ja     803ea8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803ee6:	74 14                	je     803efc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803ee8:	83 ec 04             	sub    $0x4,%esp
  803eeb:	68 ec 49 80 00       	push   $0x8049ec
  803ef0:	6a 44                	push   $0x44
  803ef2:	68 8c 49 80 00       	push   $0x80498c
  803ef7:	e8 1a fe ff ff       	call   803d16 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803efc:	90                   	nop
  803efd:	c9                   	leave  
  803efe:	c3                   	ret    
  803eff:	90                   	nop

00803f00 <__udivdi3>:
  803f00:	55                   	push   %ebp
  803f01:	57                   	push   %edi
  803f02:	56                   	push   %esi
  803f03:	53                   	push   %ebx
  803f04:	83 ec 1c             	sub    $0x1c,%esp
  803f07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f17:	89 ca                	mov    %ecx,%edx
  803f19:	89 f8                	mov    %edi,%eax
  803f1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f1f:	85 f6                	test   %esi,%esi
  803f21:	75 2d                	jne    803f50 <__udivdi3+0x50>
  803f23:	39 cf                	cmp    %ecx,%edi
  803f25:	77 65                	ja     803f8c <__udivdi3+0x8c>
  803f27:	89 fd                	mov    %edi,%ebp
  803f29:	85 ff                	test   %edi,%edi
  803f2b:	75 0b                	jne    803f38 <__udivdi3+0x38>
  803f2d:	b8 01 00 00 00       	mov    $0x1,%eax
  803f32:	31 d2                	xor    %edx,%edx
  803f34:	f7 f7                	div    %edi
  803f36:	89 c5                	mov    %eax,%ebp
  803f38:	31 d2                	xor    %edx,%edx
  803f3a:	89 c8                	mov    %ecx,%eax
  803f3c:	f7 f5                	div    %ebp
  803f3e:	89 c1                	mov    %eax,%ecx
  803f40:	89 d8                	mov    %ebx,%eax
  803f42:	f7 f5                	div    %ebp
  803f44:	89 cf                	mov    %ecx,%edi
  803f46:	89 fa                	mov    %edi,%edx
  803f48:	83 c4 1c             	add    $0x1c,%esp
  803f4b:	5b                   	pop    %ebx
  803f4c:	5e                   	pop    %esi
  803f4d:	5f                   	pop    %edi
  803f4e:	5d                   	pop    %ebp
  803f4f:	c3                   	ret    
  803f50:	39 ce                	cmp    %ecx,%esi
  803f52:	77 28                	ja     803f7c <__udivdi3+0x7c>
  803f54:	0f bd fe             	bsr    %esi,%edi
  803f57:	83 f7 1f             	xor    $0x1f,%edi
  803f5a:	75 40                	jne    803f9c <__udivdi3+0x9c>
  803f5c:	39 ce                	cmp    %ecx,%esi
  803f5e:	72 0a                	jb     803f6a <__udivdi3+0x6a>
  803f60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f64:	0f 87 9e 00 00 00    	ja     804008 <__udivdi3+0x108>
  803f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803f6f:	89 fa                	mov    %edi,%edx
  803f71:	83 c4 1c             	add    $0x1c,%esp
  803f74:	5b                   	pop    %ebx
  803f75:	5e                   	pop    %esi
  803f76:	5f                   	pop    %edi
  803f77:	5d                   	pop    %ebp
  803f78:	c3                   	ret    
  803f79:	8d 76 00             	lea    0x0(%esi),%esi
  803f7c:	31 ff                	xor    %edi,%edi
  803f7e:	31 c0                	xor    %eax,%eax
  803f80:	89 fa                	mov    %edi,%edx
  803f82:	83 c4 1c             	add    $0x1c,%esp
  803f85:	5b                   	pop    %ebx
  803f86:	5e                   	pop    %esi
  803f87:	5f                   	pop    %edi
  803f88:	5d                   	pop    %ebp
  803f89:	c3                   	ret    
  803f8a:	66 90                	xchg   %ax,%ax
  803f8c:	89 d8                	mov    %ebx,%eax
  803f8e:	f7 f7                	div    %edi
  803f90:	31 ff                	xor    %edi,%edi
  803f92:	89 fa                	mov    %edi,%edx
  803f94:	83 c4 1c             	add    $0x1c,%esp
  803f97:	5b                   	pop    %ebx
  803f98:	5e                   	pop    %esi
  803f99:	5f                   	pop    %edi
  803f9a:	5d                   	pop    %ebp
  803f9b:	c3                   	ret    
  803f9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fa1:	89 eb                	mov    %ebp,%ebx
  803fa3:	29 fb                	sub    %edi,%ebx
  803fa5:	89 f9                	mov    %edi,%ecx
  803fa7:	d3 e6                	shl    %cl,%esi
  803fa9:	89 c5                	mov    %eax,%ebp
  803fab:	88 d9                	mov    %bl,%cl
  803fad:	d3 ed                	shr    %cl,%ebp
  803faf:	89 e9                	mov    %ebp,%ecx
  803fb1:	09 f1                	or     %esi,%ecx
  803fb3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803fb7:	89 f9                	mov    %edi,%ecx
  803fb9:	d3 e0                	shl    %cl,%eax
  803fbb:	89 c5                	mov    %eax,%ebp
  803fbd:	89 d6                	mov    %edx,%esi
  803fbf:	88 d9                	mov    %bl,%cl
  803fc1:	d3 ee                	shr    %cl,%esi
  803fc3:	89 f9                	mov    %edi,%ecx
  803fc5:	d3 e2                	shl    %cl,%edx
  803fc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fcb:	88 d9                	mov    %bl,%cl
  803fcd:	d3 e8                	shr    %cl,%eax
  803fcf:	09 c2                	or     %eax,%edx
  803fd1:	89 d0                	mov    %edx,%eax
  803fd3:	89 f2                	mov    %esi,%edx
  803fd5:	f7 74 24 0c          	divl   0xc(%esp)
  803fd9:	89 d6                	mov    %edx,%esi
  803fdb:	89 c3                	mov    %eax,%ebx
  803fdd:	f7 e5                	mul    %ebp
  803fdf:	39 d6                	cmp    %edx,%esi
  803fe1:	72 19                	jb     803ffc <__udivdi3+0xfc>
  803fe3:	74 0b                	je     803ff0 <__udivdi3+0xf0>
  803fe5:	89 d8                	mov    %ebx,%eax
  803fe7:	31 ff                	xor    %edi,%edi
  803fe9:	e9 58 ff ff ff       	jmp    803f46 <__udivdi3+0x46>
  803fee:	66 90                	xchg   %ax,%ax
  803ff0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ff4:	89 f9                	mov    %edi,%ecx
  803ff6:	d3 e2                	shl    %cl,%edx
  803ff8:	39 c2                	cmp    %eax,%edx
  803ffa:	73 e9                	jae    803fe5 <__udivdi3+0xe5>
  803ffc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803fff:	31 ff                	xor    %edi,%edi
  804001:	e9 40 ff ff ff       	jmp    803f46 <__udivdi3+0x46>
  804006:	66 90                	xchg   %ax,%ax
  804008:	31 c0                	xor    %eax,%eax
  80400a:	e9 37 ff ff ff       	jmp    803f46 <__udivdi3+0x46>
  80400f:	90                   	nop

00804010 <__umoddi3>:
  804010:	55                   	push   %ebp
  804011:	57                   	push   %edi
  804012:	56                   	push   %esi
  804013:	53                   	push   %ebx
  804014:	83 ec 1c             	sub    $0x1c,%esp
  804017:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80401b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80401f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804023:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804027:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80402b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80402f:	89 f3                	mov    %esi,%ebx
  804031:	89 fa                	mov    %edi,%edx
  804033:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804037:	89 34 24             	mov    %esi,(%esp)
  80403a:	85 c0                	test   %eax,%eax
  80403c:	75 1a                	jne    804058 <__umoddi3+0x48>
  80403e:	39 f7                	cmp    %esi,%edi
  804040:	0f 86 a2 00 00 00    	jbe    8040e8 <__umoddi3+0xd8>
  804046:	89 c8                	mov    %ecx,%eax
  804048:	89 f2                	mov    %esi,%edx
  80404a:	f7 f7                	div    %edi
  80404c:	89 d0                	mov    %edx,%eax
  80404e:	31 d2                	xor    %edx,%edx
  804050:	83 c4 1c             	add    $0x1c,%esp
  804053:	5b                   	pop    %ebx
  804054:	5e                   	pop    %esi
  804055:	5f                   	pop    %edi
  804056:	5d                   	pop    %ebp
  804057:	c3                   	ret    
  804058:	39 f0                	cmp    %esi,%eax
  80405a:	0f 87 ac 00 00 00    	ja     80410c <__umoddi3+0xfc>
  804060:	0f bd e8             	bsr    %eax,%ebp
  804063:	83 f5 1f             	xor    $0x1f,%ebp
  804066:	0f 84 ac 00 00 00    	je     804118 <__umoddi3+0x108>
  80406c:	bf 20 00 00 00       	mov    $0x20,%edi
  804071:	29 ef                	sub    %ebp,%edi
  804073:	89 fe                	mov    %edi,%esi
  804075:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804079:	89 e9                	mov    %ebp,%ecx
  80407b:	d3 e0                	shl    %cl,%eax
  80407d:	89 d7                	mov    %edx,%edi
  80407f:	89 f1                	mov    %esi,%ecx
  804081:	d3 ef                	shr    %cl,%edi
  804083:	09 c7                	or     %eax,%edi
  804085:	89 e9                	mov    %ebp,%ecx
  804087:	d3 e2                	shl    %cl,%edx
  804089:	89 14 24             	mov    %edx,(%esp)
  80408c:	89 d8                	mov    %ebx,%eax
  80408e:	d3 e0                	shl    %cl,%eax
  804090:	89 c2                	mov    %eax,%edx
  804092:	8b 44 24 08          	mov    0x8(%esp),%eax
  804096:	d3 e0                	shl    %cl,%eax
  804098:	89 44 24 04          	mov    %eax,0x4(%esp)
  80409c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040a0:	89 f1                	mov    %esi,%ecx
  8040a2:	d3 e8                	shr    %cl,%eax
  8040a4:	09 d0                	or     %edx,%eax
  8040a6:	d3 eb                	shr    %cl,%ebx
  8040a8:	89 da                	mov    %ebx,%edx
  8040aa:	f7 f7                	div    %edi
  8040ac:	89 d3                	mov    %edx,%ebx
  8040ae:	f7 24 24             	mull   (%esp)
  8040b1:	89 c6                	mov    %eax,%esi
  8040b3:	89 d1                	mov    %edx,%ecx
  8040b5:	39 d3                	cmp    %edx,%ebx
  8040b7:	0f 82 87 00 00 00    	jb     804144 <__umoddi3+0x134>
  8040bd:	0f 84 91 00 00 00    	je     804154 <__umoddi3+0x144>
  8040c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040c7:	29 f2                	sub    %esi,%edx
  8040c9:	19 cb                	sbb    %ecx,%ebx
  8040cb:	89 d8                	mov    %ebx,%eax
  8040cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8040d1:	d3 e0                	shl    %cl,%eax
  8040d3:	89 e9                	mov    %ebp,%ecx
  8040d5:	d3 ea                	shr    %cl,%edx
  8040d7:	09 d0                	or     %edx,%eax
  8040d9:	89 e9                	mov    %ebp,%ecx
  8040db:	d3 eb                	shr    %cl,%ebx
  8040dd:	89 da                	mov    %ebx,%edx
  8040df:	83 c4 1c             	add    $0x1c,%esp
  8040e2:	5b                   	pop    %ebx
  8040e3:	5e                   	pop    %esi
  8040e4:	5f                   	pop    %edi
  8040e5:	5d                   	pop    %ebp
  8040e6:	c3                   	ret    
  8040e7:	90                   	nop
  8040e8:	89 fd                	mov    %edi,%ebp
  8040ea:	85 ff                	test   %edi,%edi
  8040ec:	75 0b                	jne    8040f9 <__umoddi3+0xe9>
  8040ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8040f3:	31 d2                	xor    %edx,%edx
  8040f5:	f7 f7                	div    %edi
  8040f7:	89 c5                	mov    %eax,%ebp
  8040f9:	89 f0                	mov    %esi,%eax
  8040fb:	31 d2                	xor    %edx,%edx
  8040fd:	f7 f5                	div    %ebp
  8040ff:	89 c8                	mov    %ecx,%eax
  804101:	f7 f5                	div    %ebp
  804103:	89 d0                	mov    %edx,%eax
  804105:	e9 44 ff ff ff       	jmp    80404e <__umoddi3+0x3e>
  80410a:	66 90                	xchg   %ax,%ax
  80410c:	89 c8                	mov    %ecx,%eax
  80410e:	89 f2                	mov    %esi,%edx
  804110:	83 c4 1c             	add    $0x1c,%esp
  804113:	5b                   	pop    %ebx
  804114:	5e                   	pop    %esi
  804115:	5f                   	pop    %edi
  804116:	5d                   	pop    %ebp
  804117:	c3                   	ret    
  804118:	3b 04 24             	cmp    (%esp),%eax
  80411b:	72 06                	jb     804123 <__umoddi3+0x113>
  80411d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804121:	77 0f                	ja     804132 <__umoddi3+0x122>
  804123:	89 f2                	mov    %esi,%edx
  804125:	29 f9                	sub    %edi,%ecx
  804127:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80412b:	89 14 24             	mov    %edx,(%esp)
  80412e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804132:	8b 44 24 04          	mov    0x4(%esp),%eax
  804136:	8b 14 24             	mov    (%esp),%edx
  804139:	83 c4 1c             	add    $0x1c,%esp
  80413c:	5b                   	pop    %ebx
  80413d:	5e                   	pop    %esi
  80413e:	5f                   	pop    %edi
  80413f:	5d                   	pop    %ebp
  804140:	c3                   	ret    
  804141:	8d 76 00             	lea    0x0(%esi),%esi
  804144:	2b 04 24             	sub    (%esp),%eax
  804147:	19 fa                	sbb    %edi,%edx
  804149:	89 d1                	mov    %edx,%ecx
  80414b:	89 c6                	mov    %eax,%esi
  80414d:	e9 71 ff ff ff       	jmp    8040c3 <__umoddi3+0xb3>
  804152:	66 90                	xchg   %ax,%ax
  804154:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804158:	72 ea                	jb     804144 <__umoddi3+0x134>
  80415a:	89 d9                	mov    %ebx,%ecx
  80415c:	e9 62 ff ff ff       	jmp    8040c3 <__umoddi3+0xb3>
