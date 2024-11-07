
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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
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
  80003e:	e8 89 18 00 00       	call   8018cc <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 b3 18 00 00       	call   8018fe <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 80 20 80 00       	push   $0x802080
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 ee 14 00 00       	call   80155a <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 84 20 80 00       	push   $0x802084
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 d8 14 00 00       	call   80155a <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 8c 20 80 00       	push   $0x80208c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 bb 14 00 00       	call   80155a <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 9a 20 80 00       	push   $0x80209a
  8000b8:	e8 6e 14 00 00       	call   80152b <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 a4 20 80 00       	push   $0x8020a4
  80012b:	e8 08 06 00 00       	call   800738 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 c9 20 80 00       	push   $0x8020c9
  80013f:	e8 e7 13 00 00       	call   80152b <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 ce 20 80 00       	push   $0x8020ce
  80015e:	e8 c8 13 00 00       	call   80152b <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 d2 20 80 00       	push   $0x8020d2
  80017d:	e8 a9 13 00 00       	call   80152b <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 d6 20 80 00       	push   $0x8020d6
  80019c:	e8 8a 13 00 00       	call   80152b <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 da 20 80 00       	push   $0x8020da
  8001bb:	e8 6b 13 00 00       	call   80152b <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 fc 16 00 00       	call   801931 <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 ad 13 00 00       	call   8018e5 <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 02             	shl    $0x2,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	c1 e0 02             	shl    $0x2,%eax
  80054c:	01 d0                	add    %edx,%eax
  80054e:	01 c0                	add    %eax,%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	c1 e0 04             	shl    $0x4,%eax
  800555:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80055a:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80055f:	a1 04 30 80 00       	mov    0x803004,%eax
  800564:	8a 40 20             	mov    0x20(%eax),%al
  800567:	84 c0                	test   %al,%al
  800569:	74 0d                	je     800578 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80056b:	a1 04 30 80 00       	mov    0x803004,%eax
  800570:	83 c0 20             	add    $0x20,%eax
  800573:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800578:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80057c:	7e 0a                	jle    800588 <libmain+0x5b>
		binaryname = argv[0];
  80057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	ff 75 0c             	pushl  0xc(%ebp)
  80058e:	ff 75 08             	pushl  0x8(%ebp)
  800591:	e8 a2 fa ff ff       	call   800038 <_main>
  800596:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800599:	e8 cb 10 00 00       	call   801669 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	68 f8 20 80 00       	push   $0x8020f8
  8005a6:	e8 8d 01 00 00       	call   800738 <cprintf>
  8005ab:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005ae:	a1 04 30 80 00       	mov    0x803004,%eax
  8005b3:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8005b9:	a1 04 30 80 00       	mov    0x803004,%eax
  8005be:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	52                   	push   %edx
  8005c8:	50                   	push   %eax
  8005c9:	68 20 21 80 00       	push   $0x802120
  8005ce:	e8 65 01 00 00       	call   800738 <cprintf>
  8005d3:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005d6:	a1 04 30 80 00       	mov    0x803004,%eax
  8005db:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8005e1:	a1 04 30 80 00       	mov    0x803004,%eax
  8005e6:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8005ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8005f1:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8005f7:	51                   	push   %ecx
  8005f8:	52                   	push   %edx
  8005f9:	50                   	push   %eax
  8005fa:	68 48 21 80 00       	push   $0x802148
  8005ff:	e8 34 01 00 00       	call   800738 <cprintf>
  800604:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800607:	a1 04 30 80 00       	mov    0x803004,%eax
  80060c:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	50                   	push   %eax
  800616:	68 a0 21 80 00       	push   $0x8021a0
  80061b:	e8 18 01 00 00       	call   800738 <cprintf>
  800620:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800623:	83 ec 0c             	sub    $0xc,%esp
  800626:	68 f8 20 80 00       	push   $0x8020f8
  80062b:	e8 08 01 00 00       	call   800738 <cprintf>
  800630:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800633:	e8 4b 10 00 00       	call   801683 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800638:	e8 19 00 00 00       	call   800656 <exit>
}
  80063d:	90                   	nop
  80063e:	c9                   	leave  
  80063f:	c3                   	ret    

00800640 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800640:	55                   	push   %ebp
  800641:	89 e5                	mov    %esp,%ebp
  800643:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800646:	83 ec 0c             	sub    $0xc,%esp
  800649:	6a 00                	push   $0x0
  80064b:	e8 61 12 00 00       	call   8018b1 <sys_destroy_env>
  800650:	83 c4 10             	add    $0x10,%esp
}
  800653:	90                   	nop
  800654:	c9                   	leave  
  800655:	c3                   	ret    

00800656 <exit>:

void
exit(void)
{
  800656:	55                   	push   %ebp
  800657:	89 e5                	mov    %esp,%ebp
  800659:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80065c:	e8 b6 12 00 00       	call   801917 <sys_exit_env>
}
  800661:	90                   	nop
  800662:	c9                   	leave  
  800663:	c3                   	ret    

00800664 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80066a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	8d 48 01             	lea    0x1(%eax),%ecx
  800672:	8b 55 0c             	mov    0xc(%ebp),%edx
  800675:	89 0a                	mov    %ecx,(%edx)
  800677:	8b 55 08             	mov    0x8(%ebp),%edx
  80067a:	88 d1                	mov    %dl,%cl
  80067c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800683:	8b 45 0c             	mov    0xc(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	3d ff 00 00 00       	cmp    $0xff,%eax
  80068d:	75 2c                	jne    8006bb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80068f:	a0 08 30 80 00       	mov    0x803008,%al
  800694:	0f b6 c0             	movzbl %al,%eax
  800697:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069a:	8b 12                	mov    (%edx),%edx
  80069c:	89 d1                	mov    %edx,%ecx
  80069e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a1:	83 c2 08             	add    $0x8,%edx
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	50                   	push   %eax
  8006a8:	51                   	push   %ecx
  8006a9:	52                   	push   %edx
  8006aa:	e8 78 0f 00 00       	call   801627 <sys_cputs>
  8006af:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006be:	8b 40 04             	mov    0x4(%eax),%eax
  8006c1:	8d 50 01             	lea    0x1(%eax),%edx
  8006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ca:	90                   	nop
  8006cb:	c9                   	leave  
  8006cc:	c3                   	ret    

008006cd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006cd:	55                   	push   %ebp
  8006ce:	89 e5                	mov    %esp,%ebp
  8006d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006dd:	00 00 00 
	b.cnt = 0;
  8006e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ea:	ff 75 0c             	pushl  0xc(%ebp)
  8006ed:	ff 75 08             	pushl  0x8(%ebp)
  8006f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f6:	50                   	push   %eax
  8006f7:	68 64 06 80 00       	push   $0x800664
  8006fc:	e8 11 02 00 00       	call   800912 <vprintfmt>
  800701:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800704:	a0 08 30 80 00       	mov    0x803008,%al
  800709:	0f b6 c0             	movzbl %al,%eax
  80070c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800712:	83 ec 04             	sub    $0x4,%esp
  800715:	50                   	push   %eax
  800716:	52                   	push   %edx
  800717:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071d:	83 c0 08             	add    $0x8,%eax
  800720:	50                   	push   %eax
  800721:	e8 01 0f 00 00       	call   801627 <sys_cputs>
  800726:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800729:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800730:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800736:	c9                   	leave  
  800737:	c3                   	ret    

00800738 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80073e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800745:	8d 45 0c             	lea    0xc(%ebp),%eax
  800748:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 f4             	pushl  -0xc(%ebp)
  800754:	50                   	push   %eax
  800755:	e8 73 ff ff ff       	call   8006cd <vcprintf>
  80075a:	83 c4 10             	add    $0x10,%esp
  80075d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800760:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80076b:	e8 f9 0e 00 00       	call   801669 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800770:	8d 45 0c             	lea    0xc(%ebp),%eax
  800773:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	ff 75 f4             	pushl  -0xc(%ebp)
  80077f:	50                   	push   %eax
  800780:	e8 48 ff ff ff       	call   8006cd <vcprintf>
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80078b:	e8 f3 0e 00 00       	call   801683 <sys_unlock_cons>
	return cnt;
  800790:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800793:	c9                   	leave  
  800794:	c3                   	ret    

00800795 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800795:	55                   	push   %ebp
  800796:	89 e5                	mov    %esp,%ebp
  800798:	53                   	push   %ebx
  800799:	83 ec 14             	sub    $0x14,%esp
  80079c:	8b 45 10             	mov    0x10(%ebp),%eax
  80079f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007a8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b3:	77 55                	ja     80080a <printnum+0x75>
  8007b5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b8:	72 05                	jb     8007bf <printnum+0x2a>
  8007ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007bd:	77 4b                	ja     80080a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007bf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cd:	52                   	push   %edx
  8007ce:	50                   	push   %eax
  8007cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8007d5:	e8 36 16 00 00       	call   801e10 <__udivdi3>
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	83 ec 04             	sub    $0x4,%esp
  8007e0:	ff 75 20             	pushl  0x20(%ebp)
  8007e3:	53                   	push   %ebx
  8007e4:	ff 75 18             	pushl  0x18(%ebp)
  8007e7:	52                   	push   %edx
  8007e8:	50                   	push   %eax
  8007e9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ec:	ff 75 08             	pushl  0x8(%ebp)
  8007ef:	e8 a1 ff ff ff       	call   800795 <printnum>
  8007f4:	83 c4 20             	add    $0x20,%esp
  8007f7:	eb 1a                	jmp    800813 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	ff 75 20             	pushl  0x20(%ebp)
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	ff d0                	call   *%eax
  800807:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080a:	ff 4d 1c             	decl   0x1c(%ebp)
  80080d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800811:	7f e6                	jg     8007f9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800813:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800816:	bb 00 00 00 00       	mov    $0x0,%ebx
  80081b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800821:	53                   	push   %ebx
  800822:	51                   	push   %ecx
  800823:	52                   	push   %edx
  800824:	50                   	push   %eax
  800825:	e8 f6 16 00 00       	call   801f20 <__umoddi3>
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	05 d4 23 80 00       	add    $0x8023d4,%eax
  800832:	8a 00                	mov    (%eax),%al
  800834:	0f be c0             	movsbl %al,%eax
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	50                   	push   %eax
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	ff d0                	call   *%eax
  800843:	83 c4 10             	add    $0x10,%esp
}
  800846:	90                   	nop
  800847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084a:	c9                   	leave  
  80084b:	c3                   	ret    

0080084c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80084f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800853:	7e 1c                	jle    800871 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	8d 50 08             	lea    0x8(%eax),%edx
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	89 10                	mov    %edx,(%eax)
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	8b 00                	mov    (%eax),%eax
  800867:	83 e8 08             	sub    $0x8,%eax
  80086a:	8b 50 04             	mov    0x4(%eax),%edx
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	eb 40                	jmp    8008b1 <getuint+0x65>
	else if (lflag)
  800871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800875:	74 1e                	je     800895 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	8d 50 04             	lea    0x4(%eax),%edx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	89 10                	mov    %edx,(%eax)
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	83 e8 04             	sub    $0x4,%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	ba 00 00 00 00       	mov    $0x0,%edx
  800893:	eb 1c                	jmp    8008b1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	8d 50 04             	lea    0x4(%eax),%edx
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	89 10                	mov    %edx,(%eax)
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	83 e8 04             	sub    $0x4,%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ba:	7e 1c                	jle    8008d8 <getint+0x25>
		return va_arg(*ap, long long);
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	8d 50 08             	lea    0x8(%eax),%edx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	89 10                	mov    %edx,(%eax)
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	83 e8 08             	sub    $0x8,%eax
  8008d1:	8b 50 04             	mov    0x4(%eax),%edx
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	eb 38                	jmp    800910 <getint+0x5d>
	else if (lflag)
  8008d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008dc:	74 1a                	je     8008f8 <getint+0x45>
		return va_arg(*ap, long);
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	8d 50 04             	lea    0x4(%eax),%edx
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	89 10                	mov    %edx,(%eax)
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	83 e8 04             	sub    $0x4,%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	99                   	cltd   
  8008f6:	eb 18                	jmp    800910 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	8d 50 04             	lea    0x4(%eax),%edx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	89 10                	mov    %edx,(%eax)
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	83 e8 04             	sub    $0x4,%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	99                   	cltd   
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
  800917:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091a:	eb 17                	jmp    800933 <vprintfmt+0x21>
			if (ch == '\0')
  80091c:	85 db                	test   %ebx,%ebx
  80091e:	0f 84 c1 03 00 00    	je     800ce5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	ff d0                	call   *%eax
  800930:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800933:	8b 45 10             	mov    0x10(%ebp),%eax
  800936:	8d 50 01             	lea    0x1(%eax),%edx
  800939:	89 55 10             	mov    %edx,0x10(%ebp)
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	0f b6 d8             	movzbl %al,%ebx
  800941:	83 fb 25             	cmp    $0x25,%ebx
  800944:	75 d6                	jne    80091c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800946:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80094a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800951:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800958:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80095f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800966:	8b 45 10             	mov    0x10(%ebp),%eax
  800969:	8d 50 01             	lea    0x1(%eax),%edx
  80096c:	89 55 10             	mov    %edx,0x10(%ebp)
  80096f:	8a 00                	mov    (%eax),%al
  800971:	0f b6 d8             	movzbl %al,%ebx
  800974:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800977:	83 f8 5b             	cmp    $0x5b,%eax
  80097a:	0f 87 3d 03 00 00    	ja     800cbd <vprintfmt+0x3ab>
  800980:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  800987:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800989:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80098d:	eb d7                	jmp    800966 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80098f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800993:	eb d1                	jmp    800966 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800995:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80099c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099f:	89 d0                	mov    %edx,%eax
  8009a1:	c1 e0 02             	shl    $0x2,%eax
  8009a4:	01 d0                	add    %edx,%eax
  8009a6:	01 c0                	add    %eax,%eax
  8009a8:	01 d8                	add    %ebx,%eax
  8009aa:	83 e8 30             	sub    $0x30,%eax
  8009ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b3:	8a 00                	mov    (%eax),%al
  8009b5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009b8:	83 fb 2f             	cmp    $0x2f,%ebx
  8009bb:	7e 3e                	jle    8009fb <vprintfmt+0xe9>
  8009bd:	83 fb 39             	cmp    $0x39,%ebx
  8009c0:	7f 39                	jg     8009fb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009c5:	eb d5                	jmp    80099c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ca:	83 c0 04             	add    $0x4,%eax
  8009cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d3:	83 e8 04             	sub    $0x4,%eax
  8009d6:	8b 00                	mov    (%eax),%eax
  8009d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009db:	eb 1f                	jmp    8009fc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e1:	79 83                	jns    800966 <vprintfmt+0x54>
				width = 0;
  8009e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ea:	e9 77 ff ff ff       	jmp    800966 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009ef:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009f6:	e9 6b ff ff ff       	jmp    800966 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009fb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a00:	0f 89 60 ff ff ff    	jns    800966 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a0c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a13:	e9 4e ff ff ff       	jmp    800966 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a18:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a1b:	e9 46 ff ff ff       	jmp    800966 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	83 c0 04             	add    $0x4,%eax
  800a26:	89 45 14             	mov    %eax,0x14(%ebp)
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	83 e8 04             	sub    $0x4,%eax
  800a2f:	8b 00                	mov    (%eax),%eax
  800a31:	83 ec 08             	sub    $0x8,%esp
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	50                   	push   %eax
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	ff d0                	call   *%eax
  800a3d:	83 c4 10             	add    $0x10,%esp
			break;
  800a40:	e9 9b 02 00 00       	jmp    800ce0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a45:	8b 45 14             	mov    0x14(%ebp),%eax
  800a48:	83 c0 04             	add    $0x4,%eax
  800a4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a51:	83 e8 04             	sub    $0x4,%eax
  800a54:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a56:	85 db                	test   %ebx,%ebx
  800a58:	79 02                	jns    800a5c <vprintfmt+0x14a>
				err = -err;
  800a5a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a5c:	83 fb 64             	cmp    $0x64,%ebx
  800a5f:	7f 0b                	jg     800a6c <vprintfmt+0x15a>
  800a61:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  800a68:	85 f6                	test   %esi,%esi
  800a6a:	75 19                	jne    800a85 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a6c:	53                   	push   %ebx
  800a6d:	68 e5 23 80 00       	push   $0x8023e5
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	ff 75 08             	pushl  0x8(%ebp)
  800a78:	e8 70 02 00 00       	call   800ced <printfmt>
  800a7d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a80:	e9 5b 02 00 00       	jmp    800ce0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a85:	56                   	push   %esi
  800a86:	68 ee 23 80 00       	push   $0x8023ee
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 57 02 00 00       	call   800ced <printfmt>
  800a96:	83 c4 10             	add    $0x10,%esp
			break;
  800a99:	e9 42 02 00 00       	jmp    800ce0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	83 c0 04             	add    $0x4,%eax
  800aa4:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaa:	83 e8 04             	sub    $0x4,%eax
  800aad:	8b 30                	mov    (%eax),%esi
  800aaf:	85 f6                	test   %esi,%esi
  800ab1:	75 05                	jne    800ab8 <vprintfmt+0x1a6>
				p = "(null)";
  800ab3:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  800ab8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800abc:	7e 6d                	jle    800b2b <vprintfmt+0x219>
  800abe:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac2:	74 67                	je     800b2b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	50                   	push   %eax
  800acb:	56                   	push   %esi
  800acc:	e8 1e 03 00 00       	call   800def <strnlen>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ad7:	eb 16                	jmp    800aef <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ad9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	ff d0                	call   *%eax
  800ae9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800aec:	ff 4d e4             	decl   -0x1c(%ebp)
  800aef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af3:	7f e4                	jg     800ad9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af5:	eb 34                	jmp    800b2b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800af7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800afb:	74 1c                	je     800b19 <vprintfmt+0x207>
  800afd:	83 fb 1f             	cmp    $0x1f,%ebx
  800b00:	7e 05                	jle    800b07 <vprintfmt+0x1f5>
  800b02:	83 fb 7e             	cmp    $0x7e,%ebx
  800b05:	7e 12                	jle    800b19 <vprintfmt+0x207>
					putch('?', putdat);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 0c             	pushl  0xc(%ebp)
  800b0d:	6a 3f                	push   $0x3f
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	eb 0f                	jmp    800b28 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	53                   	push   %ebx
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	ff d0                	call   *%eax
  800b25:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b28:	ff 4d e4             	decl   -0x1c(%ebp)
  800b2b:	89 f0                	mov    %esi,%eax
  800b2d:	8d 70 01             	lea    0x1(%eax),%esi
  800b30:	8a 00                	mov    (%eax),%al
  800b32:	0f be d8             	movsbl %al,%ebx
  800b35:	85 db                	test   %ebx,%ebx
  800b37:	74 24                	je     800b5d <vprintfmt+0x24b>
  800b39:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b3d:	78 b8                	js     800af7 <vprintfmt+0x1e5>
  800b3f:	ff 4d e0             	decl   -0x20(%ebp)
  800b42:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b46:	79 af                	jns    800af7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b48:	eb 13                	jmp    800b5d <vprintfmt+0x24b>
				putch(' ', putdat);
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	6a 20                	push   $0x20
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e7                	jg     800b4a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b63:	e9 78 01 00 00       	jmp    800ce0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 e8             	pushl  -0x18(%ebp)
  800b6e:	8d 45 14             	lea    0x14(%ebp),%eax
  800b71:	50                   	push   %eax
  800b72:	e8 3c fd ff ff       	call   8008b3 <getint>
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b86:	85 d2                	test   %edx,%edx
  800b88:	79 23                	jns    800bad <vprintfmt+0x29b>
				putch('-', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 2d                	push   $0x2d
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba0:	f7 d8                	neg    %eax
  800ba2:	83 d2 00             	adc    $0x0,%edx
  800ba5:	f7 da                	neg    %edx
  800ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bad:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb4:	e9 bc 00 00 00       	jmp    800c75 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 e8             	pushl  -0x18(%ebp)
  800bbf:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc2:	50                   	push   %eax
  800bc3:	e8 84 fc ff ff       	call   80084c <getuint>
  800bc8:	83 c4 10             	add    $0x10,%esp
  800bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bce:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd8:	e9 98 00 00 00       	jmp    800c75 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bdd:	83 ec 08             	sub    $0x8,%esp
  800be0:	ff 75 0c             	pushl  0xc(%ebp)
  800be3:	6a 58                	push   $0x58
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	ff d0                	call   *%eax
  800bea:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	6a 58                	push   $0x58
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	ff d0                	call   *%eax
  800bfa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bfd:	83 ec 08             	sub    $0x8,%esp
  800c00:	ff 75 0c             	pushl  0xc(%ebp)
  800c03:	6a 58                	push   $0x58
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	ff d0                	call   *%eax
  800c0a:	83 c4 10             	add    $0x10,%esp
			break;
  800c0d:	e9 ce 00 00 00       	jmp    800ce0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	6a 30                	push   $0x30
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	ff d0                	call   *%eax
  800c1f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c22:	83 ec 08             	sub    $0x8,%esp
  800c25:	ff 75 0c             	pushl  0xc(%ebp)
  800c28:	6a 78                	push   $0x78
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	ff d0                	call   *%eax
  800c2f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c32:	8b 45 14             	mov    0x14(%ebp),%eax
  800c35:	83 c0 04             	add    $0x4,%eax
  800c38:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3e:	83 e8 04             	sub    $0x4,%eax
  800c41:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c4d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c54:	eb 1f                	jmp    800c75 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 e8             	pushl  -0x18(%ebp)
  800c5c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	e8 e7 fb ff ff       	call   80084c <getuint>
  800c65:	83 c4 10             	add    $0x10,%esp
  800c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c6e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c75:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c7c:	83 ec 04             	sub    $0x4,%esp
  800c7f:	52                   	push   %edx
  800c80:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c83:	50                   	push   %eax
  800c84:	ff 75 f4             	pushl  -0xc(%ebp)
  800c87:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 00 fb ff ff       	call   800795 <printnum>
  800c95:	83 c4 20             	add    $0x20,%esp
			break;
  800c98:	eb 46                	jmp    800ce0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9a:	83 ec 08             	sub    $0x8,%esp
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	53                   	push   %ebx
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	ff d0                	call   *%eax
  800ca6:	83 c4 10             	add    $0x10,%esp
			break;
  800ca9:	eb 35                	jmp    800ce0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cab:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800cb2:	eb 2c                	jmp    800ce0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cb4:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800cbb:	eb 23                	jmp    800ce0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	6a 25                	push   $0x25
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	ff d0                	call   *%eax
  800cca:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ccd:	ff 4d 10             	decl   0x10(%ebp)
  800cd0:	eb 03                	jmp    800cd5 <vprintfmt+0x3c3>
  800cd2:	ff 4d 10             	decl   0x10(%ebp)
  800cd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd8:	48                   	dec    %eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	3c 25                	cmp    $0x25,%al
  800cdd:	75 f3                	jne    800cd2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cdf:	90                   	nop
		}
	}
  800ce0:	e9 35 fc ff ff       	jmp    80091a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    

00800ced <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf3:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf6:	83 c0 04             	add    $0x4,%eax
  800cf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cff:	ff 75 f4             	pushl  -0xc(%ebp)
  800d02:	50                   	push   %eax
  800d03:	ff 75 0c             	pushl  0xc(%ebp)
  800d06:	ff 75 08             	pushl  0x8(%ebp)
  800d09:	e8 04 fc ff ff       	call   800912 <vprintfmt>
  800d0e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d11:	90                   	nop
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	8b 40 08             	mov    0x8(%eax),%eax
  800d1d:	8d 50 01             	lea    0x1(%eax),%edx
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	8b 10                	mov    (%eax),%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8b 40 04             	mov    0x4(%eax),%eax
  800d31:	39 c2                	cmp    %eax,%edx
  800d33:	73 12                	jae    800d47 <sprintputch+0x33>
		*b->buf++ = ch;
  800d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d38:	8b 00                	mov    (%eax),%eax
  800d3a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d40:	89 0a                	mov    %ecx,(%edx)
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	88 10                	mov    %dl,(%eax)
}
  800d47:	90                   	nop
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	01 d0                	add    %edx,%eax
  800d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d6f:	74 06                	je     800d77 <vsnprintf+0x2d>
  800d71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d75:	7f 07                	jg     800d7e <vsnprintf+0x34>
		return -E_INVAL;
  800d77:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7c:	eb 20                	jmp    800d9e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d7e:	ff 75 14             	pushl  0x14(%ebp)
  800d81:	ff 75 10             	pushl  0x10(%ebp)
  800d84:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d87:	50                   	push   %eax
  800d88:	68 14 0d 80 00       	push   $0x800d14
  800d8d:	e8 80 fb ff ff       	call   800912 <vprintfmt>
  800d92:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d98:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da6:	8d 45 10             	lea    0x10(%ebp),%eax
  800da9:	83 c0 04             	add    $0x4,%eax
  800dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800daf:	8b 45 10             	mov    0x10(%ebp),%eax
  800db2:	ff 75 f4             	pushl  -0xc(%ebp)
  800db5:	50                   	push   %eax
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	ff 75 08             	pushl  0x8(%ebp)
  800dbc:	e8 89 ff ff ff       	call   800d4a <vsnprintf>
  800dc1:	83 c4 10             	add    $0x10,%esp
  800dc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd9:	eb 06                	jmp    800de1 <strlen+0x15>
		n++;
  800ddb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dde:	ff 45 08             	incl   0x8(%ebp)
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	84 c0                	test   %al,%al
  800de8:	75 f1                	jne    800ddb <strlen+0xf>
		n++;
	return n;
  800dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dfc:	eb 09                	jmp    800e07 <strnlen+0x18>
		n++;
  800dfe:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e01:	ff 45 08             	incl   0x8(%ebp)
  800e04:	ff 4d 0c             	decl   0xc(%ebp)
  800e07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0b:	74 09                	je     800e16 <strnlen+0x27>
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	84 c0                	test   %al,%al
  800e14:	75 e8                	jne    800dfe <strnlen+0xf>
		n++;
	return n;
  800e16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e27:	90                   	nop
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8d 50 01             	lea    0x1(%eax),%edx
  800e2e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e34:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e37:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e3a:	8a 12                	mov    (%edx),%dl
  800e3c:	88 10                	mov    %dl,(%eax)
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	84 c0                	test   %al,%al
  800e42:	75 e4                	jne    800e28 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    

00800e49 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5c:	eb 1f                	jmp    800e7d <strncpy+0x34>
		*dst++ = *src;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 08             	mov    %edx,0x8(%ebp)
  800e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6a:	8a 12                	mov    (%edx),%dl
  800e6c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	84 c0                	test   %al,%al
  800e75:	74 03                	je     800e7a <strncpy+0x31>
			src++;
  800e77:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e7a:	ff 45 fc             	incl   -0x4(%ebp)
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e80:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e83:	72 d9                	jb     800e5e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9a:	74 30                	je     800ecc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e9c:	eb 16                	jmp    800eb4 <strlcpy+0x2a>
			*dst++ = *src++;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ead:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb0:	8a 12                	mov    (%edx),%dl
  800eb2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb4:	ff 4d 10             	decl   0x10(%ebp)
  800eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebb:	74 09                	je     800ec6 <strlcpy+0x3c>
  800ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	84 c0                	test   %al,%al
  800ec4:	75 d8                	jne    800e9e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	29 c2                	sub    %eax,%edx
  800ed4:	89 d0                	mov    %edx,%eax
}
  800ed6:	c9                   	leave  
  800ed7:	c3                   	ret    

00800ed8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800edb:	eb 06                	jmp    800ee3 <strcmp+0xb>
		p++, q++;
  800edd:	ff 45 08             	incl   0x8(%ebp)
  800ee0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	84 c0                	test   %al,%al
  800eea:	74 0e                	je     800efa <strcmp+0x22>
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	8a 10                	mov    (%eax),%dl
  800ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	38 c2                	cmp    %al,%dl
  800ef8:	74 e3                	je     800edd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	0f b6 d0             	movzbl %al,%edx
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	0f b6 c0             	movzbl %al,%eax
  800f0a:	29 c2                	sub    %eax,%edx
  800f0c:	89 d0                	mov    %edx,%eax
}
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f13:	eb 09                	jmp    800f1e <strncmp+0xe>
		n--, p++, q++;
  800f15:	ff 4d 10             	decl   0x10(%ebp)
  800f18:	ff 45 08             	incl   0x8(%ebp)
  800f1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f22:	74 17                	je     800f3b <strncmp+0x2b>
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	84 c0                	test   %al,%al
  800f2b:	74 0e                	je     800f3b <strncmp+0x2b>
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 10                	mov    (%eax),%dl
  800f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	38 c2                	cmp    %al,%dl
  800f39:	74 da                	je     800f15 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3f:	75 07                	jne    800f48 <strncmp+0x38>
		return 0;
  800f41:	b8 00 00 00 00       	mov    $0x0,%eax
  800f46:	eb 14                	jmp    800f5c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	0f b6 d0             	movzbl %al,%edx
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	0f b6 c0             	movzbl %al,%eax
  800f58:	29 c2                	sub    %eax,%edx
  800f5a:	89 d0                	mov    %edx,%eax
}
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 04             	sub    $0x4,%esp
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6a:	eb 12                	jmp    800f7e <strchr+0x20>
		if (*s == c)
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f74:	75 05                	jne    800f7b <strchr+0x1d>
			return (char *) s;
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	eb 11                	jmp    800f8c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f7b:	ff 45 08             	incl   0x8(%ebp)
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	84 c0                	test   %al,%al
  800f85:	75 e5                	jne    800f6c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 04             	sub    $0x4,%esp
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9a:	eb 0d                	jmp    800fa9 <strfind+0x1b>
		if (*s == c)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa4:	74 0e                	je     800fb4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	84 c0                	test   %al,%al
  800fb0:	75 ea                	jne    800f9c <strfind+0xe>
  800fb2:	eb 01                	jmp    800fb5 <strfind+0x27>
		if (*s == c)
			break;
  800fb4:	90                   	nop
	return (char *) s;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb8:	c9                   	leave  
  800fb9:	c3                   	ret    

00800fba <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fcc:	eb 0e                	jmp    800fdc <memset+0x22>
		*p++ = c;
  800fce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd1:	8d 50 01             	lea    0x1(%eax),%edx
  800fd4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fda:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fdc:	ff 4d f8             	decl   -0x8(%ebp)
  800fdf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fe3:	79 e9                	jns    800fce <memset+0x14>
		*p++ = c;

	return v;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ffc:	eb 16                	jmp    801014 <memcpy+0x2a>
		*d++ = *s++;
  800ffe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801001:	8d 50 01             	lea    0x1(%eax),%edx
  801004:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801007:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80100d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801010:	8a 12                	mov    (%edx),%dl
  801012:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801014:	8b 45 10             	mov    0x10(%ebp),%eax
  801017:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101a:	89 55 10             	mov    %edx,0x10(%ebp)
  80101d:	85 c0                	test   %eax,%eax
  80101f:	75 dd                	jne    800ffe <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801038:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103e:	73 50                	jae    801090 <memmove+0x6a>
  801040:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801043:	8b 45 10             	mov    0x10(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104b:	76 43                	jbe    801090 <memmove+0x6a>
		s += n;
  80104d:	8b 45 10             	mov    0x10(%ebp),%eax
  801050:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801059:	eb 10                	jmp    80106b <memmove+0x45>
			*--d = *--s;
  80105b:	ff 4d f8             	decl   -0x8(%ebp)
  80105e:	ff 4d fc             	decl   -0x4(%ebp)
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801064:	8a 10                	mov    (%eax),%dl
  801066:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801069:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80106b:	8b 45 10             	mov    0x10(%ebp),%eax
  80106e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801071:	89 55 10             	mov    %edx,0x10(%ebp)
  801074:	85 c0                	test   %eax,%eax
  801076:	75 e3                	jne    80105b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801078:	eb 23                	jmp    80109d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80107a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107d:	8d 50 01             	lea    0x1(%eax),%edx
  801080:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801083:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801086:	8d 4a 01             	lea    0x1(%edx),%ecx
  801089:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80108c:	8a 12                	mov    (%edx),%dl
  80108e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	8d 50 ff             	lea    -0x1(%eax),%edx
  801096:	89 55 10             	mov    %edx,0x10(%ebp)
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 dd                	jne    80107a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b4:	eb 2a                	jmp    8010e0 <memcmp+0x3e>
		if (*s1 != *s2)
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	8a 10                	mov    (%eax),%dl
  8010bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	38 c2                	cmp    %al,%dl
  8010c2:	74 16                	je     8010da <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	0f b6 d0             	movzbl %al,%edx
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	0f b6 c0             	movzbl %al,%eax
  8010d4:	29 c2                	sub    %eax,%edx
  8010d6:	89 d0                	mov    %edx,%eax
  8010d8:	eb 18                	jmp    8010f2 <memcmp+0x50>
		s1++, s2++;
  8010da:	ff 45 fc             	incl   -0x4(%ebp)
  8010dd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	75 c9                	jne    8010b6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801100:	01 d0                	add    %edx,%eax
  801102:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801105:	eb 15                	jmp    80111c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f b6 d0             	movzbl %al,%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	0f b6 c0             	movzbl %al,%eax
  801115:	39 c2                	cmp    %eax,%edx
  801117:	74 0d                	je     801126 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801122:	72 e3                	jb     801107 <memfind+0x13>
  801124:	eb 01                	jmp    801127 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801126:	90                   	nop
	return (void *) s;
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    

0080112c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801132:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801139:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801140:	eb 03                	jmp    801145 <strtol+0x19>
		s++;
  801142:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	3c 20                	cmp    $0x20,%al
  80114c:	74 f4                	je     801142 <strtol+0x16>
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	3c 09                	cmp    $0x9,%al
  801155:	74 eb                	je     801142 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	3c 2b                	cmp    $0x2b,%al
  80115e:	75 05                	jne    801165 <strtol+0x39>
		s++;
  801160:	ff 45 08             	incl   0x8(%ebp)
  801163:	eb 13                	jmp    801178 <strtol+0x4c>
	else if (*s == '-')
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	3c 2d                	cmp    $0x2d,%al
  80116c:	75 0a                	jne    801178 <strtol+0x4c>
		s++, neg = 1;
  80116e:	ff 45 08             	incl   0x8(%ebp)
  801171:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801178:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117c:	74 06                	je     801184 <strtol+0x58>
  80117e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801182:	75 20                	jne    8011a4 <strtol+0x78>
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	3c 30                	cmp    $0x30,%al
  80118b:	75 17                	jne    8011a4 <strtol+0x78>
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	40                   	inc    %eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 78                	cmp    $0x78,%al
  801195:	75 0d                	jne    8011a4 <strtol+0x78>
		s += 2, base = 16;
  801197:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80119b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011a2:	eb 28                	jmp    8011cc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a8:	75 15                	jne    8011bf <strtol+0x93>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 30                	cmp    $0x30,%al
  8011b1:	75 0c                	jne    8011bf <strtol+0x93>
		s++, base = 8;
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011bd:	eb 0d                	jmp    8011cc <strtol+0xa0>
	else if (base == 0)
  8011bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c3:	75 07                	jne    8011cc <strtol+0xa0>
		base = 10;
  8011c5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	3c 2f                	cmp    $0x2f,%al
  8011d3:	7e 19                	jle    8011ee <strtol+0xc2>
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3c 39                	cmp    $0x39,%al
  8011dc:	7f 10                	jg     8011ee <strtol+0xc2>
			dig = *s - '0';
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	0f be c0             	movsbl %al,%eax
  8011e6:	83 e8 30             	sub    $0x30,%eax
  8011e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ec:	eb 42                	jmp    801230 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8a 00                	mov    (%eax),%al
  8011f3:	3c 60                	cmp    $0x60,%al
  8011f5:	7e 19                	jle    801210 <strtol+0xe4>
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	3c 7a                	cmp    $0x7a,%al
  8011fe:	7f 10                	jg     801210 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	0f be c0             	movsbl %al,%eax
  801208:	83 e8 57             	sub    $0x57,%eax
  80120b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80120e:	eb 20                	jmp    801230 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	3c 40                	cmp    $0x40,%al
  801217:	7e 39                	jle    801252 <strtol+0x126>
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 5a                	cmp    $0x5a,%al
  801220:	7f 30                	jg     801252 <strtol+0x126>
			dig = *s - 'A' + 10;
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	0f be c0             	movsbl %al,%eax
  80122a:	83 e8 37             	sub    $0x37,%eax
  80122d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801233:	3b 45 10             	cmp    0x10(%ebp),%eax
  801236:	7d 19                	jge    801251 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801238:	ff 45 08             	incl   0x8(%ebp)
  80123b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801242:	89 c2                	mov    %eax,%edx
  801244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801247:	01 d0                	add    %edx,%eax
  801249:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80124c:	e9 7b ff ff ff       	jmp    8011cc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801251:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801252:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801256:	74 08                	je     801260 <strtol+0x134>
		*endptr = (char *) s;
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	8b 55 08             	mov    0x8(%ebp),%edx
  80125e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801260:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801264:	74 07                	je     80126d <strtol+0x141>
  801266:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801269:	f7 d8                	neg    %eax
  80126b:	eb 03                	jmp    801270 <strtol+0x144>
  80126d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <ltostr>:

void
ltostr(long value, char *str)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801278:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80127f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801286:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128a:	79 13                	jns    80129f <ltostr+0x2d>
	{
		neg = 1;
  80128c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801293:	8b 45 0c             	mov    0xc(%ebp),%eax
  801296:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801299:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80129c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012a7:	99                   	cltd   
  8012a8:	f7 f9                	idiv   %ecx
  8012aa:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b0:	8d 50 01             	lea    0x1(%eax),%edx
  8012b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b6:	89 c2                	mov    %eax,%edx
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	01 d0                	add    %edx,%eax
  8012bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c0:	83 c2 30             	add    $0x30,%edx
  8012c3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012cd:	f7 e9                	imul   %ecx
  8012cf:	c1 fa 02             	sar    $0x2,%edx
  8012d2:	89 c8                	mov    %ecx,%eax
  8012d4:	c1 f8 1f             	sar    $0x1f,%eax
  8012d7:	29 c2                	sub    %eax,%edx
  8012d9:	89 d0                	mov    %edx,%eax
  8012db:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e2:	75 bb                	jne    80129f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ee:	48                   	dec    %eax
  8012ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012f6:	74 3d                	je     801335 <ltostr+0xc3>
		start = 1 ;
  8012f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012ff:	eb 34                	jmp    801335 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801301:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	01 d0                	add    %edx,%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80130e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801311:	8b 45 0c             	mov    0xc(%ebp),%eax
  801314:	01 c2                	add    %eax,%edx
  801316:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131c:	01 c8                	add    %ecx,%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801322:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801325:	8b 45 0c             	mov    0xc(%ebp),%eax
  801328:	01 c2                	add    %eax,%edx
  80132a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80132d:	88 02                	mov    %al,(%edx)
		start++ ;
  80132f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801332:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801338:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80133b:	7c c4                	jl     801301 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80133d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	01 d0                	add    %edx,%eax
  801345:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801348:	90                   	nop
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 73 fa ff ff       	call   800dcc <strlen>
  801359:	83 c4 04             	add    $0x4,%esp
  80135c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80135f:	ff 75 0c             	pushl  0xc(%ebp)
  801362:	e8 65 fa ff ff       	call   800dcc <strlen>
  801367:	83 c4 04             	add    $0x4,%esp
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80136d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80137b:	eb 17                	jmp    801394 <strcconcat+0x49>
		final[s] = str1[s] ;
  80137d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801380:	8b 45 10             	mov    0x10(%ebp),%eax
  801383:	01 c2                	add    %eax,%edx
  801385:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	01 c8                	add    %ecx,%eax
  80138d:	8a 00                	mov    (%eax),%al
  80138f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801391:	ff 45 fc             	incl   -0x4(%ebp)
  801394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801397:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80139a:	7c e1                	jl     80137d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80139c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013aa:	eb 1f                	jmp    8013cb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013af:	8d 50 01             	lea    0x1(%eax),%edx
  8013b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013b5:	89 c2                	mov    %eax,%edx
  8013b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ba:	01 c2                	add    %eax,%edx
  8013bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c2:	01 c8                	add    %ecx,%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013c8:	ff 45 f8             	incl   -0x8(%ebp)
  8013cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013d1:	7c d9                	jl     8013ac <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d9:	01 d0                	add    %edx,%eax
  8013db:	c6 00 00             	movb   $0x0,(%eax)
}
  8013de:	90                   	nop
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f0:	8b 00                	mov    (%eax),%eax
  8013f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fc:	01 d0                	add    %edx,%eax
  8013fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801404:	eb 0c                	jmp    801412 <strsplit+0x31>
			*string++ = 0;
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8d 50 01             	lea    0x1(%eax),%edx
  80140c:	89 55 08             	mov    %edx,0x8(%ebp)
  80140f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	84 c0                	test   %al,%al
  801419:	74 18                	je     801433 <strsplit+0x52>
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	0f be c0             	movsbl %al,%eax
  801423:	50                   	push   %eax
  801424:	ff 75 0c             	pushl  0xc(%ebp)
  801427:	e8 32 fb ff ff       	call   800f5e <strchr>
  80142c:	83 c4 08             	add    $0x8,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	75 d3                	jne    801406 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	84 c0                	test   %al,%al
  80143a:	74 5a                	je     801496 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80143c:	8b 45 14             	mov    0x14(%ebp),%eax
  80143f:	8b 00                	mov    (%eax),%eax
  801441:	83 f8 0f             	cmp    $0xf,%eax
  801444:	75 07                	jne    80144d <strsplit+0x6c>
		{
			return 0;
  801446:	b8 00 00 00 00       	mov    $0x0,%eax
  80144b:	eb 66                	jmp    8014b3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80144d:	8b 45 14             	mov    0x14(%ebp),%eax
  801450:	8b 00                	mov    (%eax),%eax
  801452:	8d 48 01             	lea    0x1(%eax),%ecx
  801455:	8b 55 14             	mov    0x14(%ebp),%edx
  801458:	89 0a                	mov    %ecx,(%edx)
  80145a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801461:	8b 45 10             	mov    0x10(%ebp),%eax
  801464:	01 c2                	add    %eax,%edx
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80146b:	eb 03                	jmp    801470 <strsplit+0x8f>
			string++;
  80146d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	84 c0                	test   %al,%al
  801477:	74 8b                	je     801404 <strsplit+0x23>
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	0f be c0             	movsbl %al,%eax
  801481:	50                   	push   %eax
  801482:	ff 75 0c             	pushl  0xc(%ebp)
  801485:	e8 d4 fa ff ff       	call   800f5e <strchr>
  80148a:	83 c4 08             	add    $0x8,%esp
  80148d:	85 c0                	test   %eax,%eax
  80148f:	74 dc                	je     80146d <strsplit+0x8c>
			string++;
	}
  801491:	e9 6e ff ff ff       	jmp    801404 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801496:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801497:	8b 45 14             	mov    0x14(%ebp),%eax
  80149a:	8b 00                	mov    (%eax),%eax
  80149c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a6:	01 d0                	add    %edx,%eax
  8014a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	68 68 25 80 00       	push   $0x802568
  8014c3:	68 3f 01 00 00       	push   $0x13f
  8014c8:	68 8a 25 80 00       	push   $0x80258a
  8014cd:	e8 53 07 00 00       	call   801c25 <_panic>

008014d2 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	e8 ef 06 00 00       	call   801bd2 <sys_sbrk>
  8014e3:	83 c4 10             	add    $0x10,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8014ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f2:	75 07                	jne    8014fb <malloc+0x13>
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f9:	eb 14                	jmp    80150f <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014fb:	83 ec 04             	sub    $0x4,%esp
  8014fe:	68 98 25 80 00       	push   $0x802598
  801503:	6a 1b                	push   $0x1b
  801505:	68 bd 25 80 00       	push   $0x8025bd
  80150a:	e8 16 07 00 00       	call   801c25 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	68 cc 25 80 00       	push   $0x8025cc
  80151f:	6a 29                	push   $0x29
  801521:	68 bd 25 80 00       	push   $0x8025bd
  801526:	e8 fa 06 00 00       	call   801c25 <_panic>

0080152b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	83 ec 18             	sub    $0x18,%esp
  801531:	8b 45 10             	mov    0x10(%ebp),%eax
  801534:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801537:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80153b:	75 07                	jne    801544 <smalloc+0x19>
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
  801542:	eb 14                	jmp    801558 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	68 f0 25 80 00       	push   $0x8025f0
  80154c:	6a 38                	push   $0x38
  80154e:	68 bd 25 80 00       	push   $0x8025bd
  801553:	e8 cd 06 00 00       	call   801c25 <_panic>
	return NULL;
}
  801558:	c9                   	leave  
  801559:	c3                   	ret    

0080155a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
  80155d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801560:	83 ec 04             	sub    $0x4,%esp
  801563:	68 18 26 80 00       	push   $0x802618
  801568:	6a 43                	push   $0x43
  80156a:	68 bd 25 80 00       	push   $0x8025bd
  80156f:	e8 b1 06 00 00       	call   801c25 <_panic>

00801574 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	68 3c 26 80 00       	push   $0x80263c
  801582:	6a 5b                	push   $0x5b
  801584:	68 bd 25 80 00       	push   $0x8025bd
  801589:	e8 97 06 00 00       	call   801c25 <_panic>

0080158e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	68 60 26 80 00       	push   $0x802660
  80159c:	6a 72                	push   $0x72
  80159e:	68 bd 25 80 00       	push   $0x8025bd
  8015a3:	e8 7d 06 00 00       	call   801c25 <_panic>

008015a8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	68 86 26 80 00       	push   $0x802686
  8015b6:	6a 7e                	push   $0x7e
  8015b8:	68 bd 25 80 00       	push   $0x8025bd
  8015bd:	e8 63 06 00 00       	call   801c25 <_panic>

008015c2 <shrink>:

}
void shrink(uint32 newSize)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	68 86 26 80 00       	push   $0x802686
  8015d0:	68 83 00 00 00       	push   $0x83
  8015d5:	68 bd 25 80 00       	push   $0x8025bd
  8015da:	e8 46 06 00 00       	call   801c25 <_panic>

008015df <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e5:	83 ec 04             	sub    $0x4,%esp
  8015e8:	68 86 26 80 00       	push   $0x802686
  8015ed:	68 88 00 00 00       	push   $0x88
  8015f2:	68 bd 25 80 00       	push   $0x8025bd
  8015f7:	e8 29 06 00 00       	call   801c25 <_panic>

008015fc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	57                   	push   %edi
  801600:	56                   	push   %esi
  801601:	53                   	push   %ebx
  801602:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80160e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801611:	8b 7d 18             	mov    0x18(%ebp),%edi
  801614:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801617:	cd 30                	int    $0x30
  801619:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80161c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80161f:	83 c4 10             	add    $0x10,%esp
  801622:	5b                   	pop    %ebx
  801623:	5e                   	pop    %esi
  801624:	5f                   	pop    %edi
  801625:	5d                   	pop    %ebp
  801626:	c3                   	ret    

00801627 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 04             	sub    $0x4,%esp
  80162d:	8b 45 10             	mov    0x10(%ebp),%eax
  801630:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801633:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	52                   	push   %edx
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	50                   	push   %eax
  801643:	6a 00                	push   $0x0
  801645:	e8 b2 ff ff ff       	call   8015fc <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	90                   	nop
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_cgetc>:

int
sys_cgetc(void)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 02                	push   $0x2
  80165f:	e8 98 ff ff ff       	call   8015fc <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 03                	push   $0x3
  801678:	e8 7f ff ff ff       	call   8015fc <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	90                   	nop
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 04                	push   $0x4
  801692:	e8 65 ff ff ff       	call   8015fc <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	90                   	nop
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	52                   	push   %edx
  8016ad:	50                   	push   %eax
  8016ae:	6a 08                	push   $0x8
  8016b0:	e8 47 ff ff ff       	call   8015fc <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	56                   	push   %esi
  8016be:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016bf:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
  8016d0:	51                   	push   %ecx
  8016d1:	52                   	push   %edx
  8016d2:	50                   	push   %eax
  8016d3:	6a 09                	push   $0x9
  8016d5:	e8 22 ff ff ff       	call   8015fc <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
}
  8016dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e0:	5b                   	pop    %ebx
  8016e1:	5e                   	pop    %esi
  8016e2:	5d                   	pop    %ebp
  8016e3:	c3                   	ret    

008016e4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	52                   	push   %edx
  8016f4:	50                   	push   %eax
  8016f5:	6a 0a                	push   $0xa
  8016f7:	e8 00 ff ff ff       	call   8015fc <syscall>
  8016fc:	83 c4 18             	add    $0x18,%esp
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	ff 75 0c             	pushl  0xc(%ebp)
  80170d:	ff 75 08             	pushl  0x8(%ebp)
  801710:	6a 0b                	push   $0xb
  801712:	e8 e5 fe ff ff       	call   8015fc <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 0c                	push   $0xc
  80172b:	e8 cc fe ff ff       	call   8015fc <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 0d                	push   $0xd
  801744:	e8 b3 fe ff ff       	call   8015fc <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 0e                	push   $0xe
  80175d:	e8 9a fe ff ff       	call   8015fc <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 0f                	push   $0xf
  801776:	e8 81 fe ff ff       	call   8015fc <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	ff 75 08             	pushl  0x8(%ebp)
  80178e:	6a 10                	push   $0x10
  801790:	e8 67 fe ff ff       	call   8015fc <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 11                	push   $0x11
  8017a9:	e8 4e fe ff ff       	call   8015fc <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	90                   	nop
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	50                   	push   %eax
  8017cd:	6a 01                	push   $0x1
  8017cf:	e8 28 fe ff ff       	call   8015fc <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	90                   	nop
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 14                	push   $0x14
  8017e9:	e8 0e fe ff ff       	call   8015fc <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	90                   	nop
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801800:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801803:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	6a 00                	push   $0x0
  80180c:	51                   	push   %ecx
  80180d:	52                   	push   %edx
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	50                   	push   %eax
  801812:	6a 15                	push   $0x15
  801814:	e8 e3 fd ff ff       	call   8015fc <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801821:	8b 55 0c             	mov    0xc(%ebp),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	52                   	push   %edx
  80182e:	50                   	push   %eax
  80182f:	6a 16                	push   $0x16
  801831:	e8 c6 fd ff ff       	call   8015fc <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80183e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801841:	8b 55 0c             	mov    0xc(%ebp),%edx
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	51                   	push   %ecx
  80184c:	52                   	push   %edx
  80184d:	50                   	push   %eax
  80184e:	6a 17                	push   $0x17
  801850:	e8 a7 fd ff ff       	call   8015fc <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	52                   	push   %edx
  80186a:	50                   	push   %eax
  80186b:	6a 18                	push   $0x18
  80186d:	e8 8a fd ff ff       	call   8015fc <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	ff 75 14             	pushl  0x14(%ebp)
  801882:	ff 75 10             	pushl  0x10(%ebp)
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	50                   	push   %eax
  801889:	6a 19                	push   $0x19
  80188b:	e8 6c fd ff ff       	call   8015fc <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	50                   	push   %eax
  8018a4:	6a 1a                	push   $0x1a
  8018a6:	e8 51 fd ff ff       	call   8015fc <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	90                   	nop
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	50                   	push   %eax
  8018c0:	6a 1b                	push   $0x1b
  8018c2:	e8 35 fd ff ff       	call   8015fc <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 05                	push   $0x5
  8018db:	e8 1c fd ff ff       	call   8015fc <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 06                	push   $0x6
  8018f4:	e8 03 fd ff ff       	call   8015fc <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 07                	push   $0x7
  80190d:	e8 ea fc ff ff       	call   8015fc <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_exit_env>:


void sys_exit_env(void)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 1c                	push   $0x1c
  801926:	e8 d1 fc ff ff       	call   8015fc <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	90                   	nop
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801937:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80193a:	8d 50 04             	lea    0x4(%eax),%edx
  80193d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	52                   	push   %edx
  801947:	50                   	push   %eax
  801948:	6a 1d                	push   $0x1d
  80194a:	e8 ad fc ff ff       	call   8015fc <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
	return result;
  801952:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801955:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801958:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80195b:	89 01                	mov    %eax,(%ecx)
  80195d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	c9                   	leave  
  801964:	c2 04 00             	ret    $0x4

00801967 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	ff 75 10             	pushl  0x10(%ebp)
  801971:	ff 75 0c             	pushl  0xc(%ebp)
  801974:	ff 75 08             	pushl  0x8(%ebp)
  801977:	6a 13                	push   $0x13
  801979:	e8 7e fc ff ff       	call   8015fc <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
	return ;
  801981:	90                   	nop
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_rcr2>:
uint32 sys_rcr2()
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 1e                	push   $0x1e
  801993:	e8 64 fc ff ff       	call   8015fc <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019a9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	50                   	push   %eax
  8019b6:	6a 1f                	push   $0x1f
  8019b8:	e8 3f fc ff ff       	call   8015fc <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c0:	90                   	nop
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <rsttst>:
void rsttst()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 21                	push   $0x21
  8019d2:	e8 25 fc ff ff       	call   8015fc <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019da:	90                   	nop
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 04             	sub    $0x4,%esp
  8019e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019e9:	8b 55 18             	mov    0x18(%ebp),%edx
  8019ec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f0:	52                   	push   %edx
  8019f1:	50                   	push   %eax
  8019f2:	ff 75 10             	pushl  0x10(%ebp)
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	6a 20                	push   $0x20
  8019fd:	e8 fa fb ff ff       	call   8015fc <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return ;
  801a05:	90                   	nop
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <chktst>:
void chktst(uint32 n)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	ff 75 08             	pushl  0x8(%ebp)
  801a16:	6a 22                	push   $0x22
  801a18:	e8 df fb ff ff       	call   8015fc <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a20:	90                   	nop
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <inctst>:

void inctst()
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 23                	push   $0x23
  801a32:	e8 c5 fb ff ff       	call   8015fc <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3a:	90                   	nop
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <gettst>:
uint32 gettst()
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 24                	push   $0x24
  801a4c:	e8 ab fb ff ff       	call   8015fc <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 25                	push   $0x25
  801a68:	e8 8f fb ff ff       	call   8015fc <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
  801a70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a73:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a77:	75 07                	jne    801a80 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a79:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7e:	eb 05                	jmp    801a85 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 25                	push   $0x25
  801a99:	e8 5e fb ff ff       	call   8015fc <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
  801aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801aa4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801aa8:	75 07                	jne    801ab1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801aaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801aaf:	eb 05                	jmp    801ab6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 25                	push   $0x25
  801aca:	e8 2d fb ff ff       	call   8015fc <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
  801ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ad5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ad9:	75 07                	jne    801ae2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801adb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae0:	eb 05                	jmp    801ae7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ae2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 25                	push   $0x25
  801afb:	e8 fc fa ff ff       	call   8015fc <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
  801b03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b06:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b0a:	75 07                	jne    801b13 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b11:	eb 05                	jmp    801b18 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	ff 75 08             	pushl  0x8(%ebp)
  801b28:	6a 26                	push   $0x26
  801b2a:	e8 cd fa ff ff       	call   8015fc <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b32:	90                   	nop
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	6a 00                	push   $0x0
  801b47:	53                   	push   %ebx
  801b48:	51                   	push   %ecx
  801b49:	52                   	push   %edx
  801b4a:	50                   	push   %eax
  801b4b:	6a 27                	push   $0x27
  801b4d:	e8 aa fa ff ff       	call   8015fc <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	52                   	push   %edx
  801b6a:	50                   	push   %eax
  801b6b:	6a 28                	push   $0x28
  801b6d:	e8 8a fa ff ff       	call   8015fc <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b7a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	51                   	push   %ecx
  801b86:	ff 75 10             	pushl  0x10(%ebp)
  801b89:	52                   	push   %edx
  801b8a:	50                   	push   %eax
  801b8b:	6a 29                	push   $0x29
  801b8d:	e8 6a fa ff ff       	call   8015fc <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	ff 75 10             	pushl  0x10(%ebp)
  801ba1:	ff 75 0c             	pushl  0xc(%ebp)
  801ba4:	ff 75 08             	pushl  0x8(%ebp)
  801ba7:	6a 12                	push   $0x12
  801ba9:	e8 4e fa ff ff       	call   8015fc <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb1:	90                   	nop
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 2a                	push   $0x2a
  801bc7:	e8 30 fa ff ff       	call   8015fc <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
	return;
  801bcf:	90                   	nop
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	50                   	push   %eax
  801be1:	6a 2b                	push   $0x2b
  801be3:	e8 14 fa ff ff       	call   8015fc <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	ff 75 08             	pushl  0x8(%ebp)
  801bfc:	6a 2c                	push   $0x2c
  801bfe:	e8 f9 f9 ff ff       	call   8015fc <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
	return;
  801c06:	90                   	nop
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	ff 75 0c             	pushl  0xc(%ebp)
  801c15:	ff 75 08             	pushl  0x8(%ebp)
  801c18:	6a 2d                	push   $0x2d
  801c1a:	e8 dd f9 ff ff       	call   8015fc <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
	return;
  801c22:	90                   	nop
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801c2b:	8d 45 10             	lea    0x10(%ebp),%eax
  801c2e:	83 c0 04             	add    $0x4,%eax
  801c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801c34:	a1 24 30 80 00       	mov    0x803024,%eax
  801c39:	85 c0                	test   %eax,%eax
  801c3b:	74 16                	je     801c53 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801c3d:	a1 24 30 80 00       	mov    0x803024,%eax
  801c42:	83 ec 08             	sub    $0x8,%esp
  801c45:	50                   	push   %eax
  801c46:	68 98 26 80 00       	push   $0x802698
  801c4b:	e8 e8 ea ff ff       	call   800738 <cprintf>
  801c50:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801c53:	a1 00 30 80 00       	mov    0x803000,%eax
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	50                   	push   %eax
  801c5f:	68 9d 26 80 00       	push   $0x80269d
  801c64:	e8 cf ea ff ff       	call   800738 <cprintf>
  801c69:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801c6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6f:	83 ec 08             	sub    $0x8,%esp
  801c72:	ff 75 f4             	pushl  -0xc(%ebp)
  801c75:	50                   	push   %eax
  801c76:	e8 52 ea ff ff       	call   8006cd <vcprintf>
  801c7b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801c7e:	83 ec 08             	sub    $0x8,%esp
  801c81:	6a 00                	push   $0x0
  801c83:	68 b9 26 80 00       	push   $0x8026b9
  801c88:	e8 40 ea ff ff       	call   8006cd <vcprintf>
  801c8d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801c90:	e8 c1 e9 ff ff       	call   800656 <exit>

	// should not return here
	while (1) ;
  801c95:	eb fe                	jmp    801c95 <_panic+0x70>

00801c97 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801c9d:	a1 04 30 80 00       	mov    0x803004,%eax
  801ca2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cab:	39 c2                	cmp    %eax,%edx
  801cad:	74 14                	je     801cc3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801caf:	83 ec 04             	sub    $0x4,%esp
  801cb2:	68 bc 26 80 00       	push   $0x8026bc
  801cb7:	6a 26                	push   $0x26
  801cb9:	68 08 27 80 00       	push   $0x802708
  801cbe:	e8 62 ff ff ff       	call   801c25 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801cc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801cca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801cd1:	e9 c5 00 00 00       	jmp    801d9b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	01 d0                	add    %edx,%eax
  801ce5:	8b 00                	mov    (%eax),%eax
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	75 08                	jne    801cf3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801ceb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801cee:	e9 a5 00 00 00       	jmp    801d98 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801cf3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801cfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d01:	eb 69                	jmp    801d6c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801d03:	a1 04 30 80 00       	mov    0x803004,%eax
  801d08:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801d0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d11:	89 d0                	mov    %edx,%eax
  801d13:	01 c0                	add    %eax,%eax
  801d15:	01 d0                	add    %edx,%eax
  801d17:	c1 e0 03             	shl    $0x3,%eax
  801d1a:	01 c8                	add    %ecx,%eax
  801d1c:	8a 40 04             	mov    0x4(%eax),%al
  801d1f:	84 c0                	test   %al,%al
  801d21:	75 46                	jne    801d69 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d23:	a1 04 30 80 00       	mov    0x803004,%eax
  801d28:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801d2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d31:	89 d0                	mov    %edx,%eax
  801d33:	01 c0                	add    %eax,%eax
  801d35:	01 d0                	add    %edx,%eax
  801d37:	c1 e0 03             	shl    $0x3,%eax
  801d3a:	01 c8                	add    %ecx,%eax
  801d3c:	8b 00                	mov    (%eax),%eax
  801d3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d49:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	01 c8                	add    %ecx,%eax
  801d5a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d5c:	39 c2                	cmp    %eax,%edx
  801d5e:	75 09                	jne    801d69 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801d60:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801d67:	eb 15                	jmp    801d7e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d69:	ff 45 e8             	incl   -0x18(%ebp)
  801d6c:	a1 04 30 80 00       	mov    0x803004,%eax
  801d71:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7a:	39 c2                	cmp    %eax,%edx
  801d7c:	77 85                	ja     801d03 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801d7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d82:	75 14                	jne    801d98 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801d84:	83 ec 04             	sub    $0x4,%esp
  801d87:	68 14 27 80 00       	push   $0x802714
  801d8c:	6a 3a                	push   $0x3a
  801d8e:	68 08 27 80 00       	push   $0x802708
  801d93:	e8 8d fe ff ff       	call   801c25 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801d98:	ff 45 f0             	incl   -0x10(%ebp)
  801d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801da1:	0f 8c 2f ff ff ff    	jl     801cd6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801da7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801dae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801db5:	eb 26                	jmp    801ddd <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801db7:	a1 04 30 80 00       	mov    0x803004,%eax
  801dbc:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801dc2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dc5:	89 d0                	mov    %edx,%eax
  801dc7:	01 c0                	add    %eax,%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	c1 e0 03             	shl    $0x3,%eax
  801dce:	01 c8                	add    %ecx,%eax
  801dd0:	8a 40 04             	mov    0x4(%eax),%al
  801dd3:	3c 01                	cmp    $0x1,%al
  801dd5:	75 03                	jne    801dda <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801dd7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801dda:	ff 45 e0             	incl   -0x20(%ebp)
  801ddd:	a1 04 30 80 00       	mov    0x803004,%eax
  801de2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801deb:	39 c2                	cmp    %eax,%edx
  801ded:	77 c8                	ja     801db7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801df5:	74 14                	je     801e0b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801df7:	83 ec 04             	sub    $0x4,%esp
  801dfa:	68 68 27 80 00       	push   $0x802768
  801dff:	6a 44                	push   $0x44
  801e01:	68 08 27 80 00       	push   $0x802708
  801e06:	e8 1a fe ff ff       	call   801c25 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801e0b:	90                   	nop
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    
  801e0e:	66 90                	xchg   %ax,%ax

00801e10 <__udivdi3>:
  801e10:	55                   	push   %ebp
  801e11:	57                   	push   %edi
  801e12:	56                   	push   %esi
  801e13:	53                   	push   %ebx
  801e14:	83 ec 1c             	sub    $0x1c,%esp
  801e17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e27:	89 ca                	mov    %ecx,%edx
  801e29:	89 f8                	mov    %edi,%eax
  801e2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e2f:	85 f6                	test   %esi,%esi
  801e31:	75 2d                	jne    801e60 <__udivdi3+0x50>
  801e33:	39 cf                	cmp    %ecx,%edi
  801e35:	77 65                	ja     801e9c <__udivdi3+0x8c>
  801e37:	89 fd                	mov    %edi,%ebp
  801e39:	85 ff                	test   %edi,%edi
  801e3b:	75 0b                	jne    801e48 <__udivdi3+0x38>
  801e3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e42:	31 d2                	xor    %edx,%edx
  801e44:	f7 f7                	div    %edi
  801e46:	89 c5                	mov    %eax,%ebp
  801e48:	31 d2                	xor    %edx,%edx
  801e4a:	89 c8                	mov    %ecx,%eax
  801e4c:	f7 f5                	div    %ebp
  801e4e:	89 c1                	mov    %eax,%ecx
  801e50:	89 d8                	mov    %ebx,%eax
  801e52:	f7 f5                	div    %ebp
  801e54:	89 cf                	mov    %ecx,%edi
  801e56:	89 fa                	mov    %edi,%edx
  801e58:	83 c4 1c             	add    $0x1c,%esp
  801e5b:	5b                   	pop    %ebx
  801e5c:	5e                   	pop    %esi
  801e5d:	5f                   	pop    %edi
  801e5e:	5d                   	pop    %ebp
  801e5f:	c3                   	ret    
  801e60:	39 ce                	cmp    %ecx,%esi
  801e62:	77 28                	ja     801e8c <__udivdi3+0x7c>
  801e64:	0f bd fe             	bsr    %esi,%edi
  801e67:	83 f7 1f             	xor    $0x1f,%edi
  801e6a:	75 40                	jne    801eac <__udivdi3+0x9c>
  801e6c:	39 ce                	cmp    %ecx,%esi
  801e6e:	72 0a                	jb     801e7a <__udivdi3+0x6a>
  801e70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e74:	0f 87 9e 00 00 00    	ja     801f18 <__udivdi3+0x108>
  801e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7f:	89 fa                	mov    %edi,%edx
  801e81:	83 c4 1c             	add    $0x1c,%esp
  801e84:	5b                   	pop    %ebx
  801e85:	5e                   	pop    %esi
  801e86:	5f                   	pop    %edi
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    
  801e89:	8d 76 00             	lea    0x0(%esi),%esi
  801e8c:	31 ff                	xor    %edi,%edi
  801e8e:	31 c0                	xor    %eax,%eax
  801e90:	89 fa                	mov    %edi,%edx
  801e92:	83 c4 1c             	add    $0x1c,%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5f                   	pop    %edi
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    
  801e9a:	66 90                	xchg   %ax,%ax
  801e9c:	89 d8                	mov    %ebx,%eax
  801e9e:	f7 f7                	div    %edi
  801ea0:	31 ff                	xor    %edi,%edi
  801ea2:	89 fa                	mov    %edi,%edx
  801ea4:	83 c4 1c             	add    $0x1c,%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5f                   	pop    %edi
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    
  801eac:	bd 20 00 00 00       	mov    $0x20,%ebp
  801eb1:	89 eb                	mov    %ebp,%ebx
  801eb3:	29 fb                	sub    %edi,%ebx
  801eb5:	89 f9                	mov    %edi,%ecx
  801eb7:	d3 e6                	shl    %cl,%esi
  801eb9:	89 c5                	mov    %eax,%ebp
  801ebb:	88 d9                	mov    %bl,%cl
  801ebd:	d3 ed                	shr    %cl,%ebp
  801ebf:	89 e9                	mov    %ebp,%ecx
  801ec1:	09 f1                	or     %esi,%ecx
  801ec3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ec7:	89 f9                	mov    %edi,%ecx
  801ec9:	d3 e0                	shl    %cl,%eax
  801ecb:	89 c5                	mov    %eax,%ebp
  801ecd:	89 d6                	mov    %edx,%esi
  801ecf:	88 d9                	mov    %bl,%cl
  801ed1:	d3 ee                	shr    %cl,%esi
  801ed3:	89 f9                	mov    %edi,%ecx
  801ed5:	d3 e2                	shl    %cl,%edx
  801ed7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801edb:	88 d9                	mov    %bl,%cl
  801edd:	d3 e8                	shr    %cl,%eax
  801edf:	09 c2                	or     %eax,%edx
  801ee1:	89 d0                	mov    %edx,%eax
  801ee3:	89 f2                	mov    %esi,%edx
  801ee5:	f7 74 24 0c          	divl   0xc(%esp)
  801ee9:	89 d6                	mov    %edx,%esi
  801eeb:	89 c3                	mov    %eax,%ebx
  801eed:	f7 e5                	mul    %ebp
  801eef:	39 d6                	cmp    %edx,%esi
  801ef1:	72 19                	jb     801f0c <__udivdi3+0xfc>
  801ef3:	74 0b                	je     801f00 <__udivdi3+0xf0>
  801ef5:	89 d8                	mov    %ebx,%eax
  801ef7:	31 ff                	xor    %edi,%edi
  801ef9:	e9 58 ff ff ff       	jmp    801e56 <__udivdi3+0x46>
  801efe:	66 90                	xchg   %ax,%ax
  801f00:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f04:	89 f9                	mov    %edi,%ecx
  801f06:	d3 e2                	shl    %cl,%edx
  801f08:	39 c2                	cmp    %eax,%edx
  801f0a:	73 e9                	jae    801ef5 <__udivdi3+0xe5>
  801f0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f0f:	31 ff                	xor    %edi,%edi
  801f11:	e9 40 ff ff ff       	jmp    801e56 <__udivdi3+0x46>
  801f16:	66 90                	xchg   %ax,%ax
  801f18:	31 c0                	xor    %eax,%eax
  801f1a:	e9 37 ff ff ff       	jmp    801e56 <__udivdi3+0x46>
  801f1f:	90                   	nop

00801f20 <__umoddi3>:
  801f20:	55                   	push   %ebp
  801f21:	57                   	push   %edi
  801f22:	56                   	push   %esi
  801f23:	53                   	push   %ebx
  801f24:	83 ec 1c             	sub    $0x1c,%esp
  801f27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f3f:	89 f3                	mov    %esi,%ebx
  801f41:	89 fa                	mov    %edi,%edx
  801f43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f47:	89 34 24             	mov    %esi,(%esp)
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	75 1a                	jne    801f68 <__umoddi3+0x48>
  801f4e:	39 f7                	cmp    %esi,%edi
  801f50:	0f 86 a2 00 00 00    	jbe    801ff8 <__umoddi3+0xd8>
  801f56:	89 c8                	mov    %ecx,%eax
  801f58:	89 f2                	mov    %esi,%edx
  801f5a:	f7 f7                	div    %edi
  801f5c:	89 d0                	mov    %edx,%eax
  801f5e:	31 d2                	xor    %edx,%edx
  801f60:	83 c4 1c             	add    $0x1c,%esp
  801f63:	5b                   	pop    %ebx
  801f64:	5e                   	pop    %esi
  801f65:	5f                   	pop    %edi
  801f66:	5d                   	pop    %ebp
  801f67:	c3                   	ret    
  801f68:	39 f0                	cmp    %esi,%eax
  801f6a:	0f 87 ac 00 00 00    	ja     80201c <__umoddi3+0xfc>
  801f70:	0f bd e8             	bsr    %eax,%ebp
  801f73:	83 f5 1f             	xor    $0x1f,%ebp
  801f76:	0f 84 ac 00 00 00    	je     802028 <__umoddi3+0x108>
  801f7c:	bf 20 00 00 00       	mov    $0x20,%edi
  801f81:	29 ef                	sub    %ebp,%edi
  801f83:	89 fe                	mov    %edi,%esi
  801f85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f89:	89 e9                	mov    %ebp,%ecx
  801f8b:	d3 e0                	shl    %cl,%eax
  801f8d:	89 d7                	mov    %edx,%edi
  801f8f:	89 f1                	mov    %esi,%ecx
  801f91:	d3 ef                	shr    %cl,%edi
  801f93:	09 c7                	or     %eax,%edi
  801f95:	89 e9                	mov    %ebp,%ecx
  801f97:	d3 e2                	shl    %cl,%edx
  801f99:	89 14 24             	mov    %edx,(%esp)
  801f9c:	89 d8                	mov    %ebx,%eax
  801f9e:	d3 e0                	shl    %cl,%eax
  801fa0:	89 c2                	mov    %eax,%edx
  801fa2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fa6:	d3 e0                	shl    %cl,%eax
  801fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fac:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fb0:	89 f1                	mov    %esi,%ecx
  801fb2:	d3 e8                	shr    %cl,%eax
  801fb4:	09 d0                	or     %edx,%eax
  801fb6:	d3 eb                	shr    %cl,%ebx
  801fb8:	89 da                	mov    %ebx,%edx
  801fba:	f7 f7                	div    %edi
  801fbc:	89 d3                	mov    %edx,%ebx
  801fbe:	f7 24 24             	mull   (%esp)
  801fc1:	89 c6                	mov    %eax,%esi
  801fc3:	89 d1                	mov    %edx,%ecx
  801fc5:	39 d3                	cmp    %edx,%ebx
  801fc7:	0f 82 87 00 00 00    	jb     802054 <__umoddi3+0x134>
  801fcd:	0f 84 91 00 00 00    	je     802064 <__umoddi3+0x144>
  801fd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fd7:	29 f2                	sub    %esi,%edx
  801fd9:	19 cb                	sbb    %ecx,%ebx
  801fdb:	89 d8                	mov    %ebx,%eax
  801fdd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801fe1:	d3 e0                	shl    %cl,%eax
  801fe3:	89 e9                	mov    %ebp,%ecx
  801fe5:	d3 ea                	shr    %cl,%edx
  801fe7:	09 d0                	or     %edx,%eax
  801fe9:	89 e9                	mov    %ebp,%ecx
  801feb:	d3 eb                	shr    %cl,%ebx
  801fed:	89 da                	mov    %ebx,%edx
  801fef:	83 c4 1c             	add    $0x1c,%esp
  801ff2:	5b                   	pop    %ebx
  801ff3:	5e                   	pop    %esi
  801ff4:	5f                   	pop    %edi
  801ff5:	5d                   	pop    %ebp
  801ff6:	c3                   	ret    
  801ff7:	90                   	nop
  801ff8:	89 fd                	mov    %edi,%ebp
  801ffa:	85 ff                	test   %edi,%edi
  801ffc:	75 0b                	jne    802009 <__umoddi3+0xe9>
  801ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  802003:	31 d2                	xor    %edx,%edx
  802005:	f7 f7                	div    %edi
  802007:	89 c5                	mov    %eax,%ebp
  802009:	89 f0                	mov    %esi,%eax
  80200b:	31 d2                	xor    %edx,%edx
  80200d:	f7 f5                	div    %ebp
  80200f:	89 c8                	mov    %ecx,%eax
  802011:	f7 f5                	div    %ebp
  802013:	89 d0                	mov    %edx,%eax
  802015:	e9 44 ff ff ff       	jmp    801f5e <__umoddi3+0x3e>
  80201a:	66 90                	xchg   %ax,%ax
  80201c:	89 c8                	mov    %ecx,%eax
  80201e:	89 f2                	mov    %esi,%edx
  802020:	83 c4 1c             	add    $0x1c,%esp
  802023:	5b                   	pop    %ebx
  802024:	5e                   	pop    %esi
  802025:	5f                   	pop    %edi
  802026:	5d                   	pop    %ebp
  802027:	c3                   	ret    
  802028:	3b 04 24             	cmp    (%esp),%eax
  80202b:	72 06                	jb     802033 <__umoddi3+0x113>
  80202d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802031:	77 0f                	ja     802042 <__umoddi3+0x122>
  802033:	89 f2                	mov    %esi,%edx
  802035:	29 f9                	sub    %edi,%ecx
  802037:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80203b:	89 14 24             	mov    %edx,(%esp)
  80203e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802042:	8b 44 24 04          	mov    0x4(%esp),%eax
  802046:	8b 14 24             	mov    (%esp),%edx
  802049:	83 c4 1c             	add    $0x1c,%esp
  80204c:	5b                   	pop    %ebx
  80204d:	5e                   	pop    %esi
  80204e:	5f                   	pop    %edi
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    
  802051:	8d 76 00             	lea    0x0(%esi),%esi
  802054:	2b 04 24             	sub    (%esp),%eax
  802057:	19 fa                	sbb    %edi,%edx
  802059:	89 d1                	mov    %edx,%ecx
  80205b:	89 c6                	mov    %eax,%esi
  80205d:	e9 71 ff ff ff       	jmp    801fd3 <__umoddi3+0xb3>
  802062:	66 90                	xchg   %ax,%ax
  802064:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802068:	72 ea                	jb     802054 <__umoddi3+0x134>
  80206a:	89 d9                	mov    %ebx,%ecx
  80206c:	e9 62 ff ff ff       	jmp    801fd3 <__umoddi3+0xb3>
