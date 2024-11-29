
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
  80003e:	e8 ac 1c 00 00       	call   801cef <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 d6 1c 00 00       	call   801d21 <sys_getparentenvid>
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
  80005f:	68 40 3f 80 00       	push   $0x803f40
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 59 18 00 00       	call   8018c5 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 44 3f 80 00       	push   $0x803f44
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 43 18 00 00       	call   8018c5 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 4c 3f 80 00       	push   $0x803f4c
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
  8000b3:	68 5a 3f 80 00       	push   $0x803f5a
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
  800126:	68 64 3f 80 00       	push   $0x803f64
  80012b:	e8 10 06 00 00       	call   800740 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 89 3f 80 00       	push   $0x803f89
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
  800159:	68 8e 3f 80 00       	push   $0x803f8e
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
  800178:	68 92 3f 80 00       	push   $0x803f92
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
  800197:	68 96 3f 80 00       	push   $0x803f96
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
  8001b6:	68 9a 3f 80 00       	push   $0x803f9a
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
  800230:	e8 1f 1b 00 00       	call   801d54 <sys_get_virtual_time>
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
  800533:	e8 d0 17 00 00       	call   801d08 <sys_getenvindex>
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
  8005a1:	e8 e6 14 00 00       	call   801a8c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	68 b8 3f 80 00       	push   $0x803fb8
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
  8005d1:	68 e0 3f 80 00       	push   $0x803fe0
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
  800602:	68 08 40 80 00       	push   $0x804008
  800607:	e8 34 01 00 00       	call   800740 <cprintf>
  80060c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060f:	a1 20 50 80 00       	mov    0x805020,%eax
  800614:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	50                   	push   %eax
  80061e:	68 60 40 80 00       	push   $0x804060
  800623:	e8 18 01 00 00       	call   800740 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	68 b8 3f 80 00       	push   $0x803fb8
  800633:	e8 08 01 00 00       	call   800740 <cprintf>
  800638:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80063b:	e8 66 14 00 00       	call   801aa6 <sys_unlock_cons>
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
  800653:	e8 7c 16 00 00       	call   801cd4 <sys_destroy_env>
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
  800664:	e8 d1 16 00 00       	call   801d3a <sys_exit_env>
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
  8006b2:	e8 93 13 00 00       	call   801a4a <sys_cputs>
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
  800729:	e8 1c 13 00 00       	call   801a4a <sys_cputs>
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
  800773:	e8 14 13 00 00       	call   801a8c <sys_lock_cons>
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
  800793:	e8 0e 13 00 00       	call   801aa6 <sys_unlock_cons>
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
  8007dd:	e8 ea 34 00 00       	call   803ccc <__udivdi3>
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
  80082d:	e8 aa 35 00 00       	call   803ddc <__umoddi3>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	05 94 42 80 00       	add    $0x804294,%eax
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
  800988:	8b 04 85 b8 42 80 00 	mov    0x8042b8(,%eax,4),%eax
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
  800a69:	8b 34 9d 00 41 80 00 	mov    0x804100(,%ebx,4),%esi
  800a70:	85 f6                	test   %esi,%esi
  800a72:	75 19                	jne    800a8d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a74:	53                   	push   %ebx
  800a75:	68 a5 42 80 00       	push   $0x8042a5
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
  800a8e:	68 ae 42 80 00       	push   $0x8042ae
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
  800abb:	be b1 42 80 00       	mov    $0x8042b1,%esi
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
  8014c6:	68 28 44 80 00       	push   $0x804428
  8014cb:	68 3f 01 00 00       	push   $0x13f
  8014d0:	68 4a 44 80 00       	push   $0x80444a
  8014d5:	e8 07 26 00 00       	call   803ae1 <_panic>

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
  8014e6:	e8 0a 0b 00 00       	call   801ff5 <sys_sbrk>
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
  801561:	e8 13 09 00 00       	call   801e79 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801566:	85 c0                	test   %eax,%eax
  801568:	74 16                	je     801580 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	e8 53 0e 00 00       	call   8023c8 <alloc_block_FF>
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157b:	e9 8a 01 00 00       	jmp    80170a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801580:	e8 25 09 00 00       	call   801eaa <sys_isUHeapPlacementStrategyBESTFIT>
  801585:	85 c0                	test   %eax,%eax
  801587:	0f 84 7d 01 00 00    	je     80170a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 ec 12 00 00       	call   802884 <alloc_block_BF>
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
  8016f9:	e8 2e 09 00 00       	call   80202c <sys_allocate_user_mem>
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
  801741:	e8 02 09 00 00       	call   802048 <get_block_size>
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	e8 35 1b 00 00       	call   80328c <free_block>
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
  8017e9:	e8 22 08 00 00       	call   802010 <sys_free_user_mem>
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
  8017f7:	68 58 44 80 00       	push   $0x804458
  8017fc:	68 85 00 00 00       	push   $0x85
  801801:	68 82 44 80 00       	push   $0x804482
  801806:	e8 d6 22 00 00       	call   803ae1 <_panic>
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
  80186c:	e8 a6 03 00 00       	call   801c17 <sys_createSharedObject>
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
  801890:	68 8e 44 80 00       	push   $0x80448e
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
  8018d4:	e8 68 03 00 00       	call   801c41 <sys_getSizeOfSharedObject>
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8018df:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018e3:	75 07                	jne    8018ec <sget+0x27>
  8018e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ea:	eb 7f                	jmp    80196b <sget+0xa6>
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
  80191f:	eb 4a                	jmp    80196b <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	ff 75 e8             	pushl  -0x18(%ebp)
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	e8 2c 03 00 00       	call   801c5e <sys_getSharedObject>
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801938:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80193b:	a1 20 50 80 00       	mov    0x805020,%eax
  801940:	8b 40 78             	mov    0x78(%eax),%eax
  801943:	29 c2                	sub    %eax,%edx
  801945:	89 d0                	mov    %edx,%eax
  801947:	2d 00 10 00 00       	sub    $0x1000,%eax
  80194c:	c1 e8 0c             	shr    $0xc,%eax
  80194f:	89 c2                	mov    %eax,%edx
  801951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801954:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80195b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80195f:	75 07                	jne    801968 <sget+0xa3>
  801961:	b8 00 00 00 00       	mov    $0x0,%eax
  801966:	eb 03                	jmp    80196b <sget+0xa6>
	return ptr;
  801968:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801973:	8b 55 08             	mov    0x8(%ebp),%edx
  801976:	a1 20 50 80 00       	mov    0x805020,%eax
  80197b:	8b 40 78             	mov    0x78(%eax),%eax
  80197e:	29 c2                	sub    %eax,%edx
  801980:	89 d0                	mov    %edx,%eax
  801982:	2d 00 10 00 00       	sub    $0x1000,%eax
  801987:	c1 e8 0c             	shr    $0xc,%eax
  80198a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801991:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801994:	83 ec 08             	sub    $0x8,%esp
  801997:	ff 75 08             	pushl  0x8(%ebp)
  80199a:	ff 75 f4             	pushl  -0xc(%ebp)
  80199d:	e8 db 02 00 00       	call   801c7d <sys_freeSharedObject>
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8019a8:	90                   	nop
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	68 a0 44 80 00       	push   $0x8044a0
  8019b9:	68 de 00 00 00       	push   $0xde
  8019be:	68 82 44 80 00       	push   $0x804482
  8019c3:	e8 19 21 00 00       	call   803ae1 <_panic>

008019c8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	68 c6 44 80 00       	push   $0x8044c6
  8019d6:	68 ea 00 00 00       	push   $0xea
  8019db:	68 82 44 80 00       	push   $0x804482
  8019e0:	e8 fc 20 00 00       	call   803ae1 <_panic>

008019e5 <shrink>:

}
void shrink(uint32 newSize)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	68 c6 44 80 00       	push   $0x8044c6
  8019f3:	68 ef 00 00 00       	push   $0xef
  8019f8:	68 82 44 80 00       	push   $0x804482
  8019fd:	e8 df 20 00 00       	call   803ae1 <_panic>

00801a02 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	68 c6 44 80 00       	push   $0x8044c6
  801a10:	68 f4 00 00 00       	push   $0xf4
  801a15:	68 82 44 80 00       	push   $0x804482
  801a1a:	e8 c2 20 00 00       	call   803ae1 <_panic>

00801a1f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	57                   	push   %edi
  801a23:	56                   	push   %esi
  801a24:	53                   	push   %ebx
  801a25:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a31:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a34:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a37:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a3a:	cd 30                	int    $0x30
  801a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a42:	83 c4 10             	add    $0x10,%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5f                   	pop    %edi
  801a48:	5d                   	pop    %ebp
  801a49:	c3                   	ret    

00801a4a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	8b 45 10             	mov    0x10(%ebp),%eax
  801a53:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a56:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	52                   	push   %edx
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	50                   	push   %eax
  801a66:	6a 00                	push   $0x0
  801a68:	e8 b2 ff ff ff       	call   801a1f <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	90                   	nop
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 02                	push   $0x2
  801a82:	e8 98 ff ff ff       	call   801a1f <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 03                	push   $0x3
  801a9b:	e8 7f ff ff ff       	call   801a1f <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 04                	push   $0x4
  801ab5:	e8 65 ff ff ff       	call   801a1f <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	90                   	nop
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	52                   	push   %edx
  801ad0:	50                   	push   %eax
  801ad1:	6a 08                	push   $0x8
  801ad3:	e8 47 ff ff ff       	call   801a1f <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	56                   	push   %esi
  801ae1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ae2:	8b 75 18             	mov    0x18(%ebp),%esi
  801ae5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	56                   	push   %esi
  801af2:	53                   	push   %ebx
  801af3:	51                   	push   %ecx
  801af4:	52                   	push   %edx
  801af5:	50                   	push   %eax
  801af6:	6a 09                	push   $0x9
  801af8:	e8 22 ff ff ff       	call   801a1f <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b03:	5b                   	pop    %ebx
  801b04:	5e                   	pop    %esi
  801b05:	5d                   	pop    %ebp
  801b06:	c3                   	ret    

00801b07 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	52                   	push   %edx
  801b17:	50                   	push   %eax
  801b18:	6a 0a                	push   $0xa
  801b1a:	e8 00 ff ff ff       	call   801a1f <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	ff 75 0c             	pushl  0xc(%ebp)
  801b30:	ff 75 08             	pushl  0x8(%ebp)
  801b33:	6a 0b                	push   $0xb
  801b35:	e8 e5 fe ff ff       	call   801a1f <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 0c                	push   $0xc
  801b4e:	e8 cc fe ff ff       	call   801a1f <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 0d                	push   $0xd
  801b67:	e8 b3 fe ff ff       	call   801a1f <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 0e                	push   $0xe
  801b80:	e8 9a fe ff ff       	call   801a1f <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 0f                	push   $0xf
  801b99:	e8 81 fe ff ff       	call   801a1f <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	ff 75 08             	pushl  0x8(%ebp)
  801bb1:	6a 10                	push   $0x10
  801bb3:	e8 67 fe ff ff       	call   801a1f <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 11                	push   $0x11
  801bcc:	e8 4e fe ff ff       	call   801a1f <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	90                   	nop
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_cputc>:

void
sys_cputc(const char c)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	83 ec 04             	sub    $0x4,%esp
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801be3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	50                   	push   %eax
  801bf0:	6a 01                	push   $0x1
  801bf2:	e8 28 fe ff ff       	call   801a1f <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	90                   	nop
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 14                	push   $0x14
  801c0c:	e8 0e fe ff ff       	call   801a1f <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c20:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c23:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c26:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	6a 00                	push   $0x0
  801c2f:	51                   	push   %ecx
  801c30:	52                   	push   %edx
  801c31:	ff 75 0c             	pushl  0xc(%ebp)
  801c34:	50                   	push   %eax
  801c35:	6a 15                	push   $0x15
  801c37:	e8 e3 fd ff ff       	call   801a1f <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	52                   	push   %edx
  801c51:	50                   	push   %eax
  801c52:	6a 16                	push   $0x16
  801c54:	e8 c6 fd ff ff       	call   801a1f <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c61:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	51                   	push   %ecx
  801c6f:	52                   	push   %edx
  801c70:	50                   	push   %eax
  801c71:	6a 17                	push   $0x17
  801c73:	e8 a7 fd ff ff       	call   801a1f <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	52                   	push   %edx
  801c8d:	50                   	push   %eax
  801c8e:	6a 18                	push   $0x18
  801c90:	e8 8a fd ff ff       	call   801a1f <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	ff 75 14             	pushl  0x14(%ebp)
  801ca5:	ff 75 10             	pushl  0x10(%ebp)
  801ca8:	ff 75 0c             	pushl  0xc(%ebp)
  801cab:	50                   	push   %eax
  801cac:	6a 19                	push   $0x19
  801cae:	e8 6c fd ff ff       	call   801a1f <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	50                   	push   %eax
  801cc7:	6a 1a                	push   $0x1a
  801cc9:	e8 51 fd ff ff       	call   801a1f <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	90                   	nop
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	50                   	push   %eax
  801ce3:	6a 1b                	push   $0x1b
  801ce5:	e8 35 fd ff ff       	call   801a1f <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 05                	push   $0x5
  801cfe:	e8 1c fd ff ff       	call   801a1f <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 06                	push   $0x6
  801d17:	e8 03 fd ff ff       	call   801a1f <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 07                	push   $0x7
  801d30:	e8 ea fc ff ff       	call   801a1f <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_exit_env>:


void sys_exit_env(void)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 1c                	push   $0x1c
  801d49:	e8 d1 fc ff ff       	call   801a1f <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	90                   	nop
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d5a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d5d:	8d 50 04             	lea    0x4(%eax),%edx
  801d60:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	52                   	push   %edx
  801d6a:	50                   	push   %eax
  801d6b:	6a 1d                	push   $0x1d
  801d6d:	e8 ad fc ff ff       	call   801a1f <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
	return result;
  801d75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d7e:	89 01                	mov    %eax,(%ecx)
  801d80:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	c9                   	leave  
  801d87:	c2 04 00             	ret    $0x4

00801d8a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	ff 75 10             	pushl  0x10(%ebp)
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	ff 75 08             	pushl  0x8(%ebp)
  801d9a:	6a 13                	push   $0x13
  801d9c:	e8 7e fc ff ff       	call   801a1f <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
	return ;
  801da4:	90                   	nop
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 1e                	push   $0x1e
  801db6:	e8 64 fc ff ff       	call   801a1f <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 04             	sub    $0x4,%esp
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dcc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	50                   	push   %eax
  801dd9:	6a 1f                	push   $0x1f
  801ddb:	e8 3f fc ff ff       	call   801a1f <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
	return ;
  801de3:	90                   	nop
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <rsttst>:
void rsttst()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 21                	push   $0x21
  801df5:	e8 25 fc ff ff       	call   801a1f <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfd:	90                   	nop
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 04             	sub    $0x4,%esp
  801e06:	8b 45 14             	mov    0x14(%ebp),%eax
  801e09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e0c:	8b 55 18             	mov    0x18(%ebp),%edx
  801e0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e13:	52                   	push   %edx
  801e14:	50                   	push   %eax
  801e15:	ff 75 10             	pushl  0x10(%ebp)
  801e18:	ff 75 0c             	pushl  0xc(%ebp)
  801e1b:	ff 75 08             	pushl  0x8(%ebp)
  801e1e:	6a 20                	push   $0x20
  801e20:	e8 fa fb ff ff       	call   801a1f <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
	return ;
  801e28:	90                   	nop
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <chktst>:
void chktst(uint32 n)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	ff 75 08             	pushl  0x8(%ebp)
  801e39:	6a 22                	push   $0x22
  801e3b:	e8 df fb ff ff       	call   801a1f <syscall>
  801e40:	83 c4 18             	add    $0x18,%esp
	return ;
  801e43:	90                   	nop
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <inctst>:

void inctst()
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 23                	push   $0x23
  801e55:	e8 c5 fb ff ff       	call   801a1f <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5d:	90                   	nop
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <gettst>:
uint32 gettst()
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 24                	push   $0x24
  801e6f:	e8 ab fb ff ff       	call   801a1f <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 25                	push   $0x25
  801e8b:	e8 8f fb ff ff       	call   801a1f <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
  801e93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e96:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e9a:	75 07                	jne    801ea3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea1:	eb 05                	jmp    801ea8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 25                	push   $0x25
  801ebc:	e8 5e fb ff ff       	call   801a1f <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
  801ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ec7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ecb:	75 07                	jne    801ed4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ecd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed2:	eb 05                	jmp    801ed9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 25                	push   $0x25
  801eed:	e8 2d fb ff ff       	call   801a1f <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
  801ef5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ef8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801efc:	75 07                	jne    801f05 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801efe:	b8 01 00 00 00       	mov    $0x1,%eax
  801f03:	eb 05                	jmp    801f0a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 25                	push   $0x25
  801f1e:	e8 fc fa ff ff       	call   801a1f <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
  801f26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f29:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f2d:	75 07                	jne    801f36 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f34:	eb 05                	jmp    801f3b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	ff 75 08             	pushl  0x8(%ebp)
  801f4b:	6a 26                	push   $0x26
  801f4d:	e8 cd fa ff ff       	call   801a1f <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
	return ;
  801f55:	90                   	nop
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f5c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	53                   	push   %ebx
  801f6b:	51                   	push   %ecx
  801f6c:	52                   	push   %edx
  801f6d:	50                   	push   %eax
  801f6e:	6a 27                	push   $0x27
  801f70:	e8 aa fa ff ff       	call   801a1f <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
}
  801f78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	52                   	push   %edx
  801f8d:	50                   	push   %eax
  801f8e:	6a 28                	push   $0x28
  801f90:	e8 8a fa ff ff       	call   801a1f <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f9d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	6a 00                	push   $0x0
  801fa8:	51                   	push   %ecx
  801fa9:	ff 75 10             	pushl  0x10(%ebp)
  801fac:	52                   	push   %edx
  801fad:	50                   	push   %eax
  801fae:	6a 29                	push   $0x29
  801fb0:	e8 6a fa ff ff       	call   801a1f <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	ff 75 10             	pushl  0x10(%ebp)
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	ff 75 08             	pushl  0x8(%ebp)
  801fca:	6a 12                	push   $0x12
  801fcc:	e8 4e fa ff ff       	call   801a1f <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd4:	90                   	nop
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	52                   	push   %edx
  801fe7:	50                   	push   %eax
  801fe8:	6a 2a                	push   $0x2a
  801fea:	e8 30 fa ff ff       	call   801a1f <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
	return;
  801ff2:	90                   	nop
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	50                   	push   %eax
  802004:	6a 2b                	push   $0x2b
  802006:	e8 14 fa ff ff       	call   801a1f <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	ff 75 0c             	pushl  0xc(%ebp)
  80201c:	ff 75 08             	pushl  0x8(%ebp)
  80201f:	6a 2c                	push   $0x2c
  802021:	e8 f9 f9 ff ff       	call   801a1f <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
	return;
  802029:	90                   	nop
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	ff 75 0c             	pushl  0xc(%ebp)
  802038:	ff 75 08             	pushl  0x8(%ebp)
  80203b:	6a 2d                	push   $0x2d
  80203d:	e8 dd f9 ff ff       	call   801a1f <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
	return;
  802045:	90                   	nop
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	83 e8 04             	sub    $0x4,%eax
  802054:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205a:	8b 00                	mov    (%eax),%eax
  80205c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	83 e8 04             	sub    $0x4,%eax
  80206d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802070:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802073:	8b 00                	mov    (%eax),%eax
  802075:	83 e0 01             	and    $0x1,%eax
  802078:	85 c0                	test   %eax,%eax
  80207a:	0f 94 c0             	sete   %al
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802085:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80208c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208f:	83 f8 02             	cmp    $0x2,%eax
  802092:	74 2b                	je     8020bf <alloc_block+0x40>
  802094:	83 f8 02             	cmp    $0x2,%eax
  802097:	7f 07                	jg     8020a0 <alloc_block+0x21>
  802099:	83 f8 01             	cmp    $0x1,%eax
  80209c:	74 0e                	je     8020ac <alloc_block+0x2d>
  80209e:	eb 58                	jmp    8020f8 <alloc_block+0x79>
  8020a0:	83 f8 03             	cmp    $0x3,%eax
  8020a3:	74 2d                	je     8020d2 <alloc_block+0x53>
  8020a5:	83 f8 04             	cmp    $0x4,%eax
  8020a8:	74 3b                	je     8020e5 <alloc_block+0x66>
  8020aa:	eb 4c                	jmp    8020f8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020ac:	83 ec 0c             	sub    $0xc,%esp
  8020af:	ff 75 08             	pushl  0x8(%ebp)
  8020b2:	e8 11 03 00 00       	call   8023c8 <alloc_block_FF>
  8020b7:	83 c4 10             	add    $0x10,%esp
  8020ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020bd:	eb 4a                	jmp    802109 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020bf:	83 ec 0c             	sub    $0xc,%esp
  8020c2:	ff 75 08             	pushl  0x8(%ebp)
  8020c5:	e8 fa 19 00 00       	call   803ac4 <alloc_block_NF>
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020d0:	eb 37                	jmp    802109 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020d2:	83 ec 0c             	sub    $0xc,%esp
  8020d5:	ff 75 08             	pushl  0x8(%ebp)
  8020d8:	e8 a7 07 00 00       	call   802884 <alloc_block_BF>
  8020dd:	83 c4 10             	add    $0x10,%esp
  8020e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e3:	eb 24                	jmp    802109 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020e5:	83 ec 0c             	sub    $0xc,%esp
  8020e8:	ff 75 08             	pushl  0x8(%ebp)
  8020eb:	e8 b7 19 00 00       	call   803aa7 <alloc_block_WF>
  8020f0:	83 c4 10             	add    $0x10,%esp
  8020f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f6:	eb 11                	jmp    802109 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020f8:	83 ec 0c             	sub    $0xc,%esp
  8020fb:	68 d8 44 80 00       	push   $0x8044d8
  802100:	e8 3b e6 ff ff       	call   800740 <cprintf>
  802105:	83 c4 10             	add    $0x10,%esp
		break;
  802108:	90                   	nop
	}
	return va;
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	53                   	push   %ebx
  802112:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802115:	83 ec 0c             	sub    $0xc,%esp
  802118:	68 f8 44 80 00       	push   $0x8044f8
  80211d:	e8 1e e6 ff ff       	call   800740 <cprintf>
  802122:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802125:	83 ec 0c             	sub    $0xc,%esp
  802128:	68 23 45 80 00       	push   $0x804523
  80212d:	e8 0e e6 ff ff       	call   800740 <cprintf>
  802132:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213b:	eb 37                	jmp    802174 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80213d:	83 ec 0c             	sub    $0xc,%esp
  802140:	ff 75 f4             	pushl  -0xc(%ebp)
  802143:	e8 19 ff ff ff       	call   802061 <is_free_block>
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	0f be d8             	movsbl %al,%ebx
  80214e:	83 ec 0c             	sub    $0xc,%esp
  802151:	ff 75 f4             	pushl  -0xc(%ebp)
  802154:	e8 ef fe ff ff       	call   802048 <get_block_size>
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	83 ec 04             	sub    $0x4,%esp
  80215f:	53                   	push   %ebx
  802160:	50                   	push   %eax
  802161:	68 3b 45 80 00       	push   $0x80453b
  802166:	e8 d5 e5 ff ff       	call   800740 <cprintf>
  80216b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80216e:	8b 45 10             	mov    0x10(%ebp),%eax
  802171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802174:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802178:	74 07                	je     802181 <print_blocks_list+0x73>
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	8b 00                	mov    (%eax),%eax
  80217f:	eb 05                	jmp    802186 <print_blocks_list+0x78>
  802181:	b8 00 00 00 00       	mov    $0x0,%eax
  802186:	89 45 10             	mov    %eax,0x10(%ebp)
  802189:	8b 45 10             	mov    0x10(%ebp),%eax
  80218c:	85 c0                	test   %eax,%eax
  80218e:	75 ad                	jne    80213d <print_blocks_list+0x2f>
  802190:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802194:	75 a7                	jne    80213d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802196:	83 ec 0c             	sub    $0xc,%esp
  802199:	68 f8 44 80 00       	push   $0x8044f8
  80219e:	e8 9d e5 ff ff       	call   800740 <cprintf>
  8021a3:	83 c4 10             	add    $0x10,%esp

}
  8021a6:	90                   	nop
  8021a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b5:	83 e0 01             	and    $0x1,%eax
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	74 03                	je     8021bf <initialize_dynamic_allocator+0x13>
  8021bc:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021c3:	0f 84 c7 01 00 00    	je     802390 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021c9:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8021d0:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8021d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d9:	01 d0                	add    %edx,%eax
  8021db:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8021e0:	0f 87 ad 01 00 00    	ja     802393 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	0f 89 a5 01 00 00    	jns    802396 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8021f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f7:	01 d0                	add    %edx,%eax
  8021f9:	83 e8 04             	sub    $0x4,%eax
  8021fc:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802201:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802208:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80220d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802210:	e9 87 00 00 00       	jmp    80229c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802215:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802219:	75 14                	jne    80222f <initialize_dynamic_allocator+0x83>
  80221b:	83 ec 04             	sub    $0x4,%esp
  80221e:	68 53 45 80 00       	push   $0x804553
  802223:	6a 79                	push   $0x79
  802225:	68 71 45 80 00       	push   $0x804571
  80222a:	e8 b2 18 00 00       	call   803ae1 <_panic>
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	8b 00                	mov    (%eax),%eax
  802234:	85 c0                	test   %eax,%eax
  802236:	74 10                	je     802248 <initialize_dynamic_allocator+0x9c>
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 00                	mov    (%eax),%eax
  80223d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802240:	8b 52 04             	mov    0x4(%edx),%edx
  802243:	89 50 04             	mov    %edx,0x4(%eax)
  802246:	eb 0b                	jmp    802253 <initialize_dynamic_allocator+0xa7>
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	8b 40 04             	mov    0x4(%eax),%eax
  80224e:	a3 30 50 80 00       	mov    %eax,0x805030
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 40 04             	mov    0x4(%eax),%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	74 0f                	je     80226c <initialize_dynamic_allocator+0xc0>
  80225d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802260:	8b 40 04             	mov    0x4(%eax),%eax
  802263:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802266:	8b 12                	mov    (%edx),%edx
  802268:	89 10                	mov    %edx,(%eax)
  80226a:	eb 0a                	jmp    802276 <initialize_dynamic_allocator+0xca>
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	8b 00                	mov    (%eax),%eax
  802271:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802289:	a1 38 50 80 00       	mov    0x805038,%eax
  80228e:	48                   	dec    %eax
  80228f:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802294:	a1 34 50 80 00       	mov    0x805034,%eax
  802299:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a0:	74 07                	je     8022a9 <initialize_dynamic_allocator+0xfd>
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	eb 05                	jmp    8022ae <initialize_dynamic_allocator+0x102>
  8022a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ae:	a3 34 50 80 00       	mov    %eax,0x805034
  8022b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	0f 85 55 ff ff ff    	jne    802215 <initialize_dynamic_allocator+0x69>
  8022c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c4:	0f 85 4b ff ff ff    	jne    802215 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8022d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8022d9:	a1 44 50 80 00       	mov    0x805044,%eax
  8022de:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8022e3:	a1 40 50 80 00       	mov    0x805040,%eax
  8022e8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	83 c0 08             	add    $0x8,%eax
  8022f4:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	83 c0 04             	add    $0x4,%eax
  8022fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802300:	83 ea 08             	sub    $0x8,%edx
  802303:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802305:	8b 55 0c             	mov    0xc(%ebp),%edx
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	01 d0                	add    %edx,%eax
  80230d:	83 e8 08             	sub    $0x8,%eax
  802310:	8b 55 0c             	mov    0xc(%ebp),%edx
  802313:	83 ea 08             	sub    $0x8,%edx
  802316:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802321:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802324:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80232b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80232f:	75 17                	jne    802348 <initialize_dynamic_allocator+0x19c>
  802331:	83 ec 04             	sub    $0x4,%esp
  802334:	68 8c 45 80 00       	push   $0x80458c
  802339:	68 90 00 00 00       	push   $0x90
  80233e:	68 71 45 80 00       	push   $0x804571
  802343:	e8 99 17 00 00       	call   803ae1 <_panic>
  802348:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80234e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802351:	89 10                	mov    %edx,(%eax)
  802353:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802356:	8b 00                	mov    (%eax),%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	74 0d                	je     802369 <initialize_dynamic_allocator+0x1bd>
  80235c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802364:	89 50 04             	mov    %edx,0x4(%eax)
  802367:	eb 08                	jmp    802371 <initialize_dynamic_allocator+0x1c5>
  802369:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236c:	a3 30 50 80 00       	mov    %eax,0x805030
  802371:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802374:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802379:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802383:	a1 38 50 80 00       	mov    0x805038,%eax
  802388:	40                   	inc    %eax
  802389:	a3 38 50 80 00       	mov    %eax,0x805038
  80238e:	eb 07                	jmp    802397 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802390:	90                   	nop
  802391:	eb 04                	jmp    802397 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802393:	90                   	nop
  802394:	eb 01                	jmp    802397 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802396:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80239c:	8b 45 10             	mov    0x10(%ebp),%eax
  80239f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ab:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	83 e8 04             	sub    $0x4,%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8023b8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	01 c2                	add    %eax,%edx
  8023c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c3:	89 02                	mov    %eax,(%edx)
}
  8023c5:	90                   	nop
  8023c6:	5d                   	pop    %ebp
  8023c7:	c3                   	ret    

008023c8 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	83 e0 01             	and    $0x1,%eax
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	74 03                	je     8023db <alloc_block_FF+0x13>
  8023d8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8023db:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8023df:	77 07                	ja     8023e8 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8023e1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8023e8:	a1 24 50 80 00       	mov    0x805024,%eax
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	75 73                	jne    802464 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	83 c0 10             	add    $0x10,%eax
  8023f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8023fa:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802401:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802407:	01 d0                	add    %edx,%eax
  802409:	48                   	dec    %eax
  80240a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80240d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802410:	ba 00 00 00 00       	mov    $0x0,%edx
  802415:	f7 75 ec             	divl   -0x14(%ebp)
  802418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80241b:	29 d0                	sub    %edx,%eax
  80241d:	c1 e8 0c             	shr    $0xc,%eax
  802420:	83 ec 0c             	sub    $0xc,%esp
  802423:	50                   	push   %eax
  802424:	e8 b1 f0 ff ff       	call   8014da <sbrk>
  802429:	83 c4 10             	add    $0x10,%esp
  80242c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80242f:	83 ec 0c             	sub    $0xc,%esp
  802432:	6a 00                	push   $0x0
  802434:	e8 a1 f0 ff ff       	call   8014da <sbrk>
  802439:	83 c4 10             	add    $0x10,%esp
  80243c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80243f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802442:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802445:	83 ec 08             	sub    $0x8,%esp
  802448:	50                   	push   %eax
  802449:	ff 75 e4             	pushl  -0x1c(%ebp)
  80244c:	e8 5b fd ff ff       	call   8021ac <initialize_dynamic_allocator>
  802451:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802454:	83 ec 0c             	sub    $0xc,%esp
  802457:	68 af 45 80 00       	push   $0x8045af
  80245c:	e8 df e2 ff ff       	call   800740 <cprintf>
  802461:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802464:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802468:	75 0a                	jne    802474 <alloc_block_FF+0xac>
	        return NULL;
  80246a:	b8 00 00 00 00       	mov    $0x0,%eax
  80246f:	e9 0e 04 00 00       	jmp    802882 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802474:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80247b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802480:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802483:	e9 f3 02 00 00       	jmp    80277b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80248e:	83 ec 0c             	sub    $0xc,%esp
  802491:	ff 75 bc             	pushl  -0x44(%ebp)
  802494:	e8 af fb ff ff       	call   802048 <get_block_size>
  802499:	83 c4 10             	add    $0x10,%esp
  80249c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	83 c0 08             	add    $0x8,%eax
  8024a5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024a8:	0f 87 c5 02 00 00    	ja     802773 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b1:	83 c0 18             	add    $0x18,%eax
  8024b4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024b7:	0f 87 19 02 00 00    	ja     8026d6 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8024c3:	83 e8 08             	sub    $0x8,%eax
  8024c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	8d 50 08             	lea    0x8(%eax),%edx
  8024cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024d2:	01 d0                	add    %edx,%eax
  8024d4:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	83 c0 08             	add    $0x8,%eax
  8024dd:	83 ec 04             	sub    $0x4,%esp
  8024e0:	6a 01                	push   $0x1
  8024e2:	50                   	push   %eax
  8024e3:	ff 75 bc             	pushl  -0x44(%ebp)
  8024e6:	e8 ae fe ff ff       	call   802399 <set_block_data>
  8024eb:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 40 04             	mov    0x4(%eax),%eax
  8024f4:	85 c0                	test   %eax,%eax
  8024f6:	75 68                	jne    802560 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024f8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024fc:	75 17                	jne    802515 <alloc_block_FF+0x14d>
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	68 8c 45 80 00       	push   $0x80458c
  802506:	68 d7 00 00 00       	push   $0xd7
  80250b:	68 71 45 80 00       	push   $0x804571
  802510:	e8 cc 15 00 00       	call   803ae1 <_panic>
  802515:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80251b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251e:	89 10                	mov    %edx,(%eax)
  802520:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802523:	8b 00                	mov    (%eax),%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	74 0d                	je     802536 <alloc_block_FF+0x16e>
  802529:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80252e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802531:	89 50 04             	mov    %edx,0x4(%eax)
  802534:	eb 08                	jmp    80253e <alloc_block_FF+0x176>
  802536:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802539:	a3 30 50 80 00       	mov    %eax,0x805030
  80253e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802541:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802546:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802550:	a1 38 50 80 00       	mov    0x805038,%eax
  802555:	40                   	inc    %eax
  802556:	a3 38 50 80 00       	mov    %eax,0x805038
  80255b:	e9 dc 00 00 00       	jmp    80263c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 00                	mov    (%eax),%eax
  802565:	85 c0                	test   %eax,%eax
  802567:	75 65                	jne    8025ce <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802569:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80256d:	75 17                	jne    802586 <alloc_block_FF+0x1be>
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	68 c0 45 80 00       	push   $0x8045c0
  802577:	68 db 00 00 00       	push   $0xdb
  80257c:	68 71 45 80 00       	push   $0x804571
  802581:	e8 5b 15 00 00       	call   803ae1 <_panic>
  802586:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80258c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80258f:	89 50 04             	mov    %edx,0x4(%eax)
  802592:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 0c                	je     8025a8 <alloc_block_FF+0x1e0>
  80259c:	a1 30 50 80 00       	mov    0x805030,%eax
  8025a1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025a4:	89 10                	mov    %edx,(%eax)
  8025a6:	eb 08                	jmp    8025b0 <alloc_block_FF+0x1e8>
  8025a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8025b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8025c6:	40                   	inc    %eax
  8025c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8025cc:	eb 6e                	jmp    80263c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8025ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d2:	74 06                	je     8025da <alloc_block_FF+0x212>
  8025d4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025d8:	75 17                	jne    8025f1 <alloc_block_FF+0x229>
  8025da:	83 ec 04             	sub    $0x4,%esp
  8025dd:	68 e4 45 80 00       	push   $0x8045e4
  8025e2:	68 df 00 00 00       	push   $0xdf
  8025e7:	68 71 45 80 00       	push   $0x804571
  8025ec:	e8 f0 14 00 00       	call   803ae1 <_panic>
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 10                	mov    (%eax),%edx
  8025f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f9:	89 10                	mov    %edx,(%eax)
  8025fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	74 0b                	je     80260f <alloc_block_FF+0x247>
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80260c:	89 50 04             	mov    %edx,0x4(%eax)
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802615:	89 10                	mov    %edx,(%eax)
  802617:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80261a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261d:	89 50 04             	mov    %edx,0x4(%eax)
  802620:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802623:	8b 00                	mov    (%eax),%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	75 08                	jne    802631 <alloc_block_FF+0x269>
  802629:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80262c:	a3 30 50 80 00       	mov    %eax,0x805030
  802631:	a1 38 50 80 00       	mov    0x805038,%eax
  802636:	40                   	inc    %eax
  802637:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80263c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802640:	75 17                	jne    802659 <alloc_block_FF+0x291>
  802642:	83 ec 04             	sub    $0x4,%esp
  802645:	68 53 45 80 00       	push   $0x804553
  80264a:	68 e1 00 00 00       	push   $0xe1
  80264f:	68 71 45 80 00       	push   $0x804571
  802654:	e8 88 14 00 00       	call   803ae1 <_panic>
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	85 c0                	test   %eax,%eax
  802660:	74 10                	je     802672 <alloc_block_FF+0x2aa>
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 00                	mov    (%eax),%eax
  802667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266a:	8b 52 04             	mov    0x4(%edx),%edx
  80266d:	89 50 04             	mov    %edx,0x4(%eax)
  802670:	eb 0b                	jmp    80267d <alloc_block_FF+0x2b5>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 40 04             	mov    0x4(%eax),%eax
  802678:	a3 30 50 80 00       	mov    %eax,0x805030
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 40 04             	mov    0x4(%eax),%eax
  802683:	85 c0                	test   %eax,%eax
  802685:	74 0f                	je     802696 <alloc_block_FF+0x2ce>
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 40 04             	mov    0x4(%eax),%eax
  80268d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802690:	8b 12                	mov    (%edx),%edx
  802692:	89 10                	mov    %edx,(%eax)
  802694:	eb 0a                	jmp    8026a0 <alloc_block_FF+0x2d8>
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 00                	mov    (%eax),%eax
  80269b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8026b8:	48                   	dec    %eax
  8026b9:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8026be:	83 ec 04             	sub    $0x4,%esp
  8026c1:	6a 00                	push   $0x0
  8026c3:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026c6:	ff 75 b0             	pushl  -0x50(%ebp)
  8026c9:	e8 cb fc ff ff       	call   802399 <set_block_data>
  8026ce:	83 c4 10             	add    $0x10,%esp
  8026d1:	e9 95 00 00 00       	jmp    80276b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	6a 01                	push   $0x1
  8026db:	ff 75 b8             	pushl  -0x48(%ebp)
  8026de:	ff 75 bc             	pushl  -0x44(%ebp)
  8026e1:	e8 b3 fc ff ff       	call   802399 <set_block_data>
  8026e6:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8026e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ed:	75 17                	jne    802706 <alloc_block_FF+0x33e>
  8026ef:	83 ec 04             	sub    $0x4,%esp
  8026f2:	68 53 45 80 00       	push   $0x804553
  8026f7:	68 e8 00 00 00       	push   $0xe8
  8026fc:	68 71 45 80 00       	push   $0x804571
  802701:	e8 db 13 00 00       	call   803ae1 <_panic>
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	74 10                	je     80271f <alloc_block_FF+0x357>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802717:	8b 52 04             	mov    0x4(%edx),%edx
  80271a:	89 50 04             	mov    %edx,0x4(%eax)
  80271d:	eb 0b                	jmp    80272a <alloc_block_FF+0x362>
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	a3 30 50 80 00       	mov    %eax,0x805030
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 40 04             	mov    0x4(%eax),%eax
  802730:	85 c0                	test   %eax,%eax
  802732:	74 0f                	je     802743 <alloc_block_FF+0x37b>
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 04             	mov    0x4(%eax),%eax
  80273a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273d:	8b 12                	mov    (%edx),%edx
  80273f:	89 10                	mov    %edx,(%eax)
  802741:	eb 0a                	jmp    80274d <alloc_block_FF+0x385>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 00                	mov    (%eax),%eax
  802748:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802760:	a1 38 50 80 00       	mov    0x805038,%eax
  802765:	48                   	dec    %eax
  802766:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80276b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80276e:	e9 0f 01 00 00       	jmp    802882 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802773:	a1 34 50 80 00       	mov    0x805034,%eax
  802778:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277f:	74 07                	je     802788 <alloc_block_FF+0x3c0>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 00                	mov    (%eax),%eax
  802786:	eb 05                	jmp    80278d <alloc_block_FF+0x3c5>
  802788:	b8 00 00 00 00       	mov    $0x0,%eax
  80278d:	a3 34 50 80 00       	mov    %eax,0x805034
  802792:	a1 34 50 80 00       	mov    0x805034,%eax
  802797:	85 c0                	test   %eax,%eax
  802799:	0f 85 e9 fc ff ff    	jne    802488 <alloc_block_FF+0xc0>
  80279f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a3:	0f 85 df fc ff ff    	jne    802488 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	83 c0 08             	add    $0x8,%eax
  8027af:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027b2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027bf:	01 d0                	add    %edx,%eax
  8027c1:	48                   	dec    %eax
  8027c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8027cd:	f7 75 d8             	divl   -0x28(%ebp)
  8027d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027d3:	29 d0                	sub    %edx,%eax
  8027d5:	c1 e8 0c             	shr    $0xc,%eax
  8027d8:	83 ec 0c             	sub    $0xc,%esp
  8027db:	50                   	push   %eax
  8027dc:	e8 f9 ec ff ff       	call   8014da <sbrk>
  8027e1:	83 c4 10             	add    $0x10,%esp
  8027e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8027e7:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027eb:	75 0a                	jne    8027f7 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f2:	e9 8b 00 00 00       	jmp    802882 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8027f7:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8027fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802801:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802804:	01 d0                	add    %edx,%eax
  802806:	48                   	dec    %eax
  802807:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80280a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80280d:	ba 00 00 00 00       	mov    $0x0,%edx
  802812:	f7 75 cc             	divl   -0x34(%ebp)
  802815:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802818:	29 d0                	sub    %edx,%eax
  80281a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80281d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802820:	01 d0                	add    %edx,%eax
  802822:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802827:	a1 40 50 80 00       	mov    0x805040,%eax
  80282c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802832:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802839:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80283c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80283f:	01 d0                	add    %edx,%eax
  802841:	48                   	dec    %eax
  802842:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802845:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802848:	ba 00 00 00 00       	mov    $0x0,%edx
  80284d:	f7 75 c4             	divl   -0x3c(%ebp)
  802850:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802853:	29 d0                	sub    %edx,%eax
  802855:	83 ec 04             	sub    $0x4,%esp
  802858:	6a 01                	push   $0x1
  80285a:	50                   	push   %eax
  80285b:	ff 75 d0             	pushl  -0x30(%ebp)
  80285e:	e8 36 fb ff ff       	call   802399 <set_block_data>
  802863:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802866:	83 ec 0c             	sub    $0xc,%esp
  802869:	ff 75 d0             	pushl  -0x30(%ebp)
  80286c:	e8 1b 0a 00 00       	call   80328c <free_block>
  802871:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802874:	83 ec 0c             	sub    $0xc,%esp
  802877:	ff 75 08             	pushl  0x8(%ebp)
  80287a:	e8 49 fb ff ff       	call   8023c8 <alloc_block_FF>
  80287f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802882:	c9                   	leave  
  802883:	c3                   	ret    

00802884 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802884:	55                   	push   %ebp
  802885:	89 e5                	mov    %esp,%ebp
  802887:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80288a:	8b 45 08             	mov    0x8(%ebp),%eax
  80288d:	83 e0 01             	and    $0x1,%eax
  802890:	85 c0                	test   %eax,%eax
  802892:	74 03                	je     802897 <alloc_block_BF+0x13>
  802894:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802897:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80289b:	77 07                	ja     8028a4 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80289d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8028a9:	85 c0                	test   %eax,%eax
  8028ab:	75 73                	jne    802920 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	83 c0 10             	add    $0x10,%eax
  8028b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028b6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c3:	01 d0                	add    %edx,%eax
  8028c5:	48                   	dec    %eax
  8028c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d1:	f7 75 e0             	divl   -0x20(%ebp)
  8028d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028d7:	29 d0                	sub    %edx,%eax
  8028d9:	c1 e8 0c             	shr    $0xc,%eax
  8028dc:	83 ec 0c             	sub    $0xc,%esp
  8028df:	50                   	push   %eax
  8028e0:	e8 f5 eb ff ff       	call   8014da <sbrk>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028eb:	83 ec 0c             	sub    $0xc,%esp
  8028ee:	6a 00                	push   $0x0
  8028f0:	e8 e5 eb ff ff       	call   8014da <sbrk>
  8028f5:	83 c4 10             	add    $0x10,%esp
  8028f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028fe:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802901:	83 ec 08             	sub    $0x8,%esp
  802904:	50                   	push   %eax
  802905:	ff 75 d8             	pushl  -0x28(%ebp)
  802908:	e8 9f f8 ff ff       	call   8021ac <initialize_dynamic_allocator>
  80290d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802910:	83 ec 0c             	sub    $0xc,%esp
  802913:	68 af 45 80 00       	push   $0x8045af
  802918:	e8 23 de ff ff       	call   800740 <cprintf>
  80291d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802920:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802927:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80292e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802935:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80293c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802941:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802944:	e9 1d 01 00 00       	jmp    802a66 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80294f:	83 ec 0c             	sub    $0xc,%esp
  802952:	ff 75 a8             	pushl  -0x58(%ebp)
  802955:	e8 ee f6 ff ff       	call   802048 <get_block_size>
  80295a:	83 c4 10             	add    $0x10,%esp
  80295d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	83 c0 08             	add    $0x8,%eax
  802966:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802969:	0f 87 ef 00 00 00    	ja     802a5e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	83 c0 18             	add    $0x18,%eax
  802975:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802978:	77 1d                	ja     802997 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802980:	0f 86 d8 00 00 00    	jbe    802a5e <alloc_block_BF+0x1da>
				{
					best_va = va;
  802986:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802989:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80298c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80298f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802992:	e9 c7 00 00 00       	jmp    802a5e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802997:	8b 45 08             	mov    0x8(%ebp),%eax
  80299a:	83 c0 08             	add    $0x8,%eax
  80299d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029a0:	0f 85 9d 00 00 00    	jne    802a43 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029a6:	83 ec 04             	sub    $0x4,%esp
  8029a9:	6a 01                	push   $0x1
  8029ab:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029ae:	ff 75 a8             	pushl  -0x58(%ebp)
  8029b1:	e8 e3 f9 ff ff       	call   802399 <set_block_data>
  8029b6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bd:	75 17                	jne    8029d6 <alloc_block_BF+0x152>
  8029bf:	83 ec 04             	sub    $0x4,%esp
  8029c2:	68 53 45 80 00       	push   $0x804553
  8029c7:	68 2c 01 00 00       	push   $0x12c
  8029cc:	68 71 45 80 00       	push   $0x804571
  8029d1:	e8 0b 11 00 00       	call   803ae1 <_panic>
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 10                	je     8029ef <alloc_block_BF+0x16b>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e7:	8b 52 04             	mov    0x4(%edx),%edx
  8029ea:	89 50 04             	mov    %edx,0x4(%eax)
  8029ed:	eb 0b                	jmp    8029fa <alloc_block_BF+0x176>
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 40 04             	mov    0x4(%eax),%eax
  8029f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	8b 40 04             	mov    0x4(%eax),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	74 0f                	je     802a13 <alloc_block_BF+0x18f>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 40 04             	mov    0x4(%eax),%eax
  802a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0d:	8b 12                	mov    (%edx),%edx
  802a0f:	89 10                	mov    %edx,(%eax)
  802a11:	eb 0a                	jmp    802a1d <alloc_block_BF+0x199>
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 00                	mov    (%eax),%eax
  802a18:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a30:	a1 38 50 80 00       	mov    0x805038,%eax
  802a35:	48                   	dec    %eax
  802a36:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a3b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a3e:	e9 24 04 00 00       	jmp    802e67 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a46:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a49:	76 13                	jbe    802a5e <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a4b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a52:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a58:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a5e:	a1 34 50 80 00       	mov    0x805034,%eax
  802a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6a:	74 07                	je     802a73 <alloc_block_BF+0x1ef>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	eb 05                	jmp    802a78 <alloc_block_BF+0x1f4>
  802a73:	b8 00 00 00 00       	mov    $0x0,%eax
  802a78:	a3 34 50 80 00       	mov    %eax,0x805034
  802a7d:	a1 34 50 80 00       	mov    0x805034,%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	0f 85 bf fe ff ff    	jne    802949 <alloc_block_BF+0xc5>
  802a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8e:	0f 85 b5 fe ff ff    	jne    802949 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a98:	0f 84 26 02 00 00    	je     802cc4 <alloc_block_BF+0x440>
  802a9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aa2:	0f 85 1c 02 00 00    	jne    802cc4 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aab:	2b 45 08             	sub    0x8(%ebp),%eax
  802aae:	83 e8 08             	sub    $0x8,%eax
  802ab1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	8d 50 08             	lea    0x8(%eax),%edx
  802aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abd:	01 d0                	add    %edx,%eax
  802abf:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	83 c0 08             	add    $0x8,%eax
  802ac8:	83 ec 04             	sub    $0x4,%esp
  802acb:	6a 01                	push   $0x1
  802acd:	50                   	push   %eax
  802ace:	ff 75 f0             	pushl  -0x10(%ebp)
  802ad1:	e8 c3 f8 ff ff       	call   802399 <set_block_data>
  802ad6:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	75 68                	jne    802b4b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ae3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ae7:	75 17                	jne    802b00 <alloc_block_BF+0x27c>
  802ae9:	83 ec 04             	sub    $0x4,%esp
  802aec:	68 8c 45 80 00       	push   $0x80458c
  802af1:	68 45 01 00 00       	push   $0x145
  802af6:	68 71 45 80 00       	push   $0x804571
  802afb:	e8 e1 0f 00 00       	call   803ae1 <_panic>
  802b00:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b09:	89 10                	mov    %edx,(%eax)
  802b0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 0d                	je     802b21 <alloc_block_BF+0x29d>
  802b14:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b19:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b1c:	89 50 04             	mov    %edx,0x4(%eax)
  802b1f:	eb 08                	jmp    802b29 <alloc_block_BF+0x2a5>
  802b21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b24:	a3 30 50 80 00       	mov    %eax,0x805030
  802b29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3b:	a1 38 50 80 00       	mov    0x805038,%eax
  802b40:	40                   	inc    %eax
  802b41:	a3 38 50 80 00       	mov    %eax,0x805038
  802b46:	e9 dc 00 00 00       	jmp    802c27 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	85 c0                	test   %eax,%eax
  802b52:	75 65                	jne    802bb9 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b54:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b58:	75 17                	jne    802b71 <alloc_block_BF+0x2ed>
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	68 c0 45 80 00       	push   $0x8045c0
  802b62:	68 4a 01 00 00       	push   $0x14a
  802b67:	68 71 45 80 00       	push   $0x804571
  802b6c:	e8 70 0f 00 00       	call   803ae1 <_panic>
  802b71:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b7a:	89 50 04             	mov    %edx,0x4(%eax)
  802b7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b80:	8b 40 04             	mov    0x4(%eax),%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	74 0c                	je     802b93 <alloc_block_BF+0x30f>
  802b87:	a1 30 50 80 00       	mov    0x805030,%eax
  802b8c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b8f:	89 10                	mov    %edx,(%eax)
  802b91:	eb 08                	jmp    802b9b <alloc_block_BF+0x317>
  802b93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b96:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b9e:	a3 30 50 80 00       	mov    %eax,0x805030
  802ba3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bac:	a1 38 50 80 00       	mov    0x805038,%eax
  802bb1:	40                   	inc    %eax
  802bb2:	a3 38 50 80 00       	mov    %eax,0x805038
  802bb7:	eb 6e                	jmp    802c27 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802bb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bbd:	74 06                	je     802bc5 <alloc_block_BF+0x341>
  802bbf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bc3:	75 17                	jne    802bdc <alloc_block_BF+0x358>
  802bc5:	83 ec 04             	sub    $0x4,%esp
  802bc8:	68 e4 45 80 00       	push   $0x8045e4
  802bcd:	68 4f 01 00 00       	push   $0x14f
  802bd2:	68 71 45 80 00       	push   $0x804571
  802bd7:	e8 05 0f 00 00       	call   803ae1 <_panic>
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	8b 10                	mov    (%eax),%edx
  802be1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be4:	89 10                	mov    %edx,(%eax)
  802be6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 0b                	je     802bfa <alloc_block_BF+0x376>
  802bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bf7:	89 50 04             	mov    %edx,0x4(%eax)
  802bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c00:	89 10                	mov    %edx,(%eax)
  802c02:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c08:	89 50 04             	mov    %edx,0x4(%eax)
  802c0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	75 08                	jne    802c1c <alloc_block_BF+0x398>
  802c14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c17:	a3 30 50 80 00       	mov    %eax,0x805030
  802c1c:	a1 38 50 80 00       	mov    0x805038,%eax
  802c21:	40                   	inc    %eax
  802c22:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c2b:	75 17                	jne    802c44 <alloc_block_BF+0x3c0>
  802c2d:	83 ec 04             	sub    $0x4,%esp
  802c30:	68 53 45 80 00       	push   $0x804553
  802c35:	68 51 01 00 00       	push   $0x151
  802c3a:	68 71 45 80 00       	push   $0x804571
  802c3f:	e8 9d 0e 00 00       	call   803ae1 <_panic>
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 10                	je     802c5d <alloc_block_BF+0x3d9>
  802c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c55:	8b 52 04             	mov    0x4(%edx),%edx
  802c58:	89 50 04             	mov    %edx,0x4(%eax)
  802c5b:	eb 0b                	jmp    802c68 <alloc_block_BF+0x3e4>
  802c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c60:	8b 40 04             	mov    0x4(%eax),%eax
  802c63:	a3 30 50 80 00       	mov    %eax,0x805030
  802c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 0f                	je     802c81 <alloc_block_BF+0x3fd>
  802c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c75:	8b 40 04             	mov    0x4(%eax),%eax
  802c78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7b:	8b 12                	mov    (%edx),%edx
  802c7d:	89 10                	mov    %edx,(%eax)
  802c7f:	eb 0a                	jmp    802c8b <alloc_block_BF+0x407>
  802c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9e:	a1 38 50 80 00       	mov    0x805038,%eax
  802ca3:	48                   	dec    %eax
  802ca4:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ca9:	83 ec 04             	sub    $0x4,%esp
  802cac:	6a 00                	push   $0x0
  802cae:	ff 75 d0             	pushl  -0x30(%ebp)
  802cb1:	ff 75 cc             	pushl  -0x34(%ebp)
  802cb4:	e8 e0 f6 ff ff       	call   802399 <set_block_data>
  802cb9:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbf:	e9 a3 01 00 00       	jmp    802e67 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802cc4:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802cc8:	0f 85 9d 00 00 00    	jne    802d6b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	6a 01                	push   $0x1
  802cd3:	ff 75 ec             	pushl  -0x14(%ebp)
  802cd6:	ff 75 f0             	pushl  -0x10(%ebp)
  802cd9:	e8 bb f6 ff ff       	call   802399 <set_block_data>
  802cde:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ce1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce5:	75 17                	jne    802cfe <alloc_block_BF+0x47a>
  802ce7:	83 ec 04             	sub    $0x4,%esp
  802cea:	68 53 45 80 00       	push   $0x804553
  802cef:	68 58 01 00 00       	push   $0x158
  802cf4:	68 71 45 80 00       	push   $0x804571
  802cf9:	e8 e3 0d 00 00       	call   803ae1 <_panic>
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	74 10                	je     802d17 <alloc_block_BF+0x493>
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0f:	8b 52 04             	mov    0x4(%edx),%edx
  802d12:	89 50 04             	mov    %edx,0x4(%eax)
  802d15:	eb 0b                	jmp    802d22 <alloc_block_BF+0x49e>
  802d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1a:	8b 40 04             	mov    0x4(%eax),%eax
  802d1d:	a3 30 50 80 00       	mov    %eax,0x805030
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 0f                	je     802d3b <alloc_block_BF+0x4b7>
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d35:	8b 12                	mov    (%edx),%edx
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	eb 0a                	jmp    802d45 <alloc_block_BF+0x4c1>
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d58:	a1 38 50 80 00       	mov    0x805038,%eax
  802d5d:	48                   	dec    %eax
  802d5e:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	e9 fc 00 00 00       	jmp    802e67 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	83 c0 08             	add    $0x8,%eax
  802d71:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d74:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d7b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d81:	01 d0                	add    %edx,%eax
  802d83:	48                   	dec    %eax
  802d84:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d87:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d8f:	f7 75 c4             	divl   -0x3c(%ebp)
  802d92:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d95:	29 d0                	sub    %edx,%eax
  802d97:	c1 e8 0c             	shr    $0xc,%eax
  802d9a:	83 ec 0c             	sub    $0xc,%esp
  802d9d:	50                   	push   %eax
  802d9e:	e8 37 e7 ff ff       	call   8014da <sbrk>
  802da3:	83 c4 10             	add    $0x10,%esp
  802da6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802da9:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802dad:	75 0a                	jne    802db9 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802daf:	b8 00 00 00 00       	mov    $0x0,%eax
  802db4:	e9 ae 00 00 00       	jmp    802e67 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802db9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802dc0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dc3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802dc6:	01 d0                	add    %edx,%eax
  802dc8:	48                   	dec    %eax
  802dc9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802dcc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd4:	f7 75 b8             	divl   -0x48(%ebp)
  802dd7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dda:	29 d0                	sub    %edx,%eax
  802ddc:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ddf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802de2:	01 d0                	add    %edx,%eax
  802de4:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802de9:	a1 40 50 80 00       	mov    0x805040,%eax
  802dee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802df4:	83 ec 0c             	sub    $0xc,%esp
  802df7:	68 18 46 80 00       	push   $0x804618
  802dfc:	e8 3f d9 ff ff       	call   800740 <cprintf>
  802e01:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e04:	83 ec 08             	sub    $0x8,%esp
  802e07:	ff 75 bc             	pushl  -0x44(%ebp)
  802e0a:	68 1d 46 80 00       	push   $0x80461d
  802e0f:	e8 2c d9 ff ff       	call   800740 <cprintf>
  802e14:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e17:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e1e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e21:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e24:	01 d0                	add    %edx,%eax
  802e26:	48                   	dec    %eax
  802e27:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e2a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e2d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e32:	f7 75 b0             	divl   -0x50(%ebp)
  802e35:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e38:	29 d0                	sub    %edx,%eax
  802e3a:	83 ec 04             	sub    $0x4,%esp
  802e3d:	6a 01                	push   $0x1
  802e3f:	50                   	push   %eax
  802e40:	ff 75 bc             	pushl  -0x44(%ebp)
  802e43:	e8 51 f5 ff ff       	call   802399 <set_block_data>
  802e48:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e4b:	83 ec 0c             	sub    $0xc,%esp
  802e4e:	ff 75 bc             	pushl  -0x44(%ebp)
  802e51:	e8 36 04 00 00       	call   80328c <free_block>
  802e56:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e59:	83 ec 0c             	sub    $0xc,%esp
  802e5c:	ff 75 08             	pushl  0x8(%ebp)
  802e5f:	e8 20 fa ff ff       	call   802884 <alloc_block_BF>
  802e64:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e67:	c9                   	leave  
  802e68:	c3                   	ret    

00802e69 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e69:	55                   	push   %ebp
  802e6a:	89 e5                	mov    %esp,%ebp
  802e6c:	53                   	push   %ebx
  802e6d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e82:	74 1e                	je     802ea2 <merging+0x39>
  802e84:	ff 75 08             	pushl  0x8(%ebp)
  802e87:	e8 bc f1 ff ff       	call   802048 <get_block_size>
  802e8c:	83 c4 04             	add    $0x4,%esp
  802e8f:	89 c2                	mov    %eax,%edx
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	01 d0                	add    %edx,%eax
  802e96:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e99:	75 07                	jne    802ea2 <merging+0x39>
		prev_is_free = 1;
  802e9b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ea6:	74 1e                	je     802ec6 <merging+0x5d>
  802ea8:	ff 75 10             	pushl  0x10(%ebp)
  802eab:	e8 98 f1 ff ff       	call   802048 <get_block_size>
  802eb0:	83 c4 04             	add    $0x4,%esp
  802eb3:	89 c2                	mov    %eax,%edx
  802eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  802eb8:	01 d0                	add    %edx,%eax
  802eba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ebd:	75 07                	jne    802ec6 <merging+0x5d>
		next_is_free = 1;
  802ebf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eca:	0f 84 cc 00 00 00    	je     802f9c <merging+0x133>
  802ed0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed4:	0f 84 c2 00 00 00    	je     802f9c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802eda:	ff 75 08             	pushl  0x8(%ebp)
  802edd:	e8 66 f1 ff ff       	call   802048 <get_block_size>
  802ee2:	83 c4 04             	add    $0x4,%esp
  802ee5:	89 c3                	mov    %eax,%ebx
  802ee7:	ff 75 10             	pushl  0x10(%ebp)
  802eea:	e8 59 f1 ff ff       	call   802048 <get_block_size>
  802eef:	83 c4 04             	add    $0x4,%esp
  802ef2:	01 c3                	add    %eax,%ebx
  802ef4:	ff 75 0c             	pushl  0xc(%ebp)
  802ef7:	e8 4c f1 ff ff       	call   802048 <get_block_size>
  802efc:	83 c4 04             	add    $0x4,%esp
  802eff:	01 d8                	add    %ebx,%eax
  802f01:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f04:	6a 00                	push   $0x0
  802f06:	ff 75 ec             	pushl  -0x14(%ebp)
  802f09:	ff 75 08             	pushl  0x8(%ebp)
  802f0c:	e8 88 f4 ff ff       	call   802399 <set_block_data>
  802f11:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f18:	75 17                	jne    802f31 <merging+0xc8>
  802f1a:	83 ec 04             	sub    $0x4,%esp
  802f1d:	68 53 45 80 00       	push   $0x804553
  802f22:	68 7d 01 00 00       	push   $0x17d
  802f27:	68 71 45 80 00       	push   $0x804571
  802f2c:	e8 b0 0b 00 00       	call   803ae1 <_panic>
  802f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	85 c0                	test   %eax,%eax
  802f38:	74 10                	je     802f4a <merging+0xe1>
  802f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3d:	8b 00                	mov    (%eax),%eax
  802f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f42:	8b 52 04             	mov    0x4(%edx),%edx
  802f45:	89 50 04             	mov    %edx,0x4(%eax)
  802f48:	eb 0b                	jmp    802f55 <merging+0xec>
  802f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4d:	8b 40 04             	mov    0x4(%eax),%eax
  802f50:	a3 30 50 80 00       	mov    %eax,0x805030
  802f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f58:	8b 40 04             	mov    0x4(%eax),%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	74 0f                	je     802f6e <merging+0x105>
  802f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f62:	8b 40 04             	mov    0x4(%eax),%eax
  802f65:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f68:	8b 12                	mov    (%edx),%edx
  802f6a:	89 10                	mov    %edx,(%eax)
  802f6c:	eb 0a                	jmp    802f78 <merging+0x10f>
  802f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f90:	48                   	dec    %eax
  802f91:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f96:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f97:	e9 ea 02 00 00       	jmp    803286 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa0:	74 3b                	je     802fdd <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802fa2:	83 ec 0c             	sub    $0xc,%esp
  802fa5:	ff 75 08             	pushl  0x8(%ebp)
  802fa8:	e8 9b f0 ff ff       	call   802048 <get_block_size>
  802fad:	83 c4 10             	add    $0x10,%esp
  802fb0:	89 c3                	mov    %eax,%ebx
  802fb2:	83 ec 0c             	sub    $0xc,%esp
  802fb5:	ff 75 10             	pushl  0x10(%ebp)
  802fb8:	e8 8b f0 ff ff       	call   802048 <get_block_size>
  802fbd:	83 c4 10             	add    $0x10,%esp
  802fc0:	01 d8                	add    %ebx,%eax
  802fc2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fc5:	83 ec 04             	sub    $0x4,%esp
  802fc8:	6a 00                	push   $0x0
  802fca:	ff 75 e8             	pushl  -0x18(%ebp)
  802fcd:	ff 75 08             	pushl  0x8(%ebp)
  802fd0:	e8 c4 f3 ff ff       	call   802399 <set_block_data>
  802fd5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fd8:	e9 a9 02 00 00       	jmp    803286 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802fdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe1:	0f 84 2d 01 00 00    	je     803114 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802fe7:	83 ec 0c             	sub    $0xc,%esp
  802fea:	ff 75 10             	pushl  0x10(%ebp)
  802fed:	e8 56 f0 ff ff       	call   802048 <get_block_size>
  802ff2:	83 c4 10             	add    $0x10,%esp
  802ff5:	89 c3                	mov    %eax,%ebx
  802ff7:	83 ec 0c             	sub    $0xc,%esp
  802ffa:	ff 75 0c             	pushl  0xc(%ebp)
  802ffd:	e8 46 f0 ff ff       	call   802048 <get_block_size>
  803002:	83 c4 10             	add    $0x10,%esp
  803005:	01 d8                	add    %ebx,%eax
  803007:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80300a:	83 ec 04             	sub    $0x4,%esp
  80300d:	6a 00                	push   $0x0
  80300f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803012:	ff 75 10             	pushl  0x10(%ebp)
  803015:	e8 7f f3 ff ff       	call   802399 <set_block_data>
  80301a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80301d:	8b 45 10             	mov    0x10(%ebp),%eax
  803020:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803023:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803027:	74 06                	je     80302f <merging+0x1c6>
  803029:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80302d:	75 17                	jne    803046 <merging+0x1dd>
  80302f:	83 ec 04             	sub    $0x4,%esp
  803032:	68 2c 46 80 00       	push   $0x80462c
  803037:	68 8d 01 00 00       	push   $0x18d
  80303c:	68 71 45 80 00       	push   $0x804571
  803041:	e8 9b 0a 00 00       	call   803ae1 <_panic>
  803046:	8b 45 0c             	mov    0xc(%ebp),%eax
  803049:	8b 50 04             	mov    0x4(%eax),%edx
  80304c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304f:	89 50 04             	mov    %edx,0x4(%eax)
  803052:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803055:	8b 55 0c             	mov    0xc(%ebp),%edx
  803058:	89 10                	mov    %edx,(%eax)
  80305a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305d:	8b 40 04             	mov    0x4(%eax),%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	74 0d                	je     803071 <merging+0x208>
  803064:	8b 45 0c             	mov    0xc(%ebp),%eax
  803067:	8b 40 04             	mov    0x4(%eax),%eax
  80306a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80306d:	89 10                	mov    %edx,(%eax)
  80306f:	eb 08                	jmp    803079 <merging+0x210>
  803071:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803074:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80307c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80307f:	89 50 04             	mov    %edx,0x4(%eax)
  803082:	a1 38 50 80 00       	mov    0x805038,%eax
  803087:	40                   	inc    %eax
  803088:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80308d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803091:	75 17                	jne    8030aa <merging+0x241>
  803093:	83 ec 04             	sub    $0x4,%esp
  803096:	68 53 45 80 00       	push   $0x804553
  80309b:	68 8e 01 00 00       	push   $0x18e
  8030a0:	68 71 45 80 00       	push   $0x804571
  8030a5:	e8 37 0a 00 00       	call   803ae1 <_panic>
  8030aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	85 c0                	test   %eax,%eax
  8030b1:	74 10                	je     8030c3 <merging+0x25a>
  8030b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b6:	8b 00                	mov    (%eax),%eax
  8030b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030bb:	8b 52 04             	mov    0x4(%edx),%edx
  8030be:	89 50 04             	mov    %edx,0x4(%eax)
  8030c1:	eb 0b                	jmp    8030ce <merging+0x265>
  8030c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c6:	8b 40 04             	mov    0x4(%eax),%eax
  8030c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d1:	8b 40 04             	mov    0x4(%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 0f                	je     8030e7 <merging+0x27e>
  8030d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030db:	8b 40 04             	mov    0x4(%eax),%eax
  8030de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e1:	8b 12                	mov    (%edx),%edx
  8030e3:	89 10                	mov    %edx,(%eax)
  8030e5:	eb 0a                	jmp    8030f1 <merging+0x288>
  8030e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ea:	8b 00                	mov    (%eax),%eax
  8030ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803104:	a1 38 50 80 00       	mov    0x805038,%eax
  803109:	48                   	dec    %eax
  80310a:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80310f:	e9 72 01 00 00       	jmp    803286 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803114:	8b 45 10             	mov    0x10(%ebp),%eax
  803117:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80311a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311e:	74 79                	je     803199 <merging+0x330>
  803120:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803124:	74 73                	je     803199 <merging+0x330>
  803126:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312a:	74 06                	je     803132 <merging+0x2c9>
  80312c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803130:	75 17                	jne    803149 <merging+0x2e0>
  803132:	83 ec 04             	sub    $0x4,%esp
  803135:	68 e4 45 80 00       	push   $0x8045e4
  80313a:	68 94 01 00 00       	push   $0x194
  80313f:	68 71 45 80 00       	push   $0x804571
  803144:	e8 98 09 00 00       	call   803ae1 <_panic>
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	8b 10                	mov    (%eax),%edx
  80314e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803151:	89 10                	mov    %edx,(%eax)
  803153:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803156:	8b 00                	mov    (%eax),%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	74 0b                	je     803167 <merging+0x2fe>
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803164:	89 50 04             	mov    %edx,0x4(%eax)
  803167:	8b 45 08             	mov    0x8(%ebp),%eax
  80316a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80316d:	89 10                	mov    %edx,(%eax)
  80316f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803172:	8b 55 08             	mov    0x8(%ebp),%edx
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	85 c0                	test   %eax,%eax
  80317f:	75 08                	jne    803189 <merging+0x320>
  803181:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803184:	a3 30 50 80 00       	mov    %eax,0x805030
  803189:	a1 38 50 80 00       	mov    0x805038,%eax
  80318e:	40                   	inc    %eax
  80318f:	a3 38 50 80 00       	mov    %eax,0x805038
  803194:	e9 ce 00 00 00       	jmp    803267 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803199:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319d:	74 65                	je     803204 <merging+0x39b>
  80319f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031a3:	75 17                	jne    8031bc <merging+0x353>
  8031a5:	83 ec 04             	sub    $0x4,%esp
  8031a8:	68 c0 45 80 00       	push   $0x8045c0
  8031ad:	68 95 01 00 00       	push   $0x195
  8031b2:	68 71 45 80 00       	push   $0x804571
  8031b7:	e8 25 09 00 00       	call   803ae1 <_panic>
  8031bc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c5:	89 50 04             	mov    %edx,0x4(%eax)
  8031c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cb:	8b 40 04             	mov    0x4(%eax),%eax
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	74 0c                	je     8031de <merging+0x375>
  8031d2:	a1 30 50 80 00       	mov    0x805030,%eax
  8031d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031da:	89 10                	mov    %edx,(%eax)
  8031dc:	eb 08                	jmp    8031e6 <merging+0x37d>
  8031de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8031ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8031fc:	40                   	inc    %eax
  8031fd:	a3 38 50 80 00       	mov    %eax,0x805038
  803202:	eb 63                	jmp    803267 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803204:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803208:	75 17                	jne    803221 <merging+0x3b8>
  80320a:	83 ec 04             	sub    $0x4,%esp
  80320d:	68 8c 45 80 00       	push   $0x80458c
  803212:	68 98 01 00 00       	push   $0x198
  803217:	68 71 45 80 00       	push   $0x804571
  80321c:	e8 c0 08 00 00       	call   803ae1 <_panic>
  803221:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80322a:	89 10                	mov    %edx,(%eax)
  80322c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	74 0d                	je     803242 <merging+0x3d9>
  803235:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80323a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80323d:	89 50 04             	mov    %edx,0x4(%eax)
  803240:	eb 08                	jmp    80324a <merging+0x3e1>
  803242:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803245:	a3 30 50 80 00       	mov    %eax,0x805030
  80324a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80324d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803252:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803255:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325c:	a1 38 50 80 00       	mov    0x805038,%eax
  803261:	40                   	inc    %eax
  803262:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803267:	83 ec 0c             	sub    $0xc,%esp
  80326a:	ff 75 10             	pushl  0x10(%ebp)
  80326d:	e8 d6 ed ff ff       	call   802048 <get_block_size>
  803272:	83 c4 10             	add    $0x10,%esp
  803275:	83 ec 04             	sub    $0x4,%esp
  803278:	6a 00                	push   $0x0
  80327a:	50                   	push   %eax
  80327b:	ff 75 10             	pushl  0x10(%ebp)
  80327e:	e8 16 f1 ff ff       	call   802399 <set_block_data>
  803283:	83 c4 10             	add    $0x10,%esp
	}
}
  803286:	90                   	nop
  803287:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80328a:	c9                   	leave  
  80328b:	c3                   	ret    

0080328c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80328c:	55                   	push   %ebp
  80328d:	89 e5                	mov    %esp,%ebp
  80328f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803292:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803297:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80329a:	a1 30 50 80 00       	mov    0x805030,%eax
  80329f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032a2:	73 1b                	jae    8032bf <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032a4:	a1 30 50 80 00       	mov    0x805030,%eax
  8032a9:	83 ec 04             	sub    $0x4,%esp
  8032ac:	ff 75 08             	pushl  0x8(%ebp)
  8032af:	6a 00                	push   $0x0
  8032b1:	50                   	push   %eax
  8032b2:	e8 b2 fb ff ff       	call   802e69 <merging>
  8032b7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032ba:	e9 8b 00 00 00       	jmp    80334a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8032bf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c7:	76 18                	jbe    8032e1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8032c9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ce:	83 ec 04             	sub    $0x4,%esp
  8032d1:	ff 75 08             	pushl  0x8(%ebp)
  8032d4:	50                   	push   %eax
  8032d5:	6a 00                	push   $0x0
  8032d7:	e8 8d fb ff ff       	call   802e69 <merging>
  8032dc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032df:	eb 69                	jmp    80334a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032e9:	eb 39                	jmp    803324 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032f1:	73 29                	jae    80331c <free_block+0x90>
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032fb:	76 1f                	jbe    80331c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	8b 00                	mov    (%eax),%eax
  803302:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803305:	83 ec 04             	sub    $0x4,%esp
  803308:	ff 75 08             	pushl  0x8(%ebp)
  80330b:	ff 75 f0             	pushl  -0x10(%ebp)
  80330e:	ff 75 f4             	pushl  -0xc(%ebp)
  803311:	e8 53 fb ff ff       	call   802e69 <merging>
  803316:	83 c4 10             	add    $0x10,%esp
			break;
  803319:	90                   	nop
		}
	}
}
  80331a:	eb 2e                	jmp    80334a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80331c:	a1 34 50 80 00       	mov    0x805034,%eax
  803321:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803328:	74 07                	je     803331 <free_block+0xa5>
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	8b 00                	mov    (%eax),%eax
  80332f:	eb 05                	jmp    803336 <free_block+0xaa>
  803331:	b8 00 00 00 00       	mov    $0x0,%eax
  803336:	a3 34 50 80 00       	mov    %eax,0x805034
  80333b:	a1 34 50 80 00       	mov    0x805034,%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	75 a7                	jne    8032eb <free_block+0x5f>
  803344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803348:	75 a1                	jne    8032eb <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80334a:	90                   	nop
  80334b:	c9                   	leave  
  80334c:	c3                   	ret    

0080334d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80334d:	55                   	push   %ebp
  80334e:	89 e5                	mov    %esp,%ebp
  803350:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803353:	ff 75 08             	pushl  0x8(%ebp)
  803356:	e8 ed ec ff ff       	call   802048 <get_block_size>
  80335b:	83 c4 04             	add    $0x4,%esp
  80335e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803361:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803368:	eb 17                	jmp    803381 <copy_data+0x34>
  80336a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80336d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803370:	01 c2                	add    %eax,%edx
  803372:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	01 c8                	add    %ecx,%eax
  80337a:	8a 00                	mov    (%eax),%al
  80337c:	88 02                	mov    %al,(%edx)
  80337e:	ff 45 fc             	incl   -0x4(%ebp)
  803381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803384:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803387:	72 e1                	jb     80336a <copy_data+0x1d>
}
  803389:	90                   	nop
  80338a:	c9                   	leave  
  80338b:	c3                   	ret    

0080338c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80338c:	55                   	push   %ebp
  80338d:	89 e5                	mov    %esp,%ebp
  80338f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803392:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803396:	75 23                	jne    8033bb <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80339c:	74 13                	je     8033b1 <realloc_block_FF+0x25>
  80339e:	83 ec 0c             	sub    $0xc,%esp
  8033a1:	ff 75 0c             	pushl  0xc(%ebp)
  8033a4:	e8 1f f0 ff ff       	call   8023c8 <alloc_block_FF>
  8033a9:	83 c4 10             	add    $0x10,%esp
  8033ac:	e9 f4 06 00 00       	jmp    803aa5 <realloc_block_FF+0x719>
		return NULL;
  8033b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b6:	e9 ea 06 00 00       	jmp    803aa5 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8033bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033bf:	75 18                	jne    8033d9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8033c1:	83 ec 0c             	sub    $0xc,%esp
  8033c4:	ff 75 08             	pushl  0x8(%ebp)
  8033c7:	e8 c0 fe ff ff       	call   80328c <free_block>
  8033cc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d4:	e9 cc 06 00 00       	jmp    803aa5 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8033d9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033dd:	77 07                	ja     8033e6 <realloc_block_FF+0x5a>
  8033df:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e9:	83 e0 01             	and    $0x1,%eax
  8033ec:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8033ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f2:	83 c0 08             	add    $0x8,%eax
  8033f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8033f8:	83 ec 0c             	sub    $0xc,%esp
  8033fb:	ff 75 08             	pushl  0x8(%ebp)
  8033fe:	e8 45 ec ff ff       	call   802048 <get_block_size>
  803403:	83 c4 10             	add    $0x10,%esp
  803406:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340c:	83 e8 08             	sub    $0x8,%eax
  80340f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	83 e8 04             	sub    $0x4,%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	83 e0 fe             	and    $0xfffffffe,%eax
  80341d:	89 c2                	mov    %eax,%edx
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	01 d0                	add    %edx,%eax
  803424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803427:	83 ec 0c             	sub    $0xc,%esp
  80342a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80342d:	e8 16 ec ff ff       	call   802048 <get_block_size>
  803432:	83 c4 10             	add    $0x10,%esp
  803435:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80343b:	83 e8 08             	sub    $0x8,%eax
  80343e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803441:	8b 45 0c             	mov    0xc(%ebp),%eax
  803444:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803447:	75 08                	jne    803451 <realloc_block_FF+0xc5>
	{
		 return va;
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	e9 54 06 00 00       	jmp    803aa5 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803451:	8b 45 0c             	mov    0xc(%ebp),%eax
  803454:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803457:	0f 83 e5 03 00 00    	jae    803842 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80345d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803460:	2b 45 0c             	sub    0xc(%ebp),%eax
  803463:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803466:	83 ec 0c             	sub    $0xc,%esp
  803469:	ff 75 e4             	pushl  -0x1c(%ebp)
  80346c:	e8 f0 eb ff ff       	call   802061 <is_free_block>
  803471:	83 c4 10             	add    $0x10,%esp
  803474:	84 c0                	test   %al,%al
  803476:	0f 84 3b 01 00 00    	je     8035b7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80347c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80347f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803482:	01 d0                	add    %edx,%eax
  803484:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803487:	83 ec 04             	sub    $0x4,%esp
  80348a:	6a 01                	push   $0x1
  80348c:	ff 75 f0             	pushl  -0x10(%ebp)
  80348f:	ff 75 08             	pushl  0x8(%ebp)
  803492:	e8 02 ef ff ff       	call   802399 <set_block_data>
  803497:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	83 e8 04             	sub    $0x4,%eax
  8034a0:	8b 00                	mov    (%eax),%eax
  8034a2:	83 e0 fe             	and    $0xfffffffe,%eax
  8034a5:	89 c2                	mov    %eax,%edx
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	01 d0                	add    %edx,%eax
  8034ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	6a 00                	push   $0x0
  8034b4:	ff 75 cc             	pushl  -0x34(%ebp)
  8034b7:	ff 75 c8             	pushl  -0x38(%ebp)
  8034ba:	e8 da ee ff ff       	call   802399 <set_block_data>
  8034bf:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034c6:	74 06                	je     8034ce <realloc_block_FF+0x142>
  8034c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034cc:	75 17                	jne    8034e5 <realloc_block_FF+0x159>
  8034ce:	83 ec 04             	sub    $0x4,%esp
  8034d1:	68 e4 45 80 00       	push   $0x8045e4
  8034d6:	68 f6 01 00 00       	push   $0x1f6
  8034db:	68 71 45 80 00       	push   $0x804571
  8034e0:	e8 fc 05 00 00       	call   803ae1 <_panic>
  8034e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e8:	8b 10                	mov    (%eax),%edx
  8034ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034ed:	89 10                	mov    %edx,(%eax)
  8034ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034f2:	8b 00                	mov    (%eax),%eax
  8034f4:	85 c0                	test   %eax,%eax
  8034f6:	74 0b                	je     803503 <realloc_block_FF+0x177>
  8034f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fb:	8b 00                	mov    (%eax),%eax
  8034fd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803500:	89 50 04             	mov    %edx,0x4(%eax)
  803503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803506:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803509:	89 10                	mov    %edx,(%eax)
  80350b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80350e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803511:	89 50 04             	mov    %edx,0x4(%eax)
  803514:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803517:	8b 00                	mov    (%eax),%eax
  803519:	85 c0                	test   %eax,%eax
  80351b:	75 08                	jne    803525 <realloc_block_FF+0x199>
  80351d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803520:	a3 30 50 80 00       	mov    %eax,0x805030
  803525:	a1 38 50 80 00       	mov    0x805038,%eax
  80352a:	40                   	inc    %eax
  80352b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803530:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803534:	75 17                	jne    80354d <realloc_block_FF+0x1c1>
  803536:	83 ec 04             	sub    $0x4,%esp
  803539:	68 53 45 80 00       	push   $0x804553
  80353e:	68 f7 01 00 00       	push   $0x1f7
  803543:	68 71 45 80 00       	push   $0x804571
  803548:	e8 94 05 00 00       	call   803ae1 <_panic>
  80354d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803550:	8b 00                	mov    (%eax),%eax
  803552:	85 c0                	test   %eax,%eax
  803554:	74 10                	je     803566 <realloc_block_FF+0x1da>
  803556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803559:	8b 00                	mov    (%eax),%eax
  80355b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80355e:	8b 52 04             	mov    0x4(%edx),%edx
  803561:	89 50 04             	mov    %edx,0x4(%eax)
  803564:	eb 0b                	jmp    803571 <realloc_block_FF+0x1e5>
  803566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803569:	8b 40 04             	mov    0x4(%eax),%eax
  80356c:	a3 30 50 80 00       	mov    %eax,0x805030
  803571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803574:	8b 40 04             	mov    0x4(%eax),%eax
  803577:	85 c0                	test   %eax,%eax
  803579:	74 0f                	je     80358a <realloc_block_FF+0x1fe>
  80357b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357e:	8b 40 04             	mov    0x4(%eax),%eax
  803581:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803584:	8b 12                	mov    (%edx),%edx
  803586:	89 10                	mov    %edx,(%eax)
  803588:	eb 0a                	jmp    803594 <realloc_block_FF+0x208>
  80358a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358d:	8b 00                	mov    (%eax),%eax
  80358f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803597:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80359d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8035ac:	48                   	dec    %eax
  8035ad:	a3 38 50 80 00       	mov    %eax,0x805038
  8035b2:	e9 83 02 00 00       	jmp    80383a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8035b7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8035bb:	0f 86 69 02 00 00    	jbe    80382a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8035c1:	83 ec 04             	sub    $0x4,%esp
  8035c4:	6a 01                	push   $0x1
  8035c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8035c9:	ff 75 08             	pushl  0x8(%ebp)
  8035cc:	e8 c8 ed ff ff       	call   802399 <set_block_data>
  8035d1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	83 e8 04             	sub    $0x4,%eax
  8035da:	8b 00                	mov    (%eax),%eax
  8035dc:	83 e0 fe             	and    $0xfffffffe,%eax
  8035df:	89 c2                	mov    %eax,%edx
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	01 d0                	add    %edx,%eax
  8035e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8035f1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8035f5:	75 68                	jne    80365f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035fb:	75 17                	jne    803614 <realloc_block_FF+0x288>
  8035fd:	83 ec 04             	sub    $0x4,%esp
  803600:	68 8c 45 80 00       	push   $0x80458c
  803605:	68 06 02 00 00       	push   $0x206
  80360a:	68 71 45 80 00       	push   $0x804571
  80360f:	e8 cd 04 00 00       	call   803ae1 <_panic>
  803614:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80361a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361d:	89 10                	mov    %edx,(%eax)
  80361f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803622:	8b 00                	mov    (%eax),%eax
  803624:	85 c0                	test   %eax,%eax
  803626:	74 0d                	je     803635 <realloc_block_FF+0x2a9>
  803628:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80362d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803630:	89 50 04             	mov    %edx,0x4(%eax)
  803633:	eb 08                	jmp    80363d <realloc_block_FF+0x2b1>
  803635:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803638:	a3 30 50 80 00       	mov    %eax,0x805030
  80363d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803640:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803645:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803648:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364f:	a1 38 50 80 00       	mov    0x805038,%eax
  803654:	40                   	inc    %eax
  803655:	a3 38 50 80 00       	mov    %eax,0x805038
  80365a:	e9 b0 01 00 00       	jmp    80380f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80365f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803664:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803667:	76 68                	jbe    8036d1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803669:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80366d:	75 17                	jne    803686 <realloc_block_FF+0x2fa>
  80366f:	83 ec 04             	sub    $0x4,%esp
  803672:	68 8c 45 80 00       	push   $0x80458c
  803677:	68 0b 02 00 00       	push   $0x20b
  80367c:	68 71 45 80 00       	push   $0x804571
  803681:	e8 5b 04 00 00       	call   803ae1 <_panic>
  803686:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80368c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368f:	89 10                	mov    %edx,(%eax)
  803691:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803694:	8b 00                	mov    (%eax),%eax
  803696:	85 c0                	test   %eax,%eax
  803698:	74 0d                	je     8036a7 <realloc_block_FF+0x31b>
  80369a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80369f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a2:	89 50 04             	mov    %edx,0x4(%eax)
  8036a5:	eb 08                	jmp    8036af <realloc_block_FF+0x323>
  8036a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8036af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c6:	40                   	inc    %eax
  8036c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8036cc:	e9 3e 01 00 00       	jmp    80380f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036d6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036d9:	73 68                	jae    803743 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036df:	75 17                	jne    8036f8 <realloc_block_FF+0x36c>
  8036e1:	83 ec 04             	sub    $0x4,%esp
  8036e4:	68 c0 45 80 00       	push   $0x8045c0
  8036e9:	68 10 02 00 00       	push   $0x210
  8036ee:	68 71 45 80 00       	push   $0x804571
  8036f3:	e8 e9 03 00 00       	call   803ae1 <_panic>
  8036f8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803701:	89 50 04             	mov    %edx,0x4(%eax)
  803704:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803707:	8b 40 04             	mov    0x4(%eax),%eax
  80370a:	85 c0                	test   %eax,%eax
  80370c:	74 0c                	je     80371a <realloc_block_FF+0x38e>
  80370e:	a1 30 50 80 00       	mov    0x805030,%eax
  803713:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803716:	89 10                	mov    %edx,(%eax)
  803718:	eb 08                	jmp    803722 <realloc_block_FF+0x396>
  80371a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803722:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803725:	a3 30 50 80 00       	mov    %eax,0x805030
  80372a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803733:	a1 38 50 80 00       	mov    0x805038,%eax
  803738:	40                   	inc    %eax
  803739:	a3 38 50 80 00       	mov    %eax,0x805038
  80373e:	e9 cc 00 00 00       	jmp    80380f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803743:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80374a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80374f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803752:	e9 8a 00 00 00       	jmp    8037e1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80375d:	73 7a                	jae    8037d9 <realloc_block_FF+0x44d>
  80375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803762:	8b 00                	mov    (%eax),%eax
  803764:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803767:	73 70                	jae    8037d9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80376d:	74 06                	je     803775 <realloc_block_FF+0x3e9>
  80376f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803773:	75 17                	jne    80378c <realloc_block_FF+0x400>
  803775:	83 ec 04             	sub    $0x4,%esp
  803778:	68 e4 45 80 00       	push   $0x8045e4
  80377d:	68 1a 02 00 00       	push   $0x21a
  803782:	68 71 45 80 00       	push   $0x804571
  803787:	e8 55 03 00 00       	call   803ae1 <_panic>
  80378c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378f:	8b 10                	mov    (%eax),%edx
  803791:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803794:	89 10                	mov    %edx,(%eax)
  803796:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803799:	8b 00                	mov    (%eax),%eax
  80379b:	85 c0                	test   %eax,%eax
  80379d:	74 0b                	je     8037aa <realloc_block_FF+0x41e>
  80379f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a2:	8b 00                	mov    (%eax),%eax
  8037a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037a7:	89 50 04             	mov    %edx,0x4(%eax)
  8037aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037b0:	89 10                	mov    %edx,(%eax)
  8037b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037b8:	89 50 04             	mov    %edx,0x4(%eax)
  8037bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037be:	8b 00                	mov    (%eax),%eax
  8037c0:	85 c0                	test   %eax,%eax
  8037c2:	75 08                	jne    8037cc <realloc_block_FF+0x440>
  8037c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8037cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d1:	40                   	inc    %eax
  8037d2:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8037d7:	eb 36                	jmp    80380f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037d9:	a1 34 50 80 00       	mov    0x805034,%eax
  8037de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e5:	74 07                	je     8037ee <realloc_block_FF+0x462>
  8037e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ea:	8b 00                	mov    (%eax),%eax
  8037ec:	eb 05                	jmp    8037f3 <realloc_block_FF+0x467>
  8037ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f3:	a3 34 50 80 00       	mov    %eax,0x805034
  8037f8:	a1 34 50 80 00       	mov    0x805034,%eax
  8037fd:	85 c0                	test   %eax,%eax
  8037ff:	0f 85 52 ff ff ff    	jne    803757 <realloc_block_FF+0x3cb>
  803805:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803809:	0f 85 48 ff ff ff    	jne    803757 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80380f:	83 ec 04             	sub    $0x4,%esp
  803812:	6a 00                	push   $0x0
  803814:	ff 75 d8             	pushl  -0x28(%ebp)
  803817:	ff 75 d4             	pushl  -0x2c(%ebp)
  80381a:	e8 7a eb ff ff       	call   802399 <set_block_data>
  80381f:	83 c4 10             	add    $0x10,%esp
				return va;
  803822:	8b 45 08             	mov    0x8(%ebp),%eax
  803825:	e9 7b 02 00 00       	jmp    803aa5 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80382a:	83 ec 0c             	sub    $0xc,%esp
  80382d:	68 61 46 80 00       	push   $0x804661
  803832:	e8 09 cf ff ff       	call   800740 <cprintf>
  803837:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	e9 63 02 00 00       	jmp    803aa5 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803842:	8b 45 0c             	mov    0xc(%ebp),%eax
  803845:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803848:	0f 86 4d 02 00 00    	jbe    803a9b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80384e:	83 ec 0c             	sub    $0xc,%esp
  803851:	ff 75 e4             	pushl  -0x1c(%ebp)
  803854:	e8 08 e8 ff ff       	call   802061 <is_free_block>
  803859:	83 c4 10             	add    $0x10,%esp
  80385c:	84 c0                	test   %al,%al
  80385e:	0f 84 37 02 00 00    	je     803a9b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803864:	8b 45 0c             	mov    0xc(%ebp),%eax
  803867:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80386a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80386d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803870:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803873:	76 38                	jbe    8038ad <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803875:	83 ec 0c             	sub    $0xc,%esp
  803878:	ff 75 08             	pushl  0x8(%ebp)
  80387b:	e8 0c fa ff ff       	call   80328c <free_block>
  803880:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803883:	83 ec 0c             	sub    $0xc,%esp
  803886:	ff 75 0c             	pushl  0xc(%ebp)
  803889:	e8 3a eb ff ff       	call   8023c8 <alloc_block_FF>
  80388e:	83 c4 10             	add    $0x10,%esp
  803891:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803894:	83 ec 08             	sub    $0x8,%esp
  803897:	ff 75 c0             	pushl  -0x40(%ebp)
  80389a:	ff 75 08             	pushl  0x8(%ebp)
  80389d:	e8 ab fa ff ff       	call   80334d <copy_data>
  8038a2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8038a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038a8:	e9 f8 01 00 00       	jmp    803aa5 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038b3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038b6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8038ba:	0f 87 a0 00 00 00    	ja     803960 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8038c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c4:	75 17                	jne    8038dd <realloc_block_FF+0x551>
  8038c6:	83 ec 04             	sub    $0x4,%esp
  8038c9:	68 53 45 80 00       	push   $0x804553
  8038ce:	68 38 02 00 00       	push   $0x238
  8038d3:	68 71 45 80 00       	push   $0x804571
  8038d8:	e8 04 02 00 00       	call   803ae1 <_panic>
  8038dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	85 c0                	test   %eax,%eax
  8038e4:	74 10                	je     8038f6 <realloc_block_FF+0x56a>
  8038e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e9:	8b 00                	mov    (%eax),%eax
  8038eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ee:	8b 52 04             	mov    0x4(%edx),%edx
  8038f1:	89 50 04             	mov    %edx,0x4(%eax)
  8038f4:	eb 0b                	jmp    803901 <realloc_block_FF+0x575>
  8038f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f9:	8b 40 04             	mov    0x4(%eax),%eax
  8038fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	8b 40 04             	mov    0x4(%eax),%eax
  803907:	85 c0                	test   %eax,%eax
  803909:	74 0f                	je     80391a <realloc_block_FF+0x58e>
  80390b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390e:	8b 40 04             	mov    0x4(%eax),%eax
  803911:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803914:	8b 12                	mov    (%edx),%edx
  803916:	89 10                	mov    %edx,(%eax)
  803918:	eb 0a                	jmp    803924 <realloc_block_FF+0x598>
  80391a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803927:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80392d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803930:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803937:	a1 38 50 80 00       	mov    0x805038,%eax
  80393c:	48                   	dec    %eax
  80393d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803942:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803945:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803948:	01 d0                	add    %edx,%eax
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	6a 01                	push   $0x1
  80394f:	50                   	push   %eax
  803950:	ff 75 08             	pushl  0x8(%ebp)
  803953:	e8 41 ea ff ff       	call   802399 <set_block_data>
  803958:	83 c4 10             	add    $0x10,%esp
  80395b:	e9 36 01 00 00       	jmp    803a96 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803960:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803963:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803966:	01 d0                	add    %edx,%eax
  803968:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80396b:	83 ec 04             	sub    $0x4,%esp
  80396e:	6a 01                	push   $0x1
  803970:	ff 75 f0             	pushl  -0x10(%ebp)
  803973:	ff 75 08             	pushl  0x8(%ebp)
  803976:	e8 1e ea ff ff       	call   802399 <set_block_data>
  80397b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80397e:	8b 45 08             	mov    0x8(%ebp),%eax
  803981:	83 e8 04             	sub    $0x4,%eax
  803984:	8b 00                	mov    (%eax),%eax
  803986:	83 e0 fe             	and    $0xfffffffe,%eax
  803989:	89 c2                	mov    %eax,%edx
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	01 d0                	add    %edx,%eax
  803990:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803993:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803997:	74 06                	je     80399f <realloc_block_FF+0x613>
  803999:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80399d:	75 17                	jne    8039b6 <realloc_block_FF+0x62a>
  80399f:	83 ec 04             	sub    $0x4,%esp
  8039a2:	68 e4 45 80 00       	push   $0x8045e4
  8039a7:	68 44 02 00 00       	push   $0x244
  8039ac:	68 71 45 80 00       	push   $0x804571
  8039b1:	e8 2b 01 00 00       	call   803ae1 <_panic>
  8039b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b9:	8b 10                	mov    (%eax),%edx
  8039bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039be:	89 10                	mov    %edx,(%eax)
  8039c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039c3:	8b 00                	mov    (%eax),%eax
  8039c5:	85 c0                	test   %eax,%eax
  8039c7:	74 0b                	je     8039d4 <realloc_block_FF+0x648>
  8039c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cc:	8b 00                	mov    (%eax),%eax
  8039ce:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039d1:	89 50 04             	mov    %edx,0x4(%eax)
  8039d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039da:	89 10                	mov    %edx,(%eax)
  8039dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e2:	89 50 04             	mov    %edx,0x4(%eax)
  8039e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039e8:	8b 00                	mov    (%eax),%eax
  8039ea:	85 c0                	test   %eax,%eax
  8039ec:	75 08                	jne    8039f6 <realloc_block_FF+0x66a>
  8039ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8039f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8039fb:	40                   	inc    %eax
  8039fc:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a05:	75 17                	jne    803a1e <realloc_block_FF+0x692>
  803a07:	83 ec 04             	sub    $0x4,%esp
  803a0a:	68 53 45 80 00       	push   $0x804553
  803a0f:	68 45 02 00 00       	push   $0x245
  803a14:	68 71 45 80 00       	push   $0x804571
  803a19:	e8 c3 00 00 00       	call   803ae1 <_panic>
  803a1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a21:	8b 00                	mov    (%eax),%eax
  803a23:	85 c0                	test   %eax,%eax
  803a25:	74 10                	je     803a37 <realloc_block_FF+0x6ab>
  803a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2a:	8b 00                	mov    (%eax),%eax
  803a2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2f:	8b 52 04             	mov    0x4(%edx),%edx
  803a32:	89 50 04             	mov    %edx,0x4(%eax)
  803a35:	eb 0b                	jmp    803a42 <realloc_block_FF+0x6b6>
  803a37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3a:	8b 40 04             	mov    0x4(%eax),%eax
  803a3d:	a3 30 50 80 00       	mov    %eax,0x805030
  803a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a45:	8b 40 04             	mov    0x4(%eax),%eax
  803a48:	85 c0                	test   %eax,%eax
  803a4a:	74 0f                	je     803a5b <realloc_block_FF+0x6cf>
  803a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4f:	8b 40 04             	mov    0x4(%eax),%eax
  803a52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a55:	8b 12                	mov    (%edx),%edx
  803a57:	89 10                	mov    %edx,(%eax)
  803a59:	eb 0a                	jmp    803a65 <realloc_block_FF+0x6d9>
  803a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5e:	8b 00                	mov    (%eax),%eax
  803a60:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a78:	a1 38 50 80 00       	mov    0x805038,%eax
  803a7d:	48                   	dec    %eax
  803a7e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a83:	83 ec 04             	sub    $0x4,%esp
  803a86:	6a 00                	push   $0x0
  803a88:	ff 75 bc             	pushl  -0x44(%ebp)
  803a8b:	ff 75 b8             	pushl  -0x48(%ebp)
  803a8e:	e8 06 e9 ff ff       	call   802399 <set_block_data>
  803a93:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a96:	8b 45 08             	mov    0x8(%ebp),%eax
  803a99:	eb 0a                	jmp    803aa5 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a9b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803aa2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803aa5:	c9                   	leave  
  803aa6:	c3                   	ret    

00803aa7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803aa7:	55                   	push   %ebp
  803aa8:	89 e5                	mov    %esp,%ebp
  803aaa:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803aad:	83 ec 04             	sub    $0x4,%esp
  803ab0:	68 68 46 80 00       	push   $0x804668
  803ab5:	68 58 02 00 00       	push   $0x258
  803aba:	68 71 45 80 00       	push   $0x804571
  803abf:	e8 1d 00 00 00       	call   803ae1 <_panic>

00803ac4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ac4:	55                   	push   %ebp
  803ac5:	89 e5                	mov    %esp,%ebp
  803ac7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803aca:	83 ec 04             	sub    $0x4,%esp
  803acd:	68 90 46 80 00       	push   $0x804690
  803ad2:	68 61 02 00 00       	push   $0x261
  803ad7:	68 71 45 80 00       	push   $0x804571
  803adc:	e8 00 00 00 00       	call   803ae1 <_panic>

00803ae1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803ae1:	55                   	push   %ebp
  803ae2:	89 e5                	mov    %esp,%ebp
  803ae4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803ae7:	8d 45 10             	lea    0x10(%ebp),%eax
  803aea:	83 c0 04             	add    $0x4,%eax
  803aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803af0:	a1 60 50 98 00       	mov    0x985060,%eax
  803af5:	85 c0                	test   %eax,%eax
  803af7:	74 16                	je     803b0f <_panic+0x2e>
		cprintf("%s: ", argv0);
  803af9:	a1 60 50 98 00       	mov    0x985060,%eax
  803afe:	83 ec 08             	sub    $0x8,%esp
  803b01:	50                   	push   %eax
  803b02:	68 b8 46 80 00       	push   $0x8046b8
  803b07:	e8 34 cc ff ff       	call   800740 <cprintf>
  803b0c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803b0f:	a1 00 50 80 00       	mov    0x805000,%eax
  803b14:	ff 75 0c             	pushl  0xc(%ebp)
  803b17:	ff 75 08             	pushl  0x8(%ebp)
  803b1a:	50                   	push   %eax
  803b1b:	68 bd 46 80 00       	push   $0x8046bd
  803b20:	e8 1b cc ff ff       	call   800740 <cprintf>
  803b25:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803b28:	8b 45 10             	mov    0x10(%ebp),%eax
  803b2b:	83 ec 08             	sub    $0x8,%esp
  803b2e:	ff 75 f4             	pushl  -0xc(%ebp)
  803b31:	50                   	push   %eax
  803b32:	e8 9e cb ff ff       	call   8006d5 <vcprintf>
  803b37:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803b3a:	83 ec 08             	sub    $0x8,%esp
  803b3d:	6a 00                	push   $0x0
  803b3f:	68 d9 46 80 00       	push   $0x8046d9
  803b44:	e8 8c cb ff ff       	call   8006d5 <vcprintf>
  803b49:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803b4c:	e8 0d cb ff ff       	call   80065e <exit>

	// should not return here
	while (1) ;
  803b51:	eb fe                	jmp    803b51 <_panic+0x70>

00803b53 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803b53:	55                   	push   %ebp
  803b54:	89 e5                	mov    %esp,%ebp
  803b56:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803b59:	a1 20 50 80 00       	mov    0x805020,%eax
  803b5e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b67:	39 c2                	cmp    %eax,%edx
  803b69:	74 14                	je     803b7f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803b6b:	83 ec 04             	sub    $0x4,%esp
  803b6e:	68 dc 46 80 00       	push   $0x8046dc
  803b73:	6a 26                	push   $0x26
  803b75:	68 28 47 80 00       	push   $0x804728
  803b7a:	e8 62 ff ff ff       	call   803ae1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803b86:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b8d:	e9 c5 00 00 00       	jmp    803c57 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9f:	01 d0                	add    %edx,%eax
  803ba1:	8b 00                	mov    (%eax),%eax
  803ba3:	85 c0                	test   %eax,%eax
  803ba5:	75 08                	jne    803baf <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803ba7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803baa:	e9 a5 00 00 00       	jmp    803c54 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803baf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bb6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803bbd:	eb 69                	jmp    803c28 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803bbf:	a1 20 50 80 00       	mov    0x805020,%eax
  803bc4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803bca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bcd:	89 d0                	mov    %edx,%eax
  803bcf:	01 c0                	add    %eax,%eax
  803bd1:	01 d0                	add    %edx,%eax
  803bd3:	c1 e0 03             	shl    $0x3,%eax
  803bd6:	01 c8                	add    %ecx,%eax
  803bd8:	8a 40 04             	mov    0x4(%eax),%al
  803bdb:	84 c0                	test   %al,%al
  803bdd:	75 46                	jne    803c25 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803bdf:	a1 20 50 80 00       	mov    0x805020,%eax
  803be4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803bea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bed:	89 d0                	mov    %edx,%eax
  803bef:	01 c0                	add    %eax,%eax
  803bf1:	01 d0                	add    %edx,%eax
  803bf3:	c1 e0 03             	shl    $0x3,%eax
  803bf6:	01 c8                	add    %ecx,%eax
  803bf8:	8b 00                	mov    (%eax),%eax
  803bfa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803bfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803c05:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c0a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803c11:	8b 45 08             	mov    0x8(%ebp),%eax
  803c14:	01 c8                	add    %ecx,%eax
  803c16:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803c18:	39 c2                	cmp    %eax,%edx
  803c1a:	75 09                	jne    803c25 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803c1c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803c23:	eb 15                	jmp    803c3a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c25:	ff 45 e8             	incl   -0x18(%ebp)
  803c28:	a1 20 50 80 00       	mov    0x805020,%eax
  803c2d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c36:	39 c2                	cmp    %eax,%edx
  803c38:	77 85                	ja     803bbf <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803c3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c3e:	75 14                	jne    803c54 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803c40:	83 ec 04             	sub    $0x4,%esp
  803c43:	68 34 47 80 00       	push   $0x804734
  803c48:	6a 3a                	push   $0x3a
  803c4a:	68 28 47 80 00       	push   $0x804728
  803c4f:	e8 8d fe ff ff       	call   803ae1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803c54:	ff 45 f0             	incl   -0x10(%ebp)
  803c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c5d:	0f 8c 2f ff ff ff    	jl     803b92 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803c63:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803c71:	eb 26                	jmp    803c99 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803c73:	a1 20 50 80 00       	mov    0x805020,%eax
  803c78:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c81:	89 d0                	mov    %edx,%eax
  803c83:	01 c0                	add    %eax,%eax
  803c85:	01 d0                	add    %edx,%eax
  803c87:	c1 e0 03             	shl    $0x3,%eax
  803c8a:	01 c8                	add    %ecx,%eax
  803c8c:	8a 40 04             	mov    0x4(%eax),%al
  803c8f:	3c 01                	cmp    $0x1,%al
  803c91:	75 03                	jne    803c96 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803c93:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c96:	ff 45 e0             	incl   -0x20(%ebp)
  803c99:	a1 20 50 80 00       	mov    0x805020,%eax
  803c9e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ca4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ca7:	39 c2                	cmp    %eax,%edx
  803ca9:	77 c8                	ja     803c73 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cae:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803cb1:	74 14                	je     803cc7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803cb3:	83 ec 04             	sub    $0x4,%esp
  803cb6:	68 88 47 80 00       	push   $0x804788
  803cbb:	6a 44                	push   $0x44
  803cbd:	68 28 47 80 00       	push   $0x804728
  803cc2:	e8 1a fe ff ff       	call   803ae1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803cc7:	90                   	nop
  803cc8:	c9                   	leave  
  803cc9:	c3                   	ret    
  803cca:	66 90                	xchg   %ax,%ax

00803ccc <__udivdi3>:
  803ccc:	55                   	push   %ebp
  803ccd:	57                   	push   %edi
  803cce:	56                   	push   %esi
  803ccf:	53                   	push   %ebx
  803cd0:	83 ec 1c             	sub    $0x1c,%esp
  803cd3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cd7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cdf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ce3:	89 ca                	mov    %ecx,%edx
  803ce5:	89 f8                	mov    %edi,%eax
  803ce7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ceb:	85 f6                	test   %esi,%esi
  803ced:	75 2d                	jne    803d1c <__udivdi3+0x50>
  803cef:	39 cf                	cmp    %ecx,%edi
  803cf1:	77 65                	ja     803d58 <__udivdi3+0x8c>
  803cf3:	89 fd                	mov    %edi,%ebp
  803cf5:	85 ff                	test   %edi,%edi
  803cf7:	75 0b                	jne    803d04 <__udivdi3+0x38>
  803cf9:	b8 01 00 00 00       	mov    $0x1,%eax
  803cfe:	31 d2                	xor    %edx,%edx
  803d00:	f7 f7                	div    %edi
  803d02:	89 c5                	mov    %eax,%ebp
  803d04:	31 d2                	xor    %edx,%edx
  803d06:	89 c8                	mov    %ecx,%eax
  803d08:	f7 f5                	div    %ebp
  803d0a:	89 c1                	mov    %eax,%ecx
  803d0c:	89 d8                	mov    %ebx,%eax
  803d0e:	f7 f5                	div    %ebp
  803d10:	89 cf                	mov    %ecx,%edi
  803d12:	89 fa                	mov    %edi,%edx
  803d14:	83 c4 1c             	add    $0x1c,%esp
  803d17:	5b                   	pop    %ebx
  803d18:	5e                   	pop    %esi
  803d19:	5f                   	pop    %edi
  803d1a:	5d                   	pop    %ebp
  803d1b:	c3                   	ret    
  803d1c:	39 ce                	cmp    %ecx,%esi
  803d1e:	77 28                	ja     803d48 <__udivdi3+0x7c>
  803d20:	0f bd fe             	bsr    %esi,%edi
  803d23:	83 f7 1f             	xor    $0x1f,%edi
  803d26:	75 40                	jne    803d68 <__udivdi3+0x9c>
  803d28:	39 ce                	cmp    %ecx,%esi
  803d2a:	72 0a                	jb     803d36 <__udivdi3+0x6a>
  803d2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d30:	0f 87 9e 00 00 00    	ja     803dd4 <__udivdi3+0x108>
  803d36:	b8 01 00 00 00       	mov    $0x1,%eax
  803d3b:	89 fa                	mov    %edi,%edx
  803d3d:	83 c4 1c             	add    $0x1c,%esp
  803d40:	5b                   	pop    %ebx
  803d41:	5e                   	pop    %esi
  803d42:	5f                   	pop    %edi
  803d43:	5d                   	pop    %ebp
  803d44:	c3                   	ret    
  803d45:	8d 76 00             	lea    0x0(%esi),%esi
  803d48:	31 ff                	xor    %edi,%edi
  803d4a:	31 c0                	xor    %eax,%eax
  803d4c:	89 fa                	mov    %edi,%edx
  803d4e:	83 c4 1c             	add    $0x1c,%esp
  803d51:	5b                   	pop    %ebx
  803d52:	5e                   	pop    %esi
  803d53:	5f                   	pop    %edi
  803d54:	5d                   	pop    %ebp
  803d55:	c3                   	ret    
  803d56:	66 90                	xchg   %ax,%ax
  803d58:	89 d8                	mov    %ebx,%eax
  803d5a:	f7 f7                	div    %edi
  803d5c:	31 ff                	xor    %edi,%edi
  803d5e:	89 fa                	mov    %edi,%edx
  803d60:	83 c4 1c             	add    $0x1c,%esp
  803d63:	5b                   	pop    %ebx
  803d64:	5e                   	pop    %esi
  803d65:	5f                   	pop    %edi
  803d66:	5d                   	pop    %ebp
  803d67:	c3                   	ret    
  803d68:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d6d:	89 eb                	mov    %ebp,%ebx
  803d6f:	29 fb                	sub    %edi,%ebx
  803d71:	89 f9                	mov    %edi,%ecx
  803d73:	d3 e6                	shl    %cl,%esi
  803d75:	89 c5                	mov    %eax,%ebp
  803d77:	88 d9                	mov    %bl,%cl
  803d79:	d3 ed                	shr    %cl,%ebp
  803d7b:	89 e9                	mov    %ebp,%ecx
  803d7d:	09 f1                	or     %esi,%ecx
  803d7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d83:	89 f9                	mov    %edi,%ecx
  803d85:	d3 e0                	shl    %cl,%eax
  803d87:	89 c5                	mov    %eax,%ebp
  803d89:	89 d6                	mov    %edx,%esi
  803d8b:	88 d9                	mov    %bl,%cl
  803d8d:	d3 ee                	shr    %cl,%esi
  803d8f:	89 f9                	mov    %edi,%ecx
  803d91:	d3 e2                	shl    %cl,%edx
  803d93:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d97:	88 d9                	mov    %bl,%cl
  803d99:	d3 e8                	shr    %cl,%eax
  803d9b:	09 c2                	or     %eax,%edx
  803d9d:	89 d0                	mov    %edx,%eax
  803d9f:	89 f2                	mov    %esi,%edx
  803da1:	f7 74 24 0c          	divl   0xc(%esp)
  803da5:	89 d6                	mov    %edx,%esi
  803da7:	89 c3                	mov    %eax,%ebx
  803da9:	f7 e5                	mul    %ebp
  803dab:	39 d6                	cmp    %edx,%esi
  803dad:	72 19                	jb     803dc8 <__udivdi3+0xfc>
  803daf:	74 0b                	je     803dbc <__udivdi3+0xf0>
  803db1:	89 d8                	mov    %ebx,%eax
  803db3:	31 ff                	xor    %edi,%edi
  803db5:	e9 58 ff ff ff       	jmp    803d12 <__udivdi3+0x46>
  803dba:	66 90                	xchg   %ax,%ax
  803dbc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803dc0:	89 f9                	mov    %edi,%ecx
  803dc2:	d3 e2                	shl    %cl,%edx
  803dc4:	39 c2                	cmp    %eax,%edx
  803dc6:	73 e9                	jae    803db1 <__udivdi3+0xe5>
  803dc8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803dcb:	31 ff                	xor    %edi,%edi
  803dcd:	e9 40 ff ff ff       	jmp    803d12 <__udivdi3+0x46>
  803dd2:	66 90                	xchg   %ax,%ax
  803dd4:	31 c0                	xor    %eax,%eax
  803dd6:	e9 37 ff ff ff       	jmp    803d12 <__udivdi3+0x46>
  803ddb:	90                   	nop

00803ddc <__umoddi3>:
  803ddc:	55                   	push   %ebp
  803ddd:	57                   	push   %edi
  803dde:	56                   	push   %esi
  803ddf:	53                   	push   %ebx
  803de0:	83 ec 1c             	sub    $0x1c,%esp
  803de3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803de7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803deb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803def:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803df3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803df7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dfb:	89 f3                	mov    %esi,%ebx
  803dfd:	89 fa                	mov    %edi,%edx
  803dff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e03:	89 34 24             	mov    %esi,(%esp)
  803e06:	85 c0                	test   %eax,%eax
  803e08:	75 1a                	jne    803e24 <__umoddi3+0x48>
  803e0a:	39 f7                	cmp    %esi,%edi
  803e0c:	0f 86 a2 00 00 00    	jbe    803eb4 <__umoddi3+0xd8>
  803e12:	89 c8                	mov    %ecx,%eax
  803e14:	89 f2                	mov    %esi,%edx
  803e16:	f7 f7                	div    %edi
  803e18:	89 d0                	mov    %edx,%eax
  803e1a:	31 d2                	xor    %edx,%edx
  803e1c:	83 c4 1c             	add    $0x1c,%esp
  803e1f:	5b                   	pop    %ebx
  803e20:	5e                   	pop    %esi
  803e21:	5f                   	pop    %edi
  803e22:	5d                   	pop    %ebp
  803e23:	c3                   	ret    
  803e24:	39 f0                	cmp    %esi,%eax
  803e26:	0f 87 ac 00 00 00    	ja     803ed8 <__umoddi3+0xfc>
  803e2c:	0f bd e8             	bsr    %eax,%ebp
  803e2f:	83 f5 1f             	xor    $0x1f,%ebp
  803e32:	0f 84 ac 00 00 00    	je     803ee4 <__umoddi3+0x108>
  803e38:	bf 20 00 00 00       	mov    $0x20,%edi
  803e3d:	29 ef                	sub    %ebp,%edi
  803e3f:	89 fe                	mov    %edi,%esi
  803e41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e45:	89 e9                	mov    %ebp,%ecx
  803e47:	d3 e0                	shl    %cl,%eax
  803e49:	89 d7                	mov    %edx,%edi
  803e4b:	89 f1                	mov    %esi,%ecx
  803e4d:	d3 ef                	shr    %cl,%edi
  803e4f:	09 c7                	or     %eax,%edi
  803e51:	89 e9                	mov    %ebp,%ecx
  803e53:	d3 e2                	shl    %cl,%edx
  803e55:	89 14 24             	mov    %edx,(%esp)
  803e58:	89 d8                	mov    %ebx,%eax
  803e5a:	d3 e0                	shl    %cl,%eax
  803e5c:	89 c2                	mov    %eax,%edx
  803e5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e62:	d3 e0                	shl    %cl,%eax
  803e64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e68:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e6c:	89 f1                	mov    %esi,%ecx
  803e6e:	d3 e8                	shr    %cl,%eax
  803e70:	09 d0                	or     %edx,%eax
  803e72:	d3 eb                	shr    %cl,%ebx
  803e74:	89 da                	mov    %ebx,%edx
  803e76:	f7 f7                	div    %edi
  803e78:	89 d3                	mov    %edx,%ebx
  803e7a:	f7 24 24             	mull   (%esp)
  803e7d:	89 c6                	mov    %eax,%esi
  803e7f:	89 d1                	mov    %edx,%ecx
  803e81:	39 d3                	cmp    %edx,%ebx
  803e83:	0f 82 87 00 00 00    	jb     803f10 <__umoddi3+0x134>
  803e89:	0f 84 91 00 00 00    	je     803f20 <__umoddi3+0x144>
  803e8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e93:	29 f2                	sub    %esi,%edx
  803e95:	19 cb                	sbb    %ecx,%ebx
  803e97:	89 d8                	mov    %ebx,%eax
  803e99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e9d:	d3 e0                	shl    %cl,%eax
  803e9f:	89 e9                	mov    %ebp,%ecx
  803ea1:	d3 ea                	shr    %cl,%edx
  803ea3:	09 d0                	or     %edx,%eax
  803ea5:	89 e9                	mov    %ebp,%ecx
  803ea7:	d3 eb                	shr    %cl,%ebx
  803ea9:	89 da                	mov    %ebx,%edx
  803eab:	83 c4 1c             	add    $0x1c,%esp
  803eae:	5b                   	pop    %ebx
  803eaf:	5e                   	pop    %esi
  803eb0:	5f                   	pop    %edi
  803eb1:	5d                   	pop    %ebp
  803eb2:	c3                   	ret    
  803eb3:	90                   	nop
  803eb4:	89 fd                	mov    %edi,%ebp
  803eb6:	85 ff                	test   %edi,%edi
  803eb8:	75 0b                	jne    803ec5 <__umoddi3+0xe9>
  803eba:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebf:	31 d2                	xor    %edx,%edx
  803ec1:	f7 f7                	div    %edi
  803ec3:	89 c5                	mov    %eax,%ebp
  803ec5:	89 f0                	mov    %esi,%eax
  803ec7:	31 d2                	xor    %edx,%edx
  803ec9:	f7 f5                	div    %ebp
  803ecb:	89 c8                	mov    %ecx,%eax
  803ecd:	f7 f5                	div    %ebp
  803ecf:	89 d0                	mov    %edx,%eax
  803ed1:	e9 44 ff ff ff       	jmp    803e1a <__umoddi3+0x3e>
  803ed6:	66 90                	xchg   %ax,%ax
  803ed8:	89 c8                	mov    %ecx,%eax
  803eda:	89 f2                	mov    %esi,%edx
  803edc:	83 c4 1c             	add    $0x1c,%esp
  803edf:	5b                   	pop    %ebx
  803ee0:	5e                   	pop    %esi
  803ee1:	5f                   	pop    %edi
  803ee2:	5d                   	pop    %ebp
  803ee3:	c3                   	ret    
  803ee4:	3b 04 24             	cmp    (%esp),%eax
  803ee7:	72 06                	jb     803eef <__umoddi3+0x113>
  803ee9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803eed:	77 0f                	ja     803efe <__umoddi3+0x122>
  803eef:	89 f2                	mov    %esi,%edx
  803ef1:	29 f9                	sub    %edi,%ecx
  803ef3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ef7:	89 14 24             	mov    %edx,(%esp)
  803efa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803efe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f02:	8b 14 24             	mov    (%esp),%edx
  803f05:	83 c4 1c             	add    $0x1c,%esp
  803f08:	5b                   	pop    %ebx
  803f09:	5e                   	pop    %esi
  803f0a:	5f                   	pop    %edi
  803f0b:	5d                   	pop    %ebp
  803f0c:	c3                   	ret    
  803f0d:	8d 76 00             	lea    0x0(%esi),%esi
  803f10:	2b 04 24             	sub    (%esp),%eax
  803f13:	19 fa                	sbb    %edi,%edx
  803f15:	89 d1                	mov    %edx,%ecx
  803f17:	89 c6                	mov    %eax,%esi
  803f19:	e9 71 ff ff ff       	jmp    803e8f <__umoddi3+0xb3>
  803f1e:	66 90                	xchg   %ax,%ax
  803f20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f24:	72 ea                	jb     803f10 <__umoddi3+0x134>
  803f26:	89 d9                	mov    %ebx,%ecx
  803f28:	e9 62 ff ff ff       	jmp    803e8f <__umoddi3+0xb3>
