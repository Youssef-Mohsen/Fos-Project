
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
  80003e:	e8 d7 1b 00 00       	call   801c1a <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 01 1c 00 00       	call   801c4c <sys_getparentenvid>
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
  80005f:	68 60 3e 80 00       	push   $0x803e60
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 30 18 00 00       	call   80189c <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 64 3e 80 00       	push   $0x803e64
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 1a 18 00 00       	call   80189c <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 6c 3e 80 00       	push   $0x803e6c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 fd 17 00 00       	call   80189c <sget>
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
  8000b3:	68 7a 3e 80 00       	push   $0x803e7a
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
  800126:	68 84 3e 80 00       	push   $0x803e84
  80012b:	e8 10 06 00 00       	call   800740 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 a9 3e 80 00       	push   $0x803ea9
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
  800159:	68 ae 3e 80 00       	push   $0x803eae
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
  800178:	68 b2 3e 80 00       	push   $0x803eb2
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
  800197:	68 b6 3e 80 00       	push   $0x803eb6
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
  8001b6:	68 ba 3e 80 00       	push   $0x803eba
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
  800230:	e8 4a 1a 00 00       	call   801c7f <sys_get_virtual_time>
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
  800533:	e8 fb 16 00 00       	call   801c33 <sys_getenvindex>
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
  8005a1:	e8 11 14 00 00       	call   8019b7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	68 d8 3e 80 00       	push   $0x803ed8
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
  8005d1:	68 00 3f 80 00       	push   $0x803f00
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
  800602:	68 28 3f 80 00       	push   $0x803f28
  800607:	e8 34 01 00 00       	call   800740 <cprintf>
  80060c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060f:	a1 20 50 80 00       	mov    0x805020,%eax
  800614:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	50                   	push   %eax
  80061e:	68 80 3f 80 00       	push   $0x803f80
  800623:	e8 18 01 00 00       	call   800740 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	68 d8 3e 80 00       	push   $0x803ed8
  800633:	e8 08 01 00 00       	call   800740 <cprintf>
  800638:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80063b:	e8 91 13 00 00       	call   8019d1 <sys_unlock_cons>
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
  800653:	e8 a7 15 00 00       	call   801bff <sys_destroy_env>
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
  800664:	e8 fc 15 00 00       	call   801c65 <sys_exit_env>
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
  8006b2:	e8 be 12 00 00       	call   801975 <sys_cputs>
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
  800729:	e8 47 12 00 00       	call   801975 <sys_cputs>
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
  800773:	e8 3f 12 00 00       	call   8019b7 <sys_lock_cons>
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
  800793:	e8 39 12 00 00       	call   8019d1 <sys_unlock_cons>
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
  8007dd:	e8 16 34 00 00       	call   803bf8 <__udivdi3>
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
  80082d:	e8 d6 34 00 00       	call   803d08 <__umoddi3>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	05 b4 41 80 00       	add    $0x8041b4,%eax
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
  800988:	8b 04 85 d8 41 80 00 	mov    0x8041d8(,%eax,4),%eax
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
  800a69:	8b 34 9d 20 40 80 00 	mov    0x804020(,%ebx,4),%esi
  800a70:	85 f6                	test   %esi,%esi
  800a72:	75 19                	jne    800a8d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a74:	53                   	push   %ebx
  800a75:	68 c5 41 80 00       	push   $0x8041c5
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
  800a8e:	68 ce 41 80 00       	push   $0x8041ce
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
  800abb:	be d1 41 80 00       	mov    $0x8041d1,%esi
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
  8014c6:	68 48 43 80 00       	push   $0x804348
  8014cb:	68 3f 01 00 00       	push   $0x13f
  8014d0:	68 6a 43 80 00       	push   $0x80436a
  8014d5:	e8 32 25 00 00       	call   803a0c <_panic>

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
  8014e6:	e8 35 0a 00 00       	call   801f20 <sys_sbrk>
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
  801561:	e8 3e 08 00 00       	call   801da4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801566:	85 c0                	test   %eax,%eax
  801568:	74 16                	je     801580 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	e8 7e 0d 00 00       	call   8022f3 <alloc_block_FF>
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157b:	e9 8a 01 00 00       	jmp    80170a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801580:	e8 50 08 00 00       	call   801dd5 <sys_isUHeapPlacementStrategyBESTFIT>
  801585:	85 c0                	test   %eax,%eax
  801587:	0f 84 7d 01 00 00    	je     80170a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 17 12 00 00       	call   8027af <alloc_block_BF>
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
  8015e3:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801630:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801687:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  8016e9:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	ff 75 08             	pushl  0x8(%ebp)
  8016f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8016f9:	e8 59 08 00 00       	call   801f57 <sys_allocate_user_mem>
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
  801741:	e8 2d 08 00 00       	call   801f73 <get_block_size>
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	e8 60 1a 00 00       	call   8031b7 <free_block>
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
  80178c:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8017c9:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  8017e9:	e8 4d 07 00 00       	call   801f3b <sys_free_user_mem>
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
  8017f7:	68 78 43 80 00       	push   $0x804378
  8017fc:	68 84 00 00 00       	push   $0x84
  801801:	68 a2 43 80 00       	push   $0x8043a2
  801806:	e8 01 22 00 00       	call   803a0c <_panic>
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
  80181d:	75 07                	jne    801826 <smalloc+0x19>
  80181f:	b8 00 00 00 00       	mov    $0x0,%eax
  801824:	eb 74                	jmp    80189a <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801833:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801839:	39 d0                	cmp    %edx,%eax
  80183b:	73 02                	jae    80183f <smalloc+0x32>
  80183d:	89 d0                	mov    %edx,%eax
  80183f:	83 ec 0c             	sub    $0xc,%esp
  801842:	50                   	push   %eax
  801843:	e8 a8 fc ff ff       	call   8014f0 <malloc>
  801848:	83 c4 10             	add    $0x10,%esp
  80184b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80184e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801852:	75 07                	jne    80185b <smalloc+0x4e>
  801854:	b8 00 00 00 00       	mov    $0x0,%eax
  801859:	eb 3f                	jmp    80189a <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80185b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80185f:	ff 75 ec             	pushl  -0x14(%ebp)
  801862:	50                   	push   %eax
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	ff 75 08             	pushl  0x8(%ebp)
  801869:	e8 d4 02 00 00       	call   801b42 <sys_createSharedObject>
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801874:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801878:	74 06                	je     801880 <smalloc+0x73>
  80187a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80187e:	75 07                	jne    801887 <smalloc+0x7a>
  801880:	b8 00 00 00 00       	mov    $0x0,%eax
  801885:	eb 13                	jmp    80189a <smalloc+0x8d>
	 cprintf("153\n");
  801887:	83 ec 0c             	sub    $0xc,%esp
  80188a:	68 ae 43 80 00       	push   $0x8043ae
  80188f:	e8 ac ee ff ff       	call   800740 <cprintf>
  801894:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801897:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	68 b4 43 80 00       	push   $0x8043b4
  8018aa:	68 a4 00 00 00       	push   $0xa4
  8018af:	68 a2 43 80 00       	push   $0x8043a2
  8018b4:	e8 53 21 00 00       	call   803a0c <_panic>

008018b9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	68 d8 43 80 00       	push   $0x8043d8
  8018c7:	68 bc 00 00 00       	push   $0xbc
  8018cc:	68 a2 43 80 00       	push   $0x8043a2
  8018d1:	e8 36 21 00 00       	call   803a0c <_panic>

008018d6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	68 fc 43 80 00       	push   $0x8043fc
  8018e4:	68 d3 00 00 00       	push   $0xd3
  8018e9:	68 a2 43 80 00       	push   $0x8043a2
  8018ee:	e8 19 21 00 00       	call   803a0c <_panic>

008018f3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	68 22 44 80 00       	push   $0x804422
  801901:	68 df 00 00 00       	push   $0xdf
  801906:	68 a2 43 80 00       	push   $0x8043a2
  80190b:	e8 fc 20 00 00       	call   803a0c <_panic>

00801910 <shrink>:

}
void shrink(uint32 newSize)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	68 22 44 80 00       	push   $0x804422
  80191e:	68 e4 00 00 00       	push   $0xe4
  801923:	68 a2 43 80 00       	push   $0x8043a2
  801928:	e8 df 20 00 00       	call   803a0c <_panic>

0080192d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	68 22 44 80 00       	push   $0x804422
  80193b:	68 e9 00 00 00       	push   $0xe9
  801940:	68 a2 43 80 00       	push   $0x8043a2
  801945:	e8 c2 20 00 00       	call   803a0c <_panic>

0080194a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	57                   	push   %edi
  80194e:	56                   	push   %esi
  80194f:	53                   	push   %ebx
  801950:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8b 55 0c             	mov    0xc(%ebp),%edx
  801959:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80195f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801962:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801965:	cd 30                	int    $0x30
  801967:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5f                   	pop    %edi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    

00801975 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	8b 45 10             	mov    0x10(%ebp),%eax
  80197e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801981:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	52                   	push   %edx
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	50                   	push   %eax
  801991:	6a 00                	push   $0x0
  801993:	e8 b2 ff ff ff       	call   80194a <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	90                   	nop
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_cgetc>:

int
sys_cgetc(void)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 02                	push   $0x2
  8019ad:	e8 98 ff ff ff       	call   80194a <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 03                	push   $0x3
  8019c6:	e8 7f ff ff ff       	call   80194a <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	90                   	nop
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 04                	push   $0x4
  8019e0:	e8 65 ff ff ff       	call   80194a <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	90                   	nop
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	52                   	push   %edx
  8019fb:	50                   	push   %eax
  8019fc:	6a 08                	push   $0x8
  8019fe:	e8 47 ff ff ff       	call   80194a <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	56                   	push   %esi
  801a0c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a0d:	8b 75 18             	mov    0x18(%ebp),%esi
  801a10:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a13:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	56                   	push   %esi
  801a1d:	53                   	push   %ebx
  801a1e:	51                   	push   %ecx
  801a1f:	52                   	push   %edx
  801a20:	50                   	push   %eax
  801a21:	6a 09                	push   $0x9
  801a23:	e8 22 ff ff ff       	call   80194a <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2e:	5b                   	pop    %ebx
  801a2f:	5e                   	pop    %esi
  801a30:	5d                   	pop    %ebp
  801a31:	c3                   	ret    

00801a32 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	52                   	push   %edx
  801a42:	50                   	push   %eax
  801a43:	6a 0a                	push   $0xa
  801a45:	e8 00 ff ff ff       	call   80194a <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	ff 75 0c             	pushl  0xc(%ebp)
  801a5b:	ff 75 08             	pushl  0x8(%ebp)
  801a5e:	6a 0b                	push   $0xb
  801a60:	e8 e5 fe ff ff       	call   80194a <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 0c                	push   $0xc
  801a79:	e8 cc fe ff ff       	call   80194a <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 0d                	push   $0xd
  801a92:	e8 b3 fe ff ff       	call   80194a <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 0e                	push   $0xe
  801aab:	e8 9a fe ff ff       	call   80194a <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 0f                	push   $0xf
  801ac4:	e8 81 fe ff ff       	call   80194a <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	ff 75 08             	pushl  0x8(%ebp)
  801adc:	6a 10                	push   $0x10
  801ade:	e8 67 fe ff ff       	call   80194a <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 11                	push   $0x11
  801af7:	e8 4e fe ff ff       	call   80194a <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	90                   	nop
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b0e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	50                   	push   %eax
  801b1b:	6a 01                	push   $0x1
  801b1d:	e8 28 fe ff ff       	call   80194a <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 14                	push   $0x14
  801b37:	e8 0e fe ff ff       	call   80194a <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	90                   	nop
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 04             	sub    $0x4,%esp
  801b48:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b4e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b51:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	51                   	push   %ecx
  801b5b:	52                   	push   %edx
  801b5c:	ff 75 0c             	pushl  0xc(%ebp)
  801b5f:	50                   	push   %eax
  801b60:	6a 15                	push   $0x15
  801b62:	e8 e3 fd ff ff       	call   80194a <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	52                   	push   %edx
  801b7c:	50                   	push   %eax
  801b7d:	6a 16                	push   $0x16
  801b7f:	e8 c6 fd ff ff       	call   80194a <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	51                   	push   %ecx
  801b9a:	52                   	push   %edx
  801b9b:	50                   	push   %eax
  801b9c:	6a 17                	push   $0x17
  801b9e:	e8 a7 fd ff ff       	call   80194a <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 18                	push   $0x18
  801bbb:	e8 8a fd ff ff       	call   80194a <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	6a 00                	push   $0x0
  801bcd:	ff 75 14             	pushl  0x14(%ebp)
  801bd0:	ff 75 10             	pushl  0x10(%ebp)
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	50                   	push   %eax
  801bd7:	6a 19                	push   $0x19
  801bd9:	e8 6c fd ff ff       	call   80194a <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	50                   	push   %eax
  801bf2:	6a 1a                	push   $0x1a
  801bf4:	e8 51 fd ff ff       	call   80194a <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	90                   	nop
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	50                   	push   %eax
  801c0e:	6a 1b                	push   $0x1b
  801c10:	e8 35 fd ff ff       	call   80194a <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 05                	push   $0x5
  801c29:	e8 1c fd ff ff       	call   80194a <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 06                	push   $0x6
  801c42:	e8 03 fd ff ff       	call   80194a <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 07                	push   $0x7
  801c5b:	e8 ea fc ff ff       	call   80194a <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_exit_env>:


void sys_exit_env(void)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 1c                	push   $0x1c
  801c74:	e8 d1 fc ff ff       	call   80194a <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	90                   	nop
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c85:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c88:	8d 50 04             	lea    0x4(%eax),%edx
  801c8b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	52                   	push   %edx
  801c95:	50                   	push   %eax
  801c96:	6a 1d                	push   $0x1d
  801c98:	e8 ad fc ff ff       	call   80194a <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
	return result;
  801ca0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca9:	89 01                	mov    %eax,(%ecx)
  801cab:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	c9                   	leave  
  801cb2:	c2 04 00             	ret    $0x4

00801cb5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	ff 75 10             	pushl  0x10(%ebp)
  801cbf:	ff 75 0c             	pushl  0xc(%ebp)
  801cc2:	ff 75 08             	pushl  0x8(%ebp)
  801cc5:	6a 13                	push   $0x13
  801cc7:	e8 7e fc ff ff       	call   80194a <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccf:	90                   	nop
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 1e                	push   $0x1e
  801ce1:	e8 64 fc ff ff       	call   80194a <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cf7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	50                   	push   %eax
  801d04:	6a 1f                	push   $0x1f
  801d06:	e8 3f fc ff ff       	call   80194a <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0e:	90                   	nop
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <rsttst>:
void rsttst()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 21                	push   $0x21
  801d20:	e8 25 fc ff ff       	call   80194a <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
	return ;
  801d28:	90                   	nop
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	83 ec 04             	sub    $0x4,%esp
  801d31:	8b 45 14             	mov    0x14(%ebp),%eax
  801d34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d37:	8b 55 18             	mov    0x18(%ebp),%edx
  801d3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	ff 75 10             	pushl  0x10(%ebp)
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	ff 75 08             	pushl  0x8(%ebp)
  801d49:	6a 20                	push   $0x20
  801d4b:	e8 fa fb ff ff       	call   80194a <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
	return ;
  801d53:	90                   	nop
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <chktst>:
void chktst(uint32 n)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	ff 75 08             	pushl  0x8(%ebp)
  801d64:	6a 22                	push   $0x22
  801d66:	e8 df fb ff ff       	call   80194a <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6e:	90                   	nop
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <inctst>:

void inctst()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 23                	push   $0x23
  801d80:	e8 c5 fb ff ff       	call   80194a <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
	return ;
  801d88:	90                   	nop
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <gettst>:
uint32 gettst()
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 24                	push   $0x24
  801d9a:	e8 ab fb ff ff       	call   80194a <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 25                	push   $0x25
  801db6:	e8 8f fb ff ff       	call   80194a <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
  801dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dc1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dc5:	75 07                	jne    801dce <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcc:	eb 05                	jmp    801dd3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 25                	push   $0x25
  801de7:	e8 5e fb ff ff       	call   80194a <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
  801def:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801df2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801df6:	75 07                	jne    801dff <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801df8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfd:	eb 05                	jmp    801e04 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 25                	push   $0x25
  801e18:	e8 2d fb ff ff       	call   80194a <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
  801e20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e23:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e27:	75 07                	jne    801e30 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e29:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2e:	eb 05                	jmp    801e35 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 25                	push   $0x25
  801e49:	e8 fc fa ff ff       	call   80194a <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
  801e51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e54:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e58:	75 07                	jne    801e61 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5f:	eb 05                	jmp    801e66 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	ff 75 08             	pushl  0x8(%ebp)
  801e76:	6a 26                	push   $0x26
  801e78:	e8 cd fa ff ff       	call   80194a <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e80:	90                   	nop
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e87:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	53                   	push   %ebx
  801e96:	51                   	push   %ecx
  801e97:	52                   	push   %edx
  801e98:	50                   	push   %eax
  801e99:	6a 27                	push   $0x27
  801e9b:	e8 aa fa ff ff       	call   80194a <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	52                   	push   %edx
  801eb8:	50                   	push   %eax
  801eb9:	6a 28                	push   $0x28
  801ebb:	e8 8a fa ff ff       	call   80194a <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ec8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ece:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed1:	6a 00                	push   $0x0
  801ed3:	51                   	push   %ecx
  801ed4:	ff 75 10             	pushl  0x10(%ebp)
  801ed7:	52                   	push   %edx
  801ed8:	50                   	push   %eax
  801ed9:	6a 29                	push   $0x29
  801edb:	e8 6a fa ff ff       	call   80194a <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	ff 75 10             	pushl  0x10(%ebp)
  801eef:	ff 75 0c             	pushl  0xc(%ebp)
  801ef2:	ff 75 08             	pushl  0x8(%ebp)
  801ef5:	6a 12                	push   $0x12
  801ef7:	e8 4e fa ff ff       	call   80194a <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
	return ;
  801eff:	90                   	nop
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	52                   	push   %edx
  801f12:	50                   	push   %eax
  801f13:	6a 2a                	push   $0x2a
  801f15:	e8 30 fa ff ff       	call   80194a <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
	return;
  801f1d:	90                   	nop
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	50                   	push   %eax
  801f2f:	6a 2b                	push   $0x2b
  801f31:	e8 14 fa ff ff       	call   80194a <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	ff 75 0c             	pushl  0xc(%ebp)
  801f47:	ff 75 08             	pushl  0x8(%ebp)
  801f4a:	6a 2c                	push   $0x2c
  801f4c:	e8 f9 f9 ff ff       	call   80194a <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
	return;
  801f54:	90                   	nop
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	ff 75 0c             	pushl  0xc(%ebp)
  801f63:	ff 75 08             	pushl  0x8(%ebp)
  801f66:	6a 2d                	push   $0x2d
  801f68:	e8 dd f9 ff ff       	call   80194a <syscall>
  801f6d:	83 c4 18             	add    $0x18,%esp
	return;
  801f70:	90                   	nop
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	83 e8 04             	sub    $0x4,%eax
  801f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f85:	8b 00                	mov    (%eax),%eax
  801f87:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	83 e8 04             	sub    $0x4,%eax
  801f98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9e:	8b 00                	mov    (%eax),%eax
  801fa0:	83 e0 01             	and    $0x1,%eax
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	0f 94 c0             	sete   %al
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fba:	83 f8 02             	cmp    $0x2,%eax
  801fbd:	74 2b                	je     801fea <alloc_block+0x40>
  801fbf:	83 f8 02             	cmp    $0x2,%eax
  801fc2:	7f 07                	jg     801fcb <alloc_block+0x21>
  801fc4:	83 f8 01             	cmp    $0x1,%eax
  801fc7:	74 0e                	je     801fd7 <alloc_block+0x2d>
  801fc9:	eb 58                	jmp    802023 <alloc_block+0x79>
  801fcb:	83 f8 03             	cmp    $0x3,%eax
  801fce:	74 2d                	je     801ffd <alloc_block+0x53>
  801fd0:	83 f8 04             	cmp    $0x4,%eax
  801fd3:	74 3b                	je     802010 <alloc_block+0x66>
  801fd5:	eb 4c                	jmp    802023 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fd7:	83 ec 0c             	sub    $0xc,%esp
  801fda:	ff 75 08             	pushl  0x8(%ebp)
  801fdd:	e8 11 03 00 00       	call   8022f3 <alloc_block_FF>
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe8:	eb 4a                	jmp    802034 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	ff 75 08             	pushl  0x8(%ebp)
  801ff0:	e8 fa 19 00 00       	call   8039ef <alloc_block_NF>
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ffb:	eb 37                	jmp    802034 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	ff 75 08             	pushl  0x8(%ebp)
  802003:	e8 a7 07 00 00       	call   8027af <alloc_block_BF>
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80200e:	eb 24                	jmp    802034 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	ff 75 08             	pushl  0x8(%ebp)
  802016:	e8 b7 19 00 00       	call   8039d2 <alloc_block_WF>
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802021:	eb 11                	jmp    802034 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802023:	83 ec 0c             	sub    $0xc,%esp
  802026:	68 34 44 80 00       	push   $0x804434
  80202b:	e8 10 e7 ff ff       	call   800740 <cprintf>
  802030:	83 c4 10             	add    $0x10,%esp
		break;
  802033:	90                   	nop
	}
	return va;
  802034:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	53                   	push   %ebx
  80203d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802040:	83 ec 0c             	sub    $0xc,%esp
  802043:	68 54 44 80 00       	push   $0x804454
  802048:	e8 f3 e6 ff ff       	call   800740 <cprintf>
  80204d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802050:	83 ec 0c             	sub    $0xc,%esp
  802053:	68 7f 44 80 00       	push   $0x80447f
  802058:	e8 e3 e6 ff ff       	call   800740 <cprintf>
  80205d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802066:	eb 37                	jmp    80209f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802068:	83 ec 0c             	sub    $0xc,%esp
  80206b:	ff 75 f4             	pushl  -0xc(%ebp)
  80206e:	e8 19 ff ff ff       	call   801f8c <is_free_block>
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	0f be d8             	movsbl %al,%ebx
  802079:	83 ec 0c             	sub    $0xc,%esp
  80207c:	ff 75 f4             	pushl  -0xc(%ebp)
  80207f:	e8 ef fe ff ff       	call   801f73 <get_block_size>
  802084:	83 c4 10             	add    $0x10,%esp
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	53                   	push   %ebx
  80208b:	50                   	push   %eax
  80208c:	68 97 44 80 00       	push   $0x804497
  802091:	e8 aa e6 ff ff       	call   800740 <cprintf>
  802096:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802099:	8b 45 10             	mov    0x10(%ebp),%eax
  80209c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a3:	74 07                	je     8020ac <print_blocks_list+0x73>
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	8b 00                	mov    (%eax),%eax
  8020aa:	eb 05                	jmp    8020b1 <print_blocks_list+0x78>
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b1:	89 45 10             	mov    %eax,0x10(%ebp)
  8020b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	75 ad                	jne    802068 <print_blocks_list+0x2f>
  8020bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020bf:	75 a7                	jne    802068 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020c1:	83 ec 0c             	sub    $0xc,%esp
  8020c4:	68 54 44 80 00       	push   $0x804454
  8020c9:	e8 72 e6 ff ff       	call   800740 <cprintf>
  8020ce:	83 c4 10             	add    $0x10,%esp

}
  8020d1:	90                   	nop
  8020d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e0:	83 e0 01             	and    $0x1,%eax
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	74 03                	je     8020ea <initialize_dynamic_allocator+0x13>
  8020e7:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020ee:	0f 84 c7 01 00 00    	je     8022bb <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020f4:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020fb:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802101:	8b 45 0c             	mov    0xc(%ebp),%eax
  802104:	01 d0                	add    %edx,%eax
  802106:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80210b:	0f 87 ad 01 00 00    	ja     8022be <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	85 c0                	test   %eax,%eax
  802116:	0f 89 a5 01 00 00    	jns    8022c1 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80211c:	8b 55 08             	mov    0x8(%ebp),%edx
  80211f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802122:	01 d0                	add    %edx,%eax
  802124:	83 e8 04             	sub    $0x4,%eax
  802127:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80212c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802133:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802138:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213b:	e9 87 00 00 00       	jmp    8021c7 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802140:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802144:	75 14                	jne    80215a <initialize_dynamic_allocator+0x83>
  802146:	83 ec 04             	sub    $0x4,%esp
  802149:	68 af 44 80 00       	push   $0x8044af
  80214e:	6a 79                	push   $0x79
  802150:	68 cd 44 80 00       	push   $0x8044cd
  802155:	e8 b2 18 00 00       	call   803a0c <_panic>
  80215a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215d:	8b 00                	mov    (%eax),%eax
  80215f:	85 c0                	test   %eax,%eax
  802161:	74 10                	je     802173 <initialize_dynamic_allocator+0x9c>
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	8b 00                	mov    (%eax),%eax
  802168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216b:	8b 52 04             	mov    0x4(%edx),%edx
  80216e:	89 50 04             	mov    %edx,0x4(%eax)
  802171:	eb 0b                	jmp    80217e <initialize_dynamic_allocator+0xa7>
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	8b 40 04             	mov    0x4(%eax),%eax
  802179:	a3 30 50 80 00       	mov    %eax,0x805030
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	8b 40 04             	mov    0x4(%eax),%eax
  802184:	85 c0                	test   %eax,%eax
  802186:	74 0f                	je     802197 <initialize_dynamic_allocator+0xc0>
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	8b 40 04             	mov    0x4(%eax),%eax
  80218e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802191:	8b 12                	mov    (%edx),%edx
  802193:	89 10                	mov    %edx,(%eax)
  802195:	eb 0a                	jmp    8021a1 <initialize_dynamic_allocator+0xca>
  802197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219a:	8b 00                	mov    (%eax),%eax
  80219c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8021b9:	48                   	dec    %eax
  8021ba:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021bf:	a1 34 50 80 00       	mov    0x805034,%eax
  8021c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cb:	74 07                	je     8021d4 <initialize_dynamic_allocator+0xfd>
  8021cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d0:	8b 00                	mov    (%eax),%eax
  8021d2:	eb 05                	jmp    8021d9 <initialize_dynamic_allocator+0x102>
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d9:	a3 34 50 80 00       	mov    %eax,0x805034
  8021de:	a1 34 50 80 00       	mov    0x805034,%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	0f 85 55 ff ff ff    	jne    802140 <initialize_dynamic_allocator+0x69>
  8021eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ef:	0f 85 4b ff ff ff    	jne    802140 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802204:	a1 44 50 80 00       	mov    0x805044,%eax
  802209:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80220e:	a1 40 50 80 00       	mov    0x805040,%eax
  802213:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	83 c0 08             	add    $0x8,%eax
  80221f:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	83 c0 04             	add    $0x4,%eax
  802228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222b:	83 ea 08             	sub    $0x8,%edx
  80222e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802230:	8b 55 0c             	mov    0xc(%ebp),%edx
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	01 d0                	add    %edx,%eax
  802238:	83 e8 08             	sub    $0x8,%eax
  80223b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223e:	83 ea 08             	sub    $0x8,%edx
  802241:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802243:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802246:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80224c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802256:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80225a:	75 17                	jne    802273 <initialize_dynamic_allocator+0x19c>
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	68 e8 44 80 00       	push   $0x8044e8
  802264:	68 90 00 00 00       	push   $0x90
  802269:	68 cd 44 80 00       	push   $0x8044cd
  80226e:	e8 99 17 00 00       	call   803a0c <_panic>
  802273:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802279:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227c:	89 10                	mov    %edx,(%eax)
  80227e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802281:	8b 00                	mov    (%eax),%eax
  802283:	85 c0                	test   %eax,%eax
  802285:	74 0d                	je     802294 <initialize_dynamic_allocator+0x1bd>
  802287:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80228c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80228f:	89 50 04             	mov    %edx,0x4(%eax)
  802292:	eb 08                	jmp    80229c <initialize_dynamic_allocator+0x1c5>
  802294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802297:	a3 30 50 80 00       	mov    %eax,0x805030
  80229c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8022b3:	40                   	inc    %eax
  8022b4:	a3 38 50 80 00       	mov    %eax,0x805038
  8022b9:	eb 07                	jmp    8022c2 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022bb:	90                   	nop
  8022bc:	eb 04                	jmp    8022c2 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022be:	90                   	nop
  8022bf:	eb 01                	jmp    8022c2 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022c1:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ca:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d6:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	83 e8 04             	sub    $0x4,%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	83 e0 fe             	and    $0xfffffffe,%eax
  8022e3:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	01 c2                	add    %eax,%edx
  8022eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ee:	89 02                	mov    %eax,(%edx)
}
  8022f0:	90                   	nop
  8022f1:	5d                   	pop    %ebp
  8022f2:	c3                   	ret    

008022f3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	83 e0 01             	and    $0x1,%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	74 03                	je     802306 <alloc_block_FF+0x13>
  802303:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802306:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80230a:	77 07                	ja     802313 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80230c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802313:	a1 24 50 80 00       	mov    0x805024,%eax
  802318:	85 c0                	test   %eax,%eax
  80231a:	75 73                	jne    80238f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	83 c0 10             	add    $0x10,%eax
  802322:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802325:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80232c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80232f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802332:	01 d0                	add    %edx,%eax
  802334:	48                   	dec    %eax
  802335:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802338:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80233b:	ba 00 00 00 00       	mov    $0x0,%edx
  802340:	f7 75 ec             	divl   -0x14(%ebp)
  802343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802346:	29 d0                	sub    %edx,%eax
  802348:	c1 e8 0c             	shr    $0xc,%eax
  80234b:	83 ec 0c             	sub    $0xc,%esp
  80234e:	50                   	push   %eax
  80234f:	e8 86 f1 ff ff       	call   8014da <sbrk>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	6a 00                	push   $0x0
  80235f:	e8 76 f1 ff ff       	call   8014da <sbrk>
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80236a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802370:	83 ec 08             	sub    $0x8,%esp
  802373:	50                   	push   %eax
  802374:	ff 75 e4             	pushl  -0x1c(%ebp)
  802377:	e8 5b fd ff ff       	call   8020d7 <initialize_dynamic_allocator>
  80237c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80237f:	83 ec 0c             	sub    $0xc,%esp
  802382:	68 0b 45 80 00       	push   $0x80450b
  802387:	e8 b4 e3 ff ff       	call   800740 <cprintf>
  80238c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80238f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802393:	75 0a                	jne    80239f <alloc_block_FF+0xac>
	        return NULL;
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
  80239a:	e9 0e 04 00 00       	jmp    8027ad <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80239f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ae:	e9 f3 02 00 00       	jmp    8026a6 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023b9:	83 ec 0c             	sub    $0xc,%esp
  8023bc:	ff 75 bc             	pushl  -0x44(%ebp)
  8023bf:	e8 af fb ff ff       	call   801f73 <get_block_size>
  8023c4:	83 c4 10             	add    $0x10,%esp
  8023c7:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	83 c0 08             	add    $0x8,%eax
  8023d0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023d3:	0f 87 c5 02 00 00    	ja     80269e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	83 c0 18             	add    $0x18,%eax
  8023df:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023e2:	0f 87 19 02 00 00    	ja     802601 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023eb:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ee:	83 e8 08             	sub    $0x8,%eax
  8023f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	8d 50 08             	lea    0x8(%eax),%edx
  8023fa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023fd:	01 d0                	add    %edx,%eax
  8023ff:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	83 c0 08             	add    $0x8,%eax
  802408:	83 ec 04             	sub    $0x4,%esp
  80240b:	6a 01                	push   $0x1
  80240d:	50                   	push   %eax
  80240e:	ff 75 bc             	pushl  -0x44(%ebp)
  802411:	e8 ae fe ff ff       	call   8022c4 <set_block_data>
  802416:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 40 04             	mov    0x4(%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	75 68                	jne    80248b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802423:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802427:	75 17                	jne    802440 <alloc_block_FF+0x14d>
  802429:	83 ec 04             	sub    $0x4,%esp
  80242c:	68 e8 44 80 00       	push   $0x8044e8
  802431:	68 d7 00 00 00       	push   $0xd7
  802436:	68 cd 44 80 00       	push   $0x8044cd
  80243b:	e8 cc 15 00 00       	call   803a0c <_panic>
  802440:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802446:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802449:	89 10                	mov    %edx,(%eax)
  80244b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244e:	8b 00                	mov    (%eax),%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	74 0d                	je     802461 <alloc_block_FF+0x16e>
  802454:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802459:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80245c:	89 50 04             	mov    %edx,0x4(%eax)
  80245f:	eb 08                	jmp    802469 <alloc_block_FF+0x176>
  802461:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802464:	a3 30 50 80 00       	mov    %eax,0x805030
  802469:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802471:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802474:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247b:	a1 38 50 80 00       	mov    0x805038,%eax
  802480:	40                   	inc    %eax
  802481:	a3 38 50 80 00       	mov    %eax,0x805038
  802486:	e9 dc 00 00 00       	jmp    802567 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	75 65                	jne    8024f9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802494:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802498:	75 17                	jne    8024b1 <alloc_block_FF+0x1be>
  80249a:	83 ec 04             	sub    $0x4,%esp
  80249d:	68 1c 45 80 00       	push   $0x80451c
  8024a2:	68 db 00 00 00       	push   $0xdb
  8024a7:	68 cd 44 80 00       	push   $0x8044cd
  8024ac:	e8 5b 15 00 00       	call   803a0c <_panic>
  8024b1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ba:	89 50 04             	mov    %edx,0x4(%eax)
  8024bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	74 0c                	je     8024d3 <alloc_block_FF+0x1e0>
  8024c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8024cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024cf:	89 10                	mov    %edx,(%eax)
  8024d1:	eb 08                	jmp    8024db <alloc_block_FF+0x1e8>
  8024d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024de:	a3 30 50 80 00       	mov    %eax,0x805030
  8024e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8024f1:	40                   	inc    %eax
  8024f2:	a3 38 50 80 00       	mov    %eax,0x805038
  8024f7:	eb 6e                	jmp    802567 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fd:	74 06                	je     802505 <alloc_block_FF+0x212>
  8024ff:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802503:	75 17                	jne    80251c <alloc_block_FF+0x229>
  802505:	83 ec 04             	sub    $0x4,%esp
  802508:	68 40 45 80 00       	push   $0x804540
  80250d:	68 df 00 00 00       	push   $0xdf
  802512:	68 cd 44 80 00       	push   $0x8044cd
  802517:	e8 f0 14 00 00       	call   803a0c <_panic>
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 10                	mov    (%eax),%edx
  802521:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802524:	89 10                	mov    %edx,(%eax)
  802526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	85 c0                	test   %eax,%eax
  80252d:	74 0b                	je     80253a <alloc_block_FF+0x247>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 00                	mov    (%eax),%eax
  802534:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802537:	89 50 04             	mov    %edx,0x4(%eax)
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802540:	89 10                	mov    %edx,(%eax)
  802542:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802545:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802548:	89 50 04             	mov    %edx,0x4(%eax)
  80254b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	85 c0                	test   %eax,%eax
  802552:	75 08                	jne    80255c <alloc_block_FF+0x269>
  802554:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802557:	a3 30 50 80 00       	mov    %eax,0x805030
  80255c:	a1 38 50 80 00       	mov    0x805038,%eax
  802561:	40                   	inc    %eax
  802562:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256b:	75 17                	jne    802584 <alloc_block_FF+0x291>
  80256d:	83 ec 04             	sub    $0x4,%esp
  802570:	68 af 44 80 00       	push   $0x8044af
  802575:	68 e1 00 00 00       	push   $0xe1
  80257a:	68 cd 44 80 00       	push   $0x8044cd
  80257f:	e8 88 14 00 00       	call   803a0c <_panic>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	74 10                	je     80259d <alloc_block_FF+0x2aa>
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802595:	8b 52 04             	mov    0x4(%edx),%edx
  802598:	89 50 04             	mov    %edx,0x4(%eax)
  80259b:	eb 0b                	jmp    8025a8 <alloc_block_FF+0x2b5>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 40 04             	mov    0x4(%eax),%eax
  8025a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	74 0f                	je     8025c1 <alloc_block_FF+0x2ce>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bb:	8b 12                	mov    (%edx),%edx
  8025bd:	89 10                	mov    %edx,(%eax)
  8025bf:	eb 0a                	jmp    8025cb <alloc_block_FF+0x2d8>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025de:	a1 38 50 80 00       	mov    0x805038,%eax
  8025e3:	48                   	dec    %eax
  8025e4:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025e9:	83 ec 04             	sub    $0x4,%esp
  8025ec:	6a 00                	push   $0x0
  8025ee:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025f1:	ff 75 b0             	pushl  -0x50(%ebp)
  8025f4:	e8 cb fc ff ff       	call   8022c4 <set_block_data>
  8025f9:	83 c4 10             	add    $0x10,%esp
  8025fc:	e9 95 00 00 00       	jmp    802696 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802601:	83 ec 04             	sub    $0x4,%esp
  802604:	6a 01                	push   $0x1
  802606:	ff 75 b8             	pushl  -0x48(%ebp)
  802609:	ff 75 bc             	pushl  -0x44(%ebp)
  80260c:	e8 b3 fc ff ff       	call   8022c4 <set_block_data>
  802611:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802618:	75 17                	jne    802631 <alloc_block_FF+0x33e>
  80261a:	83 ec 04             	sub    $0x4,%esp
  80261d:	68 af 44 80 00       	push   $0x8044af
  802622:	68 e8 00 00 00       	push   $0xe8
  802627:	68 cd 44 80 00       	push   $0x8044cd
  80262c:	e8 db 13 00 00       	call   803a0c <_panic>
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 00                	mov    (%eax),%eax
  802636:	85 c0                	test   %eax,%eax
  802638:	74 10                	je     80264a <alloc_block_FF+0x357>
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 00                	mov    (%eax),%eax
  80263f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802642:	8b 52 04             	mov    0x4(%edx),%edx
  802645:	89 50 04             	mov    %edx,0x4(%eax)
  802648:	eb 0b                	jmp    802655 <alloc_block_FF+0x362>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 04             	mov    0x4(%eax),%eax
  802650:	a3 30 50 80 00       	mov    %eax,0x805030
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 40 04             	mov    0x4(%eax),%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	74 0f                	je     80266e <alloc_block_FF+0x37b>
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 40 04             	mov    0x4(%eax),%eax
  802665:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802668:	8b 12                	mov    (%edx),%edx
  80266a:	89 10                	mov    %edx,(%eax)
  80266c:	eb 0a                	jmp    802678 <alloc_block_FF+0x385>
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	8b 00                	mov    (%eax),%eax
  802673:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268b:	a1 38 50 80 00       	mov    0x805038,%eax
  802690:	48                   	dec    %eax
  802691:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802696:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802699:	e9 0f 01 00 00       	jmp    8027ad <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80269e:	a1 34 50 80 00       	mov    0x805034,%eax
  8026a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026aa:	74 07                	je     8026b3 <alloc_block_FF+0x3c0>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	eb 05                	jmp    8026b8 <alloc_block_FF+0x3c5>
  8026b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b8:	a3 34 50 80 00       	mov    %eax,0x805034
  8026bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	0f 85 e9 fc ff ff    	jne    8023b3 <alloc_block_FF+0xc0>
  8026ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ce:	0f 85 df fc ff ff    	jne    8023b3 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d7:	83 c0 08             	add    $0x8,%eax
  8026da:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026dd:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026ea:	01 d0                	add    %edx,%eax
  8026ec:	48                   	dec    %eax
  8026ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f8:	f7 75 d8             	divl   -0x28(%ebp)
  8026fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026fe:	29 d0                	sub    %edx,%eax
  802700:	c1 e8 0c             	shr    $0xc,%eax
  802703:	83 ec 0c             	sub    $0xc,%esp
  802706:	50                   	push   %eax
  802707:	e8 ce ed ff ff       	call   8014da <sbrk>
  80270c:	83 c4 10             	add    $0x10,%esp
  80270f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802712:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802716:	75 0a                	jne    802722 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802718:	b8 00 00 00 00       	mov    $0x0,%eax
  80271d:	e9 8b 00 00 00       	jmp    8027ad <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802722:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802729:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80272c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80272f:	01 d0                	add    %edx,%eax
  802731:	48                   	dec    %eax
  802732:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802735:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802738:	ba 00 00 00 00       	mov    $0x0,%edx
  80273d:	f7 75 cc             	divl   -0x34(%ebp)
  802740:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802743:	29 d0                	sub    %edx,%eax
  802745:	8d 50 fc             	lea    -0x4(%eax),%edx
  802748:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80274b:	01 d0                	add    %edx,%eax
  80274d:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802752:	a1 40 50 80 00       	mov    0x805040,%eax
  802757:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80275d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802764:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802767:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80276a:	01 d0                	add    %edx,%eax
  80276c:	48                   	dec    %eax
  80276d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802770:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802773:	ba 00 00 00 00       	mov    $0x0,%edx
  802778:	f7 75 c4             	divl   -0x3c(%ebp)
  80277b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80277e:	29 d0                	sub    %edx,%eax
  802780:	83 ec 04             	sub    $0x4,%esp
  802783:	6a 01                	push   $0x1
  802785:	50                   	push   %eax
  802786:	ff 75 d0             	pushl  -0x30(%ebp)
  802789:	e8 36 fb ff ff       	call   8022c4 <set_block_data>
  80278e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802791:	83 ec 0c             	sub    $0xc,%esp
  802794:	ff 75 d0             	pushl  -0x30(%ebp)
  802797:	e8 1b 0a 00 00       	call   8031b7 <free_block>
  80279c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80279f:	83 ec 0c             	sub    $0xc,%esp
  8027a2:	ff 75 08             	pushl  0x8(%ebp)
  8027a5:	e8 49 fb ff ff       	call   8022f3 <alloc_block_FF>
  8027aa:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027ad:	c9                   	leave  
  8027ae:	c3                   	ret    

008027af <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b8:	83 e0 01             	and    $0x1,%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	74 03                	je     8027c2 <alloc_block_BF+0x13>
  8027bf:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027c2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027c6:	77 07                	ja     8027cf <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027c8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027cf:	a1 24 50 80 00       	mov    0x805024,%eax
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	75 73                	jne    80284b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027db:	83 c0 10             	add    $0x10,%eax
  8027de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027e1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ee:	01 d0                	add    %edx,%eax
  8027f0:	48                   	dec    %eax
  8027f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8027fc:	f7 75 e0             	divl   -0x20(%ebp)
  8027ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802802:	29 d0                	sub    %edx,%eax
  802804:	c1 e8 0c             	shr    $0xc,%eax
  802807:	83 ec 0c             	sub    $0xc,%esp
  80280a:	50                   	push   %eax
  80280b:	e8 ca ec ff ff       	call   8014da <sbrk>
  802810:	83 c4 10             	add    $0x10,%esp
  802813:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802816:	83 ec 0c             	sub    $0xc,%esp
  802819:	6a 00                	push   $0x0
  80281b:	e8 ba ec ff ff       	call   8014da <sbrk>
  802820:	83 c4 10             	add    $0x10,%esp
  802823:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802826:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802829:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80282c:	83 ec 08             	sub    $0x8,%esp
  80282f:	50                   	push   %eax
  802830:	ff 75 d8             	pushl  -0x28(%ebp)
  802833:	e8 9f f8 ff ff       	call   8020d7 <initialize_dynamic_allocator>
  802838:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80283b:	83 ec 0c             	sub    $0xc,%esp
  80283e:	68 0b 45 80 00       	push   $0x80450b
  802843:	e8 f8 de ff ff       	call   800740 <cprintf>
  802848:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80284b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802852:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802859:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802860:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802867:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80286c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286f:	e9 1d 01 00 00       	jmp    802991 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80287a:	83 ec 0c             	sub    $0xc,%esp
  80287d:	ff 75 a8             	pushl  -0x58(%ebp)
  802880:	e8 ee f6 ff ff       	call   801f73 <get_block_size>
  802885:	83 c4 10             	add    $0x10,%esp
  802888:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	83 c0 08             	add    $0x8,%eax
  802891:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802894:	0f 87 ef 00 00 00    	ja     802989 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	83 c0 18             	add    $0x18,%eax
  8028a0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a3:	77 1d                	ja     8028c2 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ab:	0f 86 d8 00 00 00    	jbe    802989 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028b1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028b7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028bd:	e9 c7 00 00 00       	jmp    802989 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c5:	83 c0 08             	add    $0x8,%eax
  8028c8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028cb:	0f 85 9d 00 00 00    	jne    80296e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028d1:	83 ec 04             	sub    $0x4,%esp
  8028d4:	6a 01                	push   $0x1
  8028d6:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028d9:	ff 75 a8             	pushl  -0x58(%ebp)
  8028dc:	e8 e3 f9 ff ff       	call   8022c4 <set_block_data>
  8028e1:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e8:	75 17                	jne    802901 <alloc_block_BF+0x152>
  8028ea:	83 ec 04             	sub    $0x4,%esp
  8028ed:	68 af 44 80 00       	push   $0x8044af
  8028f2:	68 2c 01 00 00       	push   $0x12c
  8028f7:	68 cd 44 80 00       	push   $0x8044cd
  8028fc:	e8 0b 11 00 00       	call   803a0c <_panic>
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 00                	mov    (%eax),%eax
  802906:	85 c0                	test   %eax,%eax
  802908:	74 10                	je     80291a <alloc_block_BF+0x16b>
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802912:	8b 52 04             	mov    0x4(%edx),%edx
  802915:	89 50 04             	mov    %edx,0x4(%eax)
  802918:	eb 0b                	jmp    802925 <alloc_block_BF+0x176>
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 40 04             	mov    0x4(%eax),%eax
  802920:	a3 30 50 80 00       	mov    %eax,0x805030
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 40 04             	mov    0x4(%eax),%eax
  80292b:	85 c0                	test   %eax,%eax
  80292d:	74 0f                	je     80293e <alloc_block_BF+0x18f>
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	8b 40 04             	mov    0x4(%eax),%eax
  802935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802938:	8b 12                	mov    (%edx),%edx
  80293a:	89 10                	mov    %edx,(%eax)
  80293c:	eb 0a                	jmp    802948 <alloc_block_BF+0x199>
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295b:	a1 38 50 80 00       	mov    0x805038,%eax
  802960:	48                   	dec    %eax
  802961:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802966:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802969:	e9 24 04 00 00       	jmp    802d92 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80296e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802971:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802974:	76 13                	jbe    802989 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802976:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80297d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802980:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802983:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802986:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802989:	a1 34 50 80 00       	mov    0x805034,%eax
  80298e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802995:	74 07                	je     80299e <alloc_block_BF+0x1ef>
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 00                	mov    (%eax),%eax
  80299c:	eb 05                	jmp    8029a3 <alloc_block_BF+0x1f4>
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8029a8:	a1 34 50 80 00       	mov    0x805034,%eax
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	0f 85 bf fe ff ff    	jne    802874 <alloc_block_BF+0xc5>
  8029b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b9:	0f 85 b5 fe ff ff    	jne    802874 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029c3:	0f 84 26 02 00 00    	je     802bef <alloc_block_BF+0x440>
  8029c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029cd:	0f 85 1c 02 00 00    	jne    802bef <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d6:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d9:	83 e8 08             	sub    $0x8,%eax
  8029dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	8d 50 08             	lea    0x8(%eax),%edx
  8029e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e8:	01 d0                	add    %edx,%eax
  8029ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	83 c0 08             	add    $0x8,%eax
  8029f3:	83 ec 04             	sub    $0x4,%esp
  8029f6:	6a 01                	push   $0x1
  8029f8:	50                   	push   %eax
  8029f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8029fc:	e8 c3 f8 ff ff       	call   8022c4 <set_block_data>
  802a01:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a07:	8b 40 04             	mov    0x4(%eax),%eax
  802a0a:	85 c0                	test   %eax,%eax
  802a0c:	75 68                	jne    802a76 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a0e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a12:	75 17                	jne    802a2b <alloc_block_BF+0x27c>
  802a14:	83 ec 04             	sub    $0x4,%esp
  802a17:	68 e8 44 80 00       	push   $0x8044e8
  802a1c:	68 45 01 00 00       	push   $0x145
  802a21:	68 cd 44 80 00       	push   $0x8044cd
  802a26:	e8 e1 0f 00 00       	call   803a0c <_panic>
  802a2b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a34:	89 10                	mov    %edx,(%eax)
  802a36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a39:	8b 00                	mov    (%eax),%eax
  802a3b:	85 c0                	test   %eax,%eax
  802a3d:	74 0d                	je     802a4c <alloc_block_BF+0x29d>
  802a3f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a44:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a47:	89 50 04             	mov    %edx,0x4(%eax)
  802a4a:	eb 08                	jmp    802a54 <alloc_block_BF+0x2a5>
  802a4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a57:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a66:	a1 38 50 80 00       	mov    0x805038,%eax
  802a6b:	40                   	inc    %eax
  802a6c:	a3 38 50 80 00       	mov    %eax,0x805038
  802a71:	e9 dc 00 00 00       	jmp    802b52 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	75 65                	jne    802ae4 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a7f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a83:	75 17                	jne    802a9c <alloc_block_BF+0x2ed>
  802a85:	83 ec 04             	sub    $0x4,%esp
  802a88:	68 1c 45 80 00       	push   $0x80451c
  802a8d:	68 4a 01 00 00       	push   $0x14a
  802a92:	68 cd 44 80 00       	push   $0x8044cd
  802a97:	e8 70 0f 00 00       	call   803a0c <_panic>
  802a9c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802aa2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa5:	89 50 04             	mov    %edx,0x4(%eax)
  802aa8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aab:	8b 40 04             	mov    0x4(%eax),%eax
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	74 0c                	je     802abe <alloc_block_BF+0x30f>
  802ab2:	a1 30 50 80 00       	mov    0x805030,%eax
  802ab7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aba:	89 10                	mov    %edx,(%eax)
  802abc:	eb 08                	jmp    802ac6 <alloc_block_BF+0x317>
  802abe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ac6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac9:	a3 30 50 80 00       	mov    %eax,0x805030
  802ace:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad7:	a1 38 50 80 00       	mov    0x805038,%eax
  802adc:	40                   	inc    %eax
  802add:	a3 38 50 80 00       	mov    %eax,0x805038
  802ae2:	eb 6e                	jmp    802b52 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ae4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae8:	74 06                	je     802af0 <alloc_block_BF+0x341>
  802aea:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802aee:	75 17                	jne    802b07 <alloc_block_BF+0x358>
  802af0:	83 ec 04             	sub    $0x4,%esp
  802af3:	68 40 45 80 00       	push   $0x804540
  802af8:	68 4f 01 00 00       	push   $0x14f
  802afd:	68 cd 44 80 00       	push   $0x8044cd
  802b02:	e8 05 0f 00 00       	call   803a0c <_panic>
  802b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0a:	8b 10                	mov    (%eax),%edx
  802b0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0f:	89 10                	mov    %edx,(%eax)
  802b11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 0b                	je     802b25 <alloc_block_BF+0x376>
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b28:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b2b:	89 10                	mov    %edx,(%eax)
  802b2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b33:	89 50 04             	mov    %edx,0x4(%eax)
  802b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	75 08                	jne    802b47 <alloc_block_BF+0x398>
  802b3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b42:	a3 30 50 80 00       	mov    %eax,0x805030
  802b47:	a1 38 50 80 00       	mov    0x805038,%eax
  802b4c:	40                   	inc    %eax
  802b4d:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b56:	75 17                	jne    802b6f <alloc_block_BF+0x3c0>
  802b58:	83 ec 04             	sub    $0x4,%esp
  802b5b:	68 af 44 80 00       	push   $0x8044af
  802b60:	68 51 01 00 00       	push   $0x151
  802b65:	68 cd 44 80 00       	push   $0x8044cd
  802b6a:	e8 9d 0e 00 00       	call   803a0c <_panic>
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	85 c0                	test   %eax,%eax
  802b76:	74 10                	je     802b88 <alloc_block_BF+0x3d9>
  802b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7b:	8b 00                	mov    (%eax),%eax
  802b7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b80:	8b 52 04             	mov    0x4(%edx),%edx
  802b83:	89 50 04             	mov    %edx,0x4(%eax)
  802b86:	eb 0b                	jmp    802b93 <alloc_block_BF+0x3e4>
  802b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8b:	8b 40 04             	mov    0x4(%eax),%eax
  802b8e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 0f                	je     802bac <alloc_block_BF+0x3fd>
  802b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba0:	8b 40 04             	mov    0x4(%eax),%eax
  802ba3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba6:	8b 12                	mov    (%edx),%edx
  802ba8:	89 10                	mov    %edx,(%eax)
  802baa:	eb 0a                	jmp    802bb6 <alloc_block_BF+0x407>
  802bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc9:	a1 38 50 80 00       	mov    0x805038,%eax
  802bce:	48                   	dec    %eax
  802bcf:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bd4:	83 ec 04             	sub    $0x4,%esp
  802bd7:	6a 00                	push   $0x0
  802bd9:	ff 75 d0             	pushl  -0x30(%ebp)
  802bdc:	ff 75 cc             	pushl  -0x34(%ebp)
  802bdf:	e8 e0 f6 ff ff       	call   8022c4 <set_block_data>
  802be4:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bea:	e9 a3 01 00 00       	jmp    802d92 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bef:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bf3:	0f 85 9d 00 00 00    	jne    802c96 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bf9:	83 ec 04             	sub    $0x4,%esp
  802bfc:	6a 01                	push   $0x1
  802bfe:	ff 75 ec             	pushl  -0x14(%ebp)
  802c01:	ff 75 f0             	pushl  -0x10(%ebp)
  802c04:	e8 bb f6 ff ff       	call   8022c4 <set_block_data>
  802c09:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c10:	75 17                	jne    802c29 <alloc_block_BF+0x47a>
  802c12:	83 ec 04             	sub    $0x4,%esp
  802c15:	68 af 44 80 00       	push   $0x8044af
  802c1a:	68 58 01 00 00       	push   $0x158
  802c1f:	68 cd 44 80 00       	push   $0x8044cd
  802c24:	e8 e3 0d 00 00       	call   803a0c <_panic>
  802c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 10                	je     802c42 <alloc_block_BF+0x493>
  802c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3a:	8b 52 04             	mov    0x4(%edx),%edx
  802c3d:	89 50 04             	mov    %edx,0x4(%eax)
  802c40:	eb 0b                	jmp    802c4d <alloc_block_BF+0x49e>
  802c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c45:	8b 40 04             	mov    0x4(%eax),%eax
  802c48:	a3 30 50 80 00       	mov    %eax,0x805030
  802c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	85 c0                	test   %eax,%eax
  802c55:	74 0f                	je     802c66 <alloc_block_BF+0x4b7>
  802c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c60:	8b 12                	mov    (%edx),%edx
  802c62:	89 10                	mov    %edx,(%eax)
  802c64:	eb 0a                	jmp    802c70 <alloc_block_BF+0x4c1>
  802c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c83:	a1 38 50 80 00       	mov    0x805038,%eax
  802c88:	48                   	dec    %eax
  802c89:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c91:	e9 fc 00 00 00       	jmp    802d92 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	83 c0 08             	add    $0x8,%eax
  802c9c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c9f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ca6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ca9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cac:	01 d0                	add    %edx,%eax
  802cae:	48                   	dec    %eax
  802caf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cb2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cb5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cba:	f7 75 c4             	divl   -0x3c(%ebp)
  802cbd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cc0:	29 d0                	sub    %edx,%eax
  802cc2:	c1 e8 0c             	shr    $0xc,%eax
  802cc5:	83 ec 0c             	sub    $0xc,%esp
  802cc8:	50                   	push   %eax
  802cc9:	e8 0c e8 ff ff       	call   8014da <sbrk>
  802cce:	83 c4 10             	add    $0x10,%esp
  802cd1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cd4:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cd8:	75 0a                	jne    802ce4 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cda:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdf:	e9 ae 00 00 00       	jmp    802d92 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ce4:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802ceb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cf1:	01 d0                	add    %edx,%eax
  802cf3:	48                   	dec    %eax
  802cf4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cf7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cfa:	ba 00 00 00 00       	mov    $0x0,%edx
  802cff:	f7 75 b8             	divl   -0x48(%ebp)
  802d02:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d05:	29 d0                	sub    %edx,%eax
  802d07:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d0a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d0d:	01 d0                	add    %edx,%eax
  802d0f:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d14:	a1 40 50 80 00       	mov    0x805040,%eax
  802d19:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d1f:	83 ec 0c             	sub    $0xc,%esp
  802d22:	68 74 45 80 00       	push   $0x804574
  802d27:	e8 14 da ff ff       	call   800740 <cprintf>
  802d2c:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d2f:	83 ec 08             	sub    $0x8,%esp
  802d32:	ff 75 bc             	pushl  -0x44(%ebp)
  802d35:	68 79 45 80 00       	push   $0x804579
  802d3a:	e8 01 da ff ff       	call   800740 <cprintf>
  802d3f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d42:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d49:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d4c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d4f:	01 d0                	add    %edx,%eax
  802d51:	48                   	dec    %eax
  802d52:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d55:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d58:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5d:	f7 75 b0             	divl   -0x50(%ebp)
  802d60:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d63:	29 d0                	sub    %edx,%eax
  802d65:	83 ec 04             	sub    $0x4,%esp
  802d68:	6a 01                	push   $0x1
  802d6a:	50                   	push   %eax
  802d6b:	ff 75 bc             	pushl  -0x44(%ebp)
  802d6e:	e8 51 f5 ff ff       	call   8022c4 <set_block_data>
  802d73:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d76:	83 ec 0c             	sub    $0xc,%esp
  802d79:	ff 75 bc             	pushl  -0x44(%ebp)
  802d7c:	e8 36 04 00 00       	call   8031b7 <free_block>
  802d81:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d84:	83 ec 0c             	sub    $0xc,%esp
  802d87:	ff 75 08             	pushl  0x8(%ebp)
  802d8a:	e8 20 fa ff ff       	call   8027af <alloc_block_BF>
  802d8f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d92:	c9                   	leave  
  802d93:	c3                   	ret    

00802d94 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d94:	55                   	push   %ebp
  802d95:	89 e5                	mov    %esp,%ebp
  802d97:	53                   	push   %ebx
  802d98:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802da2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802da9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dad:	74 1e                	je     802dcd <merging+0x39>
  802daf:	ff 75 08             	pushl  0x8(%ebp)
  802db2:	e8 bc f1 ff ff       	call   801f73 <get_block_size>
  802db7:	83 c4 04             	add    $0x4,%esp
  802dba:	89 c2                	mov    %eax,%edx
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	01 d0                	add    %edx,%eax
  802dc1:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dc4:	75 07                	jne    802dcd <merging+0x39>
		prev_is_free = 1;
  802dc6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dd1:	74 1e                	je     802df1 <merging+0x5d>
  802dd3:	ff 75 10             	pushl  0x10(%ebp)
  802dd6:	e8 98 f1 ff ff       	call   801f73 <get_block_size>
  802ddb:	83 c4 04             	add    $0x4,%esp
  802dde:	89 c2                	mov    %eax,%edx
  802de0:	8b 45 10             	mov    0x10(%ebp),%eax
  802de3:	01 d0                	add    %edx,%eax
  802de5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802de8:	75 07                	jne    802df1 <merging+0x5d>
		next_is_free = 1;
  802dea:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802df1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df5:	0f 84 cc 00 00 00    	je     802ec7 <merging+0x133>
  802dfb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dff:	0f 84 c2 00 00 00    	je     802ec7 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e05:	ff 75 08             	pushl  0x8(%ebp)
  802e08:	e8 66 f1 ff ff       	call   801f73 <get_block_size>
  802e0d:	83 c4 04             	add    $0x4,%esp
  802e10:	89 c3                	mov    %eax,%ebx
  802e12:	ff 75 10             	pushl  0x10(%ebp)
  802e15:	e8 59 f1 ff ff       	call   801f73 <get_block_size>
  802e1a:	83 c4 04             	add    $0x4,%esp
  802e1d:	01 c3                	add    %eax,%ebx
  802e1f:	ff 75 0c             	pushl  0xc(%ebp)
  802e22:	e8 4c f1 ff ff       	call   801f73 <get_block_size>
  802e27:	83 c4 04             	add    $0x4,%esp
  802e2a:	01 d8                	add    %ebx,%eax
  802e2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e2f:	6a 00                	push   $0x0
  802e31:	ff 75 ec             	pushl  -0x14(%ebp)
  802e34:	ff 75 08             	pushl  0x8(%ebp)
  802e37:	e8 88 f4 ff ff       	call   8022c4 <set_block_data>
  802e3c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e43:	75 17                	jne    802e5c <merging+0xc8>
  802e45:	83 ec 04             	sub    $0x4,%esp
  802e48:	68 af 44 80 00       	push   $0x8044af
  802e4d:	68 7d 01 00 00       	push   $0x17d
  802e52:	68 cd 44 80 00       	push   $0x8044cd
  802e57:	e8 b0 0b 00 00       	call   803a0c <_panic>
  802e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5f:	8b 00                	mov    (%eax),%eax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	74 10                	je     802e75 <merging+0xe1>
  802e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e6d:	8b 52 04             	mov    0x4(%edx),%edx
  802e70:	89 50 04             	mov    %edx,0x4(%eax)
  802e73:	eb 0b                	jmp    802e80 <merging+0xec>
  802e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e78:	8b 40 04             	mov    0x4(%eax),%eax
  802e7b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e83:	8b 40 04             	mov    0x4(%eax),%eax
  802e86:	85 c0                	test   %eax,%eax
  802e88:	74 0f                	je     802e99 <merging+0x105>
  802e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8d:	8b 40 04             	mov    0x4(%eax),%eax
  802e90:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e93:	8b 12                	mov    (%edx),%edx
  802e95:	89 10                	mov    %edx,(%eax)
  802e97:	eb 0a                	jmp    802ea3 <merging+0x10f>
  802e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9c:	8b 00                	mov    (%eax),%eax
  802e9e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eaf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb6:	a1 38 50 80 00       	mov    0x805038,%eax
  802ebb:	48                   	dec    %eax
  802ebc:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ec1:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ec2:	e9 ea 02 00 00       	jmp    8031b1 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ec7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecb:	74 3b                	je     802f08 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ecd:	83 ec 0c             	sub    $0xc,%esp
  802ed0:	ff 75 08             	pushl  0x8(%ebp)
  802ed3:	e8 9b f0 ff ff       	call   801f73 <get_block_size>
  802ed8:	83 c4 10             	add    $0x10,%esp
  802edb:	89 c3                	mov    %eax,%ebx
  802edd:	83 ec 0c             	sub    $0xc,%esp
  802ee0:	ff 75 10             	pushl  0x10(%ebp)
  802ee3:	e8 8b f0 ff ff       	call   801f73 <get_block_size>
  802ee8:	83 c4 10             	add    $0x10,%esp
  802eeb:	01 d8                	add    %ebx,%eax
  802eed:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ef0:	83 ec 04             	sub    $0x4,%esp
  802ef3:	6a 00                	push   $0x0
  802ef5:	ff 75 e8             	pushl  -0x18(%ebp)
  802ef8:	ff 75 08             	pushl  0x8(%ebp)
  802efb:	e8 c4 f3 ff ff       	call   8022c4 <set_block_data>
  802f00:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f03:	e9 a9 02 00 00       	jmp    8031b1 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f0c:	0f 84 2d 01 00 00    	je     80303f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f12:	83 ec 0c             	sub    $0xc,%esp
  802f15:	ff 75 10             	pushl  0x10(%ebp)
  802f18:	e8 56 f0 ff ff       	call   801f73 <get_block_size>
  802f1d:	83 c4 10             	add    $0x10,%esp
  802f20:	89 c3                	mov    %eax,%ebx
  802f22:	83 ec 0c             	sub    $0xc,%esp
  802f25:	ff 75 0c             	pushl  0xc(%ebp)
  802f28:	e8 46 f0 ff ff       	call   801f73 <get_block_size>
  802f2d:	83 c4 10             	add    $0x10,%esp
  802f30:	01 d8                	add    %ebx,%eax
  802f32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	6a 00                	push   $0x0
  802f3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f3d:	ff 75 10             	pushl  0x10(%ebp)
  802f40:	e8 7f f3 ff ff       	call   8022c4 <set_block_data>
  802f45:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f48:	8b 45 10             	mov    0x10(%ebp),%eax
  802f4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f52:	74 06                	je     802f5a <merging+0x1c6>
  802f54:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f58:	75 17                	jne    802f71 <merging+0x1dd>
  802f5a:	83 ec 04             	sub    $0x4,%esp
  802f5d:	68 88 45 80 00       	push   $0x804588
  802f62:	68 8d 01 00 00       	push   $0x18d
  802f67:	68 cd 44 80 00       	push   $0x8044cd
  802f6c:	e8 9b 0a 00 00       	call   803a0c <_panic>
  802f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f74:	8b 50 04             	mov    0x4(%eax),%edx
  802f77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f7a:	89 50 04             	mov    %edx,0x4(%eax)
  802f7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f83:	89 10                	mov    %edx,(%eax)
  802f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f88:	8b 40 04             	mov    0x4(%eax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	74 0d                	je     802f9c <merging+0x208>
  802f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f92:	8b 40 04             	mov    0x4(%eax),%eax
  802f95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f98:	89 10                	mov    %edx,(%eax)
  802f9a:	eb 08                	jmp    802fa4 <merging+0x210>
  802f9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802faa:	89 50 04             	mov    %edx,0x4(%eax)
  802fad:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb2:	40                   	inc    %eax
  802fb3:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fbc:	75 17                	jne    802fd5 <merging+0x241>
  802fbe:	83 ec 04             	sub    $0x4,%esp
  802fc1:	68 af 44 80 00       	push   $0x8044af
  802fc6:	68 8e 01 00 00       	push   $0x18e
  802fcb:	68 cd 44 80 00       	push   $0x8044cd
  802fd0:	e8 37 0a 00 00       	call   803a0c <_panic>
  802fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	74 10                	je     802fee <merging+0x25a>
  802fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe1:	8b 00                	mov    (%eax),%eax
  802fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe6:	8b 52 04             	mov    0x4(%edx),%edx
  802fe9:	89 50 04             	mov    %edx,0x4(%eax)
  802fec:	eb 0b                	jmp    802ff9 <merging+0x265>
  802fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff1:	8b 40 04             	mov    0x4(%eax),%eax
  802ff4:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 0f                	je     803012 <merging+0x27e>
  803003:	8b 45 0c             	mov    0xc(%ebp),%eax
  803006:	8b 40 04             	mov    0x4(%eax),%eax
  803009:	8b 55 0c             	mov    0xc(%ebp),%edx
  80300c:	8b 12                	mov    (%edx),%edx
  80300e:	89 10                	mov    %edx,(%eax)
  803010:	eb 0a                	jmp    80301c <merging+0x288>
  803012:	8b 45 0c             	mov    0xc(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80301c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803025:	8b 45 0c             	mov    0xc(%ebp),%eax
  803028:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302f:	a1 38 50 80 00       	mov    0x805038,%eax
  803034:	48                   	dec    %eax
  803035:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80303a:	e9 72 01 00 00       	jmp    8031b1 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80303f:	8b 45 10             	mov    0x10(%ebp),%eax
  803042:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803045:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803049:	74 79                	je     8030c4 <merging+0x330>
  80304b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80304f:	74 73                	je     8030c4 <merging+0x330>
  803051:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803055:	74 06                	je     80305d <merging+0x2c9>
  803057:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80305b:	75 17                	jne    803074 <merging+0x2e0>
  80305d:	83 ec 04             	sub    $0x4,%esp
  803060:	68 40 45 80 00       	push   $0x804540
  803065:	68 94 01 00 00       	push   $0x194
  80306a:	68 cd 44 80 00       	push   $0x8044cd
  80306f:	e8 98 09 00 00       	call   803a0c <_panic>
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	8b 10                	mov    (%eax),%edx
  803079:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307c:	89 10                	mov    %edx,(%eax)
  80307e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803081:	8b 00                	mov    (%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 0b                	je     803092 <merging+0x2fe>
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80308f:	89 50 04             	mov    %edx,0x4(%eax)
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803098:	89 10                	mov    %edx,(%eax)
  80309a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309d:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a0:	89 50 04             	mov    %edx,0x4(%eax)
  8030a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a6:	8b 00                	mov    (%eax),%eax
  8030a8:	85 c0                	test   %eax,%eax
  8030aa:	75 08                	jne    8030b4 <merging+0x320>
  8030ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030af:	a3 30 50 80 00       	mov    %eax,0x805030
  8030b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8030b9:	40                   	inc    %eax
  8030ba:	a3 38 50 80 00       	mov    %eax,0x805038
  8030bf:	e9 ce 00 00 00       	jmp    803192 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c8:	74 65                	je     80312f <merging+0x39b>
  8030ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030ce:	75 17                	jne    8030e7 <merging+0x353>
  8030d0:	83 ec 04             	sub    $0x4,%esp
  8030d3:	68 1c 45 80 00       	push   $0x80451c
  8030d8:	68 95 01 00 00       	push   $0x195
  8030dd:	68 cd 44 80 00       	push   $0x8044cd
  8030e2:	e8 25 09 00 00       	call   803a0c <_panic>
  8030e7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f0:	89 50 04             	mov    %edx,0x4(%eax)
  8030f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f6:	8b 40 04             	mov    0x4(%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	74 0c                	je     803109 <merging+0x375>
  8030fd:	a1 30 50 80 00       	mov    0x805030,%eax
  803102:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803105:	89 10                	mov    %edx,(%eax)
  803107:	eb 08                	jmp    803111 <merging+0x37d>
  803109:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803111:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803114:	a3 30 50 80 00       	mov    %eax,0x805030
  803119:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803122:	a1 38 50 80 00       	mov    0x805038,%eax
  803127:	40                   	inc    %eax
  803128:	a3 38 50 80 00       	mov    %eax,0x805038
  80312d:	eb 63                	jmp    803192 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80312f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803133:	75 17                	jne    80314c <merging+0x3b8>
  803135:	83 ec 04             	sub    $0x4,%esp
  803138:	68 e8 44 80 00       	push   $0x8044e8
  80313d:	68 98 01 00 00       	push   $0x198
  803142:	68 cd 44 80 00       	push   $0x8044cd
  803147:	e8 c0 08 00 00       	call   803a0c <_panic>
  80314c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803152:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803155:	89 10                	mov    %edx,(%eax)
  803157:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315a:	8b 00                	mov    (%eax),%eax
  80315c:	85 c0                	test   %eax,%eax
  80315e:	74 0d                	je     80316d <merging+0x3d9>
  803160:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803165:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803168:	89 50 04             	mov    %edx,0x4(%eax)
  80316b:	eb 08                	jmp    803175 <merging+0x3e1>
  80316d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803170:	a3 30 50 80 00       	mov    %eax,0x805030
  803175:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803178:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80317d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803180:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803187:	a1 38 50 80 00       	mov    0x805038,%eax
  80318c:	40                   	inc    %eax
  80318d:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803192:	83 ec 0c             	sub    $0xc,%esp
  803195:	ff 75 10             	pushl  0x10(%ebp)
  803198:	e8 d6 ed ff ff       	call   801f73 <get_block_size>
  80319d:	83 c4 10             	add    $0x10,%esp
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	6a 00                	push   $0x0
  8031a5:	50                   	push   %eax
  8031a6:	ff 75 10             	pushl  0x10(%ebp)
  8031a9:	e8 16 f1 ff ff       	call   8022c4 <set_block_data>
  8031ae:	83 c4 10             	add    $0x10,%esp
	}
}
  8031b1:	90                   	nop
  8031b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031b5:	c9                   	leave  
  8031b6:	c3                   	ret    

008031b7 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031b7:	55                   	push   %ebp
  8031b8:	89 e5                	mov    %esp,%ebp
  8031ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031bd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031c5:	a1 30 50 80 00       	mov    0x805030,%eax
  8031ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031cd:	73 1b                	jae    8031ea <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031cf:	a1 30 50 80 00       	mov    0x805030,%eax
  8031d4:	83 ec 04             	sub    $0x4,%esp
  8031d7:	ff 75 08             	pushl  0x8(%ebp)
  8031da:	6a 00                	push   $0x0
  8031dc:	50                   	push   %eax
  8031dd:	e8 b2 fb ff ff       	call   802d94 <merging>
  8031e2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031e5:	e9 8b 00 00 00       	jmp    803275 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031ea:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f2:	76 18                	jbe    80320c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031f4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	ff 75 08             	pushl  0x8(%ebp)
  8031ff:	50                   	push   %eax
  803200:	6a 00                	push   $0x0
  803202:	e8 8d fb ff ff       	call   802d94 <merging>
  803207:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80320a:	eb 69                	jmp    803275 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80320c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803214:	eb 39                	jmp    80324f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803219:	3b 45 08             	cmp    0x8(%ebp),%eax
  80321c:	73 29                	jae    803247 <free_block+0x90>
  80321e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	3b 45 08             	cmp    0x8(%ebp),%eax
  803226:	76 1f                	jbe    803247 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803230:	83 ec 04             	sub    $0x4,%esp
  803233:	ff 75 08             	pushl  0x8(%ebp)
  803236:	ff 75 f0             	pushl  -0x10(%ebp)
  803239:	ff 75 f4             	pushl  -0xc(%ebp)
  80323c:	e8 53 fb ff ff       	call   802d94 <merging>
  803241:	83 c4 10             	add    $0x10,%esp
			break;
  803244:	90                   	nop
		}
	}
}
  803245:	eb 2e                	jmp    803275 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803247:	a1 34 50 80 00       	mov    0x805034,%eax
  80324c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80324f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803253:	74 07                	je     80325c <free_block+0xa5>
  803255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803258:	8b 00                	mov    (%eax),%eax
  80325a:	eb 05                	jmp    803261 <free_block+0xaa>
  80325c:	b8 00 00 00 00       	mov    $0x0,%eax
  803261:	a3 34 50 80 00       	mov    %eax,0x805034
  803266:	a1 34 50 80 00       	mov    0x805034,%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	75 a7                	jne    803216 <free_block+0x5f>
  80326f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803273:	75 a1                	jne    803216 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803275:	90                   	nop
  803276:	c9                   	leave  
  803277:	c3                   	ret    

00803278 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803278:	55                   	push   %ebp
  803279:	89 e5                	mov    %esp,%ebp
  80327b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80327e:	ff 75 08             	pushl  0x8(%ebp)
  803281:	e8 ed ec ff ff       	call   801f73 <get_block_size>
  803286:	83 c4 04             	add    $0x4,%esp
  803289:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80328c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803293:	eb 17                	jmp    8032ac <copy_data+0x34>
  803295:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329b:	01 c2                	add    %eax,%edx
  80329d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	01 c8                	add    %ecx,%eax
  8032a5:	8a 00                	mov    (%eax),%al
  8032a7:	88 02                	mov    %al,(%edx)
  8032a9:	ff 45 fc             	incl   -0x4(%ebp)
  8032ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032b2:	72 e1                	jb     803295 <copy_data+0x1d>
}
  8032b4:	90                   	nop
  8032b5:	c9                   	leave  
  8032b6:	c3                   	ret    

008032b7 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032b7:	55                   	push   %ebp
  8032b8:	89 e5                	mov    %esp,%ebp
  8032ba:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c1:	75 23                	jne    8032e6 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032c7:	74 13                	je     8032dc <realloc_block_FF+0x25>
  8032c9:	83 ec 0c             	sub    $0xc,%esp
  8032cc:	ff 75 0c             	pushl  0xc(%ebp)
  8032cf:	e8 1f f0 ff ff       	call   8022f3 <alloc_block_FF>
  8032d4:	83 c4 10             	add    $0x10,%esp
  8032d7:	e9 f4 06 00 00       	jmp    8039d0 <realloc_block_FF+0x719>
		return NULL;
  8032dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e1:	e9 ea 06 00 00       	jmp    8039d0 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032ea:	75 18                	jne    803304 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032ec:	83 ec 0c             	sub    $0xc,%esp
  8032ef:	ff 75 08             	pushl  0x8(%ebp)
  8032f2:	e8 c0 fe ff ff       	call   8031b7 <free_block>
  8032f7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ff:	e9 cc 06 00 00       	jmp    8039d0 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803304:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803308:	77 07                	ja     803311 <realloc_block_FF+0x5a>
  80330a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803311:	8b 45 0c             	mov    0xc(%ebp),%eax
  803314:	83 e0 01             	and    $0x1,%eax
  803317:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80331a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80331d:	83 c0 08             	add    $0x8,%eax
  803320:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803323:	83 ec 0c             	sub    $0xc,%esp
  803326:	ff 75 08             	pushl  0x8(%ebp)
  803329:	e8 45 ec ff ff       	call   801f73 <get_block_size>
  80332e:	83 c4 10             	add    $0x10,%esp
  803331:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803334:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803337:	83 e8 08             	sub    $0x8,%eax
  80333a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	83 e8 04             	sub    $0x4,%eax
  803343:	8b 00                	mov    (%eax),%eax
  803345:	83 e0 fe             	and    $0xfffffffe,%eax
  803348:	89 c2                	mov    %eax,%edx
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	01 d0                	add    %edx,%eax
  80334f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803352:	83 ec 0c             	sub    $0xc,%esp
  803355:	ff 75 e4             	pushl  -0x1c(%ebp)
  803358:	e8 16 ec ff ff       	call   801f73 <get_block_size>
  80335d:	83 c4 10             	add    $0x10,%esp
  803360:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803363:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803366:	83 e8 08             	sub    $0x8,%eax
  803369:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80336c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803372:	75 08                	jne    80337c <realloc_block_FF+0xc5>
	{
		 return va;
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	e9 54 06 00 00       	jmp    8039d0 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80337c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803382:	0f 83 e5 03 00 00    	jae    80376d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803388:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80338e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803391:	83 ec 0c             	sub    $0xc,%esp
  803394:	ff 75 e4             	pushl  -0x1c(%ebp)
  803397:	e8 f0 eb ff ff       	call   801f8c <is_free_block>
  80339c:	83 c4 10             	add    $0x10,%esp
  80339f:	84 c0                	test   %al,%al
  8033a1:	0f 84 3b 01 00 00    	je     8034e2 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ad:	01 d0                	add    %edx,%eax
  8033af:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033b2:	83 ec 04             	sub    $0x4,%esp
  8033b5:	6a 01                	push   $0x1
  8033b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8033ba:	ff 75 08             	pushl  0x8(%ebp)
  8033bd:	e8 02 ef ff ff       	call   8022c4 <set_block_data>
  8033c2:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	83 e8 04             	sub    $0x4,%eax
  8033cb:	8b 00                	mov    (%eax),%eax
  8033cd:	83 e0 fe             	and    $0xfffffffe,%eax
  8033d0:	89 c2                	mov    %eax,%edx
  8033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d5:	01 d0                	add    %edx,%eax
  8033d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033da:	83 ec 04             	sub    $0x4,%esp
  8033dd:	6a 00                	push   $0x0
  8033df:	ff 75 cc             	pushl  -0x34(%ebp)
  8033e2:	ff 75 c8             	pushl  -0x38(%ebp)
  8033e5:	e8 da ee ff ff       	call   8022c4 <set_block_data>
  8033ea:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033f1:	74 06                	je     8033f9 <realloc_block_FF+0x142>
  8033f3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033f7:	75 17                	jne    803410 <realloc_block_FF+0x159>
  8033f9:	83 ec 04             	sub    $0x4,%esp
  8033fc:	68 40 45 80 00       	push   $0x804540
  803401:	68 f6 01 00 00       	push   $0x1f6
  803406:	68 cd 44 80 00       	push   $0x8044cd
  80340b:	e8 fc 05 00 00       	call   803a0c <_panic>
  803410:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803413:	8b 10                	mov    (%eax),%edx
  803415:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803418:	89 10                	mov    %edx,(%eax)
  80341a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80341d:	8b 00                	mov    (%eax),%eax
  80341f:	85 c0                	test   %eax,%eax
  803421:	74 0b                	je     80342e <realloc_block_FF+0x177>
  803423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80342b:	89 50 04             	mov    %edx,0x4(%eax)
  80342e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803431:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803434:	89 10                	mov    %edx,(%eax)
  803436:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803439:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80343c:	89 50 04             	mov    %edx,0x4(%eax)
  80343f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	85 c0                	test   %eax,%eax
  803446:	75 08                	jne    803450 <realloc_block_FF+0x199>
  803448:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80344b:	a3 30 50 80 00       	mov    %eax,0x805030
  803450:	a1 38 50 80 00       	mov    0x805038,%eax
  803455:	40                   	inc    %eax
  803456:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80345b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80345f:	75 17                	jne    803478 <realloc_block_FF+0x1c1>
  803461:	83 ec 04             	sub    $0x4,%esp
  803464:	68 af 44 80 00       	push   $0x8044af
  803469:	68 f7 01 00 00       	push   $0x1f7
  80346e:	68 cd 44 80 00       	push   $0x8044cd
  803473:	e8 94 05 00 00       	call   803a0c <_panic>
  803478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347b:	8b 00                	mov    (%eax),%eax
  80347d:	85 c0                	test   %eax,%eax
  80347f:	74 10                	je     803491 <realloc_block_FF+0x1da>
  803481:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803484:	8b 00                	mov    (%eax),%eax
  803486:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803489:	8b 52 04             	mov    0x4(%edx),%edx
  80348c:	89 50 04             	mov    %edx,0x4(%eax)
  80348f:	eb 0b                	jmp    80349c <realloc_block_FF+0x1e5>
  803491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803494:	8b 40 04             	mov    0x4(%eax),%eax
  803497:	a3 30 50 80 00       	mov    %eax,0x805030
  80349c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349f:	8b 40 04             	mov    0x4(%eax),%eax
  8034a2:	85 c0                	test   %eax,%eax
  8034a4:	74 0f                	je     8034b5 <realloc_block_FF+0x1fe>
  8034a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a9:	8b 40 04             	mov    0x4(%eax),%eax
  8034ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034af:	8b 12                	mov    (%edx),%edx
  8034b1:	89 10                	mov    %edx,(%eax)
  8034b3:	eb 0a                	jmp    8034bf <realloc_block_FF+0x208>
  8034b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b8:	8b 00                	mov    (%eax),%eax
  8034ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d2:	a1 38 50 80 00       	mov    0x805038,%eax
  8034d7:	48                   	dec    %eax
  8034d8:	a3 38 50 80 00       	mov    %eax,0x805038
  8034dd:	e9 83 02 00 00       	jmp    803765 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034e2:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034e6:	0f 86 69 02 00 00    	jbe    803755 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034ec:	83 ec 04             	sub    $0x4,%esp
  8034ef:	6a 01                	push   $0x1
  8034f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8034f4:	ff 75 08             	pushl  0x8(%ebp)
  8034f7:	e8 c8 ed ff ff       	call   8022c4 <set_block_data>
  8034fc:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	83 e8 04             	sub    $0x4,%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	83 e0 fe             	and    $0xfffffffe,%eax
  80350a:	89 c2                	mov    %eax,%edx
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	01 d0                	add    %edx,%eax
  803511:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803514:	a1 38 50 80 00       	mov    0x805038,%eax
  803519:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80351c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803520:	75 68                	jne    80358a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803522:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803526:	75 17                	jne    80353f <realloc_block_FF+0x288>
  803528:	83 ec 04             	sub    $0x4,%esp
  80352b:	68 e8 44 80 00       	push   $0x8044e8
  803530:	68 06 02 00 00       	push   $0x206
  803535:	68 cd 44 80 00       	push   $0x8044cd
  80353a:	e8 cd 04 00 00       	call   803a0c <_panic>
  80353f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803545:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803548:	89 10                	mov    %edx,(%eax)
  80354a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354d:	8b 00                	mov    (%eax),%eax
  80354f:	85 c0                	test   %eax,%eax
  803551:	74 0d                	je     803560 <realloc_block_FF+0x2a9>
  803553:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803558:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80355b:	89 50 04             	mov    %edx,0x4(%eax)
  80355e:	eb 08                	jmp    803568 <realloc_block_FF+0x2b1>
  803560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803563:	a3 30 50 80 00       	mov    %eax,0x805030
  803568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803570:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803573:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357a:	a1 38 50 80 00       	mov    0x805038,%eax
  80357f:	40                   	inc    %eax
  803580:	a3 38 50 80 00       	mov    %eax,0x805038
  803585:	e9 b0 01 00 00       	jmp    80373a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80358a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80358f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803592:	76 68                	jbe    8035fc <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803594:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803598:	75 17                	jne    8035b1 <realloc_block_FF+0x2fa>
  80359a:	83 ec 04             	sub    $0x4,%esp
  80359d:	68 e8 44 80 00       	push   $0x8044e8
  8035a2:	68 0b 02 00 00       	push   $0x20b
  8035a7:	68 cd 44 80 00       	push   $0x8044cd
  8035ac:	e8 5b 04 00 00       	call   803a0c <_panic>
  8035b1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ba:	89 10                	mov    %edx,(%eax)
  8035bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	85 c0                	test   %eax,%eax
  8035c3:	74 0d                	je     8035d2 <realloc_block_FF+0x31b>
  8035c5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035cd:	89 50 04             	mov    %edx,0x4(%eax)
  8035d0:	eb 08                	jmp    8035da <realloc_block_FF+0x323>
  8035d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8035da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035dd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f1:	40                   	inc    %eax
  8035f2:	a3 38 50 80 00       	mov    %eax,0x805038
  8035f7:	e9 3e 01 00 00       	jmp    80373a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035fc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803601:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803604:	73 68                	jae    80366e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803606:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80360a:	75 17                	jne    803623 <realloc_block_FF+0x36c>
  80360c:	83 ec 04             	sub    $0x4,%esp
  80360f:	68 1c 45 80 00       	push   $0x80451c
  803614:	68 10 02 00 00       	push   $0x210
  803619:	68 cd 44 80 00       	push   $0x8044cd
  80361e:	e8 e9 03 00 00       	call   803a0c <_panic>
  803623:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803629:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362c:	89 50 04             	mov    %edx,0x4(%eax)
  80362f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803632:	8b 40 04             	mov    0x4(%eax),%eax
  803635:	85 c0                	test   %eax,%eax
  803637:	74 0c                	je     803645 <realloc_block_FF+0x38e>
  803639:	a1 30 50 80 00       	mov    0x805030,%eax
  80363e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803641:	89 10                	mov    %edx,(%eax)
  803643:	eb 08                	jmp    80364d <realloc_block_FF+0x396>
  803645:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803648:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80364d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803650:	a3 30 50 80 00       	mov    %eax,0x805030
  803655:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803658:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80365e:	a1 38 50 80 00       	mov    0x805038,%eax
  803663:	40                   	inc    %eax
  803664:	a3 38 50 80 00       	mov    %eax,0x805038
  803669:	e9 cc 00 00 00       	jmp    80373a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80366e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803675:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80367a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80367d:	e9 8a 00 00 00       	jmp    80370c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803685:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803688:	73 7a                	jae    803704 <realloc_block_FF+0x44d>
  80368a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803692:	73 70                	jae    803704 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803698:	74 06                	je     8036a0 <realloc_block_FF+0x3e9>
  80369a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80369e:	75 17                	jne    8036b7 <realloc_block_FF+0x400>
  8036a0:	83 ec 04             	sub    $0x4,%esp
  8036a3:	68 40 45 80 00       	push   $0x804540
  8036a8:	68 1a 02 00 00       	push   $0x21a
  8036ad:	68 cd 44 80 00       	push   $0x8044cd
  8036b2:	e8 55 03 00 00       	call   803a0c <_panic>
  8036b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ba:	8b 10                	mov    (%eax),%edx
  8036bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bf:	89 10                	mov    %edx,(%eax)
  8036c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c4:	8b 00                	mov    (%eax),%eax
  8036c6:	85 c0                	test   %eax,%eax
  8036c8:	74 0b                	je     8036d5 <realloc_block_FF+0x41e>
  8036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cd:	8b 00                	mov    (%eax),%eax
  8036cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d2:	89 50 04             	mov    %edx,0x4(%eax)
  8036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036db:	89 10                	mov    %edx,(%eax)
  8036dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e3:	89 50 04             	mov    %edx,0x4(%eax)
  8036e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e9:	8b 00                	mov    (%eax),%eax
  8036eb:	85 c0                	test   %eax,%eax
  8036ed:	75 08                	jne    8036f7 <realloc_block_FF+0x440>
  8036ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8036f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8036fc:	40                   	inc    %eax
  8036fd:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803702:	eb 36                	jmp    80373a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803704:	a1 34 50 80 00       	mov    0x805034,%eax
  803709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80370c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803710:	74 07                	je     803719 <realloc_block_FF+0x462>
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	8b 00                	mov    (%eax),%eax
  803717:	eb 05                	jmp    80371e <realloc_block_FF+0x467>
  803719:	b8 00 00 00 00       	mov    $0x0,%eax
  80371e:	a3 34 50 80 00       	mov    %eax,0x805034
  803723:	a1 34 50 80 00       	mov    0x805034,%eax
  803728:	85 c0                	test   %eax,%eax
  80372a:	0f 85 52 ff ff ff    	jne    803682 <realloc_block_FF+0x3cb>
  803730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803734:	0f 85 48 ff ff ff    	jne    803682 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80373a:	83 ec 04             	sub    $0x4,%esp
  80373d:	6a 00                	push   $0x0
  80373f:	ff 75 d8             	pushl  -0x28(%ebp)
  803742:	ff 75 d4             	pushl  -0x2c(%ebp)
  803745:	e8 7a eb ff ff       	call   8022c4 <set_block_data>
  80374a:	83 c4 10             	add    $0x10,%esp
				return va;
  80374d:	8b 45 08             	mov    0x8(%ebp),%eax
  803750:	e9 7b 02 00 00       	jmp    8039d0 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803755:	83 ec 0c             	sub    $0xc,%esp
  803758:	68 bd 45 80 00       	push   $0x8045bd
  80375d:	e8 de cf ff ff       	call   800740 <cprintf>
  803762:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803765:	8b 45 08             	mov    0x8(%ebp),%eax
  803768:	e9 63 02 00 00       	jmp    8039d0 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80376d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803770:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803773:	0f 86 4d 02 00 00    	jbe    8039c6 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803779:	83 ec 0c             	sub    $0xc,%esp
  80377c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80377f:	e8 08 e8 ff ff       	call   801f8c <is_free_block>
  803784:	83 c4 10             	add    $0x10,%esp
  803787:	84 c0                	test   %al,%al
  803789:	0f 84 37 02 00 00    	je     8039c6 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80378f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803792:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803795:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803798:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80379b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80379e:	76 38                	jbe    8037d8 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037a0:	83 ec 0c             	sub    $0xc,%esp
  8037a3:	ff 75 08             	pushl  0x8(%ebp)
  8037a6:	e8 0c fa ff ff       	call   8031b7 <free_block>
  8037ab:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037ae:	83 ec 0c             	sub    $0xc,%esp
  8037b1:	ff 75 0c             	pushl  0xc(%ebp)
  8037b4:	e8 3a eb ff ff       	call   8022f3 <alloc_block_FF>
  8037b9:	83 c4 10             	add    $0x10,%esp
  8037bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037bf:	83 ec 08             	sub    $0x8,%esp
  8037c2:	ff 75 c0             	pushl  -0x40(%ebp)
  8037c5:	ff 75 08             	pushl  0x8(%ebp)
  8037c8:	e8 ab fa ff ff       	call   803278 <copy_data>
  8037cd:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037d3:	e9 f8 01 00 00       	jmp    8039d0 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037db:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037de:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037e1:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037e5:	0f 87 a0 00 00 00    	ja     80388b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037ef:	75 17                	jne    803808 <realloc_block_FF+0x551>
  8037f1:	83 ec 04             	sub    $0x4,%esp
  8037f4:	68 af 44 80 00       	push   $0x8044af
  8037f9:	68 38 02 00 00       	push   $0x238
  8037fe:	68 cd 44 80 00       	push   $0x8044cd
  803803:	e8 04 02 00 00       	call   803a0c <_panic>
  803808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380b:	8b 00                	mov    (%eax),%eax
  80380d:	85 c0                	test   %eax,%eax
  80380f:	74 10                	je     803821 <realloc_block_FF+0x56a>
  803811:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803814:	8b 00                	mov    (%eax),%eax
  803816:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803819:	8b 52 04             	mov    0x4(%edx),%edx
  80381c:	89 50 04             	mov    %edx,0x4(%eax)
  80381f:	eb 0b                	jmp    80382c <realloc_block_FF+0x575>
  803821:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803824:	8b 40 04             	mov    0x4(%eax),%eax
  803827:	a3 30 50 80 00       	mov    %eax,0x805030
  80382c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382f:	8b 40 04             	mov    0x4(%eax),%eax
  803832:	85 c0                	test   %eax,%eax
  803834:	74 0f                	je     803845 <realloc_block_FF+0x58e>
  803836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803839:	8b 40 04             	mov    0x4(%eax),%eax
  80383c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80383f:	8b 12                	mov    (%edx),%edx
  803841:	89 10                	mov    %edx,(%eax)
  803843:	eb 0a                	jmp    80384f <realloc_block_FF+0x598>
  803845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803848:	8b 00                	mov    (%eax),%eax
  80384a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80384f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803852:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803858:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803862:	a1 38 50 80 00       	mov    0x805038,%eax
  803867:	48                   	dec    %eax
  803868:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80386d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803870:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803873:	01 d0                	add    %edx,%eax
  803875:	83 ec 04             	sub    $0x4,%esp
  803878:	6a 01                	push   $0x1
  80387a:	50                   	push   %eax
  80387b:	ff 75 08             	pushl  0x8(%ebp)
  80387e:	e8 41 ea ff ff       	call   8022c4 <set_block_data>
  803883:	83 c4 10             	add    $0x10,%esp
  803886:	e9 36 01 00 00       	jmp    8039c1 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80388b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80388e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803891:	01 d0                	add    %edx,%eax
  803893:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803896:	83 ec 04             	sub    $0x4,%esp
  803899:	6a 01                	push   $0x1
  80389b:	ff 75 f0             	pushl  -0x10(%ebp)
  80389e:	ff 75 08             	pushl  0x8(%ebp)
  8038a1:	e8 1e ea ff ff       	call   8022c4 <set_block_data>
  8038a6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	83 e8 04             	sub    $0x4,%eax
  8038af:	8b 00                	mov    (%eax),%eax
  8038b1:	83 e0 fe             	and    $0xfffffffe,%eax
  8038b4:	89 c2                	mov    %eax,%edx
  8038b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b9:	01 d0                	add    %edx,%eax
  8038bb:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c2:	74 06                	je     8038ca <realloc_block_FF+0x613>
  8038c4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038c8:	75 17                	jne    8038e1 <realloc_block_FF+0x62a>
  8038ca:	83 ec 04             	sub    $0x4,%esp
  8038cd:	68 40 45 80 00       	push   $0x804540
  8038d2:	68 44 02 00 00       	push   $0x244
  8038d7:	68 cd 44 80 00       	push   $0x8044cd
  8038dc:	e8 2b 01 00 00       	call   803a0c <_panic>
  8038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e4:	8b 10                	mov    (%eax),%edx
  8038e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e9:	89 10                	mov    %edx,(%eax)
  8038eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ee:	8b 00                	mov    (%eax),%eax
  8038f0:	85 c0                	test   %eax,%eax
  8038f2:	74 0b                	je     8038ff <realloc_block_FF+0x648>
  8038f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f7:	8b 00                	mov    (%eax),%eax
  8038f9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038fc:	89 50 04             	mov    %edx,0x4(%eax)
  8038ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803902:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803905:	89 10                	mov    %edx,(%eax)
  803907:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80390a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390d:	89 50 04             	mov    %edx,0x4(%eax)
  803910:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803913:	8b 00                	mov    (%eax),%eax
  803915:	85 c0                	test   %eax,%eax
  803917:	75 08                	jne    803921 <realloc_block_FF+0x66a>
  803919:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80391c:	a3 30 50 80 00       	mov    %eax,0x805030
  803921:	a1 38 50 80 00       	mov    0x805038,%eax
  803926:	40                   	inc    %eax
  803927:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80392c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803930:	75 17                	jne    803949 <realloc_block_FF+0x692>
  803932:	83 ec 04             	sub    $0x4,%esp
  803935:	68 af 44 80 00       	push   $0x8044af
  80393a:	68 45 02 00 00       	push   $0x245
  80393f:	68 cd 44 80 00       	push   $0x8044cd
  803944:	e8 c3 00 00 00       	call   803a0c <_panic>
  803949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	85 c0                	test   %eax,%eax
  803950:	74 10                	je     803962 <realloc_block_FF+0x6ab>
  803952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803955:	8b 00                	mov    (%eax),%eax
  803957:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80395a:	8b 52 04             	mov    0x4(%edx),%edx
  80395d:	89 50 04             	mov    %edx,0x4(%eax)
  803960:	eb 0b                	jmp    80396d <realloc_block_FF+0x6b6>
  803962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803965:	8b 40 04             	mov    0x4(%eax),%eax
  803968:	a3 30 50 80 00       	mov    %eax,0x805030
  80396d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803970:	8b 40 04             	mov    0x4(%eax),%eax
  803973:	85 c0                	test   %eax,%eax
  803975:	74 0f                	je     803986 <realloc_block_FF+0x6cf>
  803977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397a:	8b 40 04             	mov    0x4(%eax),%eax
  80397d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803980:	8b 12                	mov    (%edx),%edx
  803982:	89 10                	mov    %edx,(%eax)
  803984:	eb 0a                	jmp    803990 <realloc_block_FF+0x6d9>
  803986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803989:	8b 00                	mov    (%eax),%eax
  80398b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803993:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a8:	48                   	dec    %eax
  8039a9:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039ae:	83 ec 04             	sub    $0x4,%esp
  8039b1:	6a 00                	push   $0x0
  8039b3:	ff 75 bc             	pushl  -0x44(%ebp)
  8039b6:	ff 75 b8             	pushl  -0x48(%ebp)
  8039b9:	e8 06 e9 ff ff       	call   8022c4 <set_block_data>
  8039be:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c4:	eb 0a                	jmp    8039d0 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039c6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039d0:	c9                   	leave  
  8039d1:	c3                   	ret    

008039d2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039d2:	55                   	push   %ebp
  8039d3:	89 e5                	mov    %esp,%ebp
  8039d5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039d8:	83 ec 04             	sub    $0x4,%esp
  8039db:	68 c4 45 80 00       	push   $0x8045c4
  8039e0:	68 58 02 00 00       	push   $0x258
  8039e5:	68 cd 44 80 00       	push   $0x8044cd
  8039ea:	e8 1d 00 00 00       	call   803a0c <_panic>

008039ef <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039ef:	55                   	push   %ebp
  8039f0:	89 e5                	mov    %esp,%ebp
  8039f2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039f5:	83 ec 04             	sub    $0x4,%esp
  8039f8:	68 ec 45 80 00       	push   $0x8045ec
  8039fd:	68 61 02 00 00       	push   $0x261
  803a02:	68 cd 44 80 00       	push   $0x8044cd
  803a07:	e8 00 00 00 00       	call   803a0c <_panic>

00803a0c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a0c:	55                   	push   %ebp
  803a0d:	89 e5                	mov    %esp,%ebp
  803a0f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a12:	8d 45 10             	lea    0x10(%ebp),%eax
  803a15:	83 c0 04             	add    $0x4,%eax
  803a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a1b:	a1 60 50 90 00       	mov    0x905060,%eax
  803a20:	85 c0                	test   %eax,%eax
  803a22:	74 16                	je     803a3a <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a24:	a1 60 50 90 00       	mov    0x905060,%eax
  803a29:	83 ec 08             	sub    $0x8,%esp
  803a2c:	50                   	push   %eax
  803a2d:	68 14 46 80 00       	push   $0x804614
  803a32:	e8 09 cd ff ff       	call   800740 <cprintf>
  803a37:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a3a:	a1 00 50 80 00       	mov    0x805000,%eax
  803a3f:	ff 75 0c             	pushl  0xc(%ebp)
  803a42:	ff 75 08             	pushl  0x8(%ebp)
  803a45:	50                   	push   %eax
  803a46:	68 19 46 80 00       	push   $0x804619
  803a4b:	e8 f0 cc ff ff       	call   800740 <cprintf>
  803a50:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a53:	8b 45 10             	mov    0x10(%ebp),%eax
  803a56:	83 ec 08             	sub    $0x8,%esp
  803a59:	ff 75 f4             	pushl  -0xc(%ebp)
  803a5c:	50                   	push   %eax
  803a5d:	e8 73 cc ff ff       	call   8006d5 <vcprintf>
  803a62:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a65:	83 ec 08             	sub    $0x8,%esp
  803a68:	6a 00                	push   $0x0
  803a6a:	68 35 46 80 00       	push   $0x804635
  803a6f:	e8 61 cc ff ff       	call   8006d5 <vcprintf>
  803a74:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a77:	e8 e2 cb ff ff       	call   80065e <exit>

	// should not return here
	while (1) ;
  803a7c:	eb fe                	jmp    803a7c <_panic+0x70>

00803a7e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a7e:	55                   	push   %ebp
  803a7f:	89 e5                	mov    %esp,%ebp
  803a81:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a84:	a1 20 50 80 00       	mov    0x805020,%eax
  803a89:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a92:	39 c2                	cmp    %eax,%edx
  803a94:	74 14                	je     803aaa <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a96:	83 ec 04             	sub    $0x4,%esp
  803a99:	68 38 46 80 00       	push   $0x804638
  803a9e:	6a 26                	push   $0x26
  803aa0:	68 84 46 80 00       	push   $0x804684
  803aa5:	e8 62 ff ff ff       	call   803a0c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803ab1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803ab8:	e9 c5 00 00 00       	jmp    803b82 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aca:	01 d0                	add    %edx,%eax
  803acc:	8b 00                	mov    (%eax),%eax
  803ace:	85 c0                	test   %eax,%eax
  803ad0:	75 08                	jne    803ada <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803ad2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803ad5:	e9 a5 00 00 00       	jmp    803b7f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803ada:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ae1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ae8:	eb 69                	jmp    803b53 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803aea:	a1 20 50 80 00       	mov    0x805020,%eax
  803aef:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803af5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803af8:	89 d0                	mov    %edx,%eax
  803afa:	01 c0                	add    %eax,%eax
  803afc:	01 d0                	add    %edx,%eax
  803afe:	c1 e0 03             	shl    $0x3,%eax
  803b01:	01 c8                	add    %ecx,%eax
  803b03:	8a 40 04             	mov    0x4(%eax),%al
  803b06:	84 c0                	test   %al,%al
  803b08:	75 46                	jne    803b50 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b0a:	a1 20 50 80 00       	mov    0x805020,%eax
  803b0f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b18:	89 d0                	mov    %edx,%eax
  803b1a:	01 c0                	add    %eax,%eax
  803b1c:	01 d0                	add    %edx,%eax
  803b1e:	c1 e0 03             	shl    $0x3,%eax
  803b21:	01 c8                	add    %ecx,%eax
  803b23:	8b 00                	mov    (%eax),%eax
  803b25:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b30:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b35:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3f:	01 c8                	add    %ecx,%eax
  803b41:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b43:	39 c2                	cmp    %eax,%edx
  803b45:	75 09                	jne    803b50 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b47:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b4e:	eb 15                	jmp    803b65 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b50:	ff 45 e8             	incl   -0x18(%ebp)
  803b53:	a1 20 50 80 00       	mov    0x805020,%eax
  803b58:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b61:	39 c2                	cmp    %eax,%edx
  803b63:	77 85                	ja     803aea <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b69:	75 14                	jne    803b7f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b6b:	83 ec 04             	sub    $0x4,%esp
  803b6e:	68 90 46 80 00       	push   $0x804690
  803b73:	6a 3a                	push   $0x3a
  803b75:	68 84 46 80 00       	push   $0x804684
  803b7a:	e8 8d fe ff ff       	call   803a0c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b7f:	ff 45 f0             	incl   -0x10(%ebp)
  803b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b85:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b88:	0f 8c 2f ff ff ff    	jl     803abd <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b8e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b9c:	eb 26                	jmp    803bc4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b9e:	a1 20 50 80 00       	mov    0x805020,%eax
  803ba3:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ba9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bac:	89 d0                	mov    %edx,%eax
  803bae:	01 c0                	add    %eax,%eax
  803bb0:	01 d0                	add    %edx,%eax
  803bb2:	c1 e0 03             	shl    $0x3,%eax
  803bb5:	01 c8                	add    %ecx,%eax
  803bb7:	8a 40 04             	mov    0x4(%eax),%al
  803bba:	3c 01                	cmp    $0x1,%al
  803bbc:	75 03                	jne    803bc1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803bbe:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bc1:	ff 45 e0             	incl   -0x20(%ebp)
  803bc4:	a1 20 50 80 00       	mov    0x805020,%eax
  803bc9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bd2:	39 c2                	cmp    %eax,%edx
  803bd4:	77 c8                	ja     803b9e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803bdc:	74 14                	je     803bf2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803bde:	83 ec 04             	sub    $0x4,%esp
  803be1:	68 e4 46 80 00       	push   $0x8046e4
  803be6:	6a 44                	push   $0x44
  803be8:	68 84 46 80 00       	push   $0x804684
  803bed:	e8 1a fe ff ff       	call   803a0c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803bf2:	90                   	nop
  803bf3:	c9                   	leave  
  803bf4:	c3                   	ret    
  803bf5:	66 90                	xchg   %ax,%ax
  803bf7:	90                   	nop

00803bf8 <__udivdi3>:
  803bf8:	55                   	push   %ebp
  803bf9:	57                   	push   %edi
  803bfa:	56                   	push   %esi
  803bfb:	53                   	push   %ebx
  803bfc:	83 ec 1c             	sub    $0x1c,%esp
  803bff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c0f:	89 ca                	mov    %ecx,%edx
  803c11:	89 f8                	mov    %edi,%eax
  803c13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c17:	85 f6                	test   %esi,%esi
  803c19:	75 2d                	jne    803c48 <__udivdi3+0x50>
  803c1b:	39 cf                	cmp    %ecx,%edi
  803c1d:	77 65                	ja     803c84 <__udivdi3+0x8c>
  803c1f:	89 fd                	mov    %edi,%ebp
  803c21:	85 ff                	test   %edi,%edi
  803c23:	75 0b                	jne    803c30 <__udivdi3+0x38>
  803c25:	b8 01 00 00 00       	mov    $0x1,%eax
  803c2a:	31 d2                	xor    %edx,%edx
  803c2c:	f7 f7                	div    %edi
  803c2e:	89 c5                	mov    %eax,%ebp
  803c30:	31 d2                	xor    %edx,%edx
  803c32:	89 c8                	mov    %ecx,%eax
  803c34:	f7 f5                	div    %ebp
  803c36:	89 c1                	mov    %eax,%ecx
  803c38:	89 d8                	mov    %ebx,%eax
  803c3a:	f7 f5                	div    %ebp
  803c3c:	89 cf                	mov    %ecx,%edi
  803c3e:	89 fa                	mov    %edi,%edx
  803c40:	83 c4 1c             	add    $0x1c,%esp
  803c43:	5b                   	pop    %ebx
  803c44:	5e                   	pop    %esi
  803c45:	5f                   	pop    %edi
  803c46:	5d                   	pop    %ebp
  803c47:	c3                   	ret    
  803c48:	39 ce                	cmp    %ecx,%esi
  803c4a:	77 28                	ja     803c74 <__udivdi3+0x7c>
  803c4c:	0f bd fe             	bsr    %esi,%edi
  803c4f:	83 f7 1f             	xor    $0x1f,%edi
  803c52:	75 40                	jne    803c94 <__udivdi3+0x9c>
  803c54:	39 ce                	cmp    %ecx,%esi
  803c56:	72 0a                	jb     803c62 <__udivdi3+0x6a>
  803c58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c5c:	0f 87 9e 00 00 00    	ja     803d00 <__udivdi3+0x108>
  803c62:	b8 01 00 00 00       	mov    $0x1,%eax
  803c67:	89 fa                	mov    %edi,%edx
  803c69:	83 c4 1c             	add    $0x1c,%esp
  803c6c:	5b                   	pop    %ebx
  803c6d:	5e                   	pop    %esi
  803c6e:	5f                   	pop    %edi
  803c6f:	5d                   	pop    %ebp
  803c70:	c3                   	ret    
  803c71:	8d 76 00             	lea    0x0(%esi),%esi
  803c74:	31 ff                	xor    %edi,%edi
  803c76:	31 c0                	xor    %eax,%eax
  803c78:	89 fa                	mov    %edi,%edx
  803c7a:	83 c4 1c             	add    $0x1c,%esp
  803c7d:	5b                   	pop    %ebx
  803c7e:	5e                   	pop    %esi
  803c7f:	5f                   	pop    %edi
  803c80:	5d                   	pop    %ebp
  803c81:	c3                   	ret    
  803c82:	66 90                	xchg   %ax,%ax
  803c84:	89 d8                	mov    %ebx,%eax
  803c86:	f7 f7                	div    %edi
  803c88:	31 ff                	xor    %edi,%edi
  803c8a:	89 fa                	mov    %edi,%edx
  803c8c:	83 c4 1c             	add    $0x1c,%esp
  803c8f:	5b                   	pop    %ebx
  803c90:	5e                   	pop    %esi
  803c91:	5f                   	pop    %edi
  803c92:	5d                   	pop    %ebp
  803c93:	c3                   	ret    
  803c94:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c99:	89 eb                	mov    %ebp,%ebx
  803c9b:	29 fb                	sub    %edi,%ebx
  803c9d:	89 f9                	mov    %edi,%ecx
  803c9f:	d3 e6                	shl    %cl,%esi
  803ca1:	89 c5                	mov    %eax,%ebp
  803ca3:	88 d9                	mov    %bl,%cl
  803ca5:	d3 ed                	shr    %cl,%ebp
  803ca7:	89 e9                	mov    %ebp,%ecx
  803ca9:	09 f1                	or     %esi,%ecx
  803cab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803caf:	89 f9                	mov    %edi,%ecx
  803cb1:	d3 e0                	shl    %cl,%eax
  803cb3:	89 c5                	mov    %eax,%ebp
  803cb5:	89 d6                	mov    %edx,%esi
  803cb7:	88 d9                	mov    %bl,%cl
  803cb9:	d3 ee                	shr    %cl,%esi
  803cbb:	89 f9                	mov    %edi,%ecx
  803cbd:	d3 e2                	shl    %cl,%edx
  803cbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cc3:	88 d9                	mov    %bl,%cl
  803cc5:	d3 e8                	shr    %cl,%eax
  803cc7:	09 c2                	or     %eax,%edx
  803cc9:	89 d0                	mov    %edx,%eax
  803ccb:	89 f2                	mov    %esi,%edx
  803ccd:	f7 74 24 0c          	divl   0xc(%esp)
  803cd1:	89 d6                	mov    %edx,%esi
  803cd3:	89 c3                	mov    %eax,%ebx
  803cd5:	f7 e5                	mul    %ebp
  803cd7:	39 d6                	cmp    %edx,%esi
  803cd9:	72 19                	jb     803cf4 <__udivdi3+0xfc>
  803cdb:	74 0b                	je     803ce8 <__udivdi3+0xf0>
  803cdd:	89 d8                	mov    %ebx,%eax
  803cdf:	31 ff                	xor    %edi,%edi
  803ce1:	e9 58 ff ff ff       	jmp    803c3e <__udivdi3+0x46>
  803ce6:	66 90                	xchg   %ax,%ax
  803ce8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803cec:	89 f9                	mov    %edi,%ecx
  803cee:	d3 e2                	shl    %cl,%edx
  803cf0:	39 c2                	cmp    %eax,%edx
  803cf2:	73 e9                	jae    803cdd <__udivdi3+0xe5>
  803cf4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cf7:	31 ff                	xor    %edi,%edi
  803cf9:	e9 40 ff ff ff       	jmp    803c3e <__udivdi3+0x46>
  803cfe:	66 90                	xchg   %ax,%ax
  803d00:	31 c0                	xor    %eax,%eax
  803d02:	e9 37 ff ff ff       	jmp    803c3e <__udivdi3+0x46>
  803d07:	90                   	nop

00803d08 <__umoddi3>:
  803d08:	55                   	push   %ebp
  803d09:	57                   	push   %edi
  803d0a:	56                   	push   %esi
  803d0b:	53                   	push   %ebx
  803d0c:	83 ec 1c             	sub    $0x1c,%esp
  803d0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d13:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d27:	89 f3                	mov    %esi,%ebx
  803d29:	89 fa                	mov    %edi,%edx
  803d2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d2f:	89 34 24             	mov    %esi,(%esp)
  803d32:	85 c0                	test   %eax,%eax
  803d34:	75 1a                	jne    803d50 <__umoddi3+0x48>
  803d36:	39 f7                	cmp    %esi,%edi
  803d38:	0f 86 a2 00 00 00    	jbe    803de0 <__umoddi3+0xd8>
  803d3e:	89 c8                	mov    %ecx,%eax
  803d40:	89 f2                	mov    %esi,%edx
  803d42:	f7 f7                	div    %edi
  803d44:	89 d0                	mov    %edx,%eax
  803d46:	31 d2                	xor    %edx,%edx
  803d48:	83 c4 1c             	add    $0x1c,%esp
  803d4b:	5b                   	pop    %ebx
  803d4c:	5e                   	pop    %esi
  803d4d:	5f                   	pop    %edi
  803d4e:	5d                   	pop    %ebp
  803d4f:	c3                   	ret    
  803d50:	39 f0                	cmp    %esi,%eax
  803d52:	0f 87 ac 00 00 00    	ja     803e04 <__umoddi3+0xfc>
  803d58:	0f bd e8             	bsr    %eax,%ebp
  803d5b:	83 f5 1f             	xor    $0x1f,%ebp
  803d5e:	0f 84 ac 00 00 00    	je     803e10 <__umoddi3+0x108>
  803d64:	bf 20 00 00 00       	mov    $0x20,%edi
  803d69:	29 ef                	sub    %ebp,%edi
  803d6b:	89 fe                	mov    %edi,%esi
  803d6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d71:	89 e9                	mov    %ebp,%ecx
  803d73:	d3 e0                	shl    %cl,%eax
  803d75:	89 d7                	mov    %edx,%edi
  803d77:	89 f1                	mov    %esi,%ecx
  803d79:	d3 ef                	shr    %cl,%edi
  803d7b:	09 c7                	or     %eax,%edi
  803d7d:	89 e9                	mov    %ebp,%ecx
  803d7f:	d3 e2                	shl    %cl,%edx
  803d81:	89 14 24             	mov    %edx,(%esp)
  803d84:	89 d8                	mov    %ebx,%eax
  803d86:	d3 e0                	shl    %cl,%eax
  803d88:	89 c2                	mov    %eax,%edx
  803d8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d8e:	d3 e0                	shl    %cl,%eax
  803d90:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d94:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d98:	89 f1                	mov    %esi,%ecx
  803d9a:	d3 e8                	shr    %cl,%eax
  803d9c:	09 d0                	or     %edx,%eax
  803d9e:	d3 eb                	shr    %cl,%ebx
  803da0:	89 da                	mov    %ebx,%edx
  803da2:	f7 f7                	div    %edi
  803da4:	89 d3                	mov    %edx,%ebx
  803da6:	f7 24 24             	mull   (%esp)
  803da9:	89 c6                	mov    %eax,%esi
  803dab:	89 d1                	mov    %edx,%ecx
  803dad:	39 d3                	cmp    %edx,%ebx
  803daf:	0f 82 87 00 00 00    	jb     803e3c <__umoddi3+0x134>
  803db5:	0f 84 91 00 00 00    	je     803e4c <__umoddi3+0x144>
  803dbb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803dbf:	29 f2                	sub    %esi,%edx
  803dc1:	19 cb                	sbb    %ecx,%ebx
  803dc3:	89 d8                	mov    %ebx,%eax
  803dc5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803dc9:	d3 e0                	shl    %cl,%eax
  803dcb:	89 e9                	mov    %ebp,%ecx
  803dcd:	d3 ea                	shr    %cl,%edx
  803dcf:	09 d0                	or     %edx,%eax
  803dd1:	89 e9                	mov    %ebp,%ecx
  803dd3:	d3 eb                	shr    %cl,%ebx
  803dd5:	89 da                	mov    %ebx,%edx
  803dd7:	83 c4 1c             	add    $0x1c,%esp
  803dda:	5b                   	pop    %ebx
  803ddb:	5e                   	pop    %esi
  803ddc:	5f                   	pop    %edi
  803ddd:	5d                   	pop    %ebp
  803dde:	c3                   	ret    
  803ddf:	90                   	nop
  803de0:	89 fd                	mov    %edi,%ebp
  803de2:	85 ff                	test   %edi,%edi
  803de4:	75 0b                	jne    803df1 <__umoddi3+0xe9>
  803de6:	b8 01 00 00 00       	mov    $0x1,%eax
  803deb:	31 d2                	xor    %edx,%edx
  803ded:	f7 f7                	div    %edi
  803def:	89 c5                	mov    %eax,%ebp
  803df1:	89 f0                	mov    %esi,%eax
  803df3:	31 d2                	xor    %edx,%edx
  803df5:	f7 f5                	div    %ebp
  803df7:	89 c8                	mov    %ecx,%eax
  803df9:	f7 f5                	div    %ebp
  803dfb:	89 d0                	mov    %edx,%eax
  803dfd:	e9 44 ff ff ff       	jmp    803d46 <__umoddi3+0x3e>
  803e02:	66 90                	xchg   %ax,%ax
  803e04:	89 c8                	mov    %ecx,%eax
  803e06:	89 f2                	mov    %esi,%edx
  803e08:	83 c4 1c             	add    $0x1c,%esp
  803e0b:	5b                   	pop    %ebx
  803e0c:	5e                   	pop    %esi
  803e0d:	5f                   	pop    %edi
  803e0e:	5d                   	pop    %ebp
  803e0f:	c3                   	ret    
  803e10:	3b 04 24             	cmp    (%esp),%eax
  803e13:	72 06                	jb     803e1b <__umoddi3+0x113>
  803e15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e19:	77 0f                	ja     803e2a <__umoddi3+0x122>
  803e1b:	89 f2                	mov    %esi,%edx
  803e1d:	29 f9                	sub    %edi,%ecx
  803e1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e23:	89 14 24             	mov    %edx,(%esp)
  803e26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e2e:	8b 14 24             	mov    (%esp),%edx
  803e31:	83 c4 1c             	add    $0x1c,%esp
  803e34:	5b                   	pop    %ebx
  803e35:	5e                   	pop    %esi
  803e36:	5f                   	pop    %edi
  803e37:	5d                   	pop    %ebp
  803e38:	c3                   	ret    
  803e39:	8d 76 00             	lea    0x0(%esi),%esi
  803e3c:	2b 04 24             	sub    (%esp),%eax
  803e3f:	19 fa                	sbb    %edi,%edx
  803e41:	89 d1                	mov    %edx,%ecx
  803e43:	89 c6                	mov    %eax,%esi
  803e45:	e9 71 ff ff ff       	jmp    803dbb <__umoddi3+0xb3>
  803e4a:	66 90                	xchg   %ax,%ax
  803e4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e50:	72 ea                	jb     803e3c <__umoddi3+0x134>
  803e52:	89 d9                	mov    %ebx,%ecx
  803e54:	e9 62 ff ff ff       	jmp    803dbb <__umoddi3+0xb3>
