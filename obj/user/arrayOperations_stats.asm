
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
  80003e:	e8 89 1c 00 00       	call   801ccc <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 b3 1c 00 00       	call   801cfe <sys_getparentenvid>
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
  80005f:	68 20 3f 80 00       	push   $0x803f20
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 59 18 00 00       	call   8018c5 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 24 3f 80 00       	push   $0x803f24
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 43 18 00 00       	call   8018c5 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 2c 3f 80 00       	push   $0x803f2c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 26 18 00 00       	call   8018c5 <sget>
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
  8000b3:	68 3a 3f 80 00       	push   $0x803f3a
  8000b8:	e8 50 17 00 00       	call   80180d <smalloc>
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
  800126:	68 44 3f 80 00       	push   $0x803f44
  80012b:	e8 10 06 00 00       	call   800740 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 69 3f 80 00       	push   $0x803f69
  80013f:	e8 c9 16 00 00       	call   80180d <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 6e 3f 80 00       	push   $0x803f6e
  80015e:	e8 aa 16 00 00       	call   80180d <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 72 3f 80 00       	push   $0x803f72
  80017d:	e8 8b 16 00 00       	call   80180d <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 76 3f 80 00       	push   $0x803f76
  80019c:	e8 6c 16 00 00       	call   80180d <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 7a 3f 80 00       	push   $0x803f7a
  8001bb:	e8 4d 16 00 00       	call   80180d <smalloc>
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
  800230:	e8 fc 1a 00 00       	call   801d31 <sys_get_virtual_time>
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
  800533:	e8 ad 17 00 00       	call   801ce5 <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80054c:	01 c8                	add    %ecx,%eax
  80054e:	01 c0                	add    %eax,%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800559:	01 c8                	add    %ecx,%eax
  80055b:	01 d0                	add    %edx,%eax
  80055d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800562:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800567:	a1 20 50 80 00       	mov    0x805020,%eax
  80056c:	8a 40 20             	mov    0x20(%eax),%al
  80056f:	84 c0                	test   %al,%al
  800571:	74 0d                	je     800580 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800573:	a1 20 50 80 00       	mov    0x805020,%eax
  800578:	83 c0 20             	add    $0x20,%eax
  80057b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800580:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800584:	7e 0a                	jle    800590 <libmain+0x63>
		binaryname = argv[0];
  800586:	8b 45 0c             	mov    0xc(%ebp),%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	ff 75 0c             	pushl  0xc(%ebp)
  800596:	ff 75 08             	pushl  0x8(%ebp)
  800599:	e8 9a fa ff ff       	call   800038 <_main>
  80059e:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8005a1:	e8 c3 14 00 00       	call   801a69 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	68 98 3f 80 00       	push   $0x803f98
  8005ae:	e8 8d 01 00 00       	call   800740 <cprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bb:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c6:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8005cc:	83 ec 04             	sub    $0x4,%esp
  8005cf:	52                   	push   %edx
  8005d0:	50                   	push   %eax
  8005d1:	68 c0 3f 80 00       	push   $0x803fc0
  8005d6:	e8 65 01 00 00       	call   800740 <cprintf>
  8005db:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005de:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e3:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8005e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ee:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8005f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f9:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8005ff:	51                   	push   %ecx
  800600:	52                   	push   %edx
  800601:	50                   	push   %eax
  800602:	68 e8 3f 80 00       	push   $0x803fe8
  800607:	e8 34 01 00 00       	call   800740 <cprintf>
  80060c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060f:	a1 20 50 80 00       	mov    0x805020,%eax
  800614:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	50                   	push   %eax
  80061e:	68 40 40 80 00       	push   $0x804040
  800623:	e8 18 01 00 00       	call   800740 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	68 98 3f 80 00       	push   $0x803f98
  800633:	e8 08 01 00 00       	call   800740 <cprintf>
  800638:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80063b:	e8 43 14 00 00       	call   801a83 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800640:	e8 19 00 00 00       	call   80065e <exit>
}
  800645:	90                   	nop
  800646:	c9                   	leave  
  800647:	c3                   	ret    

00800648 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800648:	55                   	push   %ebp
  800649:	89 e5                	mov    %esp,%ebp
  80064b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80064e:	83 ec 0c             	sub    $0xc,%esp
  800651:	6a 00                	push   $0x0
  800653:	e8 59 16 00 00       	call   801cb1 <sys_destroy_env>
  800658:	83 c4 10             	add    $0x10,%esp
}
  80065b:	90                   	nop
  80065c:	c9                   	leave  
  80065d:	c3                   	ret    

0080065e <exit>:

void
exit(void)
{
  80065e:	55                   	push   %ebp
  80065f:	89 e5                	mov    %esp,%ebp
  800661:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800664:	e8 ae 16 00 00       	call   801d17 <sys_exit_env>
}
  800669:	90                   	nop
  80066a:	c9                   	leave  
  80066b:	c3                   	ret    

0080066c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80066c:	55                   	push   %ebp
  80066d:	89 e5                	mov    %esp,%ebp
  80066f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800672:	8b 45 0c             	mov    0xc(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 48 01             	lea    0x1(%eax),%ecx
  80067a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067d:	89 0a                	mov    %ecx,(%edx)
  80067f:	8b 55 08             	mov    0x8(%ebp),%edx
  800682:	88 d1                	mov    %dl,%cl
  800684:	8b 55 0c             	mov    0xc(%ebp),%edx
  800687:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80068b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	3d ff 00 00 00       	cmp    $0xff,%eax
  800695:	75 2c                	jne    8006c3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800697:	a0 28 50 80 00       	mov    0x805028,%al
  80069c:	0f b6 c0             	movzbl %al,%eax
  80069f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a2:	8b 12                	mov    (%edx),%edx
  8006a4:	89 d1                	mov    %edx,%ecx
  8006a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a9:	83 c2 08             	add    $0x8,%edx
  8006ac:	83 ec 04             	sub    $0x4,%esp
  8006af:	50                   	push   %eax
  8006b0:	51                   	push   %ecx
  8006b1:	52                   	push   %edx
  8006b2:	e8 70 13 00 00       	call   801a27 <sys_cputs>
  8006b7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c6:	8b 40 04             	mov    0x4(%eax),%eax
  8006c9:	8d 50 01             	lea    0x1(%eax),%edx
  8006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cf:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006d2:	90                   	nop
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006de:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e5:	00 00 00 
	b.cnt = 0;
  8006e8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ef:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	ff 75 08             	pushl  0x8(%ebp)
  8006f8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fe:	50                   	push   %eax
  8006ff:	68 6c 06 80 00       	push   $0x80066c
  800704:	e8 11 02 00 00       	call   80091a <vprintfmt>
  800709:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80070c:	a0 28 50 80 00       	mov    0x805028,%al
  800711:	0f b6 c0             	movzbl %al,%eax
  800714:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80071a:	83 ec 04             	sub    $0x4,%esp
  80071d:	50                   	push   %eax
  80071e:	52                   	push   %edx
  80071f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800725:	83 c0 08             	add    $0x8,%eax
  800728:	50                   	push   %eax
  800729:	e8 f9 12 00 00       	call   801a27 <sys_cputs>
  80072e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800731:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800738:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800746:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  80074d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800750:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 f4             	pushl  -0xc(%ebp)
  80075c:	50                   	push   %eax
  80075d:	e8 73 ff ff ff       	call   8006d5 <vcprintf>
  800762:	83 c4 10             	add    $0x10,%esp
  800765:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800768:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800773:	e8 f1 12 00 00       	call   801a69 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800778:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 f4             	pushl  -0xc(%ebp)
  800787:	50                   	push   %eax
  800788:	e8 48 ff ff ff       	call   8006d5 <vcprintf>
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800793:	e8 eb 12 00 00       	call   801a83 <sys_unlock_cons>
	return cnt;
  800798:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	53                   	push   %ebx
  8007a1:	83 ec 14             	sub    $0x14,%esp
  8007a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007b0:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bb:	77 55                	ja     800812 <printnum+0x75>
  8007bd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c0:	72 05                	jb     8007c7 <printnum+0x2a>
  8007c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c5:	77 4b                	ja     800812 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007ca:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007cd:	8b 45 18             	mov    0x18(%ebp),%eax
  8007d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d5:	52                   	push   %edx
  8007d6:	50                   	push   %eax
  8007d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007da:	ff 75 f0             	pushl  -0x10(%ebp)
  8007dd:	e8 c6 34 00 00       	call   803ca8 <__udivdi3>
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	ff 75 20             	pushl  0x20(%ebp)
  8007eb:	53                   	push   %ebx
  8007ec:	ff 75 18             	pushl  0x18(%ebp)
  8007ef:	52                   	push   %edx
  8007f0:	50                   	push   %eax
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	ff 75 08             	pushl  0x8(%ebp)
  8007f7:	e8 a1 ff ff ff       	call   80079d <printnum>
  8007fc:	83 c4 20             	add    $0x20,%esp
  8007ff:	eb 1a                	jmp    80081b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	ff 75 0c             	pushl  0xc(%ebp)
  800807:	ff 75 20             	pushl  0x20(%ebp)
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	ff d0                	call   *%eax
  80080f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800812:	ff 4d 1c             	decl   0x1c(%ebp)
  800815:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800819:	7f e6                	jg     800801 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80081b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800829:	53                   	push   %ebx
  80082a:	51                   	push   %ecx
  80082b:	52                   	push   %edx
  80082c:	50                   	push   %eax
  80082d:	e8 86 35 00 00       	call   803db8 <__umoddi3>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	05 74 42 80 00       	add    $0x804274,%eax
  80083a:	8a 00                	mov    (%eax),%al
  80083c:	0f be c0             	movsbl %al,%eax
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 0c             	pushl  0xc(%ebp)
  800845:	50                   	push   %eax
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	ff d0                	call   *%eax
  80084b:	83 c4 10             	add    $0x10,%esp
}
  80084e:	90                   	nop
  80084f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800857:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80085b:	7e 1c                	jle    800879 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	8d 50 08             	lea    0x8(%eax),%edx
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	89 10                	mov    %edx,(%eax)
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	83 e8 08             	sub    $0x8,%eax
  800872:	8b 50 04             	mov    0x4(%eax),%edx
  800875:	8b 00                	mov    (%eax),%eax
  800877:	eb 40                	jmp    8008b9 <getuint+0x65>
	else if (lflag)
  800879:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087d:	74 1e                	je     80089d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	8d 50 04             	lea    0x4(%eax),%edx
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	89 10                	mov    %edx,(%eax)
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	ba 00 00 00 00       	mov    $0x0,%edx
  80089b:	eb 1c                	jmp    8008b9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	8d 50 04             	lea    0x4(%eax),%edx
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	89 10                	mov    %edx,(%eax)
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	83 e8 04             	sub    $0x4,%eax
  8008b2:	8b 00                	mov    (%eax),%eax
  8008b4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c2:	7e 1c                	jle    8008e0 <getint+0x25>
		return va_arg(*ap, long long);
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	8d 50 08             	lea    0x8(%eax),%edx
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	89 10                	mov    %edx,(%eax)
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	83 e8 08             	sub    $0x8,%eax
  8008d9:	8b 50 04             	mov    0x4(%eax),%edx
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	eb 38                	jmp    800918 <getint+0x5d>
	else if (lflag)
  8008e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e4:	74 1a                	je     800900 <getint+0x45>
		return va_arg(*ap, long);
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	8d 50 04             	lea    0x4(%eax),%edx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	89 10                	mov    %edx,(%eax)
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	83 e8 04             	sub    $0x4,%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	99                   	cltd   
  8008fe:	eb 18                	jmp    800918 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	8d 50 04             	lea    0x4(%eax),%edx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	89 10                	mov    %edx,(%eax)
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	99                   	cltd   
}
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	56                   	push   %esi
  80091e:	53                   	push   %ebx
  80091f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800922:	eb 17                	jmp    80093b <vprintfmt+0x21>
			if (ch == '\0')
  800924:	85 db                	test   %ebx,%ebx
  800926:	0f 84 c1 03 00 00    	je     800ced <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	53                   	push   %ebx
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	ff d0                	call   *%eax
  800938:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093b:	8b 45 10             	mov    0x10(%ebp),%eax
  80093e:	8d 50 01             	lea    0x1(%eax),%edx
  800941:	89 55 10             	mov    %edx,0x10(%ebp)
  800944:	8a 00                	mov    (%eax),%al
  800946:	0f b6 d8             	movzbl %al,%ebx
  800949:	83 fb 25             	cmp    $0x25,%ebx
  80094c:	75 d6                	jne    800924 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800952:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800959:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800960:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800967:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096e:	8b 45 10             	mov    0x10(%ebp),%eax
  800971:	8d 50 01             	lea    0x1(%eax),%edx
  800974:	89 55 10             	mov    %edx,0x10(%ebp)
  800977:	8a 00                	mov    (%eax),%al
  800979:	0f b6 d8             	movzbl %al,%ebx
  80097c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097f:	83 f8 5b             	cmp    $0x5b,%eax
  800982:	0f 87 3d 03 00 00    	ja     800cc5 <vprintfmt+0x3ab>
  800988:	8b 04 85 98 42 80 00 	mov    0x804298(,%eax,4),%eax
  80098f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800991:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800995:	eb d7                	jmp    80096e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800997:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80099b:	eb d1                	jmp    80096e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a7:	89 d0                	mov    %edx,%eax
  8009a9:	c1 e0 02             	shl    $0x2,%eax
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	01 c0                	add    %eax,%eax
  8009b0:	01 d8                	add    %ebx,%eax
  8009b2:	83 e8 30             	sub    $0x30,%eax
  8009b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8a 00                	mov    (%eax),%al
  8009bd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009c0:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c3:	7e 3e                	jle    800a03 <vprintfmt+0xe9>
  8009c5:	83 fb 39             	cmp    $0x39,%ebx
  8009c8:	7f 39                	jg     800a03 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ca:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009cd:	eb d5                	jmp    8009a4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	83 c0 04             	add    $0x4,%eax
  8009d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009db:	83 e8 04             	sub    $0x4,%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e3:	eb 1f                	jmp    800a04 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e9:	79 83                	jns    80096e <vprintfmt+0x54>
				width = 0;
  8009eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009f2:	e9 77 ff ff ff       	jmp    80096e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fe:	e9 6b ff ff ff       	jmp    80096e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a03:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a08:	0f 89 60 ff ff ff    	jns    80096e <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a14:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a1b:	e9 4e ff ff ff       	jmp    80096e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a20:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a23:	e9 46 ff ff ff       	jmp    80096e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	83 c0 04             	add    $0x4,%eax
  800a2e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a31:	8b 45 14             	mov    0x14(%ebp),%eax
  800a34:	83 e8 04             	sub    $0x4,%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	50                   	push   %eax
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	ff d0                	call   *%eax
  800a45:	83 c4 10             	add    $0x10,%esp
			break;
  800a48:	e9 9b 02 00 00       	jmp    800ce8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a50:	83 c0 04             	add    $0x4,%eax
  800a53:	89 45 14             	mov    %eax,0x14(%ebp)
  800a56:	8b 45 14             	mov    0x14(%ebp),%eax
  800a59:	83 e8 04             	sub    $0x4,%eax
  800a5c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5e:	85 db                	test   %ebx,%ebx
  800a60:	79 02                	jns    800a64 <vprintfmt+0x14a>
				err = -err;
  800a62:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a64:	83 fb 64             	cmp    $0x64,%ebx
  800a67:	7f 0b                	jg     800a74 <vprintfmt+0x15a>
  800a69:	8b 34 9d e0 40 80 00 	mov    0x8040e0(,%ebx,4),%esi
  800a70:	85 f6                	test   %esi,%esi
  800a72:	75 19                	jne    800a8d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a74:	53                   	push   %ebx
  800a75:	68 85 42 80 00       	push   $0x804285
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	ff 75 08             	pushl  0x8(%ebp)
  800a80:	e8 70 02 00 00       	call   800cf5 <printfmt>
  800a85:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a88:	e9 5b 02 00 00       	jmp    800ce8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8d:	56                   	push   %esi
  800a8e:	68 8e 42 80 00       	push   $0x80428e
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	ff 75 08             	pushl  0x8(%ebp)
  800a99:	e8 57 02 00 00       	call   800cf5 <printfmt>
  800a9e:	83 c4 10             	add    $0x10,%esp
			break;
  800aa1:	e9 42 02 00 00       	jmp    800ce8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	83 c0 04             	add    $0x4,%eax
  800aac:	89 45 14             	mov    %eax,0x14(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	83 e8 04             	sub    $0x4,%eax
  800ab5:	8b 30                	mov    (%eax),%esi
  800ab7:	85 f6                	test   %esi,%esi
  800ab9:	75 05                	jne    800ac0 <vprintfmt+0x1a6>
				p = "(null)";
  800abb:	be 91 42 80 00       	mov    $0x804291,%esi
			if (width > 0 && padc != '-')
  800ac0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac4:	7e 6d                	jle    800b33 <vprintfmt+0x219>
  800ac6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aca:	74 67                	je     800b33 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	50                   	push   %eax
  800ad3:	56                   	push   %esi
  800ad4:	e8 1e 03 00 00       	call   800df7 <strnlen>
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800adf:	eb 16                	jmp    800af7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ae1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af4:	ff 4d e4             	decl   -0x1c(%ebp)
  800af7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afb:	7f e4                	jg     800ae1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afd:	eb 34                	jmp    800b33 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800aff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b03:	74 1c                	je     800b21 <vprintfmt+0x207>
  800b05:	83 fb 1f             	cmp    $0x1f,%ebx
  800b08:	7e 05                	jle    800b0f <vprintfmt+0x1f5>
  800b0a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0d:	7e 12                	jle    800b21 <vprintfmt+0x207>
					putch('?', putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	6a 3f                	push   $0x3f
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	ff d0                	call   *%eax
  800b1c:	83 c4 10             	add    $0x10,%esp
  800b1f:	eb 0f                	jmp    800b30 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b21:	83 ec 08             	sub    $0x8,%esp
  800b24:	ff 75 0c             	pushl  0xc(%ebp)
  800b27:	53                   	push   %ebx
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	ff d0                	call   *%eax
  800b2d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b30:	ff 4d e4             	decl   -0x1c(%ebp)
  800b33:	89 f0                	mov    %esi,%eax
  800b35:	8d 70 01             	lea    0x1(%eax),%esi
  800b38:	8a 00                	mov    (%eax),%al
  800b3a:	0f be d8             	movsbl %al,%ebx
  800b3d:	85 db                	test   %ebx,%ebx
  800b3f:	74 24                	je     800b65 <vprintfmt+0x24b>
  800b41:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b45:	78 b8                	js     800aff <vprintfmt+0x1e5>
  800b47:	ff 4d e0             	decl   -0x20(%ebp)
  800b4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4e:	79 af                	jns    800aff <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b50:	eb 13                	jmp    800b65 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	ff 75 0c             	pushl  0xc(%ebp)
  800b58:	6a 20                	push   $0x20
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b62:	ff 4d e4             	decl   -0x1c(%ebp)
  800b65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b69:	7f e7                	jg     800b52 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b6b:	e9 78 01 00 00       	jmp    800ce8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	ff 75 e8             	pushl  -0x18(%ebp)
  800b76:	8d 45 14             	lea    0x14(%ebp),%eax
  800b79:	50                   	push   %eax
  800b7a:	e8 3c fd ff ff       	call   8008bb <getint>
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b85:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8e:	85 d2                	test   %edx,%edx
  800b90:	79 23                	jns    800bb5 <vprintfmt+0x29b>
				putch('-', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	6a 2d                	push   $0x2d
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba8:	f7 d8                	neg    %eax
  800baa:	83 d2 00             	adc    $0x0,%edx
  800bad:	f7 da                	neg    %edx
  800baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bbc:	e9 bc 00 00 00       	jmp    800c7d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bca:	50                   	push   %eax
  800bcb:	e8 84 fc ff ff       	call   800854 <getuint>
  800bd0:	83 c4 10             	add    $0x10,%esp
  800bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800be0:	e9 98 00 00 00       	jmp    800c7d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	6a 58                	push   $0x58
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	ff d0                	call   *%eax
  800bf2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	6a 58                	push   $0x58
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	ff d0                	call   *%eax
  800c02:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	6a 58                	push   $0x58
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	ff d0                	call   *%eax
  800c12:	83 c4 10             	add    $0x10,%esp
			break;
  800c15:	e9 ce 00 00 00       	jmp    800ce8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	6a 30                	push   $0x30
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	ff d0                	call   *%eax
  800c27:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	6a 78                	push   $0x78
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	ff d0                	call   *%eax
  800c37:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3d:	83 c0 04             	add    $0x4,%eax
  800c40:	89 45 14             	mov    %eax,0x14(%ebp)
  800c43:	8b 45 14             	mov    0x14(%ebp),%eax
  800c46:	83 e8 04             	sub    $0x4,%eax
  800c49:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c55:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c5c:	eb 1f                	jmp    800c7d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 e8             	pushl  -0x18(%ebp)
  800c64:	8d 45 14             	lea    0x14(%ebp),%eax
  800c67:	50                   	push   %eax
  800c68:	e8 e7 fb ff ff       	call   800854 <getuint>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c76:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c84:	83 ec 04             	sub    $0x4,%esp
  800c87:	52                   	push   %edx
  800c88:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c8b:	50                   	push   %eax
  800c8c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8f:	ff 75 f0             	pushl  -0x10(%ebp)
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	ff 75 08             	pushl  0x8(%ebp)
  800c98:	e8 00 fb ff ff       	call   80079d <printnum>
  800c9d:	83 c4 20             	add    $0x20,%esp
			break;
  800ca0:	eb 46                	jmp    800ce8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ca2:	83 ec 08             	sub    $0x8,%esp
  800ca5:	ff 75 0c             	pushl  0xc(%ebp)
  800ca8:	53                   	push   %ebx
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	ff d0                	call   *%eax
  800cae:	83 c4 10             	add    $0x10,%esp
			break;
  800cb1:	eb 35                	jmp    800ce8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cb3:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800cba:	eb 2c                	jmp    800ce8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cbc:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800cc3:	eb 23                	jmp    800ce8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc5:	83 ec 08             	sub    $0x8,%esp
  800cc8:	ff 75 0c             	pushl  0xc(%ebp)
  800ccb:	6a 25                	push   $0x25
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	ff d0                	call   *%eax
  800cd2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd5:	ff 4d 10             	decl   0x10(%ebp)
  800cd8:	eb 03                	jmp    800cdd <vprintfmt+0x3c3>
  800cda:	ff 4d 10             	decl   0x10(%ebp)
  800cdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce0:	48                   	dec    %eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	3c 25                	cmp    $0x25,%al
  800ce5:	75 f3                	jne    800cda <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ce7:	90                   	nop
		}
	}
  800ce8:	e9 35 fc ff ff       	jmp    800922 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ced:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    

00800cf5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cfb:	8d 45 10             	lea    0x10(%ebp),%eax
  800cfe:	83 c0 04             	add    $0x4,%eax
  800d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d04:	8b 45 10             	mov    0x10(%ebp),%eax
  800d07:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0a:	50                   	push   %eax
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	ff 75 08             	pushl  0x8(%ebp)
  800d11:	e8 04 fc ff ff       	call   80091a <vprintfmt>
  800d16:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d19:	90                   	nop
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d22:	8b 40 08             	mov    0x8(%eax),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8b 10                	mov    (%eax),%edx
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	8b 40 04             	mov    0x4(%eax),%eax
  800d39:	39 c2                	cmp    %eax,%edx
  800d3b:	73 12                	jae    800d4f <sprintputch+0x33>
		*b->buf++ = ch;
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8b 00                	mov    (%eax),%eax
  800d42:	8d 48 01             	lea    0x1(%eax),%ecx
  800d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d48:	89 0a                	mov    %ecx,(%edx)
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	88 10                	mov    %dl,(%eax)
}
  800d4f:	90                   	nop
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	01 d0                	add    %edx,%eax
  800d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d77:	74 06                	je     800d7f <vsnprintf+0x2d>
  800d79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7d:	7f 07                	jg     800d86 <vsnprintf+0x34>
		return -E_INVAL;
  800d7f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d84:	eb 20                	jmp    800da6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d86:	ff 75 14             	pushl  0x14(%ebp)
  800d89:	ff 75 10             	pushl  0x10(%ebp)
  800d8c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8f:	50                   	push   %eax
  800d90:	68 1c 0d 80 00       	push   $0x800d1c
  800d95:	e8 80 fb ff ff       	call   80091a <vprintfmt>
  800d9a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dae:	8d 45 10             	lea    0x10(%ebp),%eax
  800db1:	83 c0 04             	add    $0x4,%eax
  800db4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dba:	ff 75 f4             	pushl  -0xc(%ebp)
  800dbd:	50                   	push   %eax
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	ff 75 08             	pushl  0x8(%ebp)
  800dc4:	e8 89 ff ff ff       	call   800d52 <vsnprintf>
  800dc9:	83 c4 10             	add    $0x10,%esp
  800dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dd2:	c9                   	leave  
  800dd3:	c3                   	ret    

00800dd4 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de1:	eb 06                	jmp    800de9 <strlen+0x15>
		n++;
  800de3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de6:	ff 45 08             	incl   0x8(%ebp)
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	84 c0                	test   %al,%al
  800df0:	75 f1                	jne    800de3 <strlen+0xf>
		n++;
	return n;
  800df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df5:	c9                   	leave  
  800df6:	c3                   	ret    

00800df7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e04:	eb 09                	jmp    800e0f <strnlen+0x18>
		n++;
  800e06:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e09:	ff 45 08             	incl   0x8(%ebp)
  800e0c:	ff 4d 0c             	decl   0xc(%ebp)
  800e0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e13:	74 09                	je     800e1e <strnlen+0x27>
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	84 c0                	test   %al,%al
  800e1c:	75 e8                	jne    800e06 <strnlen+0xf>
		n++;
	return n;
  800e1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e21:	c9                   	leave  
  800e22:	c3                   	ret    

00800e23 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2f:	90                   	nop
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8d 50 01             	lea    0x1(%eax),%edx
  800e36:	89 55 08             	mov    %edx,0x8(%ebp)
  800e39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e42:	8a 12                	mov    (%edx),%dl
  800e44:	88 10                	mov    %dl,(%eax)
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	84 c0                	test   %al,%al
  800e4a:	75 e4                	jne    800e30 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e64:	eb 1f                	jmp    800e85 <strncpy+0x34>
		*dst++ = *src;
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e72:	8a 12                	mov    (%edx),%dl
  800e74:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	84 c0                	test   %al,%al
  800e7d:	74 03                	je     800e82 <strncpy+0x31>
			src++;
  800e7f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e82:	ff 45 fc             	incl   -0x4(%ebp)
  800e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e88:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e8b:	72 d9                	jb     800e66 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea2:	74 30                	je     800ed4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ea4:	eb 16                	jmp    800ebc <strlcpy+0x2a>
			*dst++ = *src++;
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 08             	mov    %edx,0x8(%ebp)
  800eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb8:	8a 12                	mov    (%edx),%dl
  800eba:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ebc:	ff 4d 10             	decl   0x10(%ebp)
  800ebf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec3:	74 09                	je     800ece <strlcpy+0x3c>
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	84 c0                	test   %al,%al
  800ecc:	75 d8                	jne    800ea6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	29 c2                	sub    %eax,%edx
  800edc:	89 d0                	mov    %edx,%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ee3:	eb 06                	jmp    800eeb <strcmp+0xb>
		p++, q++;
  800ee5:	ff 45 08             	incl   0x8(%ebp)
  800ee8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	84 c0                	test   %al,%al
  800ef2:	74 0e                	je     800f02 <strcmp+0x22>
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 10                	mov    (%eax),%dl
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	38 c2                	cmp    %al,%dl
  800f00:	74 e3                	je     800ee5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	0f b6 d0             	movzbl %al,%edx
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	0f b6 c0             	movzbl %al,%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
}
  800f16:	5d                   	pop    %ebp
  800f17:	c3                   	ret    

00800f18 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f1b:	eb 09                	jmp    800f26 <strncmp+0xe>
		n--, p++, q++;
  800f1d:	ff 4d 10             	decl   0x10(%ebp)
  800f20:	ff 45 08             	incl   0x8(%ebp)
  800f23:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2a:	74 17                	je     800f43 <strncmp+0x2b>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	84 c0                	test   %al,%al
  800f33:	74 0e                	je     800f43 <strncmp+0x2b>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 da                	je     800f1d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	75 07                	jne    800f50 <strncmp+0x38>
		return 0;
  800f49:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4e:	eb 14                	jmp    800f64 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	0f b6 d0             	movzbl %al,%edx
  800f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	0f b6 c0             	movzbl %al,%eax
  800f60:	29 c2                	sub    %eax,%edx
  800f62:	89 d0                	mov    %edx,%eax
}
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 04             	sub    $0x4,%esp
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f72:	eb 12                	jmp    800f86 <strchr+0x20>
		if (*s == c)
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f7c:	75 05                	jne    800f83 <strchr+0x1d>
			return (char *) s;
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	eb 11                	jmp    800f94 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f83:	ff 45 08             	incl   0x8(%ebp)
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	84 c0                	test   %al,%al
  800f8d:	75 e5                	jne    800f74 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    

00800f96 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 04             	sub    $0x4,%esp
  800f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa2:	eb 0d                	jmp    800fb1 <strfind+0x1b>
		if (*s == c)
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fac:	74 0e                	je     800fbc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fae:	ff 45 08             	incl   0x8(%ebp)
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	84 c0                	test   %al,%al
  800fb8:	75 ea                	jne    800fa4 <strfind+0xe>
  800fba:	eb 01                	jmp    800fbd <strfind+0x27>
		if (*s == c)
			break;
  800fbc:	90                   	nop
	return (char *) s;
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fce:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fd4:	eb 0e                	jmp    800fe4 <memset+0x22>
		*p++ = c;
  800fd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd9:	8d 50 01             	lea    0x1(%eax),%edx
  800fdc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fe4:	ff 4d f8             	decl   -0x8(%ebp)
  800fe7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800feb:	79 e9                	jns    800fd6 <memset+0x14>
		*p++ = c;

	return v;
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801004:	eb 16                	jmp    80101c <memcpy+0x2a>
		*d++ = *s++;
  801006:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801009:	8d 50 01             	lea    0x1(%eax),%edx
  80100c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801012:	8d 4a 01             	lea    0x1(%edx),%ecx
  801015:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801018:	8a 12                	mov    (%edx),%dl
  80101a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80101c:	8b 45 10             	mov    0x10(%ebp),%eax
  80101f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801022:	89 55 10             	mov    %edx,0x10(%ebp)
  801025:	85 c0                	test   %eax,%eax
  801027:	75 dd                	jne    801006 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102c:	c9                   	leave  
  80102d:	c3                   	ret    

0080102e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801043:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801046:	73 50                	jae    801098 <memmove+0x6a>
  801048:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104b:	8b 45 10             	mov    0x10(%ebp),%eax
  80104e:	01 d0                	add    %edx,%eax
  801050:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801053:	76 43                	jbe    801098 <memmove+0x6a>
		s += n;
  801055:	8b 45 10             	mov    0x10(%ebp),%eax
  801058:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801061:	eb 10                	jmp    801073 <memmove+0x45>
			*--d = *--s;
  801063:	ff 4d f8             	decl   -0x8(%ebp)
  801066:	ff 4d fc             	decl   -0x4(%ebp)
  801069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106c:	8a 10                	mov    (%eax),%dl
  80106e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801071:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801073:	8b 45 10             	mov    0x10(%ebp),%eax
  801076:	8d 50 ff             	lea    -0x1(%eax),%edx
  801079:	89 55 10             	mov    %edx,0x10(%ebp)
  80107c:	85 c0                	test   %eax,%eax
  80107e:	75 e3                	jne    801063 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801080:	eb 23                	jmp    8010a5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801091:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801094:	8a 12                	mov    (%edx),%dl
  801096:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801098:	8b 45 10             	mov    0x10(%ebp),%eax
  80109b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109e:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	75 dd                	jne    801082 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010bc:	eb 2a                	jmp    8010e8 <memcmp+0x3e>
		if (*s1 != *s2)
  8010be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c1:	8a 10                	mov    (%eax),%dl
  8010c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	38 c2                	cmp    %al,%dl
  8010ca:	74 16                	je     8010e2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	0f b6 d0             	movzbl %al,%edx
  8010d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	0f b6 c0             	movzbl %al,%eax
  8010dc:	29 c2                	sub    %eax,%edx
  8010de:	89 d0                	mov    %edx,%eax
  8010e0:	eb 18                	jmp    8010fa <memcmp+0x50>
		s1++, s2++;
  8010e2:	ff 45 fc             	incl   -0x4(%ebp)
  8010e5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	75 c9                	jne    8010be <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801102:	8b 55 08             	mov    0x8(%ebp),%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80110d:	eb 15                	jmp    801124 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	0f b6 d0             	movzbl %al,%edx
  801117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111a:	0f b6 c0             	movzbl %al,%eax
  80111d:	39 c2                	cmp    %eax,%edx
  80111f:	74 0d                	je     80112e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801121:	ff 45 08             	incl   0x8(%ebp)
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80112a:	72 e3                	jb     80110f <memfind+0x13>
  80112c:	eb 01                	jmp    80112f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80112e:	90                   	nop
	return (void *) s;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80113a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801141:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801148:	eb 03                	jmp    80114d <strtol+0x19>
		s++;
  80114a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	3c 20                	cmp    $0x20,%al
  801154:	74 f4                	je     80114a <strtol+0x16>
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 09                	cmp    $0x9,%al
  80115d:	74 eb                	je     80114a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 2b                	cmp    $0x2b,%al
  801166:	75 05                	jne    80116d <strtol+0x39>
		s++;
  801168:	ff 45 08             	incl   0x8(%ebp)
  80116b:	eb 13                	jmp    801180 <strtol+0x4c>
	else if (*s == '-')
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 2d                	cmp    $0x2d,%al
  801174:	75 0a                	jne    801180 <strtol+0x4c>
		s++, neg = 1;
  801176:	ff 45 08             	incl   0x8(%ebp)
  801179:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801180:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801184:	74 06                	je     80118c <strtol+0x58>
  801186:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80118a:	75 20                	jne    8011ac <strtol+0x78>
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 30                	cmp    $0x30,%al
  801193:	75 17                	jne    8011ac <strtol+0x78>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	40                   	inc    %eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	3c 78                	cmp    $0x78,%al
  80119d:	75 0d                	jne    8011ac <strtol+0x78>
		s += 2, base = 16;
  80119f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011a3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011aa:	eb 28                	jmp    8011d4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b0:	75 15                	jne    8011c7 <strtol+0x93>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	3c 30                	cmp    $0x30,%al
  8011b9:	75 0c                	jne    8011c7 <strtol+0x93>
		s++, base = 8;
  8011bb:	ff 45 08             	incl   0x8(%ebp)
  8011be:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c5:	eb 0d                	jmp    8011d4 <strtol+0xa0>
	else if (base == 0)
  8011c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cb:	75 07                	jne    8011d4 <strtol+0xa0>
		base = 10;
  8011cd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	3c 2f                	cmp    $0x2f,%al
  8011db:	7e 19                	jle    8011f6 <strtol+0xc2>
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 39                	cmp    $0x39,%al
  8011e4:	7f 10                	jg     8011f6 <strtol+0xc2>
			dig = *s - '0';
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	0f be c0             	movsbl %al,%eax
  8011ee:	83 e8 30             	sub    $0x30,%eax
  8011f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011f4:	eb 42                	jmp    801238 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	3c 60                	cmp    $0x60,%al
  8011fd:	7e 19                	jle    801218 <strtol+0xe4>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 7a                	cmp    $0x7a,%al
  801206:	7f 10                	jg     801218 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	0f be c0             	movsbl %al,%eax
  801210:	83 e8 57             	sub    $0x57,%eax
  801213:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801216:	eb 20                	jmp    801238 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	3c 40                	cmp    $0x40,%al
  80121f:	7e 39                	jle    80125a <strtol+0x126>
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 5a                	cmp    $0x5a,%al
  801228:	7f 30                	jg     80125a <strtol+0x126>
			dig = *s - 'A' + 10;
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	0f be c0             	movsbl %al,%eax
  801232:	83 e8 37             	sub    $0x37,%eax
  801235:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80123e:	7d 19                	jge    801259 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801240:	ff 45 08             	incl   0x8(%ebp)
  801243:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801246:	0f af 45 10          	imul   0x10(%ebp),%eax
  80124a:	89 c2                	mov    %eax,%edx
  80124c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801254:	e9 7b ff ff ff       	jmp    8011d4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801259:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80125a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80125e:	74 08                	je     801268 <strtol+0x134>
		*endptr = (char *) s;
  801260:	8b 45 0c             	mov    0xc(%ebp),%eax
  801263:	8b 55 08             	mov    0x8(%ebp),%edx
  801266:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801268:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80126c:	74 07                	je     801275 <strtol+0x141>
  80126e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801271:	f7 d8                	neg    %eax
  801273:	eb 03                	jmp    801278 <strtol+0x144>
  801275:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <ltostr>:

void
ltostr(long value, char *str)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801280:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801287:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80128e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801292:	79 13                	jns    8012a7 <ltostr+0x2d>
	{
		neg = 1;
  801294:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80129b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012a1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012a4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012af:	99                   	cltd   
  8012b0:	f7 f9                	idiv   %ecx
  8012b2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b8:	8d 50 01             	lea    0x1(%eax),%edx
  8012bb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012be:	89 c2                	mov    %eax,%edx
  8012c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c3:	01 d0                	add    %edx,%eax
  8012c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c8:	83 c2 30             	add    $0x30,%edx
  8012cb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d5:	f7 e9                	imul   %ecx
  8012d7:	c1 fa 02             	sar    $0x2,%edx
  8012da:	89 c8                	mov    %ecx,%eax
  8012dc:	c1 f8 1f             	sar    $0x1f,%eax
  8012df:	29 c2                	sub    %eax,%edx
  8012e1:	89 d0                	mov    %edx,%eax
  8012e3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ea:	75 bb                	jne    8012a7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f6:	48                   	dec    %eax
  8012f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012fe:	74 3d                	je     80133d <ltostr+0xc3>
		start = 1 ;
  801300:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801307:	eb 34                	jmp    80133d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801309:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	01 d0                	add    %edx,%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801316:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131c:	01 c2                	add    %eax,%edx
  80131e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801321:	8b 45 0c             	mov    0xc(%ebp),%eax
  801324:	01 c8                	add    %ecx,%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80132a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	01 c2                	add    %eax,%edx
  801332:	8a 45 eb             	mov    -0x15(%ebp),%al
  801335:	88 02                	mov    %al,(%edx)
		start++ ;
  801337:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80133a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80133d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801340:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801343:	7c c4                	jl     801309 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801345:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801350:	90                   	nop
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801359:	ff 75 08             	pushl  0x8(%ebp)
  80135c:	e8 73 fa ff ff       	call   800dd4 <strlen>
  801361:	83 c4 04             	add    $0x4,%esp
  801364:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801367:	ff 75 0c             	pushl  0xc(%ebp)
  80136a:	e8 65 fa ff ff       	call   800dd4 <strlen>
  80136f:	83 c4 04             	add    $0x4,%esp
  801372:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801375:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80137c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801383:	eb 17                	jmp    80139c <strcconcat+0x49>
		final[s] = str1[s] ;
  801385:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801388:	8b 45 10             	mov    0x10(%ebp),%eax
  80138b:	01 c2                	add    %eax,%edx
  80138d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	01 c8                	add    %ecx,%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801399:	ff 45 fc             	incl   -0x4(%ebp)
  80139c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013a2:	7c e1                	jl     801385 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013b2:	eb 1f                	jmp    8013d3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013bd:	89 c2                	mov    %eax,%edx
  8013bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c2:	01 c2                	add    %eax,%edx
  8013c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ca:	01 c8                	add    %ecx,%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013d0:	ff 45 f8             	incl   -0x8(%ebp)
  8013d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013d9:	7c d9                	jl     8013b4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013de:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e1:	01 d0                	add    %edx,%eax
  8013e3:	c6 00 00             	movb   $0x0,(%eax)
}
  8013e6:	90                   	nop
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f8:	8b 00                	mov    (%eax),%eax
  8013fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80140c:	eb 0c                	jmp    80141a <strsplit+0x31>
			*string++ = 0;
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8d 50 01             	lea    0x1(%eax),%edx
  801414:	89 55 08             	mov    %edx,0x8(%ebp)
  801417:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	84 c0                	test   %al,%al
  801421:	74 18                	je     80143b <strsplit+0x52>
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	0f be c0             	movsbl %al,%eax
  80142b:	50                   	push   %eax
  80142c:	ff 75 0c             	pushl  0xc(%ebp)
  80142f:	e8 32 fb ff ff       	call   800f66 <strchr>
  801434:	83 c4 08             	add    $0x8,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	75 d3                	jne    80140e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	84 c0                	test   %al,%al
  801442:	74 5a                	je     80149e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801444:	8b 45 14             	mov    0x14(%ebp),%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	83 f8 0f             	cmp    $0xf,%eax
  80144c:	75 07                	jne    801455 <strsplit+0x6c>
		{
			return 0;
  80144e:	b8 00 00 00 00       	mov    $0x0,%eax
  801453:	eb 66                	jmp    8014bb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801455:	8b 45 14             	mov    0x14(%ebp),%eax
  801458:	8b 00                	mov    (%eax),%eax
  80145a:	8d 48 01             	lea    0x1(%eax),%ecx
  80145d:	8b 55 14             	mov    0x14(%ebp),%edx
  801460:	89 0a                	mov    %ecx,(%edx)
  801462:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801469:	8b 45 10             	mov    0x10(%ebp),%eax
  80146c:	01 c2                	add    %eax,%edx
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801473:	eb 03                	jmp    801478 <strsplit+0x8f>
			string++;
  801475:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8a 00                	mov    (%eax),%al
  80147d:	84 c0                	test   %al,%al
  80147f:	74 8b                	je     80140c <strsplit+0x23>
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8a 00                	mov    (%eax),%al
  801486:	0f be c0             	movsbl %al,%eax
  801489:	50                   	push   %eax
  80148a:	ff 75 0c             	pushl  0xc(%ebp)
  80148d:	e8 d4 fa ff ff       	call   800f66 <strchr>
  801492:	83 c4 08             	add    $0x8,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	74 dc                	je     801475 <strsplit+0x8c>
			string++;
	}
  801499:	e9 6e ff ff ff       	jmp    80140c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80149e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80149f:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a2:	8b 00                	mov    (%eax),%eax
  8014a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ae:	01 d0                	add    %edx,%eax
  8014b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	68 08 44 80 00       	push   $0x804408
  8014cb:	68 3f 01 00 00       	push   $0x13f
  8014d0:	68 2a 44 80 00       	push   $0x80442a
  8014d5:	e8 e4 25 00 00       	call   803abe <_panic>

008014da <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8014e0:	83 ec 0c             	sub    $0xc,%esp
  8014e3:	ff 75 08             	pushl  0x8(%ebp)
  8014e6:	e8 e7 0a 00 00       	call   801fd2 <sys_sbrk>
  8014eb:	83 c4 10             	add    $0x10,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8014f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014fa:	75 0a                	jne    801506 <malloc+0x16>
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801501:	e9 07 02 00 00       	jmp    80170d <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801506:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80150d:	8b 55 08             	mov    0x8(%ebp),%edx
  801510:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801513:	01 d0                	add    %edx,%eax
  801515:	48                   	dec    %eax
  801516:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801519:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80151c:	ba 00 00 00 00       	mov    $0x0,%edx
  801521:	f7 75 dc             	divl   -0x24(%ebp)
  801524:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801527:	29 d0                	sub    %edx,%eax
  801529:	c1 e8 0c             	shr    $0xc,%eax
  80152c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80152f:	a1 20 50 80 00       	mov    0x805020,%eax
  801534:	8b 40 78             	mov    0x78(%eax),%eax
  801537:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80153c:	29 c2                	sub    %eax,%edx
  80153e:	89 d0                	mov    %edx,%eax
  801540:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801543:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801546:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154b:	c1 e8 0c             	shr    $0xc,%eax
  80154e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801551:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801558:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80155f:	77 42                	ja     8015a3 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801561:	e8 f0 08 00 00       	call   801e56 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801566:	85 c0                	test   %eax,%eax
  801568:	74 16                	je     801580 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	e8 30 0e 00 00       	call   8023a5 <alloc_block_FF>
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157b:	e9 8a 01 00 00       	jmp    80170a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801580:	e8 02 09 00 00       	call   801e87 <sys_isUHeapPlacementStrategyBESTFIT>
  801585:	85 c0                	test   %eax,%eax
  801587:	0f 84 7d 01 00 00    	je     80170a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 c9 12 00 00       	call   802861 <alloc_block_BF>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159e:	e9 67 01 00 00       	jmp    80170a <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8015a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8015a6:	48                   	dec    %eax
  8015a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8015aa:	0f 86 53 01 00 00    	jbe    801703 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8015b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8015b5:	8b 40 78             	mov    0x78(%eax),%eax
  8015b8:	05 00 10 00 00       	add    $0x1000,%eax
  8015bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8015c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8015c7:	e9 de 00 00 00       	jmp    8016aa <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8015cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8015d1:	8b 40 78             	mov    0x78(%eax),%eax
  8015d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d7:	29 c2                	sub    %eax,%edx
  8015d9:	89 d0                	mov    %edx,%eax
  8015db:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015e0:	c1 e8 0c             	shr    $0xc,%eax
  8015e3:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	0f 85 ab 00 00 00    	jne    80169d <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	05 00 10 00 00       	add    $0x1000,%eax
  8015fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8015fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801604:	eb 47                	jmp    80164d <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801606:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80160d:	76 0a                	jbe    801619 <malloc+0x129>
  80160f:	b8 00 00 00 00       	mov    $0x0,%eax
  801614:	e9 f4 00 00 00       	jmp    80170d <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801619:	a1 20 50 80 00       	mov    0x805020,%eax
  80161e:	8b 40 78             	mov    0x78(%eax),%eax
  801621:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801624:	29 c2                	sub    %eax,%edx
  801626:	89 d0                	mov    %edx,%eax
  801628:	2d 00 10 00 00       	sub    $0x1000,%eax
  80162d:	c1 e8 0c             	shr    $0xc,%eax
  801630:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801637:	85 c0                	test   %eax,%eax
  801639:	74 08                	je     801643 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  80163b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80163e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801641:	eb 5a                	jmp    80169d <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801643:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80164a:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80164d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801650:	48                   	dec    %eax
  801651:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801654:	77 b0                	ja     801606 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801656:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  80165d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801664:	eb 2f                	jmp    801695 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801669:	c1 e0 0c             	shl    $0xc,%eax
  80166c:	89 c2                	mov    %eax,%edx
  80166e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801671:	01 c2                	add    %eax,%edx
  801673:	a1 20 50 80 00       	mov    0x805020,%eax
  801678:	8b 40 78             	mov    0x78(%eax),%eax
  80167b:	29 c2                	sub    %eax,%edx
  80167d:	89 d0                	mov    %edx,%eax
  80167f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801684:	c1 e8 0c             	shr    $0xc,%eax
  801687:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  80168e:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801692:	ff 45 e0             	incl   -0x20(%ebp)
  801695:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801698:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80169b:	72 c9                	jb     801666 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80169d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016a1:	75 16                	jne    8016b9 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8016a3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8016aa:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8016b1:	0f 86 15 ff ff ff    	jbe    8015cc <malloc+0xdc>
  8016b7:	eb 01                	jmp    8016ba <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8016b9:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8016ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016be:	75 07                	jne    8016c7 <malloc+0x1d7>
  8016c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c5:	eb 46                	jmp    80170d <malloc+0x21d>
		ptr = (void*)i;
  8016c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8016cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8016d2:	8b 40 78             	mov    0x78(%eax),%eax
  8016d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d8:	29 c2                	sub    %eax,%edx
  8016da:	89 d0                	mov    %edx,%eax
  8016dc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016e1:	c1 e8 0c             	shr    $0xc,%eax
  8016e4:	89 c2                	mov    %eax,%edx
  8016e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016e9:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	ff 75 08             	pushl  0x8(%ebp)
  8016f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8016f9:	e8 0b 09 00 00       	call   802009 <sys_allocate_user_mem>
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	eb 07                	jmp    80170a <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
  801708:	eb 03                	jmp    80170d <malloc+0x21d>
	}
	return ptr;
  80170a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801715:	a1 20 50 80 00       	mov    0x805020,%eax
  80171a:	8b 40 78             	mov    0x78(%eax),%eax
  80171d:	05 00 10 00 00       	add    $0x1000,%eax
  801722:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801725:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80172c:	a1 20 50 80 00       	mov    0x805020,%eax
  801731:	8b 50 78             	mov    0x78(%eax),%edx
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	39 c2                	cmp    %eax,%edx
  801739:	76 24                	jbe    80175f <free+0x50>
		size = get_block_size(va);
  80173b:	83 ec 0c             	sub    $0xc,%esp
  80173e:	ff 75 08             	pushl  0x8(%ebp)
  801741:	e8 df 08 00 00       	call   802025 <get_block_size>
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	e8 12 1b 00 00       	call   803269 <free_block>
  801757:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80175a:	e9 ac 00 00 00       	jmp    80180b <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801765:	0f 82 89 00 00 00    	jb     8017f4 <free+0xe5>
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801773:	77 7f                	ja     8017f4 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801775:	8b 55 08             	mov    0x8(%ebp),%edx
  801778:	a1 20 50 80 00       	mov    0x805020,%eax
  80177d:	8b 40 78             	mov    0x78(%eax),%eax
  801780:	29 c2                	sub    %eax,%edx
  801782:	89 d0                	mov    %edx,%eax
  801784:	2d 00 10 00 00       	sub    $0x1000,%eax
  801789:	c1 e8 0c             	shr    $0xc,%eax
  80178c:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801793:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801796:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801799:	c1 e0 0c             	shl    $0xc,%eax
  80179c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80179f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8017a6:	eb 2f                	jmp    8017d7 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8017a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ab:	c1 e0 0c             	shl    $0xc,%eax
  8017ae:	89 c2                	mov    %eax,%edx
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	01 c2                	add    %eax,%edx
  8017b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8017ba:	8b 40 78             	mov    0x78(%eax),%eax
  8017bd:	29 c2                	sub    %eax,%edx
  8017bf:	89 d0                	mov    %edx,%eax
  8017c1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017c6:	c1 e8 0c             	shr    $0xc,%eax
  8017c9:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  8017d0:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8017d4:	ff 45 f4             	incl   -0xc(%ebp)
  8017d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017da:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017dd:	72 c9                	jb     8017a8 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	83 ec 08             	sub    $0x8,%esp
  8017e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8017e8:	50                   	push   %eax
  8017e9:	e8 ff 07 00 00       	call   801fed <sys_free_user_mem>
  8017ee:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8017f1:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8017f2:	eb 17                	jmp    80180b <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	68 38 44 80 00       	push   $0x804438
  8017fc:	68 85 00 00 00       	push   $0x85
  801801:	68 62 44 80 00       	push   $0x804462
  801806:	e8 b3 22 00 00       	call   803abe <_panic>
	}
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 28             	sub    $0x28,%esp
  801813:	8b 45 10             	mov    0x10(%ebp),%eax
  801816:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801819:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181d:	75 0a                	jne    801829 <smalloc+0x1c>
  80181f:	b8 00 00 00 00       	mov    $0x0,%eax
  801824:	e9 9a 00 00 00       	jmp    8018c3 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801836:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183c:	39 d0                	cmp    %edx,%eax
  80183e:	73 02                	jae    801842 <smalloc+0x35>
  801840:	89 d0                	mov    %edx,%eax
  801842:	83 ec 0c             	sub    $0xc,%esp
  801845:	50                   	push   %eax
  801846:	e8 a5 fc ff ff       	call   8014f0 <malloc>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801851:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801855:	75 07                	jne    80185e <smalloc+0x51>
  801857:	b8 00 00 00 00       	mov    $0x0,%eax
  80185c:	eb 65                	jmp    8018c3 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80185e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801862:	ff 75 ec             	pushl  -0x14(%ebp)
  801865:	50                   	push   %eax
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	ff 75 08             	pushl  0x8(%ebp)
  80186c:	e8 83 03 00 00       	call   801bf4 <sys_createSharedObject>
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801877:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80187b:	74 06                	je     801883 <smalloc+0x76>
  80187d:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801881:	75 07                	jne    80188a <smalloc+0x7d>
  801883:	b8 00 00 00 00       	mov    $0x0,%eax
  801888:	eb 39                	jmp    8018c3 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	ff 75 ec             	pushl  -0x14(%ebp)
  801890:	68 6e 44 80 00       	push   $0x80446e
  801895:	e8 a6 ee ff ff       	call   800740 <cprintf>
  80189a:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80189d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8018a5:	8b 40 78             	mov    0x78(%eax),%eax
  8018a8:	29 c2                	sub    %eax,%edx
  8018aa:	89 d0                	mov    %edx,%eax
  8018ac:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018b1:	c1 e8 0c             	shr    $0xc,%eax
  8018b4:	89 c2                	mov    %eax,%edx
  8018b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b9:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8018c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018cb:	83 ec 08             	sub    $0x8,%esp
  8018ce:	ff 75 0c             	pushl  0xc(%ebp)
  8018d1:	ff 75 08             	pushl  0x8(%ebp)
  8018d4:	e8 45 03 00 00       	call   801c1e <sys_getSizeOfSharedObject>
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8018df:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018e3:	75 07                	jne    8018ec <sget+0x27>
  8018e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ea:	eb 5c                	jmp    801948 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8018ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018f2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ff:	39 d0                	cmp    %edx,%eax
  801901:	7d 02                	jge    801905 <sget+0x40>
  801903:	89 d0                	mov    %edx,%eax
  801905:	83 ec 0c             	sub    $0xc,%esp
  801908:	50                   	push   %eax
  801909:	e8 e2 fb ff ff       	call   8014f0 <malloc>
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801914:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801918:	75 07                	jne    801921 <sget+0x5c>
  80191a:	b8 00 00 00 00       	mov    $0x0,%eax
  80191f:	eb 27                	jmp    801948 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	ff 75 e8             	pushl  -0x18(%ebp)
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	e8 09 03 00 00       	call   801c3b <sys_getSharedObject>
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801938:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80193c:	75 07                	jne    801945 <sget+0x80>
  80193e:	b8 00 00 00 00       	mov    $0x0,%eax
  801943:	eb 03                	jmp    801948 <sget+0x83>
	return ptr;
  801945:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801950:	8b 55 08             	mov    0x8(%ebp),%edx
  801953:	a1 20 50 80 00       	mov    0x805020,%eax
  801958:	8b 40 78             	mov    0x78(%eax),%eax
  80195b:	29 c2                	sub    %eax,%edx
  80195d:	89 d0                	mov    %edx,%eax
  80195f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801964:	c1 e8 0c             	shr    $0xc,%eax
  801967:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80196e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801971:	83 ec 08             	sub    $0x8,%esp
  801974:	ff 75 08             	pushl  0x8(%ebp)
  801977:	ff 75 f4             	pushl  -0xc(%ebp)
  80197a:	e8 db 02 00 00       	call   801c5a <sys_freeSharedObject>
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801985:	90                   	nop
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80198e:	83 ec 04             	sub    $0x4,%esp
  801991:	68 80 44 80 00       	push   $0x804480
  801996:	68 dd 00 00 00       	push   $0xdd
  80199b:	68 62 44 80 00       	push   $0x804462
  8019a0:	e8 19 21 00 00       	call   803abe <_panic>

008019a5 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ab:	83 ec 04             	sub    $0x4,%esp
  8019ae:	68 a6 44 80 00       	push   $0x8044a6
  8019b3:	68 e9 00 00 00       	push   $0xe9
  8019b8:	68 62 44 80 00       	push   $0x804462
  8019bd:	e8 fc 20 00 00       	call   803abe <_panic>

008019c2 <shrink>:

}
void shrink(uint32 newSize)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019c8:	83 ec 04             	sub    $0x4,%esp
  8019cb:	68 a6 44 80 00       	push   $0x8044a6
  8019d0:	68 ee 00 00 00       	push   $0xee
  8019d5:	68 62 44 80 00       	push   $0x804462
  8019da:	e8 df 20 00 00       	call   803abe <_panic>

008019df <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	68 a6 44 80 00       	push   $0x8044a6
  8019ed:	68 f3 00 00 00       	push   $0xf3
  8019f2:	68 62 44 80 00       	push   $0x804462
  8019f7:	e8 c2 20 00 00       	call   803abe <_panic>

008019fc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	57                   	push   %edi
  801a00:	56                   	push   %esi
  801a01:	53                   	push   %ebx
  801a02:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a11:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a14:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a17:	cd 30                	int    $0x30
  801a19:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a1f:	83 c4 10             	add    $0x10,%esp
  801a22:	5b                   	pop    %ebx
  801a23:	5e                   	pop    %esi
  801a24:	5f                   	pop    %edi
  801a25:	5d                   	pop    %ebp
  801a26:	c3                   	ret    

00801a27 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a30:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a33:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	52                   	push   %edx
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	50                   	push   %eax
  801a43:	6a 00                	push   $0x0
  801a45:	e8 b2 ff ff ff       	call   8019fc <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	90                   	nop
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 02                	push   $0x2
  801a5f:	e8 98 ff ff ff       	call   8019fc <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 03                	push   $0x3
  801a78:	e8 7f ff ff ff       	call   8019fc <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	90                   	nop
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 04                	push   $0x4
  801a92:	e8 65 ff ff ff       	call   8019fc <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	90                   	nop
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	6a 08                	push   $0x8
  801ab0:	e8 47 ff ff ff       	call   8019fc <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801abf:	8b 75 18             	mov    0x18(%ebp),%esi
  801ac2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	56                   	push   %esi
  801acf:	53                   	push   %ebx
  801ad0:	51                   	push   %ecx
  801ad1:	52                   	push   %edx
  801ad2:	50                   	push   %eax
  801ad3:	6a 09                	push   $0x9
  801ad5:	e8 22 ff ff ff       	call   8019fc <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae0:	5b                   	pop    %ebx
  801ae1:	5e                   	pop    %esi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    

00801ae4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	52                   	push   %edx
  801af4:	50                   	push   %eax
  801af5:	6a 0a                	push   $0xa
  801af7:	e8 00 ff ff ff       	call   8019fc <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	ff 75 08             	pushl  0x8(%ebp)
  801b10:	6a 0b                	push   $0xb
  801b12:	e8 e5 fe ff ff       	call   8019fc <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 0c                	push   $0xc
  801b2b:	e8 cc fe ff ff       	call   8019fc <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 0d                	push   $0xd
  801b44:	e8 b3 fe ff ff       	call   8019fc <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 0e                	push   $0xe
  801b5d:	e8 9a fe ff ff       	call   8019fc <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 0f                	push   $0xf
  801b76:	e8 81 fe ff ff       	call   8019fc <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	6a 10                	push   $0x10
  801b90:	e8 67 fe ff ff       	call   8019fc <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 11                	push   $0x11
  801ba9:	e8 4e fe ff ff       	call   8019fc <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	90                   	nop
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_cputc>:

void
sys_cputc(const char c)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 04             	sub    $0x4,%esp
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bc0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	50                   	push   %eax
  801bcd:	6a 01                	push   $0x1
  801bcf:	e8 28 fe ff ff       	call   8019fc <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	90                   	nop
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 14                	push   $0x14
  801be9:	e8 0e fe ff ff       	call   8019fc <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	90                   	nop
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c00:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c03:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c07:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0a:	6a 00                	push   $0x0
  801c0c:	51                   	push   %ecx
  801c0d:	52                   	push   %edx
  801c0e:	ff 75 0c             	pushl  0xc(%ebp)
  801c11:	50                   	push   %eax
  801c12:	6a 15                	push   $0x15
  801c14:	e8 e3 fd ff ff       	call   8019fc <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	52                   	push   %edx
  801c2e:	50                   	push   %eax
  801c2f:	6a 16                	push   $0x16
  801c31:	e8 c6 fd ff ff       	call   8019fc <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	51                   	push   %ecx
  801c4c:	52                   	push   %edx
  801c4d:	50                   	push   %eax
  801c4e:	6a 17                	push   $0x17
  801c50:	e8 a7 fd ff ff       	call   8019fc <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	52                   	push   %edx
  801c6a:	50                   	push   %eax
  801c6b:	6a 18                	push   $0x18
  801c6d:	e8 8a fd ff ff       	call   8019fc <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	6a 00                	push   $0x0
  801c7f:	ff 75 14             	pushl  0x14(%ebp)
  801c82:	ff 75 10             	pushl  0x10(%ebp)
  801c85:	ff 75 0c             	pushl  0xc(%ebp)
  801c88:	50                   	push   %eax
  801c89:	6a 19                	push   $0x19
  801c8b:	e8 6c fd ff ff       	call   8019fc <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	50                   	push   %eax
  801ca4:	6a 1a                	push   $0x1a
  801ca6:	e8 51 fd ff ff       	call   8019fc <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	90                   	nop
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	50                   	push   %eax
  801cc0:	6a 1b                	push   $0x1b
  801cc2:	e8 35 fd ff ff       	call   8019fc <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 05                	push   $0x5
  801cdb:	e8 1c fd ff ff       	call   8019fc <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 06                	push   $0x6
  801cf4:	e8 03 fd ff ff       	call   8019fc <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 07                	push   $0x7
  801d0d:	e8 ea fc ff ff       	call   8019fc <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_exit_env>:


void sys_exit_env(void)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 1c                	push   $0x1c
  801d26:	e8 d1 fc ff ff       	call   8019fc <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	90                   	nop
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d3a:	8d 50 04             	lea    0x4(%eax),%edx
  801d3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	52                   	push   %edx
  801d47:	50                   	push   %eax
  801d48:	6a 1d                	push   $0x1d
  801d4a:	e8 ad fc ff ff       	call   8019fc <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return result;
  801d52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d5b:	89 01                	mov    %eax,(%ecx)
  801d5d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	c9                   	leave  
  801d64:	c2 04 00             	ret    $0x4

00801d67 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	ff 75 10             	pushl  0x10(%ebp)
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	ff 75 08             	pushl  0x8(%ebp)
  801d77:	6a 13                	push   $0x13
  801d79:	e8 7e fc ff ff       	call   8019fc <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d81:	90                   	nop
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 1e                	push   $0x1e
  801d93:	e8 64 fc ff ff       	call   8019fc <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 04             	sub    $0x4,%esp
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801da9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	50                   	push   %eax
  801db6:	6a 1f                	push   $0x1f
  801db8:	e8 3f fc ff ff       	call   8019fc <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc0:	90                   	nop
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <rsttst>:
void rsttst()
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 21                	push   $0x21
  801dd2:	e8 25 fc ff ff       	call   8019fc <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 04             	sub    $0x4,%esp
  801de3:	8b 45 14             	mov    0x14(%ebp),%eax
  801de6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801de9:	8b 55 18             	mov    0x18(%ebp),%edx
  801dec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df0:	52                   	push   %edx
  801df1:	50                   	push   %eax
  801df2:	ff 75 10             	pushl  0x10(%ebp)
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	ff 75 08             	pushl  0x8(%ebp)
  801dfb:	6a 20                	push   $0x20
  801dfd:	e8 fa fb ff ff       	call   8019fc <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
	return ;
  801e05:	90                   	nop
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <chktst>:
void chktst(uint32 n)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	ff 75 08             	pushl  0x8(%ebp)
  801e16:	6a 22                	push   $0x22
  801e18:	e8 df fb ff ff       	call   8019fc <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e20:	90                   	nop
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <inctst>:

void inctst()
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 23                	push   $0x23
  801e32:	e8 c5 fb ff ff       	call   8019fc <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3a:	90                   	nop
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <gettst>:
uint32 gettst()
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 24                	push   $0x24
  801e4c:	e8 ab fb ff ff       	call   8019fc <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 25                	push   $0x25
  801e68:	e8 8f fb ff ff       	call   8019fc <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
  801e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e73:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e77:	75 07                	jne    801e80 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e79:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7e:	eb 05                	jmp    801e85 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  801e99:	e8 5e fb ff ff       	call   8019fc <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
  801ea1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ea4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ea8:	75 07                	jne    801eb1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801eaf:	eb 05                	jmp    801eb6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801eca:	e8 2d fb ff ff       	call   8019fc <syscall>
  801ecf:	83 c4 18             	add    $0x18,%esp
  801ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ed5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ed9:	75 07                	jne    801ee2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801edb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee0:	eb 05                	jmp    801ee7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801efb:	e8 fc fa ff ff       	call   8019fc <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
  801f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f06:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f0a:	75 07                	jne    801f13 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f11:	eb 05                	jmp    801f18 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	ff 75 08             	pushl  0x8(%ebp)
  801f28:	6a 26                	push   $0x26
  801f2a:	e8 cd fa ff ff       	call   8019fc <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f32:	90                   	nop
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	6a 00                	push   $0x0
  801f47:	53                   	push   %ebx
  801f48:	51                   	push   %ecx
  801f49:	52                   	push   %edx
  801f4a:	50                   	push   %eax
  801f4b:	6a 27                	push   $0x27
  801f4d:	e8 aa fa ff ff       	call   8019fc <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	52                   	push   %edx
  801f6a:	50                   	push   %eax
  801f6b:	6a 28                	push   $0x28
  801f6d:	e8 8a fa ff ff       	call   8019fc <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f7a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	6a 00                	push   $0x0
  801f85:	51                   	push   %ecx
  801f86:	ff 75 10             	pushl  0x10(%ebp)
  801f89:	52                   	push   %edx
  801f8a:	50                   	push   %eax
  801f8b:	6a 29                	push   $0x29
  801f8d:	e8 6a fa ff ff       	call   8019fc <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	ff 75 10             	pushl  0x10(%ebp)
  801fa1:	ff 75 0c             	pushl  0xc(%ebp)
  801fa4:	ff 75 08             	pushl  0x8(%ebp)
  801fa7:	6a 12                	push   $0x12
  801fa9:	e8 4e fa ff ff       	call   8019fc <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb1:	90                   	nop
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801fb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	52                   	push   %edx
  801fc4:	50                   	push   %eax
  801fc5:	6a 2a                	push   $0x2a
  801fc7:	e8 30 fa ff ff       	call   8019fc <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
	return;
  801fcf:	90                   	nop
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	50                   	push   %eax
  801fe1:	6a 2b                	push   $0x2b
  801fe3:	e8 14 fa ff ff       	call   8019fc <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	ff 75 0c             	pushl  0xc(%ebp)
  801ff9:	ff 75 08             	pushl  0x8(%ebp)
  801ffc:	6a 2c                	push   $0x2c
  801ffe:	e8 f9 f9 ff ff       	call   8019fc <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
	return;
  802006:	90                   	nop
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	ff 75 0c             	pushl  0xc(%ebp)
  802015:	ff 75 08             	pushl  0x8(%ebp)
  802018:	6a 2d                	push   $0x2d
  80201a:	e8 dd f9 ff ff       	call   8019fc <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
	return;
  802022:	90                   	nop
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	83 e8 04             	sub    $0x4,%eax
  802031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802034:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802037:	8b 00                	mov    (%eax),%eax
  802039:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	83 e8 04             	sub    $0x4,%eax
  80204a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80204d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802050:	8b 00                	mov    (%eax),%eax
  802052:	83 e0 01             	and    $0x1,%eax
  802055:	85 c0                	test   %eax,%eax
  802057:	0f 94 c0             	sete   %al
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802062:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206c:	83 f8 02             	cmp    $0x2,%eax
  80206f:	74 2b                	je     80209c <alloc_block+0x40>
  802071:	83 f8 02             	cmp    $0x2,%eax
  802074:	7f 07                	jg     80207d <alloc_block+0x21>
  802076:	83 f8 01             	cmp    $0x1,%eax
  802079:	74 0e                	je     802089 <alloc_block+0x2d>
  80207b:	eb 58                	jmp    8020d5 <alloc_block+0x79>
  80207d:	83 f8 03             	cmp    $0x3,%eax
  802080:	74 2d                	je     8020af <alloc_block+0x53>
  802082:	83 f8 04             	cmp    $0x4,%eax
  802085:	74 3b                	je     8020c2 <alloc_block+0x66>
  802087:	eb 4c                	jmp    8020d5 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802089:	83 ec 0c             	sub    $0xc,%esp
  80208c:	ff 75 08             	pushl  0x8(%ebp)
  80208f:	e8 11 03 00 00       	call   8023a5 <alloc_block_FF>
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80209a:	eb 4a                	jmp    8020e6 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	ff 75 08             	pushl  0x8(%ebp)
  8020a2:	e8 fa 19 00 00       	call   803aa1 <alloc_block_NF>
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020ad:	eb 37                	jmp    8020e6 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020af:	83 ec 0c             	sub    $0xc,%esp
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	e8 a7 07 00 00       	call   802861 <alloc_block_BF>
  8020ba:	83 c4 10             	add    $0x10,%esp
  8020bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020c0:	eb 24                	jmp    8020e6 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020c2:	83 ec 0c             	sub    $0xc,%esp
  8020c5:	ff 75 08             	pushl  0x8(%ebp)
  8020c8:	e8 b7 19 00 00       	call   803a84 <alloc_block_WF>
  8020cd:	83 c4 10             	add    $0x10,%esp
  8020d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020d3:	eb 11                	jmp    8020e6 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	68 b8 44 80 00       	push   $0x8044b8
  8020dd:	e8 5e e6 ff ff       	call   800740 <cprintf>
  8020e2:	83 c4 10             	add    $0x10,%esp
		break;
  8020e5:	90                   	nop
	}
	return va;
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	53                   	push   %ebx
  8020ef:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8020f2:	83 ec 0c             	sub    $0xc,%esp
  8020f5:	68 d8 44 80 00       	push   $0x8044d8
  8020fa:	e8 41 e6 ff ff       	call   800740 <cprintf>
  8020ff:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802102:	83 ec 0c             	sub    $0xc,%esp
  802105:	68 03 45 80 00       	push   $0x804503
  80210a:	e8 31 e6 ff ff       	call   800740 <cprintf>
  80210f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802118:	eb 37                	jmp    802151 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80211a:	83 ec 0c             	sub    $0xc,%esp
  80211d:	ff 75 f4             	pushl  -0xc(%ebp)
  802120:	e8 19 ff ff ff       	call   80203e <is_free_block>
  802125:	83 c4 10             	add    $0x10,%esp
  802128:	0f be d8             	movsbl %al,%ebx
  80212b:	83 ec 0c             	sub    $0xc,%esp
  80212e:	ff 75 f4             	pushl  -0xc(%ebp)
  802131:	e8 ef fe ff ff       	call   802025 <get_block_size>
  802136:	83 c4 10             	add    $0x10,%esp
  802139:	83 ec 04             	sub    $0x4,%esp
  80213c:	53                   	push   %ebx
  80213d:	50                   	push   %eax
  80213e:	68 1b 45 80 00       	push   $0x80451b
  802143:	e8 f8 e5 ff ff       	call   800740 <cprintf>
  802148:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80214b:	8b 45 10             	mov    0x10(%ebp),%eax
  80214e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802151:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802155:	74 07                	je     80215e <print_blocks_list+0x73>
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 00                	mov    (%eax),%eax
  80215c:	eb 05                	jmp    802163 <print_blocks_list+0x78>
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
  802163:	89 45 10             	mov    %eax,0x10(%ebp)
  802166:	8b 45 10             	mov    0x10(%ebp),%eax
  802169:	85 c0                	test   %eax,%eax
  80216b:	75 ad                	jne    80211a <print_blocks_list+0x2f>
  80216d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802171:	75 a7                	jne    80211a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802173:	83 ec 0c             	sub    $0xc,%esp
  802176:	68 d8 44 80 00       	push   $0x8044d8
  80217b:	e8 c0 e5 ff ff       	call   800740 <cprintf>
  802180:	83 c4 10             	add    $0x10,%esp

}
  802183:	90                   	nop
  802184:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80218f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802192:	83 e0 01             	and    $0x1,%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	74 03                	je     80219c <initialize_dynamic_allocator+0x13>
  802199:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80219c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021a0:	0f 84 c7 01 00 00    	je     80236d <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021a6:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8021ad:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8021b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b6:	01 d0                	add    %edx,%eax
  8021b8:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8021bd:	0f 87 ad 01 00 00    	ja     802370 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	0f 89 a5 01 00 00    	jns    802373 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8021ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d4:	01 d0                	add    %edx,%eax
  8021d6:	83 e8 04             	sub    $0x4,%eax
  8021d9:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8021de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8021e5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ed:	e9 87 00 00 00       	jmp    802279 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8021f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f6:	75 14                	jne    80220c <initialize_dynamic_allocator+0x83>
  8021f8:	83 ec 04             	sub    $0x4,%esp
  8021fb:	68 33 45 80 00       	push   $0x804533
  802200:	6a 79                	push   $0x79
  802202:	68 51 45 80 00       	push   $0x804551
  802207:	e8 b2 18 00 00       	call   803abe <_panic>
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	8b 00                	mov    (%eax),%eax
  802211:	85 c0                	test   %eax,%eax
  802213:	74 10                	je     802225 <initialize_dynamic_allocator+0x9c>
  802215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802218:	8b 00                	mov    (%eax),%eax
  80221a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221d:	8b 52 04             	mov    0x4(%edx),%edx
  802220:	89 50 04             	mov    %edx,0x4(%eax)
  802223:	eb 0b                	jmp    802230 <initialize_dynamic_allocator+0xa7>
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	8b 40 04             	mov    0x4(%eax),%eax
  80222b:	a3 30 50 80 00       	mov    %eax,0x805030
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	8b 40 04             	mov    0x4(%eax),%eax
  802236:	85 c0                	test   %eax,%eax
  802238:	74 0f                	je     802249 <initialize_dynamic_allocator+0xc0>
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	8b 40 04             	mov    0x4(%eax),%eax
  802240:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802243:	8b 12                	mov    (%edx),%edx
  802245:	89 10                	mov    %edx,(%eax)
  802247:	eb 0a                	jmp    802253 <initialize_dynamic_allocator+0xca>
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	8b 00                	mov    (%eax),%eax
  80224e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802266:	a1 38 50 80 00       	mov    0x805038,%eax
  80226b:	48                   	dec    %eax
  80226c:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802271:	a1 34 50 80 00       	mov    0x805034,%eax
  802276:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227d:	74 07                	je     802286 <initialize_dynamic_allocator+0xfd>
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	8b 00                	mov    (%eax),%eax
  802284:	eb 05                	jmp    80228b <initialize_dynamic_allocator+0x102>
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
  80228b:	a3 34 50 80 00       	mov    %eax,0x805034
  802290:	a1 34 50 80 00       	mov    0x805034,%eax
  802295:	85 c0                	test   %eax,%eax
  802297:	0f 85 55 ff ff ff    	jne    8021f2 <initialize_dynamic_allocator+0x69>
  80229d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a1:	0f 85 4b ff ff ff    	jne    8021f2 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8022ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8022b6:	a1 44 50 80 00       	mov    0x805044,%eax
  8022bb:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8022c0:	a1 40 50 80 00       	mov    0x805040,%eax
  8022c5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	83 c0 08             	add    $0x8,%eax
  8022d1:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	83 c0 04             	add    $0x4,%eax
  8022da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022dd:	83 ea 08             	sub    $0x8,%edx
  8022e0:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	01 d0                	add    %edx,%eax
  8022ea:	83 e8 08             	sub    $0x8,%eax
  8022ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f0:	83 ea 08             	sub    $0x8,%edx
  8022f3:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8022f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8022fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802301:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802308:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80230c:	75 17                	jne    802325 <initialize_dynamic_allocator+0x19c>
  80230e:	83 ec 04             	sub    $0x4,%esp
  802311:	68 6c 45 80 00       	push   $0x80456c
  802316:	68 90 00 00 00       	push   $0x90
  80231b:	68 51 45 80 00       	push   $0x804551
  802320:	e8 99 17 00 00       	call   803abe <_panic>
  802325:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80232b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232e:	89 10                	mov    %edx,(%eax)
  802330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802333:	8b 00                	mov    (%eax),%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	74 0d                	je     802346 <initialize_dynamic_allocator+0x1bd>
  802339:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80233e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802341:	89 50 04             	mov    %edx,0x4(%eax)
  802344:	eb 08                	jmp    80234e <initialize_dynamic_allocator+0x1c5>
  802346:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802349:	a3 30 50 80 00       	mov    %eax,0x805030
  80234e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802351:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802356:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802359:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802360:	a1 38 50 80 00       	mov    0x805038,%eax
  802365:	40                   	inc    %eax
  802366:	a3 38 50 80 00       	mov    %eax,0x805038
  80236b:	eb 07                	jmp    802374 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80236d:	90                   	nop
  80236e:	eb 04                	jmp    802374 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802370:	90                   	nop
  802371:	eb 01                	jmp    802374 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802373:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802379:	8b 45 10             	mov    0x10(%ebp),%eax
  80237c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	8d 50 fc             	lea    -0x4(%eax),%edx
  802385:	8b 45 0c             	mov    0xc(%ebp),%eax
  802388:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	83 e8 04             	sub    $0x4,%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	83 e0 fe             	and    $0xfffffffe,%eax
  802395:	8d 50 f8             	lea    -0x8(%eax),%edx
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	01 c2                	add    %eax,%edx
  80239d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a0:	89 02                	mov    %eax,(%edx)
}
  8023a2:	90                   	nop
  8023a3:	5d                   	pop    %ebp
  8023a4:	c3                   	ret    

008023a5 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	83 e0 01             	and    $0x1,%eax
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	74 03                	je     8023b8 <alloc_block_FF+0x13>
  8023b5:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8023b8:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8023bc:	77 07                	ja     8023c5 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8023be:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8023c5:	a1 24 50 80 00       	mov    0x805024,%eax
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	75 73                	jne    802441 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	83 c0 10             	add    $0x10,%eax
  8023d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8023d7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e4:	01 d0                	add    %edx,%eax
  8023e6:	48                   	dec    %eax
  8023e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f2:	f7 75 ec             	divl   -0x14(%ebp)
  8023f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023f8:	29 d0                	sub    %edx,%eax
  8023fa:	c1 e8 0c             	shr    $0xc,%eax
  8023fd:	83 ec 0c             	sub    $0xc,%esp
  802400:	50                   	push   %eax
  802401:	e8 d4 f0 ff ff       	call   8014da <sbrk>
  802406:	83 c4 10             	add    $0x10,%esp
  802409:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80240c:	83 ec 0c             	sub    $0xc,%esp
  80240f:	6a 00                	push   $0x0
  802411:	e8 c4 f0 ff ff       	call   8014da <sbrk>
  802416:	83 c4 10             	add    $0x10,%esp
  802419:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80241c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802422:	83 ec 08             	sub    $0x8,%esp
  802425:	50                   	push   %eax
  802426:	ff 75 e4             	pushl  -0x1c(%ebp)
  802429:	e8 5b fd ff ff       	call   802189 <initialize_dynamic_allocator>
  80242e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802431:	83 ec 0c             	sub    $0xc,%esp
  802434:	68 8f 45 80 00       	push   $0x80458f
  802439:	e8 02 e3 ff ff       	call   800740 <cprintf>
  80243e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802441:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802445:	75 0a                	jne    802451 <alloc_block_FF+0xac>
	        return NULL;
  802447:	b8 00 00 00 00       	mov    $0x0,%eax
  80244c:	e9 0e 04 00 00       	jmp    80285f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802458:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80245d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802460:	e9 f3 02 00 00       	jmp    802758 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80246b:	83 ec 0c             	sub    $0xc,%esp
  80246e:	ff 75 bc             	pushl  -0x44(%ebp)
  802471:	e8 af fb ff ff       	call   802025 <get_block_size>
  802476:	83 c4 10             	add    $0x10,%esp
  802479:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	83 c0 08             	add    $0x8,%eax
  802482:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802485:	0f 87 c5 02 00 00    	ja     802750 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	83 c0 18             	add    $0x18,%eax
  802491:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802494:	0f 87 19 02 00 00    	ja     8026b3 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80249a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80249d:	2b 45 08             	sub    0x8(%ebp),%eax
  8024a0:	83 e8 08             	sub    $0x8,%eax
  8024a3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	8d 50 08             	lea    0x8(%eax),%edx
  8024ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024af:	01 d0                	add    %edx,%eax
  8024b1:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	83 c0 08             	add    $0x8,%eax
  8024ba:	83 ec 04             	sub    $0x4,%esp
  8024bd:	6a 01                	push   $0x1
  8024bf:	50                   	push   %eax
  8024c0:	ff 75 bc             	pushl  -0x44(%ebp)
  8024c3:	e8 ae fe ff ff       	call   802376 <set_block_data>
  8024c8:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 04             	mov    0x4(%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	75 68                	jne    80253d <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024d5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024d9:	75 17                	jne    8024f2 <alloc_block_FF+0x14d>
  8024db:	83 ec 04             	sub    $0x4,%esp
  8024de:	68 6c 45 80 00       	push   $0x80456c
  8024e3:	68 d7 00 00 00       	push   $0xd7
  8024e8:	68 51 45 80 00       	push   $0x804551
  8024ed:	e8 cc 15 00 00       	call   803abe <_panic>
  8024f2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8024f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fb:	89 10                	mov    %edx,(%eax)
  8024fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	85 c0                	test   %eax,%eax
  802504:	74 0d                	je     802513 <alloc_block_FF+0x16e>
  802506:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80250b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80250e:	89 50 04             	mov    %edx,0x4(%eax)
  802511:	eb 08                	jmp    80251b <alloc_block_FF+0x176>
  802513:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802516:	a3 30 50 80 00       	mov    %eax,0x805030
  80251b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802523:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802526:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252d:	a1 38 50 80 00       	mov    0x805038,%eax
  802532:	40                   	inc    %eax
  802533:	a3 38 50 80 00       	mov    %eax,0x805038
  802538:	e9 dc 00 00 00       	jmp    802619 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	75 65                	jne    8025ab <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802546:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80254a:	75 17                	jne    802563 <alloc_block_FF+0x1be>
  80254c:	83 ec 04             	sub    $0x4,%esp
  80254f:	68 a0 45 80 00       	push   $0x8045a0
  802554:	68 db 00 00 00       	push   $0xdb
  802559:	68 51 45 80 00       	push   $0x804551
  80255e:	e8 5b 15 00 00       	call   803abe <_panic>
  802563:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802569:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256c:	89 50 04             	mov    %edx,0x4(%eax)
  80256f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802572:	8b 40 04             	mov    0x4(%eax),%eax
  802575:	85 c0                	test   %eax,%eax
  802577:	74 0c                	je     802585 <alloc_block_FF+0x1e0>
  802579:	a1 30 50 80 00       	mov    0x805030,%eax
  80257e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802581:	89 10                	mov    %edx,(%eax)
  802583:	eb 08                	jmp    80258d <alloc_block_FF+0x1e8>
  802585:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802588:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80258d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802590:	a3 30 50 80 00       	mov    %eax,0x805030
  802595:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802598:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259e:	a1 38 50 80 00       	mov    0x805038,%eax
  8025a3:	40                   	inc    %eax
  8025a4:	a3 38 50 80 00       	mov    %eax,0x805038
  8025a9:	eb 6e                	jmp    802619 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8025ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025af:	74 06                	je     8025b7 <alloc_block_FF+0x212>
  8025b1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025b5:	75 17                	jne    8025ce <alloc_block_FF+0x229>
  8025b7:	83 ec 04             	sub    $0x4,%esp
  8025ba:	68 c4 45 80 00       	push   $0x8045c4
  8025bf:	68 df 00 00 00       	push   $0xdf
  8025c4:	68 51 45 80 00       	push   $0x804551
  8025c9:	e8 f0 14 00 00       	call   803abe <_panic>
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 10                	mov    (%eax),%edx
  8025d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d6:	89 10                	mov    %edx,(%eax)
  8025d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025db:	8b 00                	mov    (%eax),%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 0b                	je     8025ec <alloc_block_FF+0x247>
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025e9:	89 50 04             	mov    %edx,0x4(%eax)
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025f2:	89 10                	mov    %edx,(%eax)
  8025f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fa:	89 50 04             	mov    %edx,0x4(%eax)
  8025fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802600:	8b 00                	mov    (%eax),%eax
  802602:	85 c0                	test   %eax,%eax
  802604:	75 08                	jne    80260e <alloc_block_FF+0x269>
  802606:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802609:	a3 30 50 80 00       	mov    %eax,0x805030
  80260e:	a1 38 50 80 00       	mov    0x805038,%eax
  802613:	40                   	inc    %eax
  802614:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261d:	75 17                	jne    802636 <alloc_block_FF+0x291>
  80261f:	83 ec 04             	sub    $0x4,%esp
  802622:	68 33 45 80 00       	push   $0x804533
  802627:	68 e1 00 00 00       	push   $0xe1
  80262c:	68 51 45 80 00       	push   $0x804551
  802631:	e8 88 14 00 00       	call   803abe <_panic>
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	8b 00                	mov    (%eax),%eax
  80263b:	85 c0                	test   %eax,%eax
  80263d:	74 10                	je     80264f <alloc_block_FF+0x2aa>
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 00                	mov    (%eax),%eax
  802644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802647:	8b 52 04             	mov    0x4(%edx),%edx
  80264a:	89 50 04             	mov    %edx,0x4(%eax)
  80264d:	eb 0b                	jmp    80265a <alloc_block_FF+0x2b5>
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 40 04             	mov    0x4(%eax),%eax
  802655:	a3 30 50 80 00       	mov    %eax,0x805030
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 04             	mov    0x4(%eax),%eax
  802660:	85 c0                	test   %eax,%eax
  802662:	74 0f                	je     802673 <alloc_block_FF+0x2ce>
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 40 04             	mov    0x4(%eax),%eax
  80266a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266d:	8b 12                	mov    (%edx),%edx
  80266f:	89 10                	mov    %edx,(%eax)
  802671:	eb 0a                	jmp    80267d <alloc_block_FF+0x2d8>
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 00                	mov    (%eax),%eax
  802678:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802690:	a1 38 50 80 00       	mov    0x805038,%eax
  802695:	48                   	dec    %eax
  802696:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80269b:	83 ec 04             	sub    $0x4,%esp
  80269e:	6a 00                	push   $0x0
  8026a0:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026a3:	ff 75 b0             	pushl  -0x50(%ebp)
  8026a6:	e8 cb fc ff ff       	call   802376 <set_block_data>
  8026ab:	83 c4 10             	add    $0x10,%esp
  8026ae:	e9 95 00 00 00       	jmp    802748 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8026b3:	83 ec 04             	sub    $0x4,%esp
  8026b6:	6a 01                	push   $0x1
  8026b8:	ff 75 b8             	pushl  -0x48(%ebp)
  8026bb:	ff 75 bc             	pushl  -0x44(%ebp)
  8026be:	e8 b3 fc ff ff       	call   802376 <set_block_data>
  8026c3:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8026c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ca:	75 17                	jne    8026e3 <alloc_block_FF+0x33e>
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 33 45 80 00       	push   $0x804533
  8026d4:	68 e8 00 00 00       	push   $0xe8
  8026d9:	68 51 45 80 00       	push   $0x804551
  8026de:	e8 db 13 00 00       	call   803abe <_panic>
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	74 10                	je     8026fc <alloc_block_FF+0x357>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f4:	8b 52 04             	mov    0x4(%edx),%edx
  8026f7:	89 50 04             	mov    %edx,0x4(%eax)
  8026fa:	eb 0b                	jmp    802707 <alloc_block_FF+0x362>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 04             	mov    0x4(%eax),%eax
  802702:	a3 30 50 80 00       	mov    %eax,0x805030
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 40 04             	mov    0x4(%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	74 0f                	je     802720 <alloc_block_FF+0x37b>
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271a:	8b 12                	mov    (%edx),%edx
  80271c:	89 10                	mov    %edx,(%eax)
  80271e:	eb 0a                	jmp    80272a <alloc_block_FF+0x385>
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273d:	a1 38 50 80 00       	mov    0x805038,%eax
  802742:	48                   	dec    %eax
  802743:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802748:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80274b:	e9 0f 01 00 00       	jmp    80285f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802750:	a1 34 50 80 00       	mov    0x805034,%eax
  802755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275c:	74 07                	je     802765 <alloc_block_FF+0x3c0>
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	eb 05                	jmp    80276a <alloc_block_FF+0x3c5>
  802765:	b8 00 00 00 00       	mov    $0x0,%eax
  80276a:	a3 34 50 80 00       	mov    %eax,0x805034
  80276f:	a1 34 50 80 00       	mov    0x805034,%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	0f 85 e9 fc ff ff    	jne    802465 <alloc_block_FF+0xc0>
  80277c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802780:	0f 85 df fc ff ff    	jne    802465 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802786:	8b 45 08             	mov    0x8(%ebp),%eax
  802789:	83 c0 08             	add    $0x8,%eax
  80278c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80278f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802796:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802799:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80279c:	01 d0                	add    %edx,%eax
  80279e:	48                   	dec    %eax
  80279f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027aa:	f7 75 d8             	divl   -0x28(%ebp)
  8027ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027b0:	29 d0                	sub    %edx,%eax
  8027b2:	c1 e8 0c             	shr    $0xc,%eax
  8027b5:	83 ec 0c             	sub    $0xc,%esp
  8027b8:	50                   	push   %eax
  8027b9:	e8 1c ed ff ff       	call   8014da <sbrk>
  8027be:	83 c4 10             	add    $0x10,%esp
  8027c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8027c4:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027c8:	75 0a                	jne    8027d4 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8027ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cf:	e9 8b 00 00 00       	jmp    80285f <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8027d4:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8027db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e1:	01 d0                	add    %edx,%eax
  8027e3:	48                   	dec    %eax
  8027e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8027e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ef:	f7 75 cc             	divl   -0x34(%ebp)
  8027f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027f5:	29 d0                	sub    %edx,%eax
  8027f7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027fd:	01 d0                	add    %edx,%eax
  8027ff:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802804:	a1 40 50 80 00       	mov    0x805040,%eax
  802809:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80280f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802816:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802819:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80281c:	01 d0                	add    %edx,%eax
  80281e:	48                   	dec    %eax
  80281f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802822:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802825:	ba 00 00 00 00       	mov    $0x0,%edx
  80282a:	f7 75 c4             	divl   -0x3c(%ebp)
  80282d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802830:	29 d0                	sub    %edx,%eax
  802832:	83 ec 04             	sub    $0x4,%esp
  802835:	6a 01                	push   $0x1
  802837:	50                   	push   %eax
  802838:	ff 75 d0             	pushl  -0x30(%ebp)
  80283b:	e8 36 fb ff ff       	call   802376 <set_block_data>
  802840:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802843:	83 ec 0c             	sub    $0xc,%esp
  802846:	ff 75 d0             	pushl  -0x30(%ebp)
  802849:	e8 1b 0a 00 00       	call   803269 <free_block>
  80284e:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802851:	83 ec 0c             	sub    $0xc,%esp
  802854:	ff 75 08             	pushl  0x8(%ebp)
  802857:	e8 49 fb ff ff       	call   8023a5 <alloc_block_FF>
  80285c:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80285f:	c9                   	leave  
  802860:	c3                   	ret    

00802861 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802861:	55                   	push   %ebp
  802862:	89 e5                	mov    %esp,%ebp
  802864:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	83 e0 01             	and    $0x1,%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	74 03                	je     802874 <alloc_block_BF+0x13>
  802871:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802874:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802878:	77 07                	ja     802881 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80287a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802881:	a1 24 50 80 00       	mov    0x805024,%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	75 73                	jne    8028fd <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80288a:	8b 45 08             	mov    0x8(%ebp),%eax
  80288d:	83 c0 10             	add    $0x10,%eax
  802890:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802893:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80289a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80289d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a0:	01 d0                	add    %edx,%eax
  8028a2:	48                   	dec    %eax
  8028a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ae:	f7 75 e0             	divl   -0x20(%ebp)
  8028b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028b4:	29 d0                	sub    %edx,%eax
  8028b6:	c1 e8 0c             	shr    $0xc,%eax
  8028b9:	83 ec 0c             	sub    $0xc,%esp
  8028bc:	50                   	push   %eax
  8028bd:	e8 18 ec ff ff       	call   8014da <sbrk>
  8028c2:	83 c4 10             	add    $0x10,%esp
  8028c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028c8:	83 ec 0c             	sub    $0xc,%esp
  8028cb:	6a 00                	push   $0x0
  8028cd:	e8 08 ec ff ff       	call   8014da <sbrk>
  8028d2:	83 c4 10             	add    $0x10,%esp
  8028d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028db:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8028de:	83 ec 08             	sub    $0x8,%esp
  8028e1:	50                   	push   %eax
  8028e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8028e5:	e8 9f f8 ff ff       	call   802189 <initialize_dynamic_allocator>
  8028ea:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028ed:	83 ec 0c             	sub    $0xc,%esp
  8028f0:	68 8f 45 80 00       	push   $0x80458f
  8028f5:	e8 46 de ff ff       	call   800740 <cprintf>
  8028fa:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8028fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802904:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80290b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802912:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802919:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80291e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802921:	e9 1d 01 00 00       	jmp    802a43 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80292c:	83 ec 0c             	sub    $0xc,%esp
  80292f:	ff 75 a8             	pushl  -0x58(%ebp)
  802932:	e8 ee f6 ff ff       	call   802025 <get_block_size>
  802937:	83 c4 10             	add    $0x10,%esp
  80293a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	83 c0 08             	add    $0x8,%eax
  802943:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802946:	0f 87 ef 00 00 00    	ja     802a3b <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	83 c0 18             	add    $0x18,%eax
  802952:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802955:	77 1d                	ja     802974 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80295d:	0f 86 d8 00 00 00    	jbe    802a3b <alloc_block_BF+0x1da>
				{
					best_va = va;
  802963:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802966:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802969:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80296c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80296f:	e9 c7 00 00 00       	jmp    802a3b <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	83 c0 08             	add    $0x8,%eax
  80297a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80297d:	0f 85 9d 00 00 00    	jne    802a20 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802983:	83 ec 04             	sub    $0x4,%esp
  802986:	6a 01                	push   $0x1
  802988:	ff 75 a4             	pushl  -0x5c(%ebp)
  80298b:	ff 75 a8             	pushl  -0x58(%ebp)
  80298e:	e8 e3 f9 ff ff       	call   802376 <set_block_data>
  802993:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802996:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299a:	75 17                	jne    8029b3 <alloc_block_BF+0x152>
  80299c:	83 ec 04             	sub    $0x4,%esp
  80299f:	68 33 45 80 00       	push   $0x804533
  8029a4:	68 2c 01 00 00       	push   $0x12c
  8029a9:	68 51 45 80 00       	push   $0x804551
  8029ae:	e8 0b 11 00 00       	call   803abe <_panic>
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	74 10                	je     8029cc <alloc_block_BF+0x16b>
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c4:	8b 52 04             	mov    0x4(%edx),%edx
  8029c7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ca:	eb 0b                	jmp    8029d7 <alloc_block_BF+0x176>
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 40 04             	mov    0x4(%eax),%eax
  8029d2:	a3 30 50 80 00       	mov    %eax,0x805030
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 40 04             	mov    0x4(%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	74 0f                	je     8029f0 <alloc_block_BF+0x18f>
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 04             	mov    0x4(%eax),%eax
  8029e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ea:	8b 12                	mov    (%edx),%edx
  8029ec:	89 10                	mov    %edx,(%eax)
  8029ee:	eb 0a                	jmp    8029fa <alloc_block_BF+0x199>
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 00                	mov    (%eax),%eax
  8029f5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0d:	a1 38 50 80 00       	mov    0x805038,%eax
  802a12:	48                   	dec    %eax
  802a13:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a18:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a1b:	e9 24 04 00 00       	jmp    802e44 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a23:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a26:	76 13                	jbe    802a3b <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a28:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a2f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a35:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a38:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a3b:	a1 34 50 80 00       	mov    0x805034,%eax
  802a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a47:	74 07                	je     802a50 <alloc_block_BF+0x1ef>
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	eb 05                	jmp    802a55 <alloc_block_BF+0x1f4>
  802a50:	b8 00 00 00 00       	mov    $0x0,%eax
  802a55:	a3 34 50 80 00       	mov    %eax,0x805034
  802a5a:	a1 34 50 80 00       	mov    0x805034,%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	0f 85 bf fe ff ff    	jne    802926 <alloc_block_BF+0xc5>
  802a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6b:	0f 85 b5 fe ff ff    	jne    802926 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a75:	0f 84 26 02 00 00    	je     802ca1 <alloc_block_BF+0x440>
  802a7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a7f:	0f 85 1c 02 00 00    	jne    802ca1 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a88:	2b 45 08             	sub    0x8(%ebp),%eax
  802a8b:	83 e8 08             	sub    $0x8,%eax
  802a8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	8d 50 08             	lea    0x8(%eax),%edx
  802a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9a:	01 d0                	add    %edx,%eax
  802a9c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	83 c0 08             	add    $0x8,%eax
  802aa5:	83 ec 04             	sub    $0x4,%esp
  802aa8:	6a 01                	push   $0x1
  802aaa:	50                   	push   %eax
  802aab:	ff 75 f0             	pushl  -0x10(%ebp)
  802aae:	e8 c3 f8 ff ff       	call   802376 <set_block_data>
  802ab3:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab9:	8b 40 04             	mov    0x4(%eax),%eax
  802abc:	85 c0                	test   %eax,%eax
  802abe:	75 68                	jne    802b28 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ac0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ac4:	75 17                	jne    802add <alloc_block_BF+0x27c>
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	68 6c 45 80 00       	push   $0x80456c
  802ace:	68 45 01 00 00       	push   $0x145
  802ad3:	68 51 45 80 00       	push   $0x804551
  802ad8:	e8 e1 0f 00 00       	call   803abe <_panic>
  802add:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ae3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae6:	89 10                	mov    %edx,(%eax)
  802ae8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 0d                	je     802afe <alloc_block_BF+0x29d>
  802af1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802af6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af9:	89 50 04             	mov    %edx,0x4(%eax)
  802afc:	eb 08                	jmp    802b06 <alloc_block_BF+0x2a5>
  802afe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b01:	a3 30 50 80 00       	mov    %eax,0x805030
  802b06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b09:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b18:	a1 38 50 80 00       	mov    0x805038,%eax
  802b1d:	40                   	inc    %eax
  802b1e:	a3 38 50 80 00       	mov    %eax,0x805038
  802b23:	e9 dc 00 00 00       	jmp    802c04 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	75 65                	jne    802b96 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b31:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b35:	75 17                	jne    802b4e <alloc_block_BF+0x2ed>
  802b37:	83 ec 04             	sub    $0x4,%esp
  802b3a:	68 a0 45 80 00       	push   $0x8045a0
  802b3f:	68 4a 01 00 00       	push   $0x14a
  802b44:	68 51 45 80 00       	push   $0x804551
  802b49:	e8 70 0f 00 00       	call   803abe <_panic>
  802b4e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b57:	89 50 04             	mov    %edx,0x4(%eax)
  802b5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b5d:	8b 40 04             	mov    0x4(%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	74 0c                	je     802b70 <alloc_block_BF+0x30f>
  802b64:	a1 30 50 80 00       	mov    0x805030,%eax
  802b69:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b6c:	89 10                	mov    %edx,(%eax)
  802b6e:	eb 08                	jmp    802b78 <alloc_block_BF+0x317>
  802b70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b73:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b7b:	a3 30 50 80 00       	mov    %eax,0x805030
  802b80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b89:	a1 38 50 80 00       	mov    0x805038,%eax
  802b8e:	40                   	inc    %eax
  802b8f:	a3 38 50 80 00       	mov    %eax,0x805038
  802b94:	eb 6e                	jmp    802c04 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b9a:	74 06                	je     802ba2 <alloc_block_BF+0x341>
  802b9c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ba0:	75 17                	jne    802bb9 <alloc_block_BF+0x358>
  802ba2:	83 ec 04             	sub    $0x4,%esp
  802ba5:	68 c4 45 80 00       	push   $0x8045c4
  802baa:	68 4f 01 00 00       	push   $0x14f
  802baf:	68 51 45 80 00       	push   $0x804551
  802bb4:	e8 05 0f 00 00       	call   803abe <_panic>
  802bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbc:	8b 10                	mov    (%eax),%edx
  802bbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc1:	89 10                	mov    %edx,(%eax)
  802bc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc6:	8b 00                	mov    (%eax),%eax
  802bc8:	85 c0                	test   %eax,%eax
  802bca:	74 0b                	je     802bd7 <alloc_block_BF+0x376>
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bd4:	89 50 04             	mov    %edx,0x4(%eax)
  802bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bda:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bdd:	89 10                	mov    %edx,(%eax)
  802bdf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be5:	89 50 04             	mov    %edx,0x4(%eax)
  802be8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	85 c0                	test   %eax,%eax
  802bef:	75 08                	jne    802bf9 <alloc_block_BF+0x398>
  802bf1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf4:	a3 30 50 80 00       	mov    %eax,0x805030
  802bf9:	a1 38 50 80 00       	mov    0x805038,%eax
  802bfe:	40                   	inc    %eax
  802bff:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c08:	75 17                	jne    802c21 <alloc_block_BF+0x3c0>
  802c0a:	83 ec 04             	sub    $0x4,%esp
  802c0d:	68 33 45 80 00       	push   $0x804533
  802c12:	68 51 01 00 00       	push   $0x151
  802c17:	68 51 45 80 00       	push   $0x804551
  802c1c:	e8 9d 0e 00 00       	call   803abe <_panic>
  802c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	74 10                	je     802c3a <alloc_block_BF+0x3d9>
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c32:	8b 52 04             	mov    0x4(%edx),%edx
  802c35:	89 50 04             	mov    %edx,0x4(%eax)
  802c38:	eb 0b                	jmp    802c45 <alloc_block_BF+0x3e4>
  802c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3d:	8b 40 04             	mov    0x4(%eax),%eax
  802c40:	a3 30 50 80 00       	mov    %eax,0x805030
  802c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	74 0f                	je     802c5e <alloc_block_BF+0x3fd>
  802c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c58:	8b 12                	mov    (%edx),%edx
  802c5a:	89 10                	mov    %edx,(%eax)
  802c5c:	eb 0a                	jmp    802c68 <alloc_block_BF+0x407>
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
			set_block_data(new_block_va, remaining_size, 0);
  802c86:	83 ec 04             	sub    $0x4,%esp
  802c89:	6a 00                	push   $0x0
  802c8b:	ff 75 d0             	pushl  -0x30(%ebp)
  802c8e:	ff 75 cc             	pushl  -0x34(%ebp)
  802c91:	e8 e0 f6 ff ff       	call   802376 <set_block_data>
  802c96:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	e9 a3 01 00 00       	jmp    802e44 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802ca1:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ca5:	0f 85 9d 00 00 00    	jne    802d48 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802cab:	83 ec 04             	sub    $0x4,%esp
  802cae:	6a 01                	push   $0x1
  802cb0:	ff 75 ec             	pushl  -0x14(%ebp)
  802cb3:	ff 75 f0             	pushl  -0x10(%ebp)
  802cb6:	e8 bb f6 ff ff       	call   802376 <set_block_data>
  802cbb:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802cbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc2:	75 17                	jne    802cdb <alloc_block_BF+0x47a>
  802cc4:	83 ec 04             	sub    $0x4,%esp
  802cc7:	68 33 45 80 00       	push   $0x804533
  802ccc:	68 58 01 00 00       	push   $0x158
  802cd1:	68 51 45 80 00       	push   $0x804551
  802cd6:	e8 e3 0d 00 00       	call   803abe <_panic>
  802cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 10                	je     802cf4 <alloc_block_BF+0x493>
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cec:	8b 52 04             	mov    0x4(%edx),%edx
  802cef:	89 50 04             	mov    %edx,0x4(%eax)
  802cf2:	eb 0b                	jmp    802cff <alloc_block_BF+0x49e>
  802cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf7:	8b 40 04             	mov    0x4(%eax),%eax
  802cfa:	a3 30 50 80 00       	mov    %eax,0x805030
  802cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d02:	8b 40 04             	mov    0x4(%eax),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 0f                	je     802d18 <alloc_block_BF+0x4b7>
  802d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d12:	8b 12                	mov    (%edx),%edx
  802d14:	89 10                	mov    %edx,(%eax)
  802d16:	eb 0a                	jmp    802d22 <alloc_block_BF+0x4c1>
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	8b 00                	mov    (%eax),%eax
  802d1d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d35:	a1 38 50 80 00       	mov    0x805038,%eax
  802d3a:	48                   	dec    %eax
  802d3b:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d43:	e9 fc 00 00 00       	jmp    802e44 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	83 c0 08             	add    $0x8,%eax
  802d4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d51:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d58:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d5b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d5e:	01 d0                	add    %edx,%eax
  802d60:	48                   	dec    %eax
  802d61:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d64:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d67:	ba 00 00 00 00       	mov    $0x0,%edx
  802d6c:	f7 75 c4             	divl   -0x3c(%ebp)
  802d6f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d72:	29 d0                	sub    %edx,%eax
  802d74:	c1 e8 0c             	shr    $0xc,%eax
  802d77:	83 ec 0c             	sub    $0xc,%esp
  802d7a:	50                   	push   %eax
  802d7b:	e8 5a e7 ff ff       	call   8014da <sbrk>
  802d80:	83 c4 10             	add    $0x10,%esp
  802d83:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d86:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d8a:	75 0a                	jne    802d96 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d91:	e9 ae 00 00 00       	jmp    802e44 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d96:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d9d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802da0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802da3:	01 d0                	add    %edx,%eax
  802da5:	48                   	dec    %eax
  802da6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802da9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dac:	ba 00 00 00 00       	mov    $0x0,%edx
  802db1:	f7 75 b8             	divl   -0x48(%ebp)
  802db4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802db7:	29 d0                	sub    %edx,%eax
  802db9:	8d 50 fc             	lea    -0x4(%eax),%edx
  802dbc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dbf:	01 d0                	add    %edx,%eax
  802dc1:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802dc6:	a1 40 50 80 00       	mov    0x805040,%eax
  802dcb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802dd1:	83 ec 0c             	sub    $0xc,%esp
  802dd4:	68 f8 45 80 00       	push   $0x8045f8
  802dd9:	e8 62 d9 ff ff       	call   800740 <cprintf>
  802dde:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802de1:	83 ec 08             	sub    $0x8,%esp
  802de4:	ff 75 bc             	pushl  -0x44(%ebp)
  802de7:	68 fd 45 80 00       	push   $0x8045fd
  802dec:	e8 4f d9 ff ff       	call   800740 <cprintf>
  802df1:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802df4:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802dfb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dfe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e01:	01 d0                	add    %edx,%eax
  802e03:	48                   	dec    %eax
  802e04:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e07:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  802e0f:	f7 75 b0             	divl   -0x50(%ebp)
  802e12:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e15:	29 d0                	sub    %edx,%eax
  802e17:	83 ec 04             	sub    $0x4,%esp
  802e1a:	6a 01                	push   $0x1
  802e1c:	50                   	push   %eax
  802e1d:	ff 75 bc             	pushl  -0x44(%ebp)
  802e20:	e8 51 f5 ff ff       	call   802376 <set_block_data>
  802e25:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e28:	83 ec 0c             	sub    $0xc,%esp
  802e2b:	ff 75 bc             	pushl  -0x44(%ebp)
  802e2e:	e8 36 04 00 00       	call   803269 <free_block>
  802e33:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e36:	83 ec 0c             	sub    $0xc,%esp
  802e39:	ff 75 08             	pushl  0x8(%ebp)
  802e3c:	e8 20 fa ff ff       	call   802861 <alloc_block_BF>
  802e41:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e44:	c9                   	leave  
  802e45:	c3                   	ret    

00802e46 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e46:	55                   	push   %ebp
  802e47:	89 e5                	mov    %esp,%ebp
  802e49:	53                   	push   %ebx
  802e4a:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e54:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5f:	74 1e                	je     802e7f <merging+0x39>
  802e61:	ff 75 08             	pushl  0x8(%ebp)
  802e64:	e8 bc f1 ff ff       	call   802025 <get_block_size>
  802e69:	83 c4 04             	add    $0x4,%esp
  802e6c:	89 c2                	mov    %eax,%edx
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	01 d0                	add    %edx,%eax
  802e73:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e76:	75 07                	jne    802e7f <merging+0x39>
		prev_is_free = 1;
  802e78:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e83:	74 1e                	je     802ea3 <merging+0x5d>
  802e85:	ff 75 10             	pushl  0x10(%ebp)
  802e88:	e8 98 f1 ff ff       	call   802025 <get_block_size>
  802e8d:	83 c4 04             	add    $0x4,%esp
  802e90:	89 c2                	mov    %eax,%edx
  802e92:	8b 45 10             	mov    0x10(%ebp),%eax
  802e95:	01 d0                	add    %edx,%eax
  802e97:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e9a:	75 07                	jne    802ea3 <merging+0x5d>
		next_is_free = 1;
  802e9c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ea3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea7:	0f 84 cc 00 00 00    	je     802f79 <merging+0x133>
  802ead:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb1:	0f 84 c2 00 00 00    	je     802f79 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802eb7:	ff 75 08             	pushl  0x8(%ebp)
  802eba:	e8 66 f1 ff ff       	call   802025 <get_block_size>
  802ebf:	83 c4 04             	add    $0x4,%esp
  802ec2:	89 c3                	mov    %eax,%ebx
  802ec4:	ff 75 10             	pushl  0x10(%ebp)
  802ec7:	e8 59 f1 ff ff       	call   802025 <get_block_size>
  802ecc:	83 c4 04             	add    $0x4,%esp
  802ecf:	01 c3                	add    %eax,%ebx
  802ed1:	ff 75 0c             	pushl  0xc(%ebp)
  802ed4:	e8 4c f1 ff ff       	call   802025 <get_block_size>
  802ed9:	83 c4 04             	add    $0x4,%esp
  802edc:	01 d8                	add    %ebx,%eax
  802ede:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ee1:	6a 00                	push   $0x0
  802ee3:	ff 75 ec             	pushl  -0x14(%ebp)
  802ee6:	ff 75 08             	pushl  0x8(%ebp)
  802ee9:	e8 88 f4 ff ff       	call   802376 <set_block_data>
  802eee:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ef1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ef5:	75 17                	jne    802f0e <merging+0xc8>
  802ef7:	83 ec 04             	sub    $0x4,%esp
  802efa:	68 33 45 80 00       	push   $0x804533
  802eff:	68 7d 01 00 00       	push   $0x17d
  802f04:	68 51 45 80 00       	push   $0x804551
  802f09:	e8 b0 0b 00 00       	call   803abe <_panic>
  802f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	74 10                	je     802f27 <merging+0xe1>
  802f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f1f:	8b 52 04             	mov    0x4(%edx),%edx
  802f22:	89 50 04             	mov    %edx,0x4(%eax)
  802f25:	eb 0b                	jmp    802f32 <merging+0xec>
  802f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2a:	8b 40 04             	mov    0x4(%eax),%eax
  802f2d:	a3 30 50 80 00       	mov    %eax,0x805030
  802f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f35:	8b 40 04             	mov    0x4(%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	74 0f                	je     802f4b <merging+0x105>
  802f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f45:	8b 12                	mov    (%edx),%edx
  802f47:	89 10                	mov    %edx,(%eax)
  802f49:	eb 0a                	jmp    802f55 <merging+0x10f>
  802f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f68:	a1 38 50 80 00       	mov    0x805038,%eax
  802f6d:	48                   	dec    %eax
  802f6e:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f73:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f74:	e9 ea 02 00 00       	jmp    803263 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7d:	74 3b                	je     802fba <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f7f:	83 ec 0c             	sub    $0xc,%esp
  802f82:	ff 75 08             	pushl  0x8(%ebp)
  802f85:	e8 9b f0 ff ff       	call   802025 <get_block_size>
  802f8a:	83 c4 10             	add    $0x10,%esp
  802f8d:	89 c3                	mov    %eax,%ebx
  802f8f:	83 ec 0c             	sub    $0xc,%esp
  802f92:	ff 75 10             	pushl  0x10(%ebp)
  802f95:	e8 8b f0 ff ff       	call   802025 <get_block_size>
  802f9a:	83 c4 10             	add    $0x10,%esp
  802f9d:	01 d8                	add    %ebx,%eax
  802f9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fa2:	83 ec 04             	sub    $0x4,%esp
  802fa5:	6a 00                	push   $0x0
  802fa7:	ff 75 e8             	pushl  -0x18(%ebp)
  802faa:	ff 75 08             	pushl  0x8(%ebp)
  802fad:	e8 c4 f3 ff ff       	call   802376 <set_block_data>
  802fb2:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fb5:	e9 a9 02 00 00       	jmp    803263 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802fba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fbe:	0f 84 2d 01 00 00    	je     8030f1 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802fc4:	83 ec 0c             	sub    $0xc,%esp
  802fc7:	ff 75 10             	pushl  0x10(%ebp)
  802fca:	e8 56 f0 ff ff       	call   802025 <get_block_size>
  802fcf:	83 c4 10             	add    $0x10,%esp
  802fd2:	89 c3                	mov    %eax,%ebx
  802fd4:	83 ec 0c             	sub    $0xc,%esp
  802fd7:	ff 75 0c             	pushl  0xc(%ebp)
  802fda:	e8 46 f0 ff ff       	call   802025 <get_block_size>
  802fdf:	83 c4 10             	add    $0x10,%esp
  802fe2:	01 d8                	add    %ebx,%eax
  802fe4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802fe7:	83 ec 04             	sub    $0x4,%esp
  802fea:	6a 00                	push   $0x0
  802fec:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fef:	ff 75 10             	pushl  0x10(%ebp)
  802ff2:	e8 7f f3 ff ff       	call   802376 <set_block_data>
  802ff7:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  802ffd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803000:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803004:	74 06                	je     80300c <merging+0x1c6>
  803006:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80300a:	75 17                	jne    803023 <merging+0x1dd>
  80300c:	83 ec 04             	sub    $0x4,%esp
  80300f:	68 0c 46 80 00       	push   $0x80460c
  803014:	68 8d 01 00 00       	push   $0x18d
  803019:	68 51 45 80 00       	push   $0x804551
  80301e:	e8 9b 0a 00 00       	call   803abe <_panic>
  803023:	8b 45 0c             	mov    0xc(%ebp),%eax
  803026:	8b 50 04             	mov    0x4(%eax),%edx
  803029:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80302c:	89 50 04             	mov    %edx,0x4(%eax)
  80302f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803032:	8b 55 0c             	mov    0xc(%ebp),%edx
  803035:	89 10                	mov    %edx,(%eax)
  803037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303a:	8b 40 04             	mov    0x4(%eax),%eax
  80303d:	85 c0                	test   %eax,%eax
  80303f:	74 0d                	je     80304e <merging+0x208>
  803041:	8b 45 0c             	mov    0xc(%ebp),%eax
  803044:	8b 40 04             	mov    0x4(%eax),%eax
  803047:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80304a:	89 10                	mov    %edx,(%eax)
  80304c:	eb 08                	jmp    803056 <merging+0x210>
  80304e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803051:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803056:	8b 45 0c             	mov    0xc(%ebp),%eax
  803059:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80305c:	89 50 04             	mov    %edx,0x4(%eax)
  80305f:	a1 38 50 80 00       	mov    0x805038,%eax
  803064:	40                   	inc    %eax
  803065:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80306a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80306e:	75 17                	jne    803087 <merging+0x241>
  803070:	83 ec 04             	sub    $0x4,%esp
  803073:	68 33 45 80 00       	push   $0x804533
  803078:	68 8e 01 00 00       	push   $0x18e
  80307d:	68 51 45 80 00       	push   $0x804551
  803082:	e8 37 0a 00 00       	call   803abe <_panic>
  803087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	74 10                	je     8030a0 <merging+0x25a>
  803090:	8b 45 0c             	mov    0xc(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	8b 55 0c             	mov    0xc(%ebp),%edx
  803098:	8b 52 04             	mov    0x4(%edx),%edx
  80309b:	89 50 04             	mov    %edx,0x4(%eax)
  80309e:	eb 0b                	jmp    8030ab <merging+0x265>
  8030a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a3:	8b 40 04             	mov    0x4(%eax),%eax
  8030a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ae:	8b 40 04             	mov    0x4(%eax),%eax
  8030b1:	85 c0                	test   %eax,%eax
  8030b3:	74 0f                	je     8030c4 <merging+0x27e>
  8030b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b8:	8b 40 04             	mov    0x4(%eax),%eax
  8030bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030be:	8b 12                	mov    (%edx),%edx
  8030c0:	89 10                	mov    %edx,(%eax)
  8030c2:	eb 0a                	jmp    8030ce <merging+0x288>
  8030c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c7:	8b 00                	mov    (%eax),%eax
  8030c9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e1:	a1 38 50 80 00       	mov    0x805038,%eax
  8030e6:	48                   	dec    %eax
  8030e7:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030ec:	e9 72 01 00 00       	jmp    803263 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8030f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8030f4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8030f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fb:	74 79                	je     803176 <merging+0x330>
  8030fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803101:	74 73                	je     803176 <merging+0x330>
  803103:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803107:	74 06                	je     80310f <merging+0x2c9>
  803109:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80310d:	75 17                	jne    803126 <merging+0x2e0>
  80310f:	83 ec 04             	sub    $0x4,%esp
  803112:	68 c4 45 80 00       	push   $0x8045c4
  803117:	68 94 01 00 00       	push   $0x194
  80311c:	68 51 45 80 00       	push   $0x804551
  803121:	e8 98 09 00 00       	call   803abe <_panic>
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	8b 10                	mov    (%eax),%edx
  80312b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312e:	89 10                	mov    %edx,(%eax)
  803130:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	85 c0                	test   %eax,%eax
  803137:	74 0b                	je     803144 <merging+0x2fe>
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803141:	89 50 04             	mov    %edx,0x4(%eax)
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80314a:	89 10                	mov    %edx,(%eax)
  80314c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314f:	8b 55 08             	mov    0x8(%ebp),%edx
  803152:	89 50 04             	mov    %edx,0x4(%eax)
  803155:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	85 c0                	test   %eax,%eax
  80315c:	75 08                	jne    803166 <merging+0x320>
  80315e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803161:	a3 30 50 80 00       	mov    %eax,0x805030
  803166:	a1 38 50 80 00       	mov    0x805038,%eax
  80316b:	40                   	inc    %eax
  80316c:	a3 38 50 80 00       	mov    %eax,0x805038
  803171:	e9 ce 00 00 00       	jmp    803244 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803176:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317a:	74 65                	je     8031e1 <merging+0x39b>
  80317c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803180:	75 17                	jne    803199 <merging+0x353>
  803182:	83 ec 04             	sub    $0x4,%esp
  803185:	68 a0 45 80 00       	push   $0x8045a0
  80318a:	68 95 01 00 00       	push   $0x195
  80318f:	68 51 45 80 00       	push   $0x804551
  803194:	e8 25 09 00 00       	call   803abe <_panic>
  803199:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80319f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031a2:	89 50 04             	mov    %edx,0x4(%eax)
  8031a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031a8:	8b 40 04             	mov    0x4(%eax),%eax
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	74 0c                	je     8031bb <merging+0x375>
  8031af:	a1 30 50 80 00       	mov    0x805030,%eax
  8031b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031b7:	89 10                	mov    %edx,(%eax)
  8031b9:	eb 08                	jmp    8031c3 <merging+0x37d>
  8031bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8031cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8031d9:	40                   	inc    %eax
  8031da:	a3 38 50 80 00       	mov    %eax,0x805038
  8031df:	eb 63                	jmp    803244 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8031e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031e5:	75 17                	jne    8031fe <merging+0x3b8>
  8031e7:	83 ec 04             	sub    $0x4,%esp
  8031ea:	68 6c 45 80 00       	push   $0x80456c
  8031ef:	68 98 01 00 00       	push   $0x198
  8031f4:	68 51 45 80 00       	push   $0x804551
  8031f9:	e8 c0 08 00 00       	call   803abe <_panic>
  8031fe:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803204:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803207:	89 10                	mov    %edx,(%eax)
  803209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80320c:	8b 00                	mov    (%eax),%eax
  80320e:	85 c0                	test   %eax,%eax
  803210:	74 0d                	je     80321f <merging+0x3d9>
  803212:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803217:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80321a:	89 50 04             	mov    %edx,0x4(%eax)
  80321d:	eb 08                	jmp    803227 <merging+0x3e1>
  80321f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803222:	a3 30 50 80 00       	mov    %eax,0x805030
  803227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80322a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80322f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803232:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803239:	a1 38 50 80 00       	mov    0x805038,%eax
  80323e:	40                   	inc    %eax
  80323f:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803244:	83 ec 0c             	sub    $0xc,%esp
  803247:	ff 75 10             	pushl  0x10(%ebp)
  80324a:	e8 d6 ed ff ff       	call   802025 <get_block_size>
  80324f:	83 c4 10             	add    $0x10,%esp
  803252:	83 ec 04             	sub    $0x4,%esp
  803255:	6a 00                	push   $0x0
  803257:	50                   	push   %eax
  803258:	ff 75 10             	pushl  0x10(%ebp)
  80325b:	e8 16 f1 ff ff       	call   802376 <set_block_data>
  803260:	83 c4 10             	add    $0x10,%esp
	}
}
  803263:	90                   	nop
  803264:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803267:	c9                   	leave  
  803268:	c3                   	ret    

00803269 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803269:	55                   	push   %ebp
  80326a:	89 e5                	mov    %esp,%ebp
  80326c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80326f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803274:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803277:	a1 30 50 80 00       	mov    0x805030,%eax
  80327c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80327f:	73 1b                	jae    80329c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803281:	a1 30 50 80 00       	mov    0x805030,%eax
  803286:	83 ec 04             	sub    $0x4,%esp
  803289:	ff 75 08             	pushl  0x8(%ebp)
  80328c:	6a 00                	push   $0x0
  80328e:	50                   	push   %eax
  80328f:	e8 b2 fb ff ff       	call   802e46 <merging>
  803294:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803297:	e9 8b 00 00 00       	jmp    803327 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80329c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032a4:	76 18                	jbe    8032be <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8032a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ab:	83 ec 04             	sub    $0x4,%esp
  8032ae:	ff 75 08             	pushl  0x8(%ebp)
  8032b1:	50                   	push   %eax
  8032b2:	6a 00                	push   $0x0
  8032b4:	e8 8d fb ff ff       	call   802e46 <merging>
  8032b9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032bc:	eb 69                	jmp    803327 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032c6:	eb 39                	jmp    803301 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ce:	73 29                	jae    8032f9 <free_block+0x90>
  8032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032d8:	76 1f                	jbe    8032f9 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 00                	mov    (%eax),%eax
  8032df:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8032e2:	83 ec 04             	sub    $0x4,%esp
  8032e5:	ff 75 08             	pushl  0x8(%ebp)
  8032e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8032eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8032ee:	e8 53 fb ff ff       	call   802e46 <merging>
  8032f3:	83 c4 10             	add    $0x10,%esp
			break;
  8032f6:	90                   	nop
		}
	}
}
  8032f7:	eb 2e                	jmp    803327 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032f9:	a1 34 50 80 00       	mov    0x805034,%eax
  8032fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803301:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803305:	74 07                	je     80330e <free_block+0xa5>
  803307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	eb 05                	jmp    803313 <free_block+0xaa>
  80330e:	b8 00 00 00 00       	mov    $0x0,%eax
  803313:	a3 34 50 80 00       	mov    %eax,0x805034
  803318:	a1 34 50 80 00       	mov    0x805034,%eax
  80331d:	85 c0                	test   %eax,%eax
  80331f:	75 a7                	jne    8032c8 <free_block+0x5f>
  803321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803325:	75 a1                	jne    8032c8 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803327:	90                   	nop
  803328:	c9                   	leave  
  803329:	c3                   	ret    

0080332a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80332a:	55                   	push   %ebp
  80332b:	89 e5                	mov    %esp,%ebp
  80332d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803330:	ff 75 08             	pushl  0x8(%ebp)
  803333:	e8 ed ec ff ff       	call   802025 <get_block_size>
  803338:	83 c4 04             	add    $0x4,%esp
  80333b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80333e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803345:	eb 17                	jmp    80335e <copy_data+0x34>
  803347:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80334a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334d:	01 c2                	add    %eax,%edx
  80334f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	01 c8                	add    %ecx,%eax
  803357:	8a 00                	mov    (%eax),%al
  803359:	88 02                	mov    %al,(%edx)
  80335b:	ff 45 fc             	incl   -0x4(%ebp)
  80335e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803361:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803364:	72 e1                	jb     803347 <copy_data+0x1d>
}
  803366:	90                   	nop
  803367:	c9                   	leave  
  803368:	c3                   	ret    

00803369 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803369:	55                   	push   %ebp
  80336a:	89 e5                	mov    %esp,%ebp
  80336c:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80336f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803373:	75 23                	jne    803398 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803375:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803379:	74 13                	je     80338e <realloc_block_FF+0x25>
  80337b:	83 ec 0c             	sub    $0xc,%esp
  80337e:	ff 75 0c             	pushl  0xc(%ebp)
  803381:	e8 1f f0 ff ff       	call   8023a5 <alloc_block_FF>
  803386:	83 c4 10             	add    $0x10,%esp
  803389:	e9 f4 06 00 00       	jmp    803a82 <realloc_block_FF+0x719>
		return NULL;
  80338e:	b8 00 00 00 00       	mov    $0x0,%eax
  803393:	e9 ea 06 00 00       	jmp    803a82 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80339c:	75 18                	jne    8033b6 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80339e:	83 ec 0c             	sub    $0xc,%esp
  8033a1:	ff 75 08             	pushl  0x8(%ebp)
  8033a4:	e8 c0 fe ff ff       	call   803269 <free_block>
  8033a9:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b1:	e9 cc 06 00 00       	jmp    803a82 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8033b6:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033ba:	77 07                	ja     8033c3 <realloc_block_FF+0x5a>
  8033bc:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c6:	83 e0 01             	and    $0x1,%eax
  8033c9:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8033cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033cf:	83 c0 08             	add    $0x8,%eax
  8033d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8033d5:	83 ec 0c             	sub    $0xc,%esp
  8033d8:	ff 75 08             	pushl  0x8(%ebp)
  8033db:	e8 45 ec ff ff       	call   802025 <get_block_size>
  8033e0:	83 c4 10             	add    $0x10,%esp
  8033e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e9:	83 e8 08             	sub    $0x8,%eax
  8033ec:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	83 e8 04             	sub    $0x4,%eax
  8033f5:	8b 00                	mov    (%eax),%eax
  8033f7:	83 e0 fe             	and    $0xfffffffe,%eax
  8033fa:	89 c2                	mov    %eax,%edx
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	01 d0                	add    %edx,%eax
  803401:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803404:	83 ec 0c             	sub    $0xc,%esp
  803407:	ff 75 e4             	pushl  -0x1c(%ebp)
  80340a:	e8 16 ec ff ff       	call   802025 <get_block_size>
  80340f:	83 c4 10             	add    $0x10,%esp
  803412:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803418:	83 e8 08             	sub    $0x8,%eax
  80341b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80341e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803421:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803424:	75 08                	jne    80342e <realloc_block_FF+0xc5>
	{
		 return va;
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	e9 54 06 00 00       	jmp    803a82 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80342e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803431:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803434:	0f 83 e5 03 00 00    	jae    80381f <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80343a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803440:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803443:	83 ec 0c             	sub    $0xc,%esp
  803446:	ff 75 e4             	pushl  -0x1c(%ebp)
  803449:	e8 f0 eb ff ff       	call   80203e <is_free_block>
  80344e:	83 c4 10             	add    $0x10,%esp
  803451:	84 c0                	test   %al,%al
  803453:	0f 84 3b 01 00 00    	je     803594 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803459:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80345c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80345f:	01 d0                	add    %edx,%eax
  803461:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803464:	83 ec 04             	sub    $0x4,%esp
  803467:	6a 01                	push   $0x1
  803469:	ff 75 f0             	pushl  -0x10(%ebp)
  80346c:	ff 75 08             	pushl  0x8(%ebp)
  80346f:	e8 02 ef ff ff       	call   802376 <set_block_data>
  803474:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	83 e8 04             	sub    $0x4,%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	83 e0 fe             	and    $0xfffffffe,%eax
  803482:	89 c2                	mov    %eax,%edx
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	01 d0                	add    %edx,%eax
  803489:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80348c:	83 ec 04             	sub    $0x4,%esp
  80348f:	6a 00                	push   $0x0
  803491:	ff 75 cc             	pushl  -0x34(%ebp)
  803494:	ff 75 c8             	pushl  -0x38(%ebp)
  803497:	e8 da ee ff ff       	call   802376 <set_block_data>
  80349c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80349f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034a3:	74 06                	je     8034ab <realloc_block_FF+0x142>
  8034a5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034a9:	75 17                	jne    8034c2 <realloc_block_FF+0x159>
  8034ab:	83 ec 04             	sub    $0x4,%esp
  8034ae:	68 c4 45 80 00       	push   $0x8045c4
  8034b3:	68 f6 01 00 00       	push   $0x1f6
  8034b8:	68 51 45 80 00       	push   $0x804551
  8034bd:	e8 fc 05 00 00       	call   803abe <_panic>
  8034c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c5:	8b 10                	mov    (%eax),%edx
  8034c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034ca:	89 10                	mov    %edx,(%eax)
  8034cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034cf:	8b 00                	mov    (%eax),%eax
  8034d1:	85 c0                	test   %eax,%eax
  8034d3:	74 0b                	je     8034e0 <realloc_block_FF+0x177>
  8034d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d8:	8b 00                	mov    (%eax),%eax
  8034da:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034dd:	89 50 04             	mov    %edx,0x4(%eax)
  8034e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034e6:	89 10                	mov    %edx,(%eax)
  8034e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ee:	89 50 04             	mov    %edx,0x4(%eax)
  8034f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034f4:	8b 00                	mov    (%eax),%eax
  8034f6:	85 c0                	test   %eax,%eax
  8034f8:	75 08                	jne    803502 <realloc_block_FF+0x199>
  8034fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034fd:	a3 30 50 80 00       	mov    %eax,0x805030
  803502:	a1 38 50 80 00       	mov    0x805038,%eax
  803507:	40                   	inc    %eax
  803508:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80350d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803511:	75 17                	jne    80352a <realloc_block_FF+0x1c1>
  803513:	83 ec 04             	sub    $0x4,%esp
  803516:	68 33 45 80 00       	push   $0x804533
  80351b:	68 f7 01 00 00       	push   $0x1f7
  803520:	68 51 45 80 00       	push   $0x804551
  803525:	e8 94 05 00 00       	call   803abe <_panic>
  80352a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	85 c0                	test   %eax,%eax
  803531:	74 10                	je     803543 <realloc_block_FF+0x1da>
  803533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80353b:	8b 52 04             	mov    0x4(%edx),%edx
  80353e:	89 50 04             	mov    %edx,0x4(%eax)
  803541:	eb 0b                	jmp    80354e <realloc_block_FF+0x1e5>
  803543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803546:	8b 40 04             	mov    0x4(%eax),%eax
  803549:	a3 30 50 80 00       	mov    %eax,0x805030
  80354e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803551:	8b 40 04             	mov    0x4(%eax),%eax
  803554:	85 c0                	test   %eax,%eax
  803556:	74 0f                	je     803567 <realloc_block_FF+0x1fe>
  803558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355b:	8b 40 04             	mov    0x4(%eax),%eax
  80355e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803561:	8b 12                	mov    (%edx),%edx
  803563:	89 10                	mov    %edx,(%eax)
  803565:	eb 0a                	jmp    803571 <realloc_block_FF+0x208>
  803567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356a:	8b 00                	mov    (%eax),%eax
  80356c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803574:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803584:	a1 38 50 80 00       	mov    0x805038,%eax
  803589:	48                   	dec    %eax
  80358a:	a3 38 50 80 00       	mov    %eax,0x805038
  80358f:	e9 83 02 00 00       	jmp    803817 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803594:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803598:	0f 86 69 02 00 00    	jbe    803807 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80359e:	83 ec 04             	sub    $0x4,%esp
  8035a1:	6a 01                	push   $0x1
  8035a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8035a6:	ff 75 08             	pushl  0x8(%ebp)
  8035a9:	e8 c8 ed ff ff       	call   802376 <set_block_data>
  8035ae:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	83 e8 04             	sub    $0x4,%eax
  8035b7:	8b 00                	mov    (%eax),%eax
  8035b9:	83 e0 fe             	and    $0xfffffffe,%eax
  8035bc:	89 c2                	mov    %eax,%edx
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	01 d0                	add    %edx,%eax
  8035c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035c6:	a1 38 50 80 00       	mov    0x805038,%eax
  8035cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8035ce:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8035d2:	75 68                	jne    80363c <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035d8:	75 17                	jne    8035f1 <realloc_block_FF+0x288>
  8035da:	83 ec 04             	sub    $0x4,%esp
  8035dd:	68 6c 45 80 00       	push   $0x80456c
  8035e2:	68 06 02 00 00       	push   $0x206
  8035e7:	68 51 45 80 00       	push   $0x804551
  8035ec:	e8 cd 04 00 00       	call   803abe <_panic>
  8035f1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fa:	89 10                	mov    %edx,(%eax)
  8035fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ff:	8b 00                	mov    (%eax),%eax
  803601:	85 c0                	test   %eax,%eax
  803603:	74 0d                	je     803612 <realloc_block_FF+0x2a9>
  803605:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80360a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80360d:	89 50 04             	mov    %edx,0x4(%eax)
  803610:	eb 08                	jmp    80361a <realloc_block_FF+0x2b1>
  803612:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803615:	a3 30 50 80 00       	mov    %eax,0x805030
  80361a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803625:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362c:	a1 38 50 80 00       	mov    0x805038,%eax
  803631:	40                   	inc    %eax
  803632:	a3 38 50 80 00       	mov    %eax,0x805038
  803637:	e9 b0 01 00 00       	jmp    8037ec <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80363c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803641:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803644:	76 68                	jbe    8036ae <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803646:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80364a:	75 17                	jne    803663 <realloc_block_FF+0x2fa>
  80364c:	83 ec 04             	sub    $0x4,%esp
  80364f:	68 6c 45 80 00       	push   $0x80456c
  803654:	68 0b 02 00 00       	push   $0x20b
  803659:	68 51 45 80 00       	push   $0x804551
  80365e:	e8 5b 04 00 00       	call   803abe <_panic>
  803663:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803669:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366c:	89 10                	mov    %edx,(%eax)
  80366e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803671:	8b 00                	mov    (%eax),%eax
  803673:	85 c0                	test   %eax,%eax
  803675:	74 0d                	je     803684 <realloc_block_FF+0x31b>
  803677:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80367c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80367f:	89 50 04             	mov    %edx,0x4(%eax)
  803682:	eb 08                	jmp    80368c <realloc_block_FF+0x323>
  803684:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803687:	a3 30 50 80 00       	mov    %eax,0x805030
  80368c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803694:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803697:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80369e:	a1 38 50 80 00       	mov    0x805038,%eax
  8036a3:	40                   	inc    %eax
  8036a4:	a3 38 50 80 00       	mov    %eax,0x805038
  8036a9:	e9 3e 01 00 00       	jmp    8037ec <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036b3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036b6:	73 68                	jae    803720 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036bc:	75 17                	jne    8036d5 <realloc_block_FF+0x36c>
  8036be:	83 ec 04             	sub    $0x4,%esp
  8036c1:	68 a0 45 80 00       	push   $0x8045a0
  8036c6:	68 10 02 00 00       	push   $0x210
  8036cb:	68 51 45 80 00       	push   $0x804551
  8036d0:	e8 e9 03 00 00       	call   803abe <_panic>
  8036d5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036de:	89 50 04             	mov    %edx,0x4(%eax)
  8036e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e4:	8b 40 04             	mov    0x4(%eax),%eax
  8036e7:	85 c0                	test   %eax,%eax
  8036e9:	74 0c                	je     8036f7 <realloc_block_FF+0x38e>
  8036eb:	a1 30 50 80 00       	mov    0x805030,%eax
  8036f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036f3:	89 10                	mov    %edx,(%eax)
  8036f5:	eb 08                	jmp    8036ff <realloc_block_FF+0x396>
  8036f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803702:	a3 30 50 80 00       	mov    %eax,0x805030
  803707:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803710:	a1 38 50 80 00       	mov    0x805038,%eax
  803715:	40                   	inc    %eax
  803716:	a3 38 50 80 00       	mov    %eax,0x805038
  80371b:	e9 cc 00 00 00       	jmp    8037ec <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803720:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803727:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80372c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80372f:	e9 8a 00 00 00       	jmp    8037be <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803737:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80373a:	73 7a                	jae    8037b6 <realloc_block_FF+0x44d>
  80373c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373f:	8b 00                	mov    (%eax),%eax
  803741:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803744:	73 70                	jae    8037b6 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803746:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80374a:	74 06                	je     803752 <realloc_block_FF+0x3e9>
  80374c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803750:	75 17                	jne    803769 <realloc_block_FF+0x400>
  803752:	83 ec 04             	sub    $0x4,%esp
  803755:	68 c4 45 80 00       	push   $0x8045c4
  80375a:	68 1a 02 00 00       	push   $0x21a
  80375f:	68 51 45 80 00       	push   $0x804551
  803764:	e8 55 03 00 00       	call   803abe <_panic>
  803769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376c:	8b 10                	mov    (%eax),%edx
  80376e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803771:	89 10                	mov    %edx,(%eax)
  803773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803776:	8b 00                	mov    (%eax),%eax
  803778:	85 c0                	test   %eax,%eax
  80377a:	74 0b                	je     803787 <realloc_block_FF+0x41e>
  80377c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377f:	8b 00                	mov    (%eax),%eax
  803781:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803784:	89 50 04             	mov    %edx,0x4(%eax)
  803787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80378d:	89 10                	mov    %edx,(%eax)
  80378f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803795:	89 50 04             	mov    %edx,0x4(%eax)
  803798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80379b:	8b 00                	mov    (%eax),%eax
  80379d:	85 c0                	test   %eax,%eax
  80379f:	75 08                	jne    8037a9 <realloc_block_FF+0x440>
  8037a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8037a9:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ae:	40                   	inc    %eax
  8037af:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8037b4:	eb 36                	jmp    8037ec <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037b6:	a1 34 50 80 00       	mov    0x805034,%eax
  8037bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037c2:	74 07                	je     8037cb <realloc_block_FF+0x462>
  8037c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c7:	8b 00                	mov    (%eax),%eax
  8037c9:	eb 05                	jmp    8037d0 <realloc_block_FF+0x467>
  8037cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d0:	a3 34 50 80 00       	mov    %eax,0x805034
  8037d5:	a1 34 50 80 00       	mov    0x805034,%eax
  8037da:	85 c0                	test   %eax,%eax
  8037dc:	0f 85 52 ff ff ff    	jne    803734 <realloc_block_FF+0x3cb>
  8037e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e6:	0f 85 48 ff ff ff    	jne    803734 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8037ec:	83 ec 04             	sub    $0x4,%esp
  8037ef:	6a 00                	push   $0x0
  8037f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8037f4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8037f7:	e8 7a eb ff ff       	call   802376 <set_block_data>
  8037fc:	83 c4 10             	add    $0x10,%esp
				return va;
  8037ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803802:	e9 7b 02 00 00       	jmp    803a82 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803807:	83 ec 0c             	sub    $0xc,%esp
  80380a:	68 41 46 80 00       	push   $0x804641
  80380f:	e8 2c cf ff ff       	call   800740 <cprintf>
  803814:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803817:	8b 45 08             	mov    0x8(%ebp),%eax
  80381a:	e9 63 02 00 00       	jmp    803a82 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80381f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803822:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803825:	0f 86 4d 02 00 00    	jbe    803a78 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80382b:	83 ec 0c             	sub    $0xc,%esp
  80382e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803831:	e8 08 e8 ff ff       	call   80203e <is_free_block>
  803836:	83 c4 10             	add    $0x10,%esp
  803839:	84 c0                	test   %al,%al
  80383b:	0f 84 37 02 00 00    	je     803a78 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803841:	8b 45 0c             	mov    0xc(%ebp),%eax
  803844:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803847:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80384a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80384d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803850:	76 38                	jbe    80388a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803852:	83 ec 0c             	sub    $0xc,%esp
  803855:	ff 75 08             	pushl  0x8(%ebp)
  803858:	e8 0c fa ff ff       	call   803269 <free_block>
  80385d:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803860:	83 ec 0c             	sub    $0xc,%esp
  803863:	ff 75 0c             	pushl  0xc(%ebp)
  803866:	e8 3a eb ff ff       	call   8023a5 <alloc_block_FF>
  80386b:	83 c4 10             	add    $0x10,%esp
  80386e:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803871:	83 ec 08             	sub    $0x8,%esp
  803874:	ff 75 c0             	pushl  -0x40(%ebp)
  803877:	ff 75 08             	pushl  0x8(%ebp)
  80387a:	e8 ab fa ff ff       	call   80332a <copy_data>
  80387f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803882:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803885:	e9 f8 01 00 00       	jmp    803a82 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80388a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80388d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803890:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803893:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803897:	0f 87 a0 00 00 00    	ja     80393d <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80389d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038a1:	75 17                	jne    8038ba <realloc_block_FF+0x551>
  8038a3:	83 ec 04             	sub    $0x4,%esp
  8038a6:	68 33 45 80 00       	push   $0x804533
  8038ab:	68 38 02 00 00       	push   $0x238
  8038b0:	68 51 45 80 00       	push   $0x804551
  8038b5:	e8 04 02 00 00       	call   803abe <_panic>
  8038ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bd:	8b 00                	mov    (%eax),%eax
  8038bf:	85 c0                	test   %eax,%eax
  8038c1:	74 10                	je     8038d3 <realloc_block_FF+0x56a>
  8038c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c6:	8b 00                	mov    (%eax),%eax
  8038c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038cb:	8b 52 04             	mov    0x4(%edx),%edx
  8038ce:	89 50 04             	mov    %edx,0x4(%eax)
  8038d1:	eb 0b                	jmp    8038de <realloc_block_FF+0x575>
  8038d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d6:	8b 40 04             	mov    0x4(%eax),%eax
  8038d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8038de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e1:	8b 40 04             	mov    0x4(%eax),%eax
  8038e4:	85 c0                	test   %eax,%eax
  8038e6:	74 0f                	je     8038f7 <realloc_block_FF+0x58e>
  8038e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038eb:	8b 40 04             	mov    0x4(%eax),%eax
  8038ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f1:	8b 12                	mov    (%edx),%edx
  8038f3:	89 10                	mov    %edx,(%eax)
  8038f5:	eb 0a                	jmp    803901 <realloc_block_FF+0x598>
  8038f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fa:	8b 00                	mov    (%eax),%eax
  8038fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80390a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803914:	a1 38 50 80 00       	mov    0x805038,%eax
  803919:	48                   	dec    %eax
  80391a:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80391f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803922:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803925:	01 d0                	add    %edx,%eax
  803927:	83 ec 04             	sub    $0x4,%esp
  80392a:	6a 01                	push   $0x1
  80392c:	50                   	push   %eax
  80392d:	ff 75 08             	pushl  0x8(%ebp)
  803930:	e8 41 ea ff ff       	call   802376 <set_block_data>
  803935:	83 c4 10             	add    $0x10,%esp
  803938:	e9 36 01 00 00       	jmp    803a73 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80393d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803940:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803943:	01 d0                	add    %edx,%eax
  803945:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803948:	83 ec 04             	sub    $0x4,%esp
  80394b:	6a 01                	push   $0x1
  80394d:	ff 75 f0             	pushl  -0x10(%ebp)
  803950:	ff 75 08             	pushl  0x8(%ebp)
  803953:	e8 1e ea ff ff       	call   802376 <set_block_data>
  803958:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80395b:	8b 45 08             	mov    0x8(%ebp),%eax
  80395e:	83 e8 04             	sub    $0x4,%eax
  803961:	8b 00                	mov    (%eax),%eax
  803963:	83 e0 fe             	and    $0xfffffffe,%eax
  803966:	89 c2                	mov    %eax,%edx
  803968:	8b 45 08             	mov    0x8(%ebp),%eax
  80396b:	01 d0                	add    %edx,%eax
  80396d:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803970:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803974:	74 06                	je     80397c <realloc_block_FF+0x613>
  803976:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80397a:	75 17                	jne    803993 <realloc_block_FF+0x62a>
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	68 c4 45 80 00       	push   $0x8045c4
  803984:	68 44 02 00 00       	push   $0x244
  803989:	68 51 45 80 00       	push   $0x804551
  80398e:	e8 2b 01 00 00       	call   803abe <_panic>
  803993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803996:	8b 10                	mov    (%eax),%edx
  803998:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80399b:	89 10                	mov    %edx,(%eax)
  80399d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039a0:	8b 00                	mov    (%eax),%eax
  8039a2:	85 c0                	test   %eax,%eax
  8039a4:	74 0b                	je     8039b1 <realloc_block_FF+0x648>
  8039a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a9:	8b 00                	mov    (%eax),%eax
  8039ab:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039ae:	89 50 04             	mov    %edx,0x4(%eax)
  8039b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039b7:	89 10                	mov    %edx,(%eax)
  8039b9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039bf:	89 50 04             	mov    %edx,0x4(%eax)
  8039c2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039c5:	8b 00                	mov    (%eax),%eax
  8039c7:	85 c0                	test   %eax,%eax
  8039c9:	75 08                	jne    8039d3 <realloc_block_FF+0x66a>
  8039cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8039d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8039d8:	40                   	inc    %eax
  8039d9:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039e2:	75 17                	jne    8039fb <realloc_block_FF+0x692>
  8039e4:	83 ec 04             	sub    $0x4,%esp
  8039e7:	68 33 45 80 00       	push   $0x804533
  8039ec:	68 45 02 00 00       	push   $0x245
  8039f1:	68 51 45 80 00       	push   $0x804551
  8039f6:	e8 c3 00 00 00       	call   803abe <_panic>
  8039fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fe:	8b 00                	mov    (%eax),%eax
  803a00:	85 c0                	test   %eax,%eax
  803a02:	74 10                	je     803a14 <realloc_block_FF+0x6ab>
  803a04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a07:	8b 00                	mov    (%eax),%eax
  803a09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a0c:	8b 52 04             	mov    0x4(%edx),%edx
  803a0f:	89 50 04             	mov    %edx,0x4(%eax)
  803a12:	eb 0b                	jmp    803a1f <realloc_block_FF+0x6b6>
  803a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a17:	8b 40 04             	mov    0x4(%eax),%eax
  803a1a:	a3 30 50 80 00       	mov    %eax,0x805030
  803a1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a22:	8b 40 04             	mov    0x4(%eax),%eax
  803a25:	85 c0                	test   %eax,%eax
  803a27:	74 0f                	je     803a38 <realloc_block_FF+0x6cf>
  803a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2c:	8b 40 04             	mov    0x4(%eax),%eax
  803a2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a32:	8b 12                	mov    (%edx),%edx
  803a34:	89 10                	mov    %edx,(%eax)
  803a36:	eb 0a                	jmp    803a42 <realloc_block_FF+0x6d9>
  803a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3b:	8b 00                	mov    (%eax),%eax
  803a3d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a55:	a1 38 50 80 00       	mov    0x805038,%eax
  803a5a:	48                   	dec    %eax
  803a5b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a60:	83 ec 04             	sub    $0x4,%esp
  803a63:	6a 00                	push   $0x0
  803a65:	ff 75 bc             	pushl  -0x44(%ebp)
  803a68:	ff 75 b8             	pushl  -0x48(%ebp)
  803a6b:	e8 06 e9 ff ff       	call   802376 <set_block_data>
  803a70:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a73:	8b 45 08             	mov    0x8(%ebp),%eax
  803a76:	eb 0a                	jmp    803a82 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a78:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a82:	c9                   	leave  
  803a83:	c3                   	ret    

00803a84 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a84:	55                   	push   %ebp
  803a85:	89 e5                	mov    %esp,%ebp
  803a87:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a8a:	83 ec 04             	sub    $0x4,%esp
  803a8d:	68 48 46 80 00       	push   $0x804648
  803a92:	68 58 02 00 00       	push   $0x258
  803a97:	68 51 45 80 00       	push   $0x804551
  803a9c:	e8 1d 00 00 00       	call   803abe <_panic>

00803aa1 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803aa1:	55                   	push   %ebp
  803aa2:	89 e5                	mov    %esp,%ebp
  803aa4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803aa7:	83 ec 04             	sub    $0x4,%esp
  803aaa:	68 70 46 80 00       	push   $0x804670
  803aaf:	68 61 02 00 00       	push   $0x261
  803ab4:	68 51 45 80 00       	push   $0x804551
  803ab9:	e8 00 00 00 00       	call   803abe <_panic>

00803abe <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803abe:	55                   	push   %ebp
  803abf:	89 e5                	mov    %esp,%ebp
  803ac1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803ac4:	8d 45 10             	lea    0x10(%ebp),%eax
  803ac7:	83 c0 04             	add    $0x4,%eax
  803aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803acd:	a1 60 50 98 00       	mov    0x985060,%eax
  803ad2:	85 c0                	test   %eax,%eax
  803ad4:	74 16                	je     803aec <_panic+0x2e>
		cprintf("%s: ", argv0);
  803ad6:	a1 60 50 98 00       	mov    0x985060,%eax
  803adb:	83 ec 08             	sub    $0x8,%esp
  803ade:	50                   	push   %eax
  803adf:	68 98 46 80 00       	push   $0x804698
  803ae4:	e8 57 cc ff ff       	call   800740 <cprintf>
  803ae9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803aec:	a1 00 50 80 00       	mov    0x805000,%eax
  803af1:	ff 75 0c             	pushl  0xc(%ebp)
  803af4:	ff 75 08             	pushl  0x8(%ebp)
  803af7:	50                   	push   %eax
  803af8:	68 9d 46 80 00       	push   $0x80469d
  803afd:	e8 3e cc ff ff       	call   800740 <cprintf>
  803b02:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803b05:	8b 45 10             	mov    0x10(%ebp),%eax
  803b08:	83 ec 08             	sub    $0x8,%esp
  803b0b:	ff 75 f4             	pushl  -0xc(%ebp)
  803b0e:	50                   	push   %eax
  803b0f:	e8 c1 cb ff ff       	call   8006d5 <vcprintf>
  803b14:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803b17:	83 ec 08             	sub    $0x8,%esp
  803b1a:	6a 00                	push   $0x0
  803b1c:	68 b9 46 80 00       	push   $0x8046b9
  803b21:	e8 af cb ff ff       	call   8006d5 <vcprintf>
  803b26:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803b29:	e8 30 cb ff ff       	call   80065e <exit>

	// should not return here
	while (1) ;
  803b2e:	eb fe                	jmp    803b2e <_panic+0x70>

00803b30 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803b30:	55                   	push   %ebp
  803b31:	89 e5                	mov    %esp,%ebp
  803b33:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803b36:	a1 20 50 80 00       	mov    0x805020,%eax
  803b3b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b44:	39 c2                	cmp    %eax,%edx
  803b46:	74 14                	je     803b5c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803b48:	83 ec 04             	sub    $0x4,%esp
  803b4b:	68 bc 46 80 00       	push   $0x8046bc
  803b50:	6a 26                	push   $0x26
  803b52:	68 08 47 80 00       	push   $0x804708
  803b57:	e8 62 ff ff ff       	call   803abe <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803b5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803b63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b6a:	e9 c5 00 00 00       	jmp    803c34 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b72:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b79:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7c:	01 d0                	add    %edx,%eax
  803b7e:	8b 00                	mov    (%eax),%eax
  803b80:	85 c0                	test   %eax,%eax
  803b82:	75 08                	jne    803b8c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803b84:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803b87:	e9 a5 00 00 00       	jmp    803c31 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803b8c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b93:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b9a:	eb 69                	jmp    803c05 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b9c:	a1 20 50 80 00       	mov    0x805020,%eax
  803ba1:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ba7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803baa:	89 d0                	mov    %edx,%eax
  803bac:	01 c0                	add    %eax,%eax
  803bae:	01 d0                	add    %edx,%eax
  803bb0:	c1 e0 03             	shl    $0x3,%eax
  803bb3:	01 c8                	add    %ecx,%eax
  803bb5:	8a 40 04             	mov    0x4(%eax),%al
  803bb8:	84 c0                	test   %al,%al
  803bba:	75 46                	jne    803c02 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803bbc:	a1 20 50 80 00       	mov    0x805020,%eax
  803bc1:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803bc7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bca:	89 d0                	mov    %edx,%eax
  803bcc:	01 c0                	add    %eax,%eax
  803bce:	01 d0                	add    %edx,%eax
  803bd0:	c1 e0 03             	shl    $0x3,%eax
  803bd3:	01 c8                	add    %ecx,%eax
  803bd5:	8b 00                	mov    (%eax),%eax
  803bd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803bda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bdd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803be2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803be7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803bee:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf1:	01 c8                	add    %ecx,%eax
  803bf3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803bf5:	39 c2                	cmp    %eax,%edx
  803bf7:	75 09                	jne    803c02 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803bf9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803c00:	eb 15                	jmp    803c17 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c02:	ff 45 e8             	incl   -0x18(%ebp)
  803c05:	a1 20 50 80 00       	mov    0x805020,%eax
  803c0a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c13:	39 c2                	cmp    %eax,%edx
  803c15:	77 85                	ja     803b9c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803c17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c1b:	75 14                	jne    803c31 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803c1d:	83 ec 04             	sub    $0x4,%esp
  803c20:	68 14 47 80 00       	push   $0x804714
  803c25:	6a 3a                	push   $0x3a
  803c27:	68 08 47 80 00       	push   $0x804708
  803c2c:	e8 8d fe ff ff       	call   803abe <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803c31:	ff 45 f0             	incl   -0x10(%ebp)
  803c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c37:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c3a:	0f 8c 2f ff ff ff    	jl     803b6f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803c40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c47:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803c4e:	eb 26                	jmp    803c76 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803c50:	a1 20 50 80 00       	mov    0x805020,%eax
  803c55:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c5e:	89 d0                	mov    %edx,%eax
  803c60:	01 c0                	add    %eax,%eax
  803c62:	01 d0                	add    %edx,%eax
  803c64:	c1 e0 03             	shl    $0x3,%eax
  803c67:	01 c8                	add    %ecx,%eax
  803c69:	8a 40 04             	mov    0x4(%eax),%al
  803c6c:	3c 01                	cmp    $0x1,%al
  803c6e:	75 03                	jne    803c73 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803c70:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c73:	ff 45 e0             	incl   -0x20(%ebp)
  803c76:	a1 20 50 80 00       	mov    0x805020,%eax
  803c7b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c84:	39 c2                	cmp    %eax,%edx
  803c86:	77 c8                	ja     803c50 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c8e:	74 14                	je     803ca4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803c90:	83 ec 04             	sub    $0x4,%esp
  803c93:	68 68 47 80 00       	push   $0x804768
  803c98:	6a 44                	push   $0x44
  803c9a:	68 08 47 80 00       	push   $0x804708
  803c9f:	e8 1a fe ff ff       	call   803abe <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803ca4:	90                   	nop
  803ca5:	c9                   	leave  
  803ca6:	c3                   	ret    
  803ca7:	90                   	nop

00803ca8 <__udivdi3>:
  803ca8:	55                   	push   %ebp
  803ca9:	57                   	push   %edi
  803caa:	56                   	push   %esi
  803cab:	53                   	push   %ebx
  803cac:	83 ec 1c             	sub    $0x1c,%esp
  803caf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cb3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cbb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803cbf:	89 ca                	mov    %ecx,%edx
  803cc1:	89 f8                	mov    %edi,%eax
  803cc3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803cc7:	85 f6                	test   %esi,%esi
  803cc9:	75 2d                	jne    803cf8 <__udivdi3+0x50>
  803ccb:	39 cf                	cmp    %ecx,%edi
  803ccd:	77 65                	ja     803d34 <__udivdi3+0x8c>
  803ccf:	89 fd                	mov    %edi,%ebp
  803cd1:	85 ff                	test   %edi,%edi
  803cd3:	75 0b                	jne    803ce0 <__udivdi3+0x38>
  803cd5:	b8 01 00 00 00       	mov    $0x1,%eax
  803cda:	31 d2                	xor    %edx,%edx
  803cdc:	f7 f7                	div    %edi
  803cde:	89 c5                	mov    %eax,%ebp
  803ce0:	31 d2                	xor    %edx,%edx
  803ce2:	89 c8                	mov    %ecx,%eax
  803ce4:	f7 f5                	div    %ebp
  803ce6:	89 c1                	mov    %eax,%ecx
  803ce8:	89 d8                	mov    %ebx,%eax
  803cea:	f7 f5                	div    %ebp
  803cec:	89 cf                	mov    %ecx,%edi
  803cee:	89 fa                	mov    %edi,%edx
  803cf0:	83 c4 1c             	add    $0x1c,%esp
  803cf3:	5b                   	pop    %ebx
  803cf4:	5e                   	pop    %esi
  803cf5:	5f                   	pop    %edi
  803cf6:	5d                   	pop    %ebp
  803cf7:	c3                   	ret    
  803cf8:	39 ce                	cmp    %ecx,%esi
  803cfa:	77 28                	ja     803d24 <__udivdi3+0x7c>
  803cfc:	0f bd fe             	bsr    %esi,%edi
  803cff:	83 f7 1f             	xor    $0x1f,%edi
  803d02:	75 40                	jne    803d44 <__udivdi3+0x9c>
  803d04:	39 ce                	cmp    %ecx,%esi
  803d06:	72 0a                	jb     803d12 <__udivdi3+0x6a>
  803d08:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d0c:	0f 87 9e 00 00 00    	ja     803db0 <__udivdi3+0x108>
  803d12:	b8 01 00 00 00       	mov    $0x1,%eax
  803d17:	89 fa                	mov    %edi,%edx
  803d19:	83 c4 1c             	add    $0x1c,%esp
  803d1c:	5b                   	pop    %ebx
  803d1d:	5e                   	pop    %esi
  803d1e:	5f                   	pop    %edi
  803d1f:	5d                   	pop    %ebp
  803d20:	c3                   	ret    
  803d21:	8d 76 00             	lea    0x0(%esi),%esi
  803d24:	31 ff                	xor    %edi,%edi
  803d26:	31 c0                	xor    %eax,%eax
  803d28:	89 fa                	mov    %edi,%edx
  803d2a:	83 c4 1c             	add    $0x1c,%esp
  803d2d:	5b                   	pop    %ebx
  803d2e:	5e                   	pop    %esi
  803d2f:	5f                   	pop    %edi
  803d30:	5d                   	pop    %ebp
  803d31:	c3                   	ret    
  803d32:	66 90                	xchg   %ax,%ax
  803d34:	89 d8                	mov    %ebx,%eax
  803d36:	f7 f7                	div    %edi
  803d38:	31 ff                	xor    %edi,%edi
  803d3a:	89 fa                	mov    %edi,%edx
  803d3c:	83 c4 1c             	add    $0x1c,%esp
  803d3f:	5b                   	pop    %ebx
  803d40:	5e                   	pop    %esi
  803d41:	5f                   	pop    %edi
  803d42:	5d                   	pop    %ebp
  803d43:	c3                   	ret    
  803d44:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d49:	89 eb                	mov    %ebp,%ebx
  803d4b:	29 fb                	sub    %edi,%ebx
  803d4d:	89 f9                	mov    %edi,%ecx
  803d4f:	d3 e6                	shl    %cl,%esi
  803d51:	89 c5                	mov    %eax,%ebp
  803d53:	88 d9                	mov    %bl,%cl
  803d55:	d3 ed                	shr    %cl,%ebp
  803d57:	89 e9                	mov    %ebp,%ecx
  803d59:	09 f1                	or     %esi,%ecx
  803d5b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d5f:	89 f9                	mov    %edi,%ecx
  803d61:	d3 e0                	shl    %cl,%eax
  803d63:	89 c5                	mov    %eax,%ebp
  803d65:	89 d6                	mov    %edx,%esi
  803d67:	88 d9                	mov    %bl,%cl
  803d69:	d3 ee                	shr    %cl,%esi
  803d6b:	89 f9                	mov    %edi,%ecx
  803d6d:	d3 e2                	shl    %cl,%edx
  803d6f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d73:	88 d9                	mov    %bl,%cl
  803d75:	d3 e8                	shr    %cl,%eax
  803d77:	09 c2                	or     %eax,%edx
  803d79:	89 d0                	mov    %edx,%eax
  803d7b:	89 f2                	mov    %esi,%edx
  803d7d:	f7 74 24 0c          	divl   0xc(%esp)
  803d81:	89 d6                	mov    %edx,%esi
  803d83:	89 c3                	mov    %eax,%ebx
  803d85:	f7 e5                	mul    %ebp
  803d87:	39 d6                	cmp    %edx,%esi
  803d89:	72 19                	jb     803da4 <__udivdi3+0xfc>
  803d8b:	74 0b                	je     803d98 <__udivdi3+0xf0>
  803d8d:	89 d8                	mov    %ebx,%eax
  803d8f:	31 ff                	xor    %edi,%edi
  803d91:	e9 58 ff ff ff       	jmp    803cee <__udivdi3+0x46>
  803d96:	66 90                	xchg   %ax,%ax
  803d98:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d9c:	89 f9                	mov    %edi,%ecx
  803d9e:	d3 e2                	shl    %cl,%edx
  803da0:	39 c2                	cmp    %eax,%edx
  803da2:	73 e9                	jae    803d8d <__udivdi3+0xe5>
  803da4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803da7:	31 ff                	xor    %edi,%edi
  803da9:	e9 40 ff ff ff       	jmp    803cee <__udivdi3+0x46>
  803dae:	66 90                	xchg   %ax,%ax
  803db0:	31 c0                	xor    %eax,%eax
  803db2:	e9 37 ff ff ff       	jmp    803cee <__udivdi3+0x46>
  803db7:	90                   	nop

00803db8 <__umoddi3>:
  803db8:	55                   	push   %ebp
  803db9:	57                   	push   %edi
  803dba:	56                   	push   %esi
  803dbb:	53                   	push   %ebx
  803dbc:	83 ec 1c             	sub    $0x1c,%esp
  803dbf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803dc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803dc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dcb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803dcf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dd7:	89 f3                	mov    %esi,%ebx
  803dd9:	89 fa                	mov    %edi,%edx
  803ddb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ddf:	89 34 24             	mov    %esi,(%esp)
  803de2:	85 c0                	test   %eax,%eax
  803de4:	75 1a                	jne    803e00 <__umoddi3+0x48>
  803de6:	39 f7                	cmp    %esi,%edi
  803de8:	0f 86 a2 00 00 00    	jbe    803e90 <__umoddi3+0xd8>
  803dee:	89 c8                	mov    %ecx,%eax
  803df0:	89 f2                	mov    %esi,%edx
  803df2:	f7 f7                	div    %edi
  803df4:	89 d0                	mov    %edx,%eax
  803df6:	31 d2                	xor    %edx,%edx
  803df8:	83 c4 1c             	add    $0x1c,%esp
  803dfb:	5b                   	pop    %ebx
  803dfc:	5e                   	pop    %esi
  803dfd:	5f                   	pop    %edi
  803dfe:	5d                   	pop    %ebp
  803dff:	c3                   	ret    
  803e00:	39 f0                	cmp    %esi,%eax
  803e02:	0f 87 ac 00 00 00    	ja     803eb4 <__umoddi3+0xfc>
  803e08:	0f bd e8             	bsr    %eax,%ebp
  803e0b:	83 f5 1f             	xor    $0x1f,%ebp
  803e0e:	0f 84 ac 00 00 00    	je     803ec0 <__umoddi3+0x108>
  803e14:	bf 20 00 00 00       	mov    $0x20,%edi
  803e19:	29 ef                	sub    %ebp,%edi
  803e1b:	89 fe                	mov    %edi,%esi
  803e1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e21:	89 e9                	mov    %ebp,%ecx
  803e23:	d3 e0                	shl    %cl,%eax
  803e25:	89 d7                	mov    %edx,%edi
  803e27:	89 f1                	mov    %esi,%ecx
  803e29:	d3 ef                	shr    %cl,%edi
  803e2b:	09 c7                	or     %eax,%edi
  803e2d:	89 e9                	mov    %ebp,%ecx
  803e2f:	d3 e2                	shl    %cl,%edx
  803e31:	89 14 24             	mov    %edx,(%esp)
  803e34:	89 d8                	mov    %ebx,%eax
  803e36:	d3 e0                	shl    %cl,%eax
  803e38:	89 c2                	mov    %eax,%edx
  803e3a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e3e:	d3 e0                	shl    %cl,%eax
  803e40:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e44:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e48:	89 f1                	mov    %esi,%ecx
  803e4a:	d3 e8                	shr    %cl,%eax
  803e4c:	09 d0                	or     %edx,%eax
  803e4e:	d3 eb                	shr    %cl,%ebx
  803e50:	89 da                	mov    %ebx,%edx
  803e52:	f7 f7                	div    %edi
  803e54:	89 d3                	mov    %edx,%ebx
  803e56:	f7 24 24             	mull   (%esp)
  803e59:	89 c6                	mov    %eax,%esi
  803e5b:	89 d1                	mov    %edx,%ecx
  803e5d:	39 d3                	cmp    %edx,%ebx
  803e5f:	0f 82 87 00 00 00    	jb     803eec <__umoddi3+0x134>
  803e65:	0f 84 91 00 00 00    	je     803efc <__umoddi3+0x144>
  803e6b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e6f:	29 f2                	sub    %esi,%edx
  803e71:	19 cb                	sbb    %ecx,%ebx
  803e73:	89 d8                	mov    %ebx,%eax
  803e75:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e79:	d3 e0                	shl    %cl,%eax
  803e7b:	89 e9                	mov    %ebp,%ecx
  803e7d:	d3 ea                	shr    %cl,%edx
  803e7f:	09 d0                	or     %edx,%eax
  803e81:	89 e9                	mov    %ebp,%ecx
  803e83:	d3 eb                	shr    %cl,%ebx
  803e85:	89 da                	mov    %ebx,%edx
  803e87:	83 c4 1c             	add    $0x1c,%esp
  803e8a:	5b                   	pop    %ebx
  803e8b:	5e                   	pop    %esi
  803e8c:	5f                   	pop    %edi
  803e8d:	5d                   	pop    %ebp
  803e8e:	c3                   	ret    
  803e8f:	90                   	nop
  803e90:	89 fd                	mov    %edi,%ebp
  803e92:	85 ff                	test   %edi,%edi
  803e94:	75 0b                	jne    803ea1 <__umoddi3+0xe9>
  803e96:	b8 01 00 00 00       	mov    $0x1,%eax
  803e9b:	31 d2                	xor    %edx,%edx
  803e9d:	f7 f7                	div    %edi
  803e9f:	89 c5                	mov    %eax,%ebp
  803ea1:	89 f0                	mov    %esi,%eax
  803ea3:	31 d2                	xor    %edx,%edx
  803ea5:	f7 f5                	div    %ebp
  803ea7:	89 c8                	mov    %ecx,%eax
  803ea9:	f7 f5                	div    %ebp
  803eab:	89 d0                	mov    %edx,%eax
  803ead:	e9 44 ff ff ff       	jmp    803df6 <__umoddi3+0x3e>
  803eb2:	66 90                	xchg   %ax,%ax
  803eb4:	89 c8                	mov    %ecx,%eax
  803eb6:	89 f2                	mov    %esi,%edx
  803eb8:	83 c4 1c             	add    $0x1c,%esp
  803ebb:	5b                   	pop    %ebx
  803ebc:	5e                   	pop    %esi
  803ebd:	5f                   	pop    %edi
  803ebe:	5d                   	pop    %ebp
  803ebf:	c3                   	ret    
  803ec0:	3b 04 24             	cmp    (%esp),%eax
  803ec3:	72 06                	jb     803ecb <__umoddi3+0x113>
  803ec5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ec9:	77 0f                	ja     803eda <__umoddi3+0x122>
  803ecb:	89 f2                	mov    %esi,%edx
  803ecd:	29 f9                	sub    %edi,%ecx
  803ecf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ed3:	89 14 24             	mov    %edx,(%esp)
  803ed6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eda:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ede:	8b 14 24             	mov    (%esp),%edx
  803ee1:	83 c4 1c             	add    $0x1c,%esp
  803ee4:	5b                   	pop    %ebx
  803ee5:	5e                   	pop    %esi
  803ee6:	5f                   	pop    %edi
  803ee7:	5d                   	pop    %ebp
  803ee8:	c3                   	ret    
  803ee9:	8d 76 00             	lea    0x0(%esi),%esi
  803eec:	2b 04 24             	sub    (%esp),%eax
  803eef:	19 fa                	sbb    %edi,%edx
  803ef1:	89 d1                	mov    %edx,%ecx
  803ef3:	89 c6                	mov    %eax,%esi
  803ef5:	e9 71 ff ff ff       	jmp    803e6b <__umoddi3+0xb3>
  803efa:	66 90                	xchg   %ax,%ax
  803efc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f00:	72 ea                	jb     803eec <__umoddi3+0x134>
  803f02:	89 d9                	mov    %ebx,%ecx
  803f04:	e9 62 ff ff ff       	jmp    803e6b <__umoddi3+0xb3>
