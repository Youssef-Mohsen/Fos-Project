
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
  80003e:	e8 3f 1c 00 00       	call   801c82 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 69 1c 00 00       	call   801cb4 <sys_getparentenvid>
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
  80005f:	68 e0 3e 80 00       	push   $0x803ee0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 30 18 00 00       	call   80189c <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e4 3e 80 00       	push   $0x803ee4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 1a 18 00 00       	call   80189c <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ec 3e 80 00       	push   $0x803eec
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
  8000b3:	68 fa 3e 80 00       	push   $0x803efa
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
  800126:	68 04 3f 80 00       	push   $0x803f04
  80012b:	e8 10 06 00 00       	call   800740 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 29 3f 80 00       	push   $0x803f29
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
  800159:	68 2e 3f 80 00       	push   $0x803f2e
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
  800178:	68 32 3f 80 00       	push   $0x803f32
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
  800197:	68 36 3f 80 00       	push   $0x803f36
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
  8001b6:	68 3a 3f 80 00       	push   $0x803f3a
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
  800230:	e8 b2 1a 00 00       	call   801ce7 <sys_get_virtual_time>
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
  800533:	e8 63 17 00 00       	call   801c9b <sys_getenvindex>
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
  8005a1:	e8 79 14 00 00       	call   801a1f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	68 58 3f 80 00       	push   $0x803f58
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
  8005d1:	68 80 3f 80 00       	push   $0x803f80
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
  800602:	68 a8 3f 80 00       	push   $0x803fa8
  800607:	e8 34 01 00 00       	call   800740 <cprintf>
  80060c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060f:	a1 20 50 80 00       	mov    0x805020,%eax
  800614:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	50                   	push   %eax
  80061e:	68 00 40 80 00       	push   $0x804000
  800623:	e8 18 01 00 00       	call   800740 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	68 58 3f 80 00       	push   $0x803f58
  800633:	e8 08 01 00 00       	call   800740 <cprintf>
  800638:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80063b:	e8 f9 13 00 00       	call   801a39 <sys_unlock_cons>
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
  800653:	e8 0f 16 00 00       	call   801c67 <sys_destroy_env>
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
  800664:	e8 64 16 00 00       	call   801ccd <sys_exit_env>
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
  8006b2:	e8 26 13 00 00       	call   8019dd <sys_cputs>
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
  800729:	e8 af 12 00 00       	call   8019dd <sys_cputs>
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
  800773:	e8 a7 12 00 00       	call   801a1f <sys_lock_cons>
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
  800793:	e8 a1 12 00 00       	call   801a39 <sys_unlock_cons>
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
  8007dd:	e8 7e 34 00 00       	call   803c60 <__udivdi3>
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
  80082d:	e8 3e 35 00 00       	call   803d70 <__umoddi3>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	05 34 42 80 00       	add    $0x804234,%eax
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
  800988:	8b 04 85 58 42 80 00 	mov    0x804258(,%eax,4),%eax
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
  800a69:	8b 34 9d a0 40 80 00 	mov    0x8040a0(,%ebx,4),%esi
  800a70:	85 f6                	test   %esi,%esi
  800a72:	75 19                	jne    800a8d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a74:	53                   	push   %ebx
  800a75:	68 45 42 80 00       	push   $0x804245
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
  800a8e:	68 4e 42 80 00       	push   $0x80424e
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
  800abb:	be 51 42 80 00       	mov    $0x804251,%esi
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
  8014c6:	68 c8 43 80 00       	push   $0x8043c8
  8014cb:	68 3f 01 00 00       	push   $0x13f
  8014d0:	68 ea 43 80 00       	push   $0x8043ea
  8014d5:	e8 9a 25 00 00       	call   803a74 <_panic>

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
  8014e6:	e8 9d 0a 00 00       	call   801f88 <sys_sbrk>
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
  801561:	e8 a6 08 00 00       	call   801e0c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801566:	85 c0                	test   %eax,%eax
  801568:	74 16                	je     801580 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	e8 e6 0d 00 00       	call   80235b <alloc_block_FF>
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157b:	e9 8a 01 00 00       	jmp    80170a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801580:	e8 b8 08 00 00       	call   801e3d <sys_isUHeapPlacementStrategyBESTFIT>
  801585:	85 c0                	test   %eax,%eax
  801587:	0f 84 7d 01 00 00    	je     80170a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 7f 12 00 00       	call   802817 <alloc_block_BF>
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
  8016f9:	e8 c1 08 00 00       	call   801fbf <sys_allocate_user_mem>
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
  801741:	e8 95 08 00 00       	call   801fdb <get_block_size>
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	e8 c8 1a 00 00       	call   80321f <free_block>
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
  8017e9:	e8 b5 07 00 00       	call   801fa3 <sys_free_user_mem>
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
  8017f7:	68 f8 43 80 00       	push   $0x8043f8
  8017fc:	68 84 00 00 00       	push   $0x84
  801801:	68 22 44 80 00       	push   $0x804422
  801806:	e8 69 22 00 00       	call   803a74 <_panic>
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
  801869:	e8 3c 03 00 00       	call   801baa <sys_createSharedObject>
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
  80188a:	68 2e 44 80 00       	push   $0x80442e
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
  80189f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018a2:	83 ec 08             	sub    $0x8,%esp
  8018a5:	ff 75 0c             	pushl  0xc(%ebp)
  8018a8:	ff 75 08             	pushl  0x8(%ebp)
  8018ab:	e8 24 03 00 00       	call   801bd4 <sys_getSizeOfSharedObject>
  8018b0:	83 c4 10             	add    $0x10,%esp
  8018b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8018b6:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018ba:	75 07                	jne    8018c3 <sget+0x27>
  8018bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c1:	eb 5c                	jmp    80191f <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8018c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018c9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d6:	39 d0                	cmp    %edx,%eax
  8018d8:	7d 02                	jge    8018dc <sget+0x40>
  8018da:	89 d0                	mov    %edx,%eax
  8018dc:	83 ec 0c             	sub    $0xc,%esp
  8018df:	50                   	push   %eax
  8018e0:	e8 0b fc ff ff       	call   8014f0 <malloc>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8018eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018ef:	75 07                	jne    8018f8 <sget+0x5c>
  8018f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f6:	eb 27                	jmp    80191f <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 e8 02 00 00       	call   801bf1 <sys_getSharedObject>
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80190f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801913:	75 07                	jne    80191c <sget+0x80>
  801915:	b8 00 00 00 00       	mov    $0x0,%eax
  80191a:	eb 03                	jmp    80191f <sget+0x83>
	return ptr;
  80191c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	68 34 44 80 00       	push   $0x804434
  80192f:	68 c2 00 00 00       	push   $0xc2
  801934:	68 22 44 80 00       	push   $0x804422
  801939:	e8 36 21 00 00       	call   803a74 <_panic>

0080193e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	68 58 44 80 00       	push   $0x804458
  80194c:	68 d9 00 00 00       	push   $0xd9
  801951:	68 22 44 80 00       	push   $0x804422
  801956:	e8 19 21 00 00       	call   803a74 <_panic>

0080195b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	68 7e 44 80 00       	push   $0x80447e
  801969:	68 e5 00 00 00       	push   $0xe5
  80196e:	68 22 44 80 00       	push   $0x804422
  801973:	e8 fc 20 00 00       	call   803a74 <_panic>

00801978 <shrink>:

}
void shrink(uint32 newSize)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80197e:	83 ec 04             	sub    $0x4,%esp
  801981:	68 7e 44 80 00       	push   $0x80447e
  801986:	68 ea 00 00 00       	push   $0xea
  80198b:	68 22 44 80 00       	push   $0x804422
  801990:	e8 df 20 00 00       	call   803a74 <_panic>

00801995 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80199b:	83 ec 04             	sub    $0x4,%esp
  80199e:	68 7e 44 80 00       	push   $0x80447e
  8019a3:	68 ef 00 00 00       	push   $0xef
  8019a8:	68 22 44 80 00       	push   $0x804422
  8019ad:	e8 c2 20 00 00       	call   803a74 <_panic>

008019b2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	57                   	push   %edi
  8019b6:	56                   	push   %esi
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019c7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019ca:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019cd:	cd 30                	int    $0x30
  8019cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	5b                   	pop    %ebx
  8019d9:	5e                   	pop    %esi
  8019da:	5f                   	pop    %edi
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    

008019dd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 04             	sub    $0x4,%esp
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019e9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	52                   	push   %edx
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	50                   	push   %eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	e8 b2 ff ff ff       	call   8019b2 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 02                	push   $0x2
  801a15:	e8 98 ff ff ff       	call   8019b2 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 03                	push   $0x3
  801a2e:	e8 7f ff ff ff       	call   8019b2 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	90                   	nop
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 04                	push   $0x4
  801a48:	e8 65 ff ff ff       	call   8019b2 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	90                   	nop
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	52                   	push   %edx
  801a63:	50                   	push   %eax
  801a64:	6a 08                	push   $0x8
  801a66:	e8 47 ff ff ff       	call   8019b2 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	56                   	push   %esi
  801a74:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a75:	8b 75 18             	mov    0x18(%ebp),%esi
  801a78:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	56                   	push   %esi
  801a85:	53                   	push   %ebx
  801a86:	51                   	push   %ecx
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 09                	push   $0x9
  801a8b:	e8 22 ff ff ff       	call   8019b2 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a96:	5b                   	pop    %ebx
  801a97:	5e                   	pop    %esi
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    

00801a9a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	52                   	push   %edx
  801aaa:	50                   	push   %eax
  801aab:	6a 0a                	push   $0xa
  801aad:	e8 00 ff ff ff       	call   8019b2 <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	ff 75 08             	pushl  0x8(%ebp)
  801ac6:	6a 0b                	push   $0xb
  801ac8:	e8 e5 fe ff ff       	call   8019b2 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 0c                	push   $0xc
  801ae1:	e8 cc fe ff ff       	call   8019b2 <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 0d                	push   $0xd
  801afa:	e8 b3 fe ff ff       	call   8019b2 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 0e                	push   $0xe
  801b13:	e8 9a fe ff ff       	call   8019b2 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 0f                	push   $0xf
  801b2c:	e8 81 fe ff ff       	call   8019b2 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	ff 75 08             	pushl  0x8(%ebp)
  801b44:	6a 10                	push   $0x10
  801b46:	e8 67 fe ff ff       	call   8019b2 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 11                	push   $0x11
  801b5f:	e8 4e fe ff ff       	call   8019b2 <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	90                   	nop
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_cputc>:

void
sys_cputc(const char c)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 04             	sub    $0x4,%esp
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b76:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	50                   	push   %eax
  801b83:	6a 01                	push   $0x1
  801b85:	e8 28 fe ff ff       	call   8019b2 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	90                   	nop
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 14                	push   $0x14
  801b9f:	e8 0e fe ff ff       	call   8019b2 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	90                   	nop
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bb6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	6a 00                	push   $0x0
  801bc2:	51                   	push   %ecx
  801bc3:	52                   	push   %edx
  801bc4:	ff 75 0c             	pushl  0xc(%ebp)
  801bc7:	50                   	push   %eax
  801bc8:	6a 15                	push   $0x15
  801bca:	e8 e3 fd ff ff       	call   8019b2 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	52                   	push   %edx
  801be4:	50                   	push   %eax
  801be5:	6a 16                	push   $0x16
  801be7:	e8 c6 fd ff ff       	call   8019b2 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	51                   	push   %ecx
  801c02:	52                   	push   %edx
  801c03:	50                   	push   %eax
  801c04:	6a 17                	push   $0x17
  801c06:	e8 a7 fd ff ff       	call   8019b2 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	52                   	push   %edx
  801c20:	50                   	push   %eax
  801c21:	6a 18                	push   $0x18
  801c23:	e8 8a fd ff ff       	call   8019b2 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	6a 00                	push   $0x0
  801c35:	ff 75 14             	pushl  0x14(%ebp)
  801c38:	ff 75 10             	pushl  0x10(%ebp)
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	50                   	push   %eax
  801c3f:	6a 19                	push   $0x19
  801c41:	e8 6c fd ff ff       	call   8019b2 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	50                   	push   %eax
  801c5a:	6a 1a                	push   $0x1a
  801c5c:	e8 51 fd ff ff       	call   8019b2 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	90                   	nop
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	50                   	push   %eax
  801c76:	6a 1b                	push   $0x1b
  801c78:	e8 35 fd ff ff       	call   8019b2 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 05                	push   $0x5
  801c91:	e8 1c fd ff ff       	call   8019b2 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 06                	push   $0x6
  801caa:	e8 03 fd ff ff       	call   8019b2 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 07                	push   $0x7
  801cc3:	e8 ea fc ff ff       	call   8019b2 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_exit_env>:


void sys_exit_env(void)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 1c                	push   $0x1c
  801cdc:	e8 d1 fc ff ff       	call   8019b2 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	90                   	nop
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ced:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf0:	8d 50 04             	lea    0x4(%eax),%edx
  801cf3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	52                   	push   %edx
  801cfd:	50                   	push   %eax
  801cfe:	6a 1d                	push   $0x1d
  801d00:	e8 ad fc ff ff       	call   8019b2 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
	return result;
  801d08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d11:	89 01                	mov    %eax,(%ecx)
  801d13:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	c9                   	leave  
  801d1a:	c2 04 00             	ret    $0x4

00801d1d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	ff 75 10             	pushl  0x10(%ebp)
  801d27:	ff 75 0c             	pushl  0xc(%ebp)
  801d2a:	ff 75 08             	pushl  0x8(%ebp)
  801d2d:	6a 13                	push   $0x13
  801d2f:	e8 7e fc ff ff       	call   8019b2 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
	return ;
  801d37:	90                   	nop
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_rcr2>:
uint32 sys_rcr2()
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 1e                	push   $0x1e
  801d49:	e8 64 fc ff ff       	call   8019b2 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 04             	sub    $0x4,%esp
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d5f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	50                   	push   %eax
  801d6c:	6a 1f                	push   $0x1f
  801d6e:	e8 3f fc ff ff       	call   8019b2 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
	return ;
  801d76:	90                   	nop
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <rsttst>:
void rsttst()
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 21                	push   $0x21
  801d88:	e8 25 fc ff ff       	call   8019b2 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d90:	90                   	nop
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 04             	sub    $0x4,%esp
  801d99:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d9f:	8b 55 18             	mov    0x18(%ebp),%edx
  801da2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da6:	52                   	push   %edx
  801da7:	50                   	push   %eax
  801da8:	ff 75 10             	pushl  0x10(%ebp)
  801dab:	ff 75 0c             	pushl  0xc(%ebp)
  801dae:	ff 75 08             	pushl  0x8(%ebp)
  801db1:	6a 20                	push   $0x20
  801db3:	e8 fa fb ff ff       	call   8019b2 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbb:	90                   	nop
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <chktst>:
void chktst(uint32 n)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	ff 75 08             	pushl  0x8(%ebp)
  801dcc:	6a 22                	push   $0x22
  801dce:	e8 df fb ff ff       	call   8019b2 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd6:	90                   	nop
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <inctst>:

void inctst()
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 23                	push   $0x23
  801de8:	e8 c5 fb ff ff       	call   8019b2 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
	return ;
  801df0:	90                   	nop
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <gettst>:
uint32 gettst()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 24                	push   $0x24
  801e02:	e8 ab fb ff ff       	call   8019b2 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 25                	push   $0x25
  801e1e:	e8 8f fb ff ff       	call   8019b2 <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
  801e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e29:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e2d:	75 07                	jne    801e36 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e34:	eb 05                	jmp    801e3b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 25                	push   $0x25
  801e4f:	e8 5e fb ff ff       	call   8019b2 <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
  801e57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e5a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e5e:	75 07                	jne    801e67 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e60:	b8 01 00 00 00       	mov    $0x1,%eax
  801e65:	eb 05                	jmp    801e6c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 25                	push   $0x25
  801e80:	e8 2d fb ff ff       	call   8019b2 <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
  801e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e8b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e8f:	75 07                	jne    801e98 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e91:	b8 01 00 00 00       	mov    $0x1,%eax
  801e96:	eb 05                	jmp    801e9d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 25                	push   $0x25
  801eb1:	e8 fc fa ff ff       	call   8019b2 <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
  801eb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ebc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ec0:	75 07                	jne    801ec9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ec2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec7:	eb 05                	jmp    801ece <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ec9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	ff 75 08             	pushl  0x8(%ebp)
  801ede:	6a 26                	push   $0x26
  801ee0:	e8 cd fa ff ff       	call   8019b2 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee8:	90                   	nop
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	6a 00                	push   $0x0
  801efd:	53                   	push   %ebx
  801efe:	51                   	push   %ecx
  801eff:	52                   	push   %edx
  801f00:	50                   	push   %eax
  801f01:	6a 27                	push   $0x27
  801f03:	e8 aa fa ff ff       	call   8019b2 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
}
  801f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	52                   	push   %edx
  801f20:	50                   	push   %eax
  801f21:	6a 28                	push   $0x28
  801f23:	e8 8a fa ff ff       	call   8019b2 <syscall>
  801f28:	83 c4 18             	add    $0x18,%esp
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f30:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	6a 00                	push   $0x0
  801f3b:	51                   	push   %ecx
  801f3c:	ff 75 10             	pushl  0x10(%ebp)
  801f3f:	52                   	push   %edx
  801f40:	50                   	push   %eax
  801f41:	6a 29                	push   $0x29
  801f43:	e8 6a fa ff ff       	call   8019b2 <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	ff 75 10             	pushl  0x10(%ebp)
  801f57:	ff 75 0c             	pushl  0xc(%ebp)
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	6a 12                	push   $0x12
  801f5f:	e8 4e fa ff ff       	call   8019b2 <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
	return ;
  801f67:	90                   	nop
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	52                   	push   %edx
  801f7a:	50                   	push   %eax
  801f7b:	6a 2a                	push   $0x2a
  801f7d:	e8 30 fa ff ff       	call   8019b2 <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
	return;
  801f85:	90                   	nop
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	50                   	push   %eax
  801f97:	6a 2b                	push   $0x2b
  801f99:	e8 14 fa ff ff       	call   8019b2 <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	ff 75 0c             	pushl  0xc(%ebp)
  801faf:	ff 75 08             	pushl  0x8(%ebp)
  801fb2:	6a 2c                	push   $0x2c
  801fb4:	e8 f9 f9 ff ff       	call   8019b2 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
	return;
  801fbc:	90                   	nop
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	ff 75 0c             	pushl  0xc(%ebp)
  801fcb:	ff 75 08             	pushl  0x8(%ebp)
  801fce:	6a 2d                	push   $0x2d
  801fd0:	e8 dd f9 ff ff       	call   8019b2 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
	return;
  801fd8:	90                   	nop
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	83 e8 04             	sub    $0x4,%eax
  801fe7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801fea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fed:	8b 00                	mov    (%eax),%eax
  801fef:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	83 e8 04             	sub    $0x4,%eax
  802000:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802003:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802006:	8b 00                	mov    (%eax),%eax
  802008:	83 e0 01             	and    $0x1,%eax
  80200b:	85 c0                	test   %eax,%eax
  80200d:	0f 94 c0             	sete   %al
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802018:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80201f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802022:	83 f8 02             	cmp    $0x2,%eax
  802025:	74 2b                	je     802052 <alloc_block+0x40>
  802027:	83 f8 02             	cmp    $0x2,%eax
  80202a:	7f 07                	jg     802033 <alloc_block+0x21>
  80202c:	83 f8 01             	cmp    $0x1,%eax
  80202f:	74 0e                	je     80203f <alloc_block+0x2d>
  802031:	eb 58                	jmp    80208b <alloc_block+0x79>
  802033:	83 f8 03             	cmp    $0x3,%eax
  802036:	74 2d                	je     802065 <alloc_block+0x53>
  802038:	83 f8 04             	cmp    $0x4,%eax
  80203b:	74 3b                	je     802078 <alloc_block+0x66>
  80203d:	eb 4c                	jmp    80208b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	e8 11 03 00 00       	call   80235b <alloc_block_FF>
  80204a:	83 c4 10             	add    $0x10,%esp
  80204d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802050:	eb 4a                	jmp    80209c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802052:	83 ec 0c             	sub    $0xc,%esp
  802055:	ff 75 08             	pushl  0x8(%ebp)
  802058:	e8 fa 19 00 00       	call   803a57 <alloc_block_NF>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802063:	eb 37                	jmp    80209c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	ff 75 08             	pushl  0x8(%ebp)
  80206b:	e8 a7 07 00 00       	call   802817 <alloc_block_BF>
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802076:	eb 24                	jmp    80209c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802078:	83 ec 0c             	sub    $0xc,%esp
  80207b:	ff 75 08             	pushl  0x8(%ebp)
  80207e:	e8 b7 19 00 00       	call   803a3a <alloc_block_WF>
  802083:	83 c4 10             	add    $0x10,%esp
  802086:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802089:	eb 11                	jmp    80209c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	68 90 44 80 00       	push   $0x804490
  802093:	e8 a8 e6 ff ff       	call   800740 <cprintf>
  802098:	83 c4 10             	add    $0x10,%esp
		break;
  80209b:	90                   	nop
	}
	return va;
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	53                   	push   %ebx
  8020a5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8020a8:	83 ec 0c             	sub    $0xc,%esp
  8020ab:	68 b0 44 80 00       	push   $0x8044b0
  8020b0:	e8 8b e6 ff ff       	call   800740 <cprintf>
  8020b5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8020b8:	83 ec 0c             	sub    $0xc,%esp
  8020bb:	68 db 44 80 00       	push   $0x8044db
  8020c0:	e8 7b e6 ff ff       	call   800740 <cprintf>
  8020c5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ce:	eb 37                	jmp    802107 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8020d0:	83 ec 0c             	sub    $0xc,%esp
  8020d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d6:	e8 19 ff ff ff       	call   801ff4 <is_free_block>
  8020db:	83 c4 10             	add    $0x10,%esp
  8020de:	0f be d8             	movsbl %al,%ebx
  8020e1:	83 ec 0c             	sub    $0xc,%esp
  8020e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e7:	e8 ef fe ff ff       	call   801fdb <get_block_size>
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	53                   	push   %ebx
  8020f3:	50                   	push   %eax
  8020f4:	68 f3 44 80 00       	push   $0x8044f3
  8020f9:	e8 42 e6 ff ff       	call   800740 <cprintf>
  8020fe:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802101:	8b 45 10             	mov    0x10(%ebp),%eax
  802104:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210b:	74 07                	je     802114 <print_blocks_list+0x73>
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 00                	mov    (%eax),%eax
  802112:	eb 05                	jmp    802119 <print_blocks_list+0x78>
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
  802119:	89 45 10             	mov    %eax,0x10(%ebp)
  80211c:	8b 45 10             	mov    0x10(%ebp),%eax
  80211f:	85 c0                	test   %eax,%eax
  802121:	75 ad                	jne    8020d0 <print_blocks_list+0x2f>
  802123:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802127:	75 a7                	jne    8020d0 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802129:	83 ec 0c             	sub    $0xc,%esp
  80212c:	68 b0 44 80 00       	push   $0x8044b0
  802131:	e8 0a e6 ff ff       	call   800740 <cprintf>
  802136:	83 c4 10             	add    $0x10,%esp

}
  802139:	90                   	nop
  80213a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802145:	8b 45 0c             	mov    0xc(%ebp),%eax
  802148:	83 e0 01             	and    $0x1,%eax
  80214b:	85 c0                	test   %eax,%eax
  80214d:	74 03                	je     802152 <initialize_dynamic_allocator+0x13>
  80214f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802152:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802156:	0f 84 c7 01 00 00    	je     802323 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80215c:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802163:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802166:	8b 55 08             	mov    0x8(%ebp),%edx
  802169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216c:	01 d0                	add    %edx,%eax
  80216e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802173:	0f 87 ad 01 00 00    	ja     802326 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	85 c0                	test   %eax,%eax
  80217e:	0f 89 a5 01 00 00    	jns    802329 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802184:	8b 55 08             	mov    0x8(%ebp),%edx
  802187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218a:	01 d0                	add    %edx,%eax
  80218c:	83 e8 04             	sub    $0x4,%eax
  80218f:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802194:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80219b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a3:	e9 87 00 00 00       	jmp    80222f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8021a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ac:	75 14                	jne    8021c2 <initialize_dynamic_allocator+0x83>
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	68 0b 45 80 00       	push   $0x80450b
  8021b6:	6a 79                	push   $0x79
  8021b8:	68 29 45 80 00       	push   $0x804529
  8021bd:	e8 b2 18 00 00       	call   803a74 <_panic>
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 00                	mov    (%eax),%eax
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	74 10                	je     8021db <initialize_dynamic_allocator+0x9c>
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 00                	mov    (%eax),%eax
  8021d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d3:	8b 52 04             	mov    0x4(%edx),%edx
  8021d6:	89 50 04             	mov    %edx,0x4(%eax)
  8021d9:	eb 0b                	jmp    8021e6 <initialize_dynamic_allocator+0xa7>
  8021db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021de:	8b 40 04             	mov    0x4(%eax),%eax
  8021e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 40 04             	mov    0x4(%eax),%eax
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	74 0f                	je     8021ff <initialize_dynamic_allocator+0xc0>
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	8b 40 04             	mov    0x4(%eax),%eax
  8021f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f9:	8b 12                	mov    (%edx),%edx
  8021fb:	89 10                	mov    %edx,(%eax)
  8021fd:	eb 0a                	jmp    802209 <initialize_dynamic_allocator+0xca>
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	8b 00                	mov    (%eax),%eax
  802204:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802215:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80221c:	a1 38 50 80 00       	mov    0x805038,%eax
  802221:	48                   	dec    %eax
  802222:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802227:	a1 34 50 80 00       	mov    0x805034,%eax
  80222c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80222f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802233:	74 07                	je     80223c <initialize_dynamic_allocator+0xfd>
  802235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802238:	8b 00                	mov    (%eax),%eax
  80223a:	eb 05                	jmp    802241 <initialize_dynamic_allocator+0x102>
  80223c:	b8 00 00 00 00       	mov    $0x0,%eax
  802241:	a3 34 50 80 00       	mov    %eax,0x805034
  802246:	a1 34 50 80 00       	mov    0x805034,%eax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	0f 85 55 ff ff ff    	jne    8021a8 <initialize_dynamic_allocator+0x69>
  802253:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802257:	0f 85 4b ff ff ff    	jne    8021a8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802266:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80226c:	a1 44 50 80 00       	mov    0x805044,%eax
  802271:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802276:	a1 40 50 80 00       	mov    0x805040,%eax
  80227b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	83 c0 08             	add    $0x8,%eax
  802287:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	83 c0 04             	add    $0x4,%eax
  802290:	8b 55 0c             	mov    0xc(%ebp),%edx
  802293:	83 ea 08             	sub    $0x8,%edx
  802296:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	01 d0                	add    %edx,%eax
  8022a0:	83 e8 08             	sub    $0x8,%eax
  8022a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a6:	83 ea 08             	sub    $0x8,%edx
  8022a9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8022ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8022b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8022be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022c2:	75 17                	jne    8022db <initialize_dynamic_allocator+0x19c>
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	68 44 45 80 00       	push   $0x804544
  8022cc:	68 90 00 00 00       	push   $0x90
  8022d1:	68 29 45 80 00       	push   $0x804529
  8022d6:	e8 99 17 00 00       	call   803a74 <_panic>
  8022db:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e4:	89 10                	mov    %edx,(%eax)
  8022e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e9:	8b 00                	mov    (%eax),%eax
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	74 0d                	je     8022fc <initialize_dynamic_allocator+0x1bd>
  8022ef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022f7:	89 50 04             	mov    %edx,0x4(%eax)
  8022fa:	eb 08                	jmp    802304 <initialize_dynamic_allocator+0x1c5>
  8022fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ff:	a3 30 50 80 00       	mov    %eax,0x805030
  802304:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802307:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80230c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802316:	a1 38 50 80 00       	mov    0x805038,%eax
  80231b:	40                   	inc    %eax
  80231c:	a3 38 50 80 00       	mov    %eax,0x805038
  802321:	eb 07                	jmp    80232a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802323:	90                   	nop
  802324:	eb 04                	jmp    80232a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802326:	90                   	nop
  802327:	eb 01                	jmp    80232a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802329:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80232f:	8b 45 10             	mov    0x10(%ebp),%eax
  802332:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8d 50 fc             	lea    -0x4(%eax),%edx
  80233b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	83 e8 04             	sub    $0x4,%eax
  802346:	8b 00                	mov    (%eax),%eax
  802348:	83 e0 fe             	and    $0xfffffffe,%eax
  80234b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	01 c2                	add    %eax,%edx
  802353:	8b 45 0c             	mov    0xc(%ebp),%eax
  802356:	89 02                	mov    %eax,(%edx)
}
  802358:	90                   	nop
  802359:	5d                   	pop    %ebp
  80235a:	c3                   	ret    

0080235b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	83 e0 01             	and    $0x1,%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	74 03                	je     80236e <alloc_block_FF+0x13>
  80236b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80236e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802372:	77 07                	ja     80237b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802374:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80237b:	a1 24 50 80 00       	mov    0x805024,%eax
  802380:	85 c0                	test   %eax,%eax
  802382:	75 73                	jne    8023f7 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	83 c0 10             	add    $0x10,%eax
  80238a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80238d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802394:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239a:	01 d0                	add    %edx,%eax
  80239c:	48                   	dec    %eax
  80239d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a8:	f7 75 ec             	divl   -0x14(%ebp)
  8023ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ae:	29 d0                	sub    %edx,%eax
  8023b0:	c1 e8 0c             	shr    $0xc,%eax
  8023b3:	83 ec 0c             	sub    $0xc,%esp
  8023b6:	50                   	push   %eax
  8023b7:	e8 1e f1 ff ff       	call   8014da <sbrk>
  8023bc:	83 c4 10             	add    $0x10,%esp
  8023bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8023c2:	83 ec 0c             	sub    $0xc,%esp
  8023c5:	6a 00                	push   $0x0
  8023c7:	e8 0e f1 ff ff       	call   8014da <sbrk>
  8023cc:	83 c4 10             	add    $0x10,%esp
  8023cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8023d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8023d8:	83 ec 08             	sub    $0x8,%esp
  8023db:	50                   	push   %eax
  8023dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023df:	e8 5b fd ff ff       	call   80213f <initialize_dynamic_allocator>
  8023e4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8023e7:	83 ec 0c             	sub    $0xc,%esp
  8023ea:	68 67 45 80 00       	push   $0x804567
  8023ef:	e8 4c e3 ff ff       	call   800740 <cprintf>
  8023f4:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023fb:	75 0a                	jne    802407 <alloc_block_FF+0xac>
	        return NULL;
  8023fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802402:	e9 0e 04 00 00       	jmp    802815 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802407:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80240e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802413:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802416:	e9 f3 02 00 00       	jmp    80270e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802421:	83 ec 0c             	sub    $0xc,%esp
  802424:	ff 75 bc             	pushl  -0x44(%ebp)
  802427:	e8 af fb ff ff       	call   801fdb <get_block_size>
  80242c:	83 c4 10             	add    $0x10,%esp
  80242f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	83 c0 08             	add    $0x8,%eax
  802438:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80243b:	0f 87 c5 02 00 00    	ja     802706 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	83 c0 18             	add    $0x18,%eax
  802447:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80244a:	0f 87 19 02 00 00    	ja     802669 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802450:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802453:	2b 45 08             	sub    0x8(%ebp),%eax
  802456:	83 e8 08             	sub    $0x8,%eax
  802459:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	8d 50 08             	lea    0x8(%eax),%edx
  802462:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802465:	01 d0                	add    %edx,%eax
  802467:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	83 c0 08             	add    $0x8,%eax
  802470:	83 ec 04             	sub    $0x4,%esp
  802473:	6a 01                	push   $0x1
  802475:	50                   	push   %eax
  802476:	ff 75 bc             	pushl  -0x44(%ebp)
  802479:	e8 ae fe ff ff       	call   80232c <set_block_data>
  80247e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 40 04             	mov    0x4(%eax),%eax
  802487:	85 c0                	test   %eax,%eax
  802489:	75 68                	jne    8024f3 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80248b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80248f:	75 17                	jne    8024a8 <alloc_block_FF+0x14d>
  802491:	83 ec 04             	sub    $0x4,%esp
  802494:	68 44 45 80 00       	push   $0x804544
  802499:	68 d7 00 00 00       	push   $0xd7
  80249e:	68 29 45 80 00       	push   $0x804529
  8024a3:	e8 cc 15 00 00       	call   803a74 <_panic>
  8024a8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8024ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b1:	89 10                	mov    %edx,(%eax)
  8024b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 0d                	je     8024c9 <alloc_block_FF+0x16e>
  8024bc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024c1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024c4:	89 50 04             	mov    %edx,0x4(%eax)
  8024c7:	eb 08                	jmp    8024d1 <alloc_block_FF+0x176>
  8024c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8024d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8024e8:	40                   	inc    %eax
  8024e9:	a3 38 50 80 00       	mov    %eax,0x805038
  8024ee:	e9 dc 00 00 00       	jmp    8025cf <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	8b 00                	mov    (%eax),%eax
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	75 65                	jne    802561 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024fc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802500:	75 17                	jne    802519 <alloc_block_FF+0x1be>
  802502:	83 ec 04             	sub    $0x4,%esp
  802505:	68 78 45 80 00       	push   $0x804578
  80250a:	68 db 00 00 00       	push   $0xdb
  80250f:	68 29 45 80 00       	push   $0x804529
  802514:	e8 5b 15 00 00       	call   803a74 <_panic>
  802519:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80251f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802522:	89 50 04             	mov    %edx,0x4(%eax)
  802525:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802528:	8b 40 04             	mov    0x4(%eax),%eax
  80252b:	85 c0                	test   %eax,%eax
  80252d:	74 0c                	je     80253b <alloc_block_FF+0x1e0>
  80252f:	a1 30 50 80 00       	mov    0x805030,%eax
  802534:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802537:	89 10                	mov    %edx,(%eax)
  802539:	eb 08                	jmp    802543 <alloc_block_FF+0x1e8>
  80253b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80253e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802543:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802546:	a3 30 50 80 00       	mov    %eax,0x805030
  80254b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80254e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802554:	a1 38 50 80 00       	mov    0x805038,%eax
  802559:	40                   	inc    %eax
  80255a:	a3 38 50 80 00       	mov    %eax,0x805038
  80255f:	eb 6e                	jmp    8025cf <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802565:	74 06                	je     80256d <alloc_block_FF+0x212>
  802567:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80256b:	75 17                	jne    802584 <alloc_block_FF+0x229>
  80256d:	83 ec 04             	sub    $0x4,%esp
  802570:	68 9c 45 80 00       	push   $0x80459c
  802575:	68 df 00 00 00       	push   $0xdf
  80257a:	68 29 45 80 00       	push   $0x804529
  80257f:	e8 f0 14 00 00       	call   803a74 <_panic>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 10                	mov    (%eax),%edx
  802589:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80258c:	89 10                	mov    %edx,(%eax)
  80258e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	74 0b                	je     8025a2 <alloc_block_FF+0x247>
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 00                	mov    (%eax),%eax
  80259c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80259f:	89 50 04             	mov    %edx,0x4(%eax)
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025a8:	89 10                	mov    %edx,(%eax)
  8025aa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b0:	89 50 04             	mov    %edx,0x4(%eax)
  8025b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	75 08                	jne    8025c4 <alloc_block_FF+0x269>
  8025bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c4:	a1 38 50 80 00       	mov    0x805038,%eax
  8025c9:	40                   	inc    %eax
  8025ca:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8025cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d3:	75 17                	jne    8025ec <alloc_block_FF+0x291>
  8025d5:	83 ec 04             	sub    $0x4,%esp
  8025d8:	68 0b 45 80 00       	push   $0x80450b
  8025dd:	68 e1 00 00 00       	push   $0xe1
  8025e2:	68 29 45 80 00       	push   $0x804529
  8025e7:	e8 88 14 00 00       	call   803a74 <_panic>
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	74 10                	je     802605 <alloc_block_FF+0x2aa>
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 00                	mov    (%eax),%eax
  8025fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fd:	8b 52 04             	mov    0x4(%edx),%edx
  802600:	89 50 04             	mov    %edx,0x4(%eax)
  802603:	eb 0b                	jmp    802610 <alloc_block_FF+0x2b5>
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 40 04             	mov    0x4(%eax),%eax
  80260b:	a3 30 50 80 00       	mov    %eax,0x805030
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	85 c0                	test   %eax,%eax
  802618:	74 0f                	je     802629 <alloc_block_FF+0x2ce>
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 40 04             	mov    0x4(%eax),%eax
  802620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802623:	8b 12                	mov    (%edx),%edx
  802625:	89 10                	mov    %edx,(%eax)
  802627:	eb 0a                	jmp    802633 <alloc_block_FF+0x2d8>
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802646:	a1 38 50 80 00       	mov    0x805038,%eax
  80264b:	48                   	dec    %eax
  80264c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802651:	83 ec 04             	sub    $0x4,%esp
  802654:	6a 00                	push   $0x0
  802656:	ff 75 b4             	pushl  -0x4c(%ebp)
  802659:	ff 75 b0             	pushl  -0x50(%ebp)
  80265c:	e8 cb fc ff ff       	call   80232c <set_block_data>
  802661:	83 c4 10             	add    $0x10,%esp
  802664:	e9 95 00 00 00       	jmp    8026fe <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802669:	83 ec 04             	sub    $0x4,%esp
  80266c:	6a 01                	push   $0x1
  80266e:	ff 75 b8             	pushl  -0x48(%ebp)
  802671:	ff 75 bc             	pushl  -0x44(%ebp)
  802674:	e8 b3 fc ff ff       	call   80232c <set_block_data>
  802679:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80267c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802680:	75 17                	jne    802699 <alloc_block_FF+0x33e>
  802682:	83 ec 04             	sub    $0x4,%esp
  802685:	68 0b 45 80 00       	push   $0x80450b
  80268a:	68 e8 00 00 00       	push   $0xe8
  80268f:	68 29 45 80 00       	push   $0x804529
  802694:	e8 db 13 00 00       	call   803a74 <_panic>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 10                	je     8026b2 <alloc_block_FF+0x357>
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026aa:	8b 52 04             	mov    0x4(%edx),%edx
  8026ad:	89 50 04             	mov    %edx,0x4(%eax)
  8026b0:	eb 0b                	jmp    8026bd <alloc_block_FF+0x362>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 04             	mov    0x4(%eax),%eax
  8026b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 40 04             	mov    0x4(%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 0f                	je     8026d6 <alloc_block_FF+0x37b>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d0:	8b 12                	mov    (%edx),%edx
  8026d2:	89 10                	mov    %edx,(%eax)
  8026d4:	eb 0a                	jmp    8026e0 <alloc_block_FF+0x385>
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 00                	mov    (%eax),%eax
  8026db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8026f8:	48                   	dec    %eax
  8026f9:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8026fe:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802701:	e9 0f 01 00 00       	jmp    802815 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802706:	a1 34 50 80 00       	mov    0x805034,%eax
  80270b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802712:	74 07                	je     80271b <alloc_block_FF+0x3c0>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	eb 05                	jmp    802720 <alloc_block_FF+0x3c5>
  80271b:	b8 00 00 00 00       	mov    $0x0,%eax
  802720:	a3 34 50 80 00       	mov    %eax,0x805034
  802725:	a1 34 50 80 00       	mov    0x805034,%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	0f 85 e9 fc ff ff    	jne    80241b <alloc_block_FF+0xc0>
  802732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802736:	0f 85 df fc ff ff    	jne    80241b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	83 c0 08             	add    $0x8,%eax
  802742:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802745:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80274c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80274f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802752:	01 d0                	add    %edx,%eax
  802754:	48                   	dec    %eax
  802755:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80275b:	ba 00 00 00 00       	mov    $0x0,%edx
  802760:	f7 75 d8             	divl   -0x28(%ebp)
  802763:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802766:	29 d0                	sub    %edx,%eax
  802768:	c1 e8 0c             	shr    $0xc,%eax
  80276b:	83 ec 0c             	sub    $0xc,%esp
  80276e:	50                   	push   %eax
  80276f:	e8 66 ed ff ff       	call   8014da <sbrk>
  802774:	83 c4 10             	add    $0x10,%esp
  802777:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80277a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80277e:	75 0a                	jne    80278a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
  802785:	e9 8b 00 00 00       	jmp    802815 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80278a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802791:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802794:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802797:	01 d0                	add    %edx,%eax
  802799:	48                   	dec    %eax
  80279a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80279d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a5:	f7 75 cc             	divl   -0x34(%ebp)
  8027a8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027ab:	29 d0                	sub    %edx,%eax
  8027ad:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027b3:	01 d0                	add    %edx,%eax
  8027b5:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8027ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8027bf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8027c5:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8027cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027d2:	01 d0                	add    %edx,%eax
  8027d4:	48                   	dec    %eax
  8027d5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8027d8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027db:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e0:	f7 75 c4             	divl   -0x3c(%ebp)
  8027e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027e6:	29 d0                	sub    %edx,%eax
  8027e8:	83 ec 04             	sub    $0x4,%esp
  8027eb:	6a 01                	push   $0x1
  8027ed:	50                   	push   %eax
  8027ee:	ff 75 d0             	pushl  -0x30(%ebp)
  8027f1:	e8 36 fb ff ff       	call   80232c <set_block_data>
  8027f6:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027f9:	83 ec 0c             	sub    $0xc,%esp
  8027fc:	ff 75 d0             	pushl  -0x30(%ebp)
  8027ff:	e8 1b 0a 00 00       	call   80321f <free_block>
  802804:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802807:	83 ec 0c             	sub    $0xc,%esp
  80280a:	ff 75 08             	pushl  0x8(%ebp)
  80280d:	e8 49 fb ff ff       	call   80235b <alloc_block_FF>
  802812:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	83 e0 01             	and    $0x1,%eax
  802823:	85 c0                	test   %eax,%eax
  802825:	74 03                	je     80282a <alloc_block_BF+0x13>
  802827:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80282a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80282e:	77 07                	ja     802837 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802830:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802837:	a1 24 50 80 00       	mov    0x805024,%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	75 73                	jne    8028b3 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	83 c0 10             	add    $0x10,%eax
  802846:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802849:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802850:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802856:	01 d0                	add    %edx,%eax
  802858:	48                   	dec    %eax
  802859:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80285c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80285f:	ba 00 00 00 00       	mov    $0x0,%edx
  802864:	f7 75 e0             	divl   -0x20(%ebp)
  802867:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80286a:	29 d0                	sub    %edx,%eax
  80286c:	c1 e8 0c             	shr    $0xc,%eax
  80286f:	83 ec 0c             	sub    $0xc,%esp
  802872:	50                   	push   %eax
  802873:	e8 62 ec ff ff       	call   8014da <sbrk>
  802878:	83 c4 10             	add    $0x10,%esp
  80287b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80287e:	83 ec 0c             	sub    $0xc,%esp
  802881:	6a 00                	push   $0x0
  802883:	e8 52 ec ff ff       	call   8014da <sbrk>
  802888:	83 c4 10             	add    $0x10,%esp
  80288b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80288e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802891:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802894:	83 ec 08             	sub    $0x8,%esp
  802897:	50                   	push   %eax
  802898:	ff 75 d8             	pushl  -0x28(%ebp)
  80289b:	e8 9f f8 ff ff       	call   80213f <initialize_dynamic_allocator>
  8028a0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028a3:	83 ec 0c             	sub    $0xc,%esp
  8028a6:	68 67 45 80 00       	push   $0x804567
  8028ab:	e8 90 de ff ff       	call   800740 <cprintf>
  8028b0:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8028b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8028ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8028c1:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8028c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8028cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d7:	e9 1d 01 00 00       	jmp    8029f9 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8028e2:	83 ec 0c             	sub    $0xc,%esp
  8028e5:	ff 75 a8             	pushl  -0x58(%ebp)
  8028e8:	e8 ee f6 ff ff       	call   801fdb <get_block_size>
  8028ed:	83 c4 10             	add    $0x10,%esp
  8028f0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	83 c0 08             	add    $0x8,%eax
  8028f9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028fc:	0f 87 ef 00 00 00    	ja     8029f1 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	83 c0 18             	add    $0x18,%eax
  802908:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80290b:	77 1d                	ja     80292a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80290d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802910:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802913:	0f 86 d8 00 00 00    	jbe    8029f1 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802919:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80291c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80291f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802922:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802925:	e9 c7 00 00 00       	jmp    8029f1 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80292a:	8b 45 08             	mov    0x8(%ebp),%eax
  80292d:	83 c0 08             	add    $0x8,%eax
  802930:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802933:	0f 85 9d 00 00 00    	jne    8029d6 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802939:	83 ec 04             	sub    $0x4,%esp
  80293c:	6a 01                	push   $0x1
  80293e:	ff 75 a4             	pushl  -0x5c(%ebp)
  802941:	ff 75 a8             	pushl  -0x58(%ebp)
  802944:	e8 e3 f9 ff ff       	call   80232c <set_block_data>
  802949:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80294c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802950:	75 17                	jne    802969 <alloc_block_BF+0x152>
  802952:	83 ec 04             	sub    $0x4,%esp
  802955:	68 0b 45 80 00       	push   $0x80450b
  80295a:	68 2c 01 00 00       	push   $0x12c
  80295f:	68 29 45 80 00       	push   $0x804529
  802964:	e8 0b 11 00 00       	call   803a74 <_panic>
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	85 c0                	test   %eax,%eax
  802970:	74 10                	je     802982 <alloc_block_BF+0x16b>
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 00                	mov    (%eax),%eax
  802977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297a:	8b 52 04             	mov    0x4(%edx),%edx
  80297d:	89 50 04             	mov    %edx,0x4(%eax)
  802980:	eb 0b                	jmp    80298d <alloc_block_BF+0x176>
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 40 04             	mov    0x4(%eax),%eax
  802988:	a3 30 50 80 00       	mov    %eax,0x805030
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	85 c0                	test   %eax,%eax
  802995:	74 0f                	je     8029a6 <alloc_block_BF+0x18f>
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 40 04             	mov    0x4(%eax),%eax
  80299d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a0:	8b 12                	mov    (%edx),%edx
  8029a2:	89 10                	mov    %edx,(%eax)
  8029a4:	eb 0a                	jmp    8029b0 <alloc_block_BF+0x199>
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 00                	mov    (%eax),%eax
  8029ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8029c8:	48                   	dec    %eax
  8029c9:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8029ce:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029d1:	e9 24 04 00 00       	jmp    802dfa <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8029d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029dc:	76 13                	jbe    8029f1 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8029de:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8029e5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029eb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029ee:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029f1:	a1 34 50 80 00       	mov    0x805034,%eax
  8029f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fd:	74 07                	je     802a06 <alloc_block_BF+0x1ef>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	eb 05                	jmp    802a0b <alloc_block_BF+0x1f4>
  802a06:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0b:	a3 34 50 80 00       	mov    %eax,0x805034
  802a10:	a1 34 50 80 00       	mov    0x805034,%eax
  802a15:	85 c0                	test   %eax,%eax
  802a17:	0f 85 bf fe ff ff    	jne    8028dc <alloc_block_BF+0xc5>
  802a1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a21:	0f 85 b5 fe ff ff    	jne    8028dc <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a2b:	0f 84 26 02 00 00    	je     802c57 <alloc_block_BF+0x440>
  802a31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a35:	0f 85 1c 02 00 00    	jne    802c57 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3e:	2b 45 08             	sub    0x8(%ebp),%eax
  802a41:	83 e8 08             	sub    $0x8,%eax
  802a44:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	8d 50 08             	lea    0x8(%eax),%edx
  802a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a50:	01 d0                	add    %edx,%eax
  802a52:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	83 c0 08             	add    $0x8,%eax
  802a5b:	83 ec 04             	sub    $0x4,%esp
  802a5e:	6a 01                	push   $0x1
  802a60:	50                   	push   %eax
  802a61:	ff 75 f0             	pushl  -0x10(%ebp)
  802a64:	e8 c3 f8 ff ff       	call   80232c <set_block_data>
  802a69:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6f:	8b 40 04             	mov    0x4(%eax),%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	75 68                	jne    802ade <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a76:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a7a:	75 17                	jne    802a93 <alloc_block_BF+0x27c>
  802a7c:	83 ec 04             	sub    $0x4,%esp
  802a7f:	68 44 45 80 00       	push   $0x804544
  802a84:	68 45 01 00 00       	push   $0x145
  802a89:	68 29 45 80 00       	push   $0x804529
  802a8e:	e8 e1 0f 00 00       	call   803a74 <_panic>
  802a93:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a99:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9c:	89 10                	mov    %edx,(%eax)
  802a9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	74 0d                	je     802ab4 <alloc_block_BF+0x29d>
  802aa7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802aac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aaf:	89 50 04             	mov    %edx,0x4(%eax)
  802ab2:	eb 08                	jmp    802abc <alloc_block_BF+0x2a5>
  802ab4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab7:	a3 30 50 80 00       	mov    %eax,0x805030
  802abc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ac4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ace:	a1 38 50 80 00       	mov    0x805038,%eax
  802ad3:	40                   	inc    %eax
  802ad4:	a3 38 50 80 00       	mov    %eax,0x805038
  802ad9:	e9 dc 00 00 00       	jmp    802bba <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae1:	8b 00                	mov    (%eax),%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	75 65                	jne    802b4c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ae7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802aeb:	75 17                	jne    802b04 <alloc_block_BF+0x2ed>
  802aed:	83 ec 04             	sub    $0x4,%esp
  802af0:	68 78 45 80 00       	push   $0x804578
  802af5:	68 4a 01 00 00       	push   $0x14a
  802afa:	68 29 45 80 00       	push   $0x804529
  802aff:	e8 70 0f 00 00       	call   803a74 <_panic>
  802b04:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0d:	89 50 04             	mov    %edx,0x4(%eax)
  802b10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b13:	8b 40 04             	mov    0x4(%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 0c                	je     802b26 <alloc_block_BF+0x30f>
  802b1a:	a1 30 50 80 00       	mov    0x805030,%eax
  802b1f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b22:	89 10                	mov    %edx,(%eax)
  802b24:	eb 08                	jmp    802b2e <alloc_block_BF+0x317>
  802b26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b29:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b31:	a3 30 50 80 00       	mov    %eax,0x805030
  802b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3f:	a1 38 50 80 00       	mov    0x805038,%eax
  802b44:	40                   	inc    %eax
  802b45:	a3 38 50 80 00       	mov    %eax,0x805038
  802b4a:	eb 6e                	jmp    802bba <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b50:	74 06                	je     802b58 <alloc_block_BF+0x341>
  802b52:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b56:	75 17                	jne    802b6f <alloc_block_BF+0x358>
  802b58:	83 ec 04             	sub    $0x4,%esp
  802b5b:	68 9c 45 80 00       	push   $0x80459c
  802b60:	68 4f 01 00 00       	push   $0x14f
  802b65:	68 29 45 80 00       	push   $0x804529
  802b6a:	e8 05 0f 00 00       	call   803a74 <_panic>
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	8b 10                	mov    (%eax),%edx
  802b74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b77:	89 10                	mov    %edx,(%eax)
  802b79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	74 0b                	je     802b8d <alloc_block_BF+0x376>
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b90:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b93:	89 10                	mov    %edx,(%eax)
  802b95:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9b:	89 50 04             	mov    %edx,0x4(%eax)
  802b9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	75 08                	jne    802baf <alloc_block_BF+0x398>
  802ba7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802baa:	a3 30 50 80 00       	mov    %eax,0x805030
  802baf:	a1 38 50 80 00       	mov    0x805038,%eax
  802bb4:	40                   	inc    %eax
  802bb5:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802bba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bbe:	75 17                	jne    802bd7 <alloc_block_BF+0x3c0>
  802bc0:	83 ec 04             	sub    $0x4,%esp
  802bc3:	68 0b 45 80 00       	push   $0x80450b
  802bc8:	68 51 01 00 00       	push   $0x151
  802bcd:	68 29 45 80 00       	push   $0x804529
  802bd2:	e8 9d 0e 00 00       	call   803a74 <_panic>
  802bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	74 10                	je     802bf0 <alloc_block_BF+0x3d9>
  802be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be3:	8b 00                	mov    (%eax),%eax
  802be5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be8:	8b 52 04             	mov    0x4(%edx),%edx
  802beb:	89 50 04             	mov    %edx,0x4(%eax)
  802bee:	eb 0b                	jmp    802bfb <alloc_block_BF+0x3e4>
  802bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	85 c0                	test   %eax,%eax
  802c03:	74 0f                	je     802c14 <alloc_block_BF+0x3fd>
  802c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c08:	8b 40 04             	mov    0x4(%eax),%eax
  802c0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c0e:	8b 12                	mov    (%edx),%edx
  802c10:	89 10                	mov    %edx,(%eax)
  802c12:	eb 0a                	jmp    802c1e <alloc_block_BF+0x407>
  802c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c31:	a1 38 50 80 00       	mov    0x805038,%eax
  802c36:	48                   	dec    %eax
  802c37:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	6a 00                	push   $0x0
  802c41:	ff 75 d0             	pushl  -0x30(%ebp)
  802c44:	ff 75 cc             	pushl  -0x34(%ebp)
  802c47:	e8 e0 f6 ff ff       	call   80232c <set_block_data>
  802c4c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c52:	e9 a3 01 00 00       	jmp    802dfa <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c57:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c5b:	0f 85 9d 00 00 00    	jne    802cfe <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c61:	83 ec 04             	sub    $0x4,%esp
  802c64:	6a 01                	push   $0x1
  802c66:	ff 75 ec             	pushl  -0x14(%ebp)
  802c69:	ff 75 f0             	pushl  -0x10(%ebp)
  802c6c:	e8 bb f6 ff ff       	call   80232c <set_block_data>
  802c71:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c78:	75 17                	jne    802c91 <alloc_block_BF+0x47a>
  802c7a:	83 ec 04             	sub    $0x4,%esp
  802c7d:	68 0b 45 80 00       	push   $0x80450b
  802c82:	68 58 01 00 00       	push   $0x158
  802c87:	68 29 45 80 00       	push   $0x804529
  802c8c:	e8 e3 0d 00 00       	call   803a74 <_panic>
  802c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	74 10                	je     802caa <alloc_block_BF+0x493>
  802c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca2:	8b 52 04             	mov    0x4(%edx),%edx
  802ca5:	89 50 04             	mov    %edx,0x4(%eax)
  802ca8:	eb 0b                	jmp    802cb5 <alloc_block_BF+0x49e>
  802caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cad:	8b 40 04             	mov    0x4(%eax),%eax
  802cb0:	a3 30 50 80 00       	mov    %eax,0x805030
  802cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	74 0f                	je     802cce <alloc_block_BF+0x4b7>
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	8b 40 04             	mov    0x4(%eax),%eax
  802cc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc8:	8b 12                	mov    (%edx),%edx
  802cca:	89 10                	mov    %edx,(%eax)
  802ccc:	eb 0a                	jmp    802cd8 <alloc_block_BF+0x4c1>
  802cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ceb:	a1 38 50 80 00       	mov    0x805038,%eax
  802cf0:	48                   	dec    %eax
  802cf1:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	e9 fc 00 00 00       	jmp    802dfa <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	83 c0 08             	add    $0x8,%eax
  802d04:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d07:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d0e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d14:	01 d0                	add    %edx,%eax
  802d16:	48                   	dec    %eax
  802d17:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d1a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  802d22:	f7 75 c4             	divl   -0x3c(%ebp)
  802d25:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d28:	29 d0                	sub    %edx,%eax
  802d2a:	c1 e8 0c             	shr    $0xc,%eax
  802d2d:	83 ec 0c             	sub    $0xc,%esp
  802d30:	50                   	push   %eax
  802d31:	e8 a4 e7 ff ff       	call   8014da <sbrk>
  802d36:	83 c4 10             	add    $0x10,%esp
  802d39:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d3c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d40:	75 0a                	jne    802d4c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d42:	b8 00 00 00 00       	mov    $0x0,%eax
  802d47:	e9 ae 00 00 00       	jmp    802dfa <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d4c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d53:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d56:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d59:	01 d0                	add    %edx,%eax
  802d5b:	48                   	dec    %eax
  802d5c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d5f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d62:	ba 00 00 00 00       	mov    $0x0,%edx
  802d67:	f7 75 b8             	divl   -0x48(%ebp)
  802d6a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d6d:	29 d0                	sub    %edx,%eax
  802d6f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d72:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d75:	01 d0                	add    %edx,%eax
  802d77:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d7c:	a1 40 50 80 00       	mov    0x805040,%eax
  802d81:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d87:	83 ec 0c             	sub    $0xc,%esp
  802d8a:	68 d0 45 80 00       	push   $0x8045d0
  802d8f:	e8 ac d9 ff ff       	call   800740 <cprintf>
  802d94:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d97:	83 ec 08             	sub    $0x8,%esp
  802d9a:	ff 75 bc             	pushl  -0x44(%ebp)
  802d9d:	68 d5 45 80 00       	push   $0x8045d5
  802da2:	e8 99 d9 ff ff       	call   800740 <cprintf>
  802da7:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802daa:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802db1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802db4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802db7:	01 d0                	add    %edx,%eax
  802db9:	48                   	dec    %eax
  802dba:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802dbd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802dc0:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc5:	f7 75 b0             	divl   -0x50(%ebp)
  802dc8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802dcb:	29 d0                	sub    %edx,%eax
  802dcd:	83 ec 04             	sub    $0x4,%esp
  802dd0:	6a 01                	push   $0x1
  802dd2:	50                   	push   %eax
  802dd3:	ff 75 bc             	pushl  -0x44(%ebp)
  802dd6:	e8 51 f5 ff ff       	call   80232c <set_block_data>
  802ddb:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802dde:	83 ec 0c             	sub    $0xc,%esp
  802de1:	ff 75 bc             	pushl  -0x44(%ebp)
  802de4:	e8 36 04 00 00       	call   80321f <free_block>
  802de9:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802dec:	83 ec 0c             	sub    $0xc,%esp
  802def:	ff 75 08             	pushl  0x8(%ebp)
  802df2:	e8 20 fa ff ff       	call   802817 <alloc_block_BF>
  802df7:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802dfa:	c9                   	leave  
  802dfb:	c3                   	ret    

00802dfc <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802dfc:	55                   	push   %ebp
  802dfd:	89 e5                	mov    %esp,%ebp
  802dff:	53                   	push   %ebx
  802e00:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e15:	74 1e                	je     802e35 <merging+0x39>
  802e17:	ff 75 08             	pushl  0x8(%ebp)
  802e1a:	e8 bc f1 ff ff       	call   801fdb <get_block_size>
  802e1f:	83 c4 04             	add    $0x4,%esp
  802e22:	89 c2                	mov    %eax,%edx
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	01 d0                	add    %edx,%eax
  802e29:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e2c:	75 07                	jne    802e35 <merging+0x39>
		prev_is_free = 1;
  802e2e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e39:	74 1e                	je     802e59 <merging+0x5d>
  802e3b:	ff 75 10             	pushl  0x10(%ebp)
  802e3e:	e8 98 f1 ff ff       	call   801fdb <get_block_size>
  802e43:	83 c4 04             	add    $0x4,%esp
  802e46:	89 c2                	mov    %eax,%edx
  802e48:	8b 45 10             	mov    0x10(%ebp),%eax
  802e4b:	01 d0                	add    %edx,%eax
  802e4d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e50:	75 07                	jne    802e59 <merging+0x5d>
		next_is_free = 1;
  802e52:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5d:	0f 84 cc 00 00 00    	je     802f2f <merging+0x133>
  802e63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e67:	0f 84 c2 00 00 00    	je     802f2f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e6d:	ff 75 08             	pushl  0x8(%ebp)
  802e70:	e8 66 f1 ff ff       	call   801fdb <get_block_size>
  802e75:	83 c4 04             	add    $0x4,%esp
  802e78:	89 c3                	mov    %eax,%ebx
  802e7a:	ff 75 10             	pushl  0x10(%ebp)
  802e7d:	e8 59 f1 ff ff       	call   801fdb <get_block_size>
  802e82:	83 c4 04             	add    $0x4,%esp
  802e85:	01 c3                	add    %eax,%ebx
  802e87:	ff 75 0c             	pushl  0xc(%ebp)
  802e8a:	e8 4c f1 ff ff       	call   801fdb <get_block_size>
  802e8f:	83 c4 04             	add    $0x4,%esp
  802e92:	01 d8                	add    %ebx,%eax
  802e94:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e97:	6a 00                	push   $0x0
  802e99:	ff 75 ec             	pushl  -0x14(%ebp)
  802e9c:	ff 75 08             	pushl  0x8(%ebp)
  802e9f:	e8 88 f4 ff ff       	call   80232c <set_block_data>
  802ea4:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ea7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eab:	75 17                	jne    802ec4 <merging+0xc8>
  802ead:	83 ec 04             	sub    $0x4,%esp
  802eb0:	68 0b 45 80 00       	push   $0x80450b
  802eb5:	68 7d 01 00 00       	push   $0x17d
  802eba:	68 29 45 80 00       	push   $0x804529
  802ebf:	e8 b0 0b 00 00       	call   803a74 <_panic>
  802ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec7:	8b 00                	mov    (%eax),%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	74 10                	je     802edd <merging+0xe1>
  802ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed0:	8b 00                	mov    (%eax),%eax
  802ed2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed5:	8b 52 04             	mov    0x4(%edx),%edx
  802ed8:	89 50 04             	mov    %edx,0x4(%eax)
  802edb:	eb 0b                	jmp    802ee8 <merging+0xec>
  802edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee0:	8b 40 04             	mov    0x4(%eax),%eax
  802ee3:	a3 30 50 80 00       	mov    %eax,0x805030
  802ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eeb:	8b 40 04             	mov    0x4(%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 0f                	je     802f01 <merging+0x105>
  802ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802efb:	8b 12                	mov    (%edx),%edx
  802efd:	89 10                	mov    %edx,(%eax)
  802eff:	eb 0a                	jmp    802f0b <merging+0x10f>
  802f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f04:	8b 00                	mov    (%eax),%eax
  802f06:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1e:	a1 38 50 80 00       	mov    0x805038,%eax
  802f23:	48                   	dec    %eax
  802f24:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f29:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f2a:	e9 ea 02 00 00       	jmp    803219 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f33:	74 3b                	je     802f70 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f35:	83 ec 0c             	sub    $0xc,%esp
  802f38:	ff 75 08             	pushl  0x8(%ebp)
  802f3b:	e8 9b f0 ff ff       	call   801fdb <get_block_size>
  802f40:	83 c4 10             	add    $0x10,%esp
  802f43:	89 c3                	mov    %eax,%ebx
  802f45:	83 ec 0c             	sub    $0xc,%esp
  802f48:	ff 75 10             	pushl  0x10(%ebp)
  802f4b:	e8 8b f0 ff ff       	call   801fdb <get_block_size>
  802f50:	83 c4 10             	add    $0x10,%esp
  802f53:	01 d8                	add    %ebx,%eax
  802f55:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f58:	83 ec 04             	sub    $0x4,%esp
  802f5b:	6a 00                	push   $0x0
  802f5d:	ff 75 e8             	pushl  -0x18(%ebp)
  802f60:	ff 75 08             	pushl  0x8(%ebp)
  802f63:	e8 c4 f3 ff ff       	call   80232c <set_block_data>
  802f68:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f6b:	e9 a9 02 00 00       	jmp    803219 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f74:	0f 84 2d 01 00 00    	je     8030a7 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f7a:	83 ec 0c             	sub    $0xc,%esp
  802f7d:	ff 75 10             	pushl  0x10(%ebp)
  802f80:	e8 56 f0 ff ff       	call   801fdb <get_block_size>
  802f85:	83 c4 10             	add    $0x10,%esp
  802f88:	89 c3                	mov    %eax,%ebx
  802f8a:	83 ec 0c             	sub    $0xc,%esp
  802f8d:	ff 75 0c             	pushl  0xc(%ebp)
  802f90:	e8 46 f0 ff ff       	call   801fdb <get_block_size>
  802f95:	83 c4 10             	add    $0x10,%esp
  802f98:	01 d8                	add    %ebx,%eax
  802f9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f9d:	83 ec 04             	sub    $0x4,%esp
  802fa0:	6a 00                	push   $0x0
  802fa2:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fa5:	ff 75 10             	pushl  0x10(%ebp)
  802fa8:	e8 7f f3 ff ff       	call   80232c <set_block_data>
  802fad:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  802fb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802fb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fba:	74 06                	je     802fc2 <merging+0x1c6>
  802fbc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fc0:	75 17                	jne    802fd9 <merging+0x1dd>
  802fc2:	83 ec 04             	sub    $0x4,%esp
  802fc5:	68 e4 45 80 00       	push   $0x8045e4
  802fca:	68 8d 01 00 00       	push   $0x18d
  802fcf:	68 29 45 80 00       	push   $0x804529
  802fd4:	e8 9b 0a 00 00       	call   803a74 <_panic>
  802fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdc:	8b 50 04             	mov    0x4(%eax),%edx
  802fdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe2:	89 50 04             	mov    %edx,0x4(%eax)
  802fe5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802feb:	89 10                	mov    %edx,(%eax)
  802fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff0:	8b 40 04             	mov    0x4(%eax),%eax
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	74 0d                	je     803004 <merging+0x208>
  802ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffa:	8b 40 04             	mov    0x4(%eax),%eax
  802ffd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803000:	89 10                	mov    %edx,(%eax)
  803002:	eb 08                	jmp    80300c <merging+0x210>
  803004:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803007:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80300c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803012:	89 50 04             	mov    %edx,0x4(%eax)
  803015:	a1 38 50 80 00       	mov    0x805038,%eax
  80301a:	40                   	inc    %eax
  80301b:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803020:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803024:	75 17                	jne    80303d <merging+0x241>
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	68 0b 45 80 00       	push   $0x80450b
  80302e:	68 8e 01 00 00       	push   $0x18e
  803033:	68 29 45 80 00       	push   $0x804529
  803038:	e8 37 0a 00 00       	call   803a74 <_panic>
  80303d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	85 c0                	test   %eax,%eax
  803044:	74 10                	je     803056 <merging+0x25a>
  803046:	8b 45 0c             	mov    0xc(%ebp),%eax
  803049:	8b 00                	mov    (%eax),%eax
  80304b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80304e:	8b 52 04             	mov    0x4(%edx),%edx
  803051:	89 50 04             	mov    %edx,0x4(%eax)
  803054:	eb 0b                	jmp    803061 <merging+0x265>
  803056:	8b 45 0c             	mov    0xc(%ebp),%eax
  803059:	8b 40 04             	mov    0x4(%eax),%eax
  80305c:	a3 30 50 80 00       	mov    %eax,0x805030
  803061:	8b 45 0c             	mov    0xc(%ebp),%eax
  803064:	8b 40 04             	mov    0x4(%eax),%eax
  803067:	85 c0                	test   %eax,%eax
  803069:	74 0f                	je     80307a <merging+0x27e>
  80306b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306e:	8b 40 04             	mov    0x4(%eax),%eax
  803071:	8b 55 0c             	mov    0xc(%ebp),%edx
  803074:	8b 12                	mov    (%edx),%edx
  803076:	89 10                	mov    %edx,(%eax)
  803078:	eb 0a                	jmp    803084 <merging+0x288>
  80307a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80307d:	8b 00                	mov    (%eax),%eax
  80307f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803084:	8b 45 0c             	mov    0xc(%ebp),%eax
  803087:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803090:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803097:	a1 38 50 80 00       	mov    0x805038,%eax
  80309c:	48                   	dec    %eax
  80309d:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030a2:	e9 72 01 00 00       	jmp    803219 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8030a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8030aa:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8030ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b1:	74 79                	je     80312c <merging+0x330>
  8030b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030b7:	74 73                	je     80312c <merging+0x330>
  8030b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030bd:	74 06                	je     8030c5 <merging+0x2c9>
  8030bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030c3:	75 17                	jne    8030dc <merging+0x2e0>
  8030c5:	83 ec 04             	sub    $0x4,%esp
  8030c8:	68 9c 45 80 00       	push   $0x80459c
  8030cd:	68 94 01 00 00       	push   $0x194
  8030d2:	68 29 45 80 00       	push   $0x804529
  8030d7:	e8 98 09 00 00       	call   803a74 <_panic>
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	8b 10                	mov    (%eax),%edx
  8030e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e4:	89 10                	mov    %edx,(%eax)
  8030e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 0b                	je     8030fa <merging+0x2fe>
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	8b 00                	mov    (%eax),%eax
  8030f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803100:	89 10                	mov    %edx,(%eax)
  803102:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803105:	8b 55 08             	mov    0x8(%ebp),%edx
  803108:	89 50 04             	mov    %edx,0x4(%eax)
  80310b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	85 c0                	test   %eax,%eax
  803112:	75 08                	jne    80311c <merging+0x320>
  803114:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803117:	a3 30 50 80 00       	mov    %eax,0x805030
  80311c:	a1 38 50 80 00       	mov    0x805038,%eax
  803121:	40                   	inc    %eax
  803122:	a3 38 50 80 00       	mov    %eax,0x805038
  803127:	e9 ce 00 00 00       	jmp    8031fa <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80312c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803130:	74 65                	je     803197 <merging+0x39b>
  803132:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803136:	75 17                	jne    80314f <merging+0x353>
  803138:	83 ec 04             	sub    $0x4,%esp
  80313b:	68 78 45 80 00       	push   $0x804578
  803140:	68 95 01 00 00       	push   $0x195
  803145:	68 29 45 80 00       	push   $0x804529
  80314a:	e8 25 09 00 00       	call   803a74 <_panic>
  80314f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803155:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803158:	89 50 04             	mov    %edx,0x4(%eax)
  80315b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315e:	8b 40 04             	mov    0x4(%eax),%eax
  803161:	85 c0                	test   %eax,%eax
  803163:	74 0c                	je     803171 <merging+0x375>
  803165:	a1 30 50 80 00       	mov    0x805030,%eax
  80316a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80316d:	89 10                	mov    %edx,(%eax)
  80316f:	eb 08                	jmp    803179 <merging+0x37d>
  803171:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803174:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803179:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80317c:	a3 30 50 80 00       	mov    %eax,0x805030
  803181:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803184:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318a:	a1 38 50 80 00       	mov    0x805038,%eax
  80318f:	40                   	inc    %eax
  803190:	a3 38 50 80 00       	mov    %eax,0x805038
  803195:	eb 63                	jmp    8031fa <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803197:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80319b:	75 17                	jne    8031b4 <merging+0x3b8>
  80319d:	83 ec 04             	sub    $0x4,%esp
  8031a0:	68 44 45 80 00       	push   $0x804544
  8031a5:	68 98 01 00 00       	push   $0x198
  8031aa:	68 29 45 80 00       	push   $0x804529
  8031af:	e8 c0 08 00 00       	call   803a74 <_panic>
  8031b4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031bd:	89 10                	mov    %edx,(%eax)
  8031bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c2:	8b 00                	mov    (%eax),%eax
  8031c4:	85 c0                	test   %eax,%eax
  8031c6:	74 0d                	je     8031d5 <merging+0x3d9>
  8031c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031d0:	89 50 04             	mov    %edx,0x4(%eax)
  8031d3:	eb 08                	jmp    8031dd <merging+0x3e1>
  8031d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8031dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8031f4:	40                   	inc    %eax
  8031f5:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8031fa:	83 ec 0c             	sub    $0xc,%esp
  8031fd:	ff 75 10             	pushl  0x10(%ebp)
  803200:	e8 d6 ed ff ff       	call   801fdb <get_block_size>
  803205:	83 c4 10             	add    $0x10,%esp
  803208:	83 ec 04             	sub    $0x4,%esp
  80320b:	6a 00                	push   $0x0
  80320d:	50                   	push   %eax
  80320e:	ff 75 10             	pushl  0x10(%ebp)
  803211:	e8 16 f1 ff ff       	call   80232c <set_block_data>
  803216:	83 c4 10             	add    $0x10,%esp
	}
}
  803219:	90                   	nop
  80321a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80321d:	c9                   	leave  
  80321e:	c3                   	ret    

0080321f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80321f:	55                   	push   %ebp
  803220:	89 e5                	mov    %esp,%ebp
  803222:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803225:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80322a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80322d:	a1 30 50 80 00       	mov    0x805030,%eax
  803232:	3b 45 08             	cmp    0x8(%ebp),%eax
  803235:	73 1b                	jae    803252 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803237:	a1 30 50 80 00       	mov    0x805030,%eax
  80323c:	83 ec 04             	sub    $0x4,%esp
  80323f:	ff 75 08             	pushl  0x8(%ebp)
  803242:	6a 00                	push   $0x0
  803244:	50                   	push   %eax
  803245:	e8 b2 fb ff ff       	call   802dfc <merging>
  80324a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80324d:	e9 8b 00 00 00       	jmp    8032dd <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803252:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803257:	3b 45 08             	cmp    0x8(%ebp),%eax
  80325a:	76 18                	jbe    803274 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80325c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803261:	83 ec 04             	sub    $0x4,%esp
  803264:	ff 75 08             	pushl  0x8(%ebp)
  803267:	50                   	push   %eax
  803268:	6a 00                	push   $0x0
  80326a:	e8 8d fb ff ff       	call   802dfc <merging>
  80326f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803272:	eb 69                	jmp    8032dd <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803274:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803279:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80327c:	eb 39                	jmp    8032b7 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	3b 45 08             	cmp    0x8(%ebp),%eax
  803284:	73 29                	jae    8032af <free_block+0x90>
  803286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803289:	8b 00                	mov    (%eax),%eax
  80328b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80328e:	76 1f                	jbe    8032af <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	ff 75 08             	pushl  0x8(%ebp)
  80329e:	ff 75 f0             	pushl  -0x10(%ebp)
  8032a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8032a4:	e8 53 fb ff ff       	call   802dfc <merging>
  8032a9:	83 c4 10             	add    $0x10,%esp
			break;
  8032ac:	90                   	nop
		}
	}
}
  8032ad:	eb 2e                	jmp    8032dd <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032af:	a1 34 50 80 00       	mov    0x805034,%eax
  8032b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bb:	74 07                	je     8032c4 <free_block+0xa5>
  8032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	eb 05                	jmp    8032c9 <free_block+0xaa>
  8032c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8032ce:	a1 34 50 80 00       	mov    0x805034,%eax
  8032d3:	85 c0                	test   %eax,%eax
  8032d5:	75 a7                	jne    80327e <free_block+0x5f>
  8032d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032db:	75 a1                	jne    80327e <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032dd:	90                   	nop
  8032de:	c9                   	leave  
  8032df:	c3                   	ret    

008032e0 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8032e0:	55                   	push   %ebp
  8032e1:	89 e5                	mov    %esp,%ebp
  8032e3:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8032e6:	ff 75 08             	pushl  0x8(%ebp)
  8032e9:	e8 ed ec ff ff       	call   801fdb <get_block_size>
  8032ee:	83 c4 04             	add    $0x4,%esp
  8032f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032fb:	eb 17                	jmp    803314 <copy_data+0x34>
  8032fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803300:	8b 45 0c             	mov    0xc(%ebp),%eax
  803303:	01 c2                	add    %eax,%edx
  803305:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	01 c8                	add    %ecx,%eax
  80330d:	8a 00                	mov    (%eax),%al
  80330f:	88 02                	mov    %al,(%edx)
  803311:	ff 45 fc             	incl   -0x4(%ebp)
  803314:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803317:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80331a:	72 e1                	jb     8032fd <copy_data+0x1d>
}
  80331c:	90                   	nop
  80331d:	c9                   	leave  
  80331e:	c3                   	ret    

0080331f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80331f:	55                   	push   %ebp
  803320:	89 e5                	mov    %esp,%ebp
  803322:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803325:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803329:	75 23                	jne    80334e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80332b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80332f:	74 13                	je     803344 <realloc_block_FF+0x25>
  803331:	83 ec 0c             	sub    $0xc,%esp
  803334:	ff 75 0c             	pushl  0xc(%ebp)
  803337:	e8 1f f0 ff ff       	call   80235b <alloc_block_FF>
  80333c:	83 c4 10             	add    $0x10,%esp
  80333f:	e9 f4 06 00 00       	jmp    803a38 <realloc_block_FF+0x719>
		return NULL;
  803344:	b8 00 00 00 00       	mov    $0x0,%eax
  803349:	e9 ea 06 00 00       	jmp    803a38 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80334e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803352:	75 18                	jne    80336c <realloc_block_FF+0x4d>
	{
		free_block(va);
  803354:	83 ec 0c             	sub    $0xc,%esp
  803357:	ff 75 08             	pushl  0x8(%ebp)
  80335a:	e8 c0 fe ff ff       	call   80321f <free_block>
  80335f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803362:	b8 00 00 00 00       	mov    $0x0,%eax
  803367:	e9 cc 06 00 00       	jmp    803a38 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80336c:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803370:	77 07                	ja     803379 <realloc_block_FF+0x5a>
  803372:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337c:	83 e0 01             	and    $0x1,%eax
  80337f:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803382:	8b 45 0c             	mov    0xc(%ebp),%eax
  803385:	83 c0 08             	add    $0x8,%eax
  803388:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80338b:	83 ec 0c             	sub    $0xc,%esp
  80338e:	ff 75 08             	pushl  0x8(%ebp)
  803391:	e8 45 ec ff ff       	call   801fdb <get_block_size>
  803396:	83 c4 10             	add    $0x10,%esp
  803399:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80339c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339f:	83 e8 08             	sub    $0x8,%eax
  8033a2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	83 e8 04             	sub    $0x4,%eax
  8033ab:	8b 00                	mov    (%eax),%eax
  8033ad:	83 e0 fe             	and    $0xfffffffe,%eax
  8033b0:	89 c2                	mov    %eax,%edx
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	01 d0                	add    %edx,%eax
  8033b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8033ba:	83 ec 0c             	sub    $0xc,%esp
  8033bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033c0:	e8 16 ec ff ff       	call   801fdb <get_block_size>
  8033c5:	83 c4 10             	add    $0x10,%esp
  8033c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ce:	83 e8 08             	sub    $0x8,%eax
  8033d1:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8033d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033da:	75 08                	jne    8033e4 <realloc_block_FF+0xc5>
	{
		 return va;
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	e9 54 06 00 00       	jmp    803a38 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8033e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033ea:	0f 83 e5 03 00 00    	jae    8037d5 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f3:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033f9:	83 ec 0c             	sub    $0xc,%esp
  8033fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033ff:	e8 f0 eb ff ff       	call   801ff4 <is_free_block>
  803404:	83 c4 10             	add    $0x10,%esp
  803407:	84 c0                	test   %al,%al
  803409:	0f 84 3b 01 00 00    	je     80354a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80340f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803412:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803415:	01 d0                	add    %edx,%eax
  803417:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80341a:	83 ec 04             	sub    $0x4,%esp
  80341d:	6a 01                	push   $0x1
  80341f:	ff 75 f0             	pushl  -0x10(%ebp)
  803422:	ff 75 08             	pushl  0x8(%ebp)
  803425:	e8 02 ef ff ff       	call   80232c <set_block_data>
  80342a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	83 e8 04             	sub    $0x4,%eax
  803433:	8b 00                	mov    (%eax),%eax
  803435:	83 e0 fe             	and    $0xfffffffe,%eax
  803438:	89 c2                	mov    %eax,%edx
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	01 d0                	add    %edx,%eax
  80343f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803442:	83 ec 04             	sub    $0x4,%esp
  803445:	6a 00                	push   $0x0
  803447:	ff 75 cc             	pushl  -0x34(%ebp)
  80344a:	ff 75 c8             	pushl  -0x38(%ebp)
  80344d:	e8 da ee ff ff       	call   80232c <set_block_data>
  803452:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803455:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803459:	74 06                	je     803461 <realloc_block_FF+0x142>
  80345b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80345f:	75 17                	jne    803478 <realloc_block_FF+0x159>
  803461:	83 ec 04             	sub    $0x4,%esp
  803464:	68 9c 45 80 00       	push   $0x80459c
  803469:	68 f6 01 00 00       	push   $0x1f6
  80346e:	68 29 45 80 00       	push   $0x804529
  803473:	e8 fc 05 00 00       	call   803a74 <_panic>
  803478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347b:	8b 10                	mov    (%eax),%edx
  80347d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803480:	89 10                	mov    %edx,(%eax)
  803482:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803485:	8b 00                	mov    (%eax),%eax
  803487:	85 c0                	test   %eax,%eax
  803489:	74 0b                	je     803496 <realloc_block_FF+0x177>
  80348b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348e:	8b 00                	mov    (%eax),%eax
  803490:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803493:	89 50 04             	mov    %edx,0x4(%eax)
  803496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803499:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80349c:	89 10                	mov    %edx,(%eax)
  80349e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a4:	89 50 04             	mov    %edx,0x4(%eax)
  8034a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034aa:	8b 00                	mov    (%eax),%eax
  8034ac:	85 c0                	test   %eax,%eax
  8034ae:	75 08                	jne    8034b8 <realloc_block_FF+0x199>
  8034b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8034b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8034bd:	40                   	inc    %eax
  8034be:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8034c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034c7:	75 17                	jne    8034e0 <realloc_block_FF+0x1c1>
  8034c9:	83 ec 04             	sub    $0x4,%esp
  8034cc:	68 0b 45 80 00       	push   $0x80450b
  8034d1:	68 f7 01 00 00       	push   $0x1f7
  8034d6:	68 29 45 80 00       	push   $0x804529
  8034db:	e8 94 05 00 00       	call   803a74 <_panic>
  8034e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e3:	8b 00                	mov    (%eax),%eax
  8034e5:	85 c0                	test   %eax,%eax
  8034e7:	74 10                	je     8034f9 <realloc_block_FF+0x1da>
  8034e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034f1:	8b 52 04             	mov    0x4(%edx),%edx
  8034f4:	89 50 04             	mov    %edx,0x4(%eax)
  8034f7:	eb 0b                	jmp    803504 <realloc_block_FF+0x1e5>
  8034f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fc:	8b 40 04             	mov    0x4(%eax),%eax
  8034ff:	a3 30 50 80 00       	mov    %eax,0x805030
  803504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803507:	8b 40 04             	mov    0x4(%eax),%eax
  80350a:	85 c0                	test   %eax,%eax
  80350c:	74 0f                	je     80351d <realloc_block_FF+0x1fe>
  80350e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803511:	8b 40 04             	mov    0x4(%eax),%eax
  803514:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803517:	8b 12                	mov    (%edx),%edx
  803519:	89 10                	mov    %edx,(%eax)
  80351b:	eb 0a                	jmp    803527 <realloc_block_FF+0x208>
  80351d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803520:	8b 00                	mov    (%eax),%eax
  803522:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803533:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353a:	a1 38 50 80 00       	mov    0x805038,%eax
  80353f:	48                   	dec    %eax
  803540:	a3 38 50 80 00       	mov    %eax,0x805038
  803545:	e9 83 02 00 00       	jmp    8037cd <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80354a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80354e:	0f 86 69 02 00 00    	jbe    8037bd <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803554:	83 ec 04             	sub    $0x4,%esp
  803557:	6a 01                	push   $0x1
  803559:	ff 75 f0             	pushl  -0x10(%ebp)
  80355c:	ff 75 08             	pushl  0x8(%ebp)
  80355f:	e8 c8 ed ff ff       	call   80232c <set_block_data>
  803564:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	83 e8 04             	sub    $0x4,%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	83 e0 fe             	and    $0xfffffffe,%eax
  803572:	89 c2                	mov    %eax,%edx
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	01 d0                	add    %edx,%eax
  803579:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80357c:	a1 38 50 80 00       	mov    0x805038,%eax
  803581:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803584:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803588:	75 68                	jne    8035f2 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80358a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80358e:	75 17                	jne    8035a7 <realloc_block_FF+0x288>
  803590:	83 ec 04             	sub    $0x4,%esp
  803593:	68 44 45 80 00       	push   $0x804544
  803598:	68 06 02 00 00       	push   $0x206
  80359d:	68 29 45 80 00       	push   $0x804529
  8035a2:	e8 cd 04 00 00       	call   803a74 <_panic>
  8035a7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b0:	89 10                	mov    %edx,(%eax)
  8035b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b5:	8b 00                	mov    (%eax),%eax
  8035b7:	85 c0                	test   %eax,%eax
  8035b9:	74 0d                	je     8035c8 <realloc_block_FF+0x2a9>
  8035bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035c3:	89 50 04             	mov    %edx,0x4(%eax)
  8035c6:	eb 08                	jmp    8035d0 <realloc_block_FF+0x2b1>
  8035c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8035d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e7:	40                   	inc    %eax
  8035e8:	a3 38 50 80 00       	mov    %eax,0x805038
  8035ed:	e9 b0 01 00 00       	jmp    8037a2 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035f2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035f7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035fa:	76 68                	jbe    803664 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803600:	75 17                	jne    803619 <realloc_block_FF+0x2fa>
  803602:	83 ec 04             	sub    $0x4,%esp
  803605:	68 44 45 80 00       	push   $0x804544
  80360a:	68 0b 02 00 00       	push   $0x20b
  80360f:	68 29 45 80 00       	push   $0x804529
  803614:	e8 5b 04 00 00       	call   803a74 <_panic>
  803619:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80361f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803622:	89 10                	mov    %edx,(%eax)
  803624:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803627:	8b 00                	mov    (%eax),%eax
  803629:	85 c0                	test   %eax,%eax
  80362b:	74 0d                	je     80363a <realloc_block_FF+0x31b>
  80362d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803632:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803635:	89 50 04             	mov    %edx,0x4(%eax)
  803638:	eb 08                	jmp    803642 <realloc_block_FF+0x323>
  80363a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363d:	a3 30 50 80 00       	mov    %eax,0x805030
  803642:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803645:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80364a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803654:	a1 38 50 80 00       	mov    0x805038,%eax
  803659:	40                   	inc    %eax
  80365a:	a3 38 50 80 00       	mov    %eax,0x805038
  80365f:	e9 3e 01 00 00       	jmp    8037a2 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803664:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803669:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80366c:	73 68                	jae    8036d6 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80366e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803672:	75 17                	jne    80368b <realloc_block_FF+0x36c>
  803674:	83 ec 04             	sub    $0x4,%esp
  803677:	68 78 45 80 00       	push   $0x804578
  80367c:	68 10 02 00 00       	push   $0x210
  803681:	68 29 45 80 00       	push   $0x804529
  803686:	e8 e9 03 00 00       	call   803a74 <_panic>
  80368b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803691:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803694:	89 50 04             	mov    %edx,0x4(%eax)
  803697:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369a:	8b 40 04             	mov    0x4(%eax),%eax
  80369d:	85 c0                	test   %eax,%eax
  80369f:	74 0c                	je     8036ad <realloc_block_FF+0x38e>
  8036a1:	a1 30 50 80 00       	mov    0x805030,%eax
  8036a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a9:	89 10                	mov    %edx,(%eax)
  8036ab:	eb 08                	jmp    8036b5 <realloc_block_FF+0x396>
  8036ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8036bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c6:	a1 38 50 80 00       	mov    0x805038,%eax
  8036cb:	40                   	inc    %eax
  8036cc:	a3 38 50 80 00       	mov    %eax,0x805038
  8036d1:	e9 cc 00 00 00       	jmp    8037a2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8036d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8036dd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e5:	e9 8a 00 00 00       	jmp    803774 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ed:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036f0:	73 7a                	jae    80376c <realloc_block_FF+0x44d>
  8036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f5:	8b 00                	mov    (%eax),%eax
  8036f7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036fa:	73 70                	jae    80376c <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803700:	74 06                	je     803708 <realloc_block_FF+0x3e9>
  803702:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803706:	75 17                	jne    80371f <realloc_block_FF+0x400>
  803708:	83 ec 04             	sub    $0x4,%esp
  80370b:	68 9c 45 80 00       	push   $0x80459c
  803710:	68 1a 02 00 00       	push   $0x21a
  803715:	68 29 45 80 00       	push   $0x804529
  80371a:	e8 55 03 00 00       	call   803a74 <_panic>
  80371f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803722:	8b 10                	mov    (%eax),%edx
  803724:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803727:	89 10                	mov    %edx,(%eax)
  803729:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372c:	8b 00                	mov    (%eax),%eax
  80372e:	85 c0                	test   %eax,%eax
  803730:	74 0b                	je     80373d <realloc_block_FF+0x41e>
  803732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803735:	8b 00                	mov    (%eax),%eax
  803737:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80373a:	89 50 04             	mov    %edx,0x4(%eax)
  80373d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803740:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803743:	89 10                	mov    %edx,(%eax)
  803745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80374b:	89 50 04             	mov    %edx,0x4(%eax)
  80374e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803751:	8b 00                	mov    (%eax),%eax
  803753:	85 c0                	test   %eax,%eax
  803755:	75 08                	jne    80375f <realloc_block_FF+0x440>
  803757:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80375a:	a3 30 50 80 00       	mov    %eax,0x805030
  80375f:	a1 38 50 80 00       	mov    0x805038,%eax
  803764:	40                   	inc    %eax
  803765:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80376a:	eb 36                	jmp    8037a2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80376c:	a1 34 50 80 00       	mov    0x805034,%eax
  803771:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803778:	74 07                	je     803781 <realloc_block_FF+0x462>
  80377a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377d:	8b 00                	mov    (%eax),%eax
  80377f:	eb 05                	jmp    803786 <realloc_block_FF+0x467>
  803781:	b8 00 00 00 00       	mov    $0x0,%eax
  803786:	a3 34 50 80 00       	mov    %eax,0x805034
  80378b:	a1 34 50 80 00       	mov    0x805034,%eax
  803790:	85 c0                	test   %eax,%eax
  803792:	0f 85 52 ff ff ff    	jne    8036ea <realloc_block_FF+0x3cb>
  803798:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80379c:	0f 85 48 ff ff ff    	jne    8036ea <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8037a2:	83 ec 04             	sub    $0x4,%esp
  8037a5:	6a 00                	push   $0x0
  8037a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8037aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8037ad:	e8 7a eb ff ff       	call   80232c <set_block_data>
  8037b2:	83 c4 10             	add    $0x10,%esp
				return va;
  8037b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b8:	e9 7b 02 00 00       	jmp    803a38 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8037bd:	83 ec 0c             	sub    $0xc,%esp
  8037c0:	68 19 46 80 00       	push   $0x804619
  8037c5:	e8 76 cf ff ff       	call   800740 <cprintf>
  8037ca:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8037cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d0:	e9 63 02 00 00       	jmp    803a38 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8037d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037db:	0f 86 4d 02 00 00    	jbe    803a2e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8037e1:	83 ec 0c             	sub    $0xc,%esp
  8037e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037e7:	e8 08 e8 ff ff       	call   801ff4 <is_free_block>
  8037ec:	83 c4 10             	add    $0x10,%esp
  8037ef:	84 c0                	test   %al,%al
  8037f1:	0f 84 37 02 00 00    	je     803a2e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037fa:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037fd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803800:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803803:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803806:	76 38                	jbe    803840 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803808:	83 ec 0c             	sub    $0xc,%esp
  80380b:	ff 75 08             	pushl  0x8(%ebp)
  80380e:	e8 0c fa ff ff       	call   80321f <free_block>
  803813:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803816:	83 ec 0c             	sub    $0xc,%esp
  803819:	ff 75 0c             	pushl  0xc(%ebp)
  80381c:	e8 3a eb ff ff       	call   80235b <alloc_block_FF>
  803821:	83 c4 10             	add    $0x10,%esp
  803824:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803827:	83 ec 08             	sub    $0x8,%esp
  80382a:	ff 75 c0             	pushl  -0x40(%ebp)
  80382d:	ff 75 08             	pushl  0x8(%ebp)
  803830:	e8 ab fa ff ff       	call   8032e0 <copy_data>
  803835:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803838:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80383b:	e9 f8 01 00 00       	jmp    803a38 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803840:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803843:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803846:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803849:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80384d:	0f 87 a0 00 00 00    	ja     8038f3 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803853:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803857:	75 17                	jne    803870 <realloc_block_FF+0x551>
  803859:	83 ec 04             	sub    $0x4,%esp
  80385c:	68 0b 45 80 00       	push   $0x80450b
  803861:	68 38 02 00 00       	push   $0x238
  803866:	68 29 45 80 00       	push   $0x804529
  80386b:	e8 04 02 00 00       	call   803a74 <_panic>
  803870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803873:	8b 00                	mov    (%eax),%eax
  803875:	85 c0                	test   %eax,%eax
  803877:	74 10                	je     803889 <realloc_block_FF+0x56a>
  803879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387c:	8b 00                	mov    (%eax),%eax
  80387e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803881:	8b 52 04             	mov    0x4(%edx),%edx
  803884:	89 50 04             	mov    %edx,0x4(%eax)
  803887:	eb 0b                	jmp    803894 <realloc_block_FF+0x575>
  803889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388c:	8b 40 04             	mov    0x4(%eax),%eax
  80388f:	a3 30 50 80 00       	mov    %eax,0x805030
  803894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803897:	8b 40 04             	mov    0x4(%eax),%eax
  80389a:	85 c0                	test   %eax,%eax
  80389c:	74 0f                	je     8038ad <realloc_block_FF+0x58e>
  80389e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a1:	8b 40 04             	mov    0x4(%eax),%eax
  8038a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a7:	8b 12                	mov    (%edx),%edx
  8038a9:	89 10                	mov    %edx,(%eax)
  8038ab:	eb 0a                	jmp    8038b7 <realloc_block_FF+0x598>
  8038ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b0:	8b 00                	mov    (%eax),%eax
  8038b2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8038cf:	48                   	dec    %eax
  8038d0:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8038d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038db:	01 d0                	add    %edx,%eax
  8038dd:	83 ec 04             	sub    $0x4,%esp
  8038e0:	6a 01                	push   $0x1
  8038e2:	50                   	push   %eax
  8038e3:	ff 75 08             	pushl  0x8(%ebp)
  8038e6:	e8 41 ea ff ff       	call   80232c <set_block_data>
  8038eb:	83 c4 10             	add    $0x10,%esp
  8038ee:	e9 36 01 00 00       	jmp    803a29 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038f6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038f9:	01 d0                	add    %edx,%eax
  8038fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038fe:	83 ec 04             	sub    $0x4,%esp
  803901:	6a 01                	push   $0x1
  803903:	ff 75 f0             	pushl  -0x10(%ebp)
  803906:	ff 75 08             	pushl  0x8(%ebp)
  803909:	e8 1e ea ff ff       	call   80232c <set_block_data>
  80390e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803911:	8b 45 08             	mov    0x8(%ebp),%eax
  803914:	83 e8 04             	sub    $0x4,%eax
  803917:	8b 00                	mov    (%eax),%eax
  803919:	83 e0 fe             	and    $0xfffffffe,%eax
  80391c:	89 c2                	mov    %eax,%edx
  80391e:	8b 45 08             	mov    0x8(%ebp),%eax
  803921:	01 d0                	add    %edx,%eax
  803923:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803926:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80392a:	74 06                	je     803932 <realloc_block_FF+0x613>
  80392c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803930:	75 17                	jne    803949 <realloc_block_FF+0x62a>
  803932:	83 ec 04             	sub    $0x4,%esp
  803935:	68 9c 45 80 00       	push   $0x80459c
  80393a:	68 44 02 00 00       	push   $0x244
  80393f:	68 29 45 80 00       	push   $0x804529
  803944:	e8 2b 01 00 00       	call   803a74 <_panic>
  803949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394c:	8b 10                	mov    (%eax),%edx
  80394e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803951:	89 10                	mov    %edx,(%eax)
  803953:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803956:	8b 00                	mov    (%eax),%eax
  803958:	85 c0                	test   %eax,%eax
  80395a:	74 0b                	je     803967 <realloc_block_FF+0x648>
  80395c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803964:	89 50 04             	mov    %edx,0x4(%eax)
  803967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80396d:	89 10                	mov    %edx,(%eax)
  80396f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803972:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803975:	89 50 04             	mov    %edx,0x4(%eax)
  803978:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80397b:	8b 00                	mov    (%eax),%eax
  80397d:	85 c0                	test   %eax,%eax
  80397f:	75 08                	jne    803989 <realloc_block_FF+0x66a>
  803981:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803984:	a3 30 50 80 00       	mov    %eax,0x805030
  803989:	a1 38 50 80 00       	mov    0x805038,%eax
  80398e:	40                   	inc    %eax
  80398f:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803994:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803998:	75 17                	jne    8039b1 <realloc_block_FF+0x692>
  80399a:	83 ec 04             	sub    $0x4,%esp
  80399d:	68 0b 45 80 00       	push   $0x80450b
  8039a2:	68 45 02 00 00       	push   $0x245
  8039a7:	68 29 45 80 00       	push   $0x804529
  8039ac:	e8 c3 00 00 00       	call   803a74 <_panic>
  8039b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b4:	8b 00                	mov    (%eax),%eax
  8039b6:	85 c0                	test   %eax,%eax
  8039b8:	74 10                	je     8039ca <realloc_block_FF+0x6ab>
  8039ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bd:	8b 00                	mov    (%eax),%eax
  8039bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c2:	8b 52 04             	mov    0x4(%edx),%edx
  8039c5:	89 50 04             	mov    %edx,0x4(%eax)
  8039c8:	eb 0b                	jmp    8039d5 <realloc_block_FF+0x6b6>
  8039ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cd:	8b 40 04             	mov    0x4(%eax),%eax
  8039d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8039d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d8:	8b 40 04             	mov    0x4(%eax),%eax
  8039db:	85 c0                	test   %eax,%eax
  8039dd:	74 0f                	je     8039ee <realloc_block_FF+0x6cf>
  8039df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e2:	8b 40 04             	mov    0x4(%eax),%eax
  8039e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e8:	8b 12                	mov    (%edx),%edx
  8039ea:	89 10                	mov    %edx,(%eax)
  8039ec:	eb 0a                	jmp    8039f8 <realloc_block_FF+0x6d9>
  8039ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f1:	8b 00                	mov    (%eax),%eax
  8039f3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a0b:	a1 38 50 80 00       	mov    0x805038,%eax
  803a10:	48                   	dec    %eax
  803a11:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a16:	83 ec 04             	sub    $0x4,%esp
  803a19:	6a 00                	push   $0x0
  803a1b:	ff 75 bc             	pushl  -0x44(%ebp)
  803a1e:	ff 75 b8             	pushl  -0x48(%ebp)
  803a21:	e8 06 e9 ff ff       	call   80232c <set_block_data>
  803a26:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a29:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2c:	eb 0a                	jmp    803a38 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a2e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a38:	c9                   	leave  
  803a39:	c3                   	ret    

00803a3a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a3a:	55                   	push   %ebp
  803a3b:	89 e5                	mov    %esp,%ebp
  803a3d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a40:	83 ec 04             	sub    $0x4,%esp
  803a43:	68 20 46 80 00       	push   $0x804620
  803a48:	68 58 02 00 00       	push   $0x258
  803a4d:	68 29 45 80 00       	push   $0x804529
  803a52:	e8 1d 00 00 00       	call   803a74 <_panic>

00803a57 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a57:	55                   	push   %ebp
  803a58:	89 e5                	mov    %esp,%ebp
  803a5a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a5d:	83 ec 04             	sub    $0x4,%esp
  803a60:	68 48 46 80 00       	push   $0x804648
  803a65:	68 61 02 00 00       	push   $0x261
  803a6a:	68 29 45 80 00       	push   $0x804529
  803a6f:	e8 00 00 00 00       	call   803a74 <_panic>

00803a74 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a74:	55                   	push   %ebp
  803a75:	89 e5                	mov    %esp,%ebp
  803a77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a7a:	8d 45 10             	lea    0x10(%ebp),%eax
  803a7d:	83 c0 04             	add    $0x4,%eax
  803a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a83:	a1 60 50 90 00       	mov    0x905060,%eax
  803a88:	85 c0                	test   %eax,%eax
  803a8a:	74 16                	je     803aa2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a8c:	a1 60 50 90 00       	mov    0x905060,%eax
  803a91:	83 ec 08             	sub    $0x8,%esp
  803a94:	50                   	push   %eax
  803a95:	68 70 46 80 00       	push   $0x804670
  803a9a:	e8 a1 cc ff ff       	call   800740 <cprintf>
  803a9f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803aa2:	a1 00 50 80 00       	mov    0x805000,%eax
  803aa7:	ff 75 0c             	pushl  0xc(%ebp)
  803aaa:	ff 75 08             	pushl  0x8(%ebp)
  803aad:	50                   	push   %eax
  803aae:	68 75 46 80 00       	push   $0x804675
  803ab3:	e8 88 cc ff ff       	call   800740 <cprintf>
  803ab8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803abb:	8b 45 10             	mov    0x10(%ebp),%eax
  803abe:	83 ec 08             	sub    $0x8,%esp
  803ac1:	ff 75 f4             	pushl  -0xc(%ebp)
  803ac4:	50                   	push   %eax
  803ac5:	e8 0b cc ff ff       	call   8006d5 <vcprintf>
  803aca:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803acd:	83 ec 08             	sub    $0x8,%esp
  803ad0:	6a 00                	push   $0x0
  803ad2:	68 91 46 80 00       	push   $0x804691
  803ad7:	e8 f9 cb ff ff       	call   8006d5 <vcprintf>
  803adc:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803adf:	e8 7a cb ff ff       	call   80065e <exit>

	// should not return here
	while (1) ;
  803ae4:	eb fe                	jmp    803ae4 <_panic+0x70>

00803ae6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803ae6:	55                   	push   %ebp
  803ae7:	89 e5                	mov    %esp,%ebp
  803ae9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803aec:	a1 20 50 80 00       	mov    0x805020,%eax
  803af1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803afa:	39 c2                	cmp    %eax,%edx
  803afc:	74 14                	je     803b12 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803afe:	83 ec 04             	sub    $0x4,%esp
  803b01:	68 94 46 80 00       	push   $0x804694
  803b06:	6a 26                	push   $0x26
  803b08:	68 e0 46 80 00       	push   $0x8046e0
  803b0d:	e8 62 ff ff ff       	call   803a74 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803b12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803b19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b20:	e9 c5 00 00 00       	jmp    803bea <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b32:	01 d0                	add    %edx,%eax
  803b34:	8b 00                	mov    (%eax),%eax
  803b36:	85 c0                	test   %eax,%eax
  803b38:	75 08                	jne    803b42 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803b3a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803b3d:	e9 a5 00 00 00       	jmp    803be7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803b42:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b49:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b50:	eb 69                	jmp    803bbb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b52:	a1 20 50 80 00       	mov    0x805020,%eax
  803b57:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b60:	89 d0                	mov    %edx,%eax
  803b62:	01 c0                	add    %eax,%eax
  803b64:	01 d0                	add    %edx,%eax
  803b66:	c1 e0 03             	shl    $0x3,%eax
  803b69:	01 c8                	add    %ecx,%eax
  803b6b:	8a 40 04             	mov    0x4(%eax),%al
  803b6e:	84 c0                	test   %al,%al
  803b70:	75 46                	jne    803bb8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b72:	a1 20 50 80 00       	mov    0x805020,%eax
  803b77:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b7d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b80:	89 d0                	mov    %edx,%eax
  803b82:	01 c0                	add    %eax,%eax
  803b84:	01 d0                	add    %edx,%eax
  803b86:	c1 e0 03             	shl    $0x3,%eax
  803b89:	01 c8                	add    %ecx,%eax
  803b8b:	8b 00                	mov    (%eax),%eax
  803b8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b98:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b9d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba7:	01 c8                	add    %ecx,%eax
  803ba9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803bab:	39 c2                	cmp    %eax,%edx
  803bad:	75 09                	jne    803bb8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803baf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803bb6:	eb 15                	jmp    803bcd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bb8:	ff 45 e8             	incl   -0x18(%ebp)
  803bbb:	a1 20 50 80 00       	mov    0x805020,%eax
  803bc0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc9:	39 c2                	cmp    %eax,%edx
  803bcb:	77 85                	ja     803b52 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803bcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803bd1:	75 14                	jne    803be7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803bd3:	83 ec 04             	sub    $0x4,%esp
  803bd6:	68 ec 46 80 00       	push   $0x8046ec
  803bdb:	6a 3a                	push   $0x3a
  803bdd:	68 e0 46 80 00       	push   $0x8046e0
  803be2:	e8 8d fe ff ff       	call   803a74 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803be7:	ff 45 f0             	incl   -0x10(%ebp)
  803bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bed:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803bf0:	0f 8c 2f ff ff ff    	jl     803b25 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803bf6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bfd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803c04:	eb 26                	jmp    803c2c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803c06:	a1 20 50 80 00       	mov    0x805020,%eax
  803c0b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c14:	89 d0                	mov    %edx,%eax
  803c16:	01 c0                	add    %eax,%eax
  803c18:	01 d0                	add    %edx,%eax
  803c1a:	c1 e0 03             	shl    $0x3,%eax
  803c1d:	01 c8                	add    %ecx,%eax
  803c1f:	8a 40 04             	mov    0x4(%eax),%al
  803c22:	3c 01                	cmp    $0x1,%al
  803c24:	75 03                	jne    803c29 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803c26:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c29:	ff 45 e0             	incl   -0x20(%ebp)
  803c2c:	a1 20 50 80 00       	mov    0x805020,%eax
  803c31:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c3a:	39 c2                	cmp    %eax,%edx
  803c3c:	77 c8                	ja     803c06 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c41:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c44:	74 14                	je     803c5a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803c46:	83 ec 04             	sub    $0x4,%esp
  803c49:	68 40 47 80 00       	push   $0x804740
  803c4e:	6a 44                	push   $0x44
  803c50:	68 e0 46 80 00       	push   $0x8046e0
  803c55:	e8 1a fe ff ff       	call   803a74 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803c5a:	90                   	nop
  803c5b:	c9                   	leave  
  803c5c:	c3                   	ret    
  803c5d:	66 90                	xchg   %ax,%ax
  803c5f:	90                   	nop

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
