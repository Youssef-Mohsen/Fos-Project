
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
  80003e:	e8 87 1d 00 00       	call   801dca <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 b1 1d 00 00       	call   801dfc <sys_getparentenvid>
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
  80005f:	68 20 40 80 00       	push   $0x804020
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 ac 18 00 00       	call   801918 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 24 40 80 00       	push   $0x804024
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 96 18 00 00       	call   801918 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 2c 40 80 00       	push   $0x80402c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 79 18 00 00       	call   801918 <sget>
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
  8000b3:	68 3a 40 80 00       	push   $0x80403a
  8000b8:	e8 51 17 00 00       	call   80180e <smalloc>
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
  800126:	68 44 40 80 00       	push   $0x804044
  80012b:	e8 10 06 00 00       	call   800740 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 69 40 80 00       	push   $0x804069
  80013f:	e8 ca 16 00 00       	call   80180e <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 6e 40 80 00       	push   $0x80406e
  80015e:	e8 ab 16 00 00       	call   80180e <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 72 40 80 00       	push   $0x804072
  80017d:	e8 8c 16 00 00       	call   80180e <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 76 40 80 00       	push   $0x804076
  80019c:	e8 6d 16 00 00       	call   80180e <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 7a 40 80 00       	push   $0x80407a
  8001bb:	e8 4e 16 00 00       	call   80180e <smalloc>
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
  800230:	e8 fa 1b 00 00       	call   801e2f <sys_get_virtual_time>
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
  800533:	e8 ab 18 00 00       	call   801de3 <sys_getenvindex>
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
  8005a1:	e8 c1 15 00 00       	call   801b67 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	68 98 40 80 00       	push   $0x804098
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
  8005d1:	68 c0 40 80 00       	push   $0x8040c0
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
  800602:	68 e8 40 80 00       	push   $0x8040e8
  800607:	e8 34 01 00 00       	call   800740 <cprintf>
  80060c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060f:	a1 20 50 80 00       	mov    0x805020,%eax
  800614:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	50                   	push   %eax
  80061e:	68 40 41 80 00       	push   $0x804140
  800623:	e8 18 01 00 00       	call   800740 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	68 98 40 80 00       	push   $0x804098
  800633:	e8 08 01 00 00       	call   800740 <cprintf>
  800638:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80063b:	e8 41 15 00 00       	call   801b81 <sys_unlock_cons>
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
  800653:	e8 57 17 00 00       	call   801daf <sys_destroy_env>
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
  800664:	e8 ac 17 00 00       	call   801e15 <sys_exit_env>
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
  800697:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  8006b2:	e8 6e 14 00 00       	call   801b25 <sys_cputs>
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
  80070c:	a0 2c 50 80 00       	mov    0x80502c,%al
  800711:	0f b6 c0             	movzbl %al,%eax
  800714:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80071a:	83 ec 04             	sub    $0x4,%esp
  80071d:	50                   	push   %eax
  80071e:	52                   	push   %edx
  80071f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800725:	83 c0 08             	add    $0x8,%eax
  800728:	50                   	push   %eax
  800729:	e8 f7 13 00 00       	call   801b25 <sys_cputs>
  80072e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800731:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  800746:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  800773:	e8 ef 13 00 00       	call   801b67 <sys_lock_cons>
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
  800793:	e8 e9 13 00 00       	call   801b81 <sys_unlock_cons>
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
  8007dd:	e8 c6 35 00 00       	call   803da8 <__udivdi3>
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
  80082d:	e8 86 36 00 00       	call   803eb8 <__umoddi3>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	05 74 43 80 00       	add    $0x804374,%eax
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
  800988:	8b 04 85 98 43 80 00 	mov    0x804398(,%eax,4),%eax
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
  800a69:	8b 34 9d e0 41 80 00 	mov    0x8041e0(,%ebx,4),%esi
  800a70:	85 f6                	test   %esi,%esi
  800a72:	75 19                	jne    800a8d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a74:	53                   	push   %ebx
  800a75:	68 85 43 80 00       	push   $0x804385
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
  800a8e:	68 8e 43 80 00       	push   $0x80438e
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
  800abb:	be 91 43 80 00       	mov    $0x804391,%esi
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
  800cb3:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800cba:	eb 2c                	jmp    800ce8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cbc:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8014c6:	68 08 45 80 00       	push   $0x804508
  8014cb:	68 3f 01 00 00       	push   $0x13f
  8014d0:	68 2a 45 80 00       	push   $0x80452a
  8014d5:	e8 e2 26 00 00       	call   803bbc <_panic>

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
  8014e6:	e8 e5 0b 00 00       	call   8020d0 <sys_sbrk>
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
  801561:	e8 ee 09 00 00       	call   801f54 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801566:	85 c0                	test   %eax,%eax
  801568:	74 16                	je     801580 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	e8 2e 0f 00 00       	call   8024a3 <alloc_block_FF>
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157b:	e9 8a 01 00 00       	jmp    80170a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801580:	e8 00 0a 00 00       	call   801f85 <sys_isUHeapPlacementStrategyBESTFIT>
  801585:	85 c0                	test   %eax,%eax
  801587:	0f 84 7d 01 00 00    	je     80170a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 c7 13 00 00       	call   80295f <alloc_block_BF>
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
  8015e3:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801630:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801687:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  8016e9:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	ff 75 08             	pushl  0x8(%ebp)
  8016f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8016f9:	e8 09 0a 00 00       	call   802107 <sys_allocate_user_mem>
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
  801741:	e8 dd 09 00 00       	call   802123 <get_block_size>
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	e8 10 1c 00 00       	call   803367 <free_block>
  801757:	83 c4 10             	add    $0x10,%esp
		}

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
  80178c:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  801793:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801796:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801799:	c1 e0 0c             	shl    $0xc,%eax
  80179c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80179f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8017a6:	eb 42                	jmp    8017ea <free+0xdb>
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
  8017c9:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  8017d0:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8017d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	83 ec 08             	sub    $0x8,%esp
  8017dd:	52                   	push   %edx
  8017de:	50                   	push   %eax
  8017df:	e8 07 09 00 00       	call   8020eb <sys_free_user_mem>
  8017e4:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8017e7:	ff 45 f4             	incl   -0xc(%ebp)
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017f0:	72 b6                	jb     8017a8 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8017f2:	eb 17                	jmp    80180b <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	68 38 45 80 00       	push   $0x804538
  8017fc:	68 88 00 00 00       	push   $0x88
  801801:	68 62 45 80 00       	push   $0x804562
  801806:	e8 b1 23 00 00       	call   803bbc <_panic>
	}
}
  80180b:	90                   	nop
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 28             	sub    $0x28,%esp
  801814:	8b 45 10             	mov    0x10(%ebp),%eax
  801817:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80181a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181e:	75 0a                	jne    80182a <smalloc+0x1c>
  801820:	b8 00 00 00 00       	mov    $0x0,%eax
  801825:	e9 ec 00 00 00       	jmp    801916 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80182a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801830:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801837:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80183a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183d:	39 d0                	cmp    %edx,%eax
  80183f:	73 02                	jae    801843 <smalloc+0x35>
  801841:	89 d0                	mov    %edx,%eax
  801843:	83 ec 0c             	sub    $0xc,%esp
  801846:	50                   	push   %eax
  801847:	e8 a4 fc ff ff       	call   8014f0 <malloc>
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801852:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801856:	75 0a                	jne    801862 <smalloc+0x54>
  801858:	b8 00 00 00 00       	mov    $0x0,%eax
  80185d:	e9 b4 00 00 00       	jmp    801916 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801862:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801866:	ff 75 ec             	pushl  -0x14(%ebp)
  801869:	50                   	push   %eax
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	ff 75 08             	pushl  0x8(%ebp)
  801870:	e8 7d 04 00 00       	call   801cf2 <sys_createSharedObject>
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80187b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80187f:	74 06                	je     801887 <smalloc+0x79>
  801881:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801885:	75 0a                	jne    801891 <smalloc+0x83>
  801887:	b8 00 00 00 00       	mov    $0x0,%eax
  80188c:	e9 85 00 00 00       	jmp    801916 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801891:	83 ec 08             	sub    $0x8,%esp
  801894:	ff 75 ec             	pushl  -0x14(%ebp)
  801897:	68 6e 45 80 00       	push   $0x80456e
  80189c:	e8 9f ee ff ff       	call   800740 <cprintf>
  8018a1:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8018a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8018ac:	8b 40 78             	mov    0x78(%eax),%eax
  8018af:	29 c2                	sub    %eax,%edx
  8018b1:	89 d0                	mov    %edx,%eax
  8018b3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018b8:	c1 e8 0c             	shr    $0xc,%eax
  8018bb:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8018c1:	42                   	inc    %edx
  8018c2:	89 15 24 50 80 00    	mov    %edx,0x805024
  8018c8:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8018ce:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8018d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8018dd:	8b 40 78             	mov    0x78(%eax),%eax
  8018e0:	29 c2                	sub    %eax,%edx
  8018e2:	89 d0                	mov    %edx,%eax
  8018e4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018e9:	c1 e8 0c             	shr    $0xc,%eax
  8018ec:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8018f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8018f8:	8b 50 10             	mov    0x10(%eax),%edx
  8018fb:	89 c8                	mov    %ecx,%eax
  8018fd:	c1 e0 02             	shl    $0x2,%eax
  801900:	89 c1                	mov    %eax,%ecx
  801902:	c1 e1 09             	shl    $0x9,%ecx
  801905:	01 c8                	add    %ecx,%eax
  801907:	01 c2                	add    %eax,%edx
  801909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190c:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801913:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80191e:	83 ec 08             	sub    $0x8,%esp
  801921:	ff 75 0c             	pushl  0xc(%ebp)
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	e8 f0 03 00 00       	call   801d1c <sys_getSizeOfSharedObject>
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801932:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801936:	75 0a                	jne    801942 <sget+0x2a>
  801938:	b8 00 00 00 00       	mov    $0x0,%eax
  80193d:	e9 e7 00 00 00       	jmp    801a29 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801948:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80194f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801955:	39 d0                	cmp    %edx,%eax
  801957:	73 02                	jae    80195b <sget+0x43>
  801959:	89 d0                	mov    %edx,%eax
  80195b:	83 ec 0c             	sub    $0xc,%esp
  80195e:	50                   	push   %eax
  80195f:	e8 8c fb ff ff       	call   8014f0 <malloc>
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80196a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80196e:	75 0a                	jne    80197a <sget+0x62>
  801970:	b8 00 00 00 00       	mov    $0x0,%eax
  801975:	e9 af 00 00 00       	jmp    801a29 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	ff 75 e8             	pushl  -0x18(%ebp)
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	ff 75 08             	pushl  0x8(%ebp)
  801986:	e8 ae 03 00 00       	call   801d39 <sys_getSharedObject>
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801991:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801994:	a1 20 50 80 00       	mov    0x805020,%eax
  801999:	8b 40 78             	mov    0x78(%eax),%eax
  80199c:	29 c2                	sub    %eax,%edx
  80199e:	89 d0                	mov    %edx,%eax
  8019a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019a5:	c1 e8 0c             	shr    $0xc,%eax
  8019a8:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8019ae:	42                   	inc    %edx
  8019af:	89 15 24 50 80 00    	mov    %edx,0x805024
  8019b5:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8019bb:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8019c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8019ca:	8b 40 78             	mov    0x78(%eax),%eax
  8019cd:	29 c2                	sub    %eax,%edx
  8019cf:	89 d0                	mov    %edx,%eax
  8019d1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019d6:	c1 e8 0c             	shr    $0xc,%eax
  8019d9:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8019e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8019e5:	8b 50 10             	mov    0x10(%eax),%edx
  8019e8:	89 c8                	mov    %ecx,%eax
  8019ea:	c1 e0 02             	shl    $0x2,%eax
  8019ed:	89 c1                	mov    %eax,%ecx
  8019ef:	c1 e1 09             	shl    $0x9,%ecx
  8019f2:	01 c8                	add    %ecx,%eax
  8019f4:	01 c2                	add    %eax,%edx
  8019f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f9:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801a00:	a1 20 50 80 00       	mov    0x805020,%eax
  801a05:	8b 40 10             	mov    0x10(%eax),%eax
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	50                   	push   %eax
  801a0c:	68 7d 45 80 00       	push   $0x80457d
  801a11:	e8 2a ed ff ff       	call   800740 <cprintf>
  801a16:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a19:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a1d:	75 07                	jne    801a26 <sget+0x10e>
  801a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a24:	eb 03                	jmp    801a29 <sget+0x111>
	return ptr;
  801a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801a31:	8b 55 08             	mov    0x8(%ebp),%edx
  801a34:	a1 20 50 80 00       	mov    0x805020,%eax
  801a39:	8b 40 78             	mov    0x78(%eax),%eax
  801a3c:	29 c2                	sub    %eax,%edx
  801a3e:	89 d0                	mov    %edx,%eax
  801a40:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a45:	c1 e8 0c             	shr    $0xc,%eax
  801a48:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801a4f:	a1 20 50 80 00       	mov    0x805020,%eax
  801a54:	8b 50 10             	mov    0x10(%eax),%edx
  801a57:	89 c8                	mov    %ecx,%eax
  801a59:	c1 e0 02             	shl    $0x2,%eax
  801a5c:	89 c1                	mov    %eax,%ecx
  801a5e:	c1 e1 09             	shl    $0x9,%ecx
  801a61:	01 c8                	add    %ecx,%eax
  801a63:	01 d0                	add    %edx,%eax
  801a65:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a6f:	83 ec 08             	sub    $0x8,%esp
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	ff 75 f4             	pushl  -0xc(%ebp)
  801a78:	e8 db 02 00 00       	call   801d58 <sys_freeSharedObject>
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801a83:	90                   	nop
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	68 8c 45 80 00       	push   $0x80458c
  801a94:	68 e5 00 00 00       	push   $0xe5
  801a99:	68 62 45 80 00       	push   $0x804562
  801a9e:	e8 19 21 00 00       	call   803bbc <_panic>

00801aa3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	68 b2 45 80 00       	push   $0x8045b2
  801ab1:	68 f1 00 00 00       	push   $0xf1
  801ab6:	68 62 45 80 00       	push   $0x804562
  801abb:	e8 fc 20 00 00       	call   803bbc <_panic>

00801ac0 <shrink>:

}
void shrink(uint32 newSize)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac6:	83 ec 04             	sub    $0x4,%esp
  801ac9:	68 b2 45 80 00       	push   $0x8045b2
  801ace:	68 f6 00 00 00       	push   $0xf6
  801ad3:	68 62 45 80 00       	push   $0x804562
  801ad8:	e8 df 20 00 00       	call   803bbc <_panic>

00801add <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae3:	83 ec 04             	sub    $0x4,%esp
  801ae6:	68 b2 45 80 00       	push   $0x8045b2
  801aeb:	68 fb 00 00 00       	push   $0xfb
  801af0:	68 62 45 80 00       	push   $0x804562
  801af5:	e8 c2 20 00 00       	call   803bbc <_panic>

00801afa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	57                   	push   %edi
  801afe:	56                   	push   %esi
  801aff:	53                   	push   %ebx
  801b00:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b0f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b12:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b15:	cd 30                	int    $0x30
  801b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	5b                   	pop    %ebx
  801b21:	5e                   	pop    %esi
  801b22:	5f                   	pop    %edi
  801b23:	5d                   	pop    %ebp
  801b24:	c3                   	ret    

00801b25 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	83 ec 04             	sub    $0x4,%esp
  801b2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b31:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	52                   	push   %edx
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	50                   	push   %eax
  801b41:	6a 00                	push   $0x0
  801b43:	e8 b2 ff ff ff       	call   801afa <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	90                   	nop
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_cgetc>:

int
sys_cgetc(void)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 02                	push   $0x2
  801b5d:	e8 98 ff ff ff       	call   801afa <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 03                	push   $0x3
  801b76:	e8 7f ff ff ff       	call   801afa <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	90                   	nop
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 04                	push   $0x4
  801b90:	e8 65 ff ff ff       	call   801afa <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	90                   	nop
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	52                   	push   %edx
  801bab:	50                   	push   %eax
  801bac:	6a 08                	push   $0x8
  801bae:	e8 47 ff ff ff       	call   801afa <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	56                   	push   %esi
  801bbc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bbd:	8b 75 18             	mov    0x18(%ebp),%esi
  801bc0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	56                   	push   %esi
  801bcd:	53                   	push   %ebx
  801bce:	51                   	push   %ecx
  801bcf:	52                   	push   %edx
  801bd0:	50                   	push   %eax
  801bd1:	6a 09                	push   $0x9
  801bd3:	e8 22 ff ff ff       	call   801afa <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bde:	5b                   	pop    %ebx
  801bdf:	5e                   	pop    %esi
  801be0:	5d                   	pop    %ebp
  801be1:	c3                   	ret    

00801be2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 0a                	push   $0xa
  801bf5:	e8 00 ff ff ff       	call   801afa <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	ff 75 0c             	pushl  0xc(%ebp)
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	6a 0b                	push   $0xb
  801c10:	e8 e5 fe ff ff       	call   801afa <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 0c                	push   $0xc
  801c29:	e8 cc fe ff ff       	call   801afa <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 0d                	push   $0xd
  801c42:	e8 b3 fe ff ff       	call   801afa <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 0e                	push   $0xe
  801c5b:	e8 9a fe ff ff       	call   801afa <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 0f                	push   $0xf
  801c74:	e8 81 fe ff ff       	call   801afa <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	ff 75 08             	pushl  0x8(%ebp)
  801c8c:	6a 10                	push   $0x10
  801c8e:	e8 67 fe ff ff       	call   801afa <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 11                	push   $0x11
  801ca7:	e8 4e fe ff ff       	call   801afa <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	90                   	nop
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_cputc>:

void
sys_cputc(const char c)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 04             	sub    $0x4,%esp
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cbe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	50                   	push   %eax
  801ccb:	6a 01                	push   $0x1
  801ccd:	e8 28 fe ff ff       	call   801afa <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	90                   	nop
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 14                	push   $0x14
  801ce7:	e8 0e fe ff ff       	call   801afa <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	90                   	nop
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cfe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d01:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	6a 00                	push   $0x0
  801d0a:	51                   	push   %ecx
  801d0b:	52                   	push   %edx
  801d0c:	ff 75 0c             	pushl  0xc(%ebp)
  801d0f:	50                   	push   %eax
  801d10:	6a 15                	push   $0x15
  801d12:	e8 e3 fd ff ff       	call   801afa <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	52                   	push   %edx
  801d2c:	50                   	push   %eax
  801d2d:	6a 16                	push   $0x16
  801d2f:	e8 c6 fd ff ff       	call   801afa <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	51                   	push   %ecx
  801d4a:	52                   	push   %edx
  801d4b:	50                   	push   %eax
  801d4c:	6a 17                	push   $0x17
  801d4e:	e8 a7 fd ff ff       	call   801afa <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	6a 18                	push   $0x18
  801d6b:	e8 8a fd ff ff       	call   801afa <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	ff 75 14             	pushl  0x14(%ebp)
  801d80:	ff 75 10             	pushl  0x10(%ebp)
  801d83:	ff 75 0c             	pushl  0xc(%ebp)
  801d86:	50                   	push   %eax
  801d87:	6a 19                	push   $0x19
  801d89:	e8 6c fd ff ff       	call   801afa <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	50                   	push   %eax
  801da2:	6a 1a                	push   $0x1a
  801da4:	e8 51 fd ff ff       	call   801afa <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
}
  801dac:	90                   	nop
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	50                   	push   %eax
  801dbe:	6a 1b                	push   $0x1b
  801dc0:	e8 35 fd ff ff       	call   801afa <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 05                	push   $0x5
  801dd9:	e8 1c fd ff ff       	call   801afa <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 06                	push   $0x6
  801df2:	e8 03 fd ff ff       	call   801afa <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 07                	push   $0x7
  801e0b:	e8 ea fc ff ff       	call   801afa <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_exit_env>:


void sys_exit_env(void)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 1c                	push   $0x1c
  801e24:	e8 d1 fc ff ff       	call   801afa <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	90                   	nop
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e35:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e38:	8d 50 04             	lea    0x4(%eax),%edx
  801e3b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	52                   	push   %edx
  801e45:	50                   	push   %eax
  801e46:	6a 1d                	push   $0x1d
  801e48:	e8 ad fc ff ff       	call   801afa <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
	return result;
  801e50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e59:	89 01                	mov    %eax,(%ecx)
  801e5b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	c9                   	leave  
  801e62:	c2 04 00             	ret    $0x4

00801e65 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	ff 75 10             	pushl  0x10(%ebp)
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	ff 75 08             	pushl  0x8(%ebp)
  801e75:	6a 13                	push   $0x13
  801e77:	e8 7e fc ff ff       	call   801afa <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7f:	90                   	nop
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 1e                	push   $0x1e
  801e91:	e8 64 fc ff ff       	call   801afa <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 04             	sub    $0x4,%esp
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ea7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	50                   	push   %eax
  801eb4:	6a 1f                	push   $0x1f
  801eb6:	e8 3f fc ff ff       	call   801afa <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebe:	90                   	nop
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <rsttst>:
void rsttst()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 21                	push   $0x21
  801ed0:	e8 25 fc ff ff       	call   801afa <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed8:	90                   	nop
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ee7:	8b 55 18             	mov    0x18(%ebp),%edx
  801eea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eee:	52                   	push   %edx
  801eef:	50                   	push   %eax
  801ef0:	ff 75 10             	pushl  0x10(%ebp)
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	ff 75 08             	pushl  0x8(%ebp)
  801ef9:	6a 20                	push   $0x20
  801efb:	e8 fa fb ff ff       	call   801afa <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
	return ;
  801f03:	90                   	nop
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <chktst>:
void chktst(uint32 n)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	ff 75 08             	pushl  0x8(%ebp)
  801f14:	6a 22                	push   $0x22
  801f16:	e8 df fb ff ff       	call   801afa <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1e:	90                   	nop
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <inctst>:

void inctst()
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 23                	push   $0x23
  801f30:	e8 c5 fb ff ff       	call   801afa <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
	return ;
  801f38:	90                   	nop
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <gettst>:
uint32 gettst()
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 24                	push   $0x24
  801f4a:	e8 ab fb ff ff       	call   801afa <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
}
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

00801f54 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 25                	push   $0x25
  801f66:	e8 8f fb ff ff       	call   801afa <syscall>
  801f6b:	83 c4 18             	add    $0x18,%esp
  801f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f71:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f75:	75 07                	jne    801f7e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f77:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7c:	eb 05                	jmp    801f83 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 25                	push   $0x25
  801f97:	e8 5e fb ff ff       	call   801afa <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
  801f9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fa2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fa6:	75 07                	jne    801faf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fa8:	b8 01 00 00 00       	mov    $0x1,%eax
  801fad:	eb 05                	jmp    801fb4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 25                	push   $0x25
  801fc8:	e8 2d fb ff ff       	call   801afa <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
  801fd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fd3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fd7:	75 07                	jne    801fe0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fde:	eb 05                	jmp    801fe5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fe0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 25                	push   $0x25
  801ff9:	e8 fc fa ff ff       	call   801afa <syscall>
  801ffe:	83 c4 18             	add    $0x18,%esp
  802001:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802004:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802008:	75 07                	jne    802011 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80200a:	b8 01 00 00 00       	mov    $0x1,%eax
  80200f:	eb 05                	jmp    802016 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802011:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	ff 75 08             	pushl  0x8(%ebp)
  802026:	6a 26                	push   $0x26
  802028:	e8 cd fa ff ff       	call   801afa <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
	return ;
  802030:	90                   	nop
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802037:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80203a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	6a 00                	push   $0x0
  802045:	53                   	push   %ebx
  802046:	51                   	push   %ecx
  802047:	52                   	push   %edx
  802048:	50                   	push   %eax
  802049:	6a 27                	push   $0x27
  80204b:	e8 aa fa ff ff       	call   801afa <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
}
  802053:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80205b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	52                   	push   %edx
  802068:	50                   	push   %eax
  802069:	6a 28                	push   $0x28
  80206b:	e8 8a fa ff ff       	call   801afa <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802078:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80207b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	6a 00                	push   $0x0
  802083:	51                   	push   %ecx
  802084:	ff 75 10             	pushl  0x10(%ebp)
  802087:	52                   	push   %edx
  802088:	50                   	push   %eax
  802089:	6a 29                	push   $0x29
  80208b:	e8 6a fa ff ff       	call   801afa <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	ff 75 10             	pushl  0x10(%ebp)
  80209f:	ff 75 0c             	pushl  0xc(%ebp)
  8020a2:	ff 75 08             	pushl  0x8(%ebp)
  8020a5:	6a 12                	push   $0x12
  8020a7:	e8 4e fa ff ff       	call   801afa <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8020af:	90                   	nop
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8020b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	52                   	push   %edx
  8020c2:	50                   	push   %eax
  8020c3:	6a 2a                	push   $0x2a
  8020c5:	e8 30 fa ff ff       	call   801afa <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
	return;
  8020cd:	90                   	nop
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	50                   	push   %eax
  8020df:	6a 2b                	push   $0x2b
  8020e1:	e8 14 fa ff ff       	call   801afa <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	ff 75 08             	pushl  0x8(%ebp)
  8020fa:	6a 2c                	push   $0x2c
  8020fc:	e8 f9 f9 ff ff       	call   801afa <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
	return;
  802104:	90                   	nop
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	ff 75 0c             	pushl  0xc(%ebp)
  802113:	ff 75 08             	pushl  0x8(%ebp)
  802116:	6a 2d                	push   $0x2d
  802118:	e8 dd f9 ff ff       	call   801afa <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
	return;
  802120:	90                   	nop
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	83 e8 04             	sub    $0x4,%eax
  80212f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802132:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802135:	8b 00                	mov    (%eax),%eax
  802137:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	83 e8 04             	sub    $0x4,%eax
  802148:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80214b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80214e:	8b 00                	mov    (%eax),%eax
  802150:	83 e0 01             	and    $0x1,%eax
  802153:	85 c0                	test   %eax,%eax
  802155:	0f 94 c0             	sete   %al
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802160:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216a:	83 f8 02             	cmp    $0x2,%eax
  80216d:	74 2b                	je     80219a <alloc_block+0x40>
  80216f:	83 f8 02             	cmp    $0x2,%eax
  802172:	7f 07                	jg     80217b <alloc_block+0x21>
  802174:	83 f8 01             	cmp    $0x1,%eax
  802177:	74 0e                	je     802187 <alloc_block+0x2d>
  802179:	eb 58                	jmp    8021d3 <alloc_block+0x79>
  80217b:	83 f8 03             	cmp    $0x3,%eax
  80217e:	74 2d                	je     8021ad <alloc_block+0x53>
  802180:	83 f8 04             	cmp    $0x4,%eax
  802183:	74 3b                	je     8021c0 <alloc_block+0x66>
  802185:	eb 4c                	jmp    8021d3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802187:	83 ec 0c             	sub    $0xc,%esp
  80218a:	ff 75 08             	pushl  0x8(%ebp)
  80218d:	e8 11 03 00 00       	call   8024a3 <alloc_block_FF>
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802198:	eb 4a                	jmp    8021e4 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80219a:	83 ec 0c             	sub    $0xc,%esp
  80219d:	ff 75 08             	pushl  0x8(%ebp)
  8021a0:	e8 fa 19 00 00       	call   803b9f <alloc_block_NF>
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021ab:	eb 37                	jmp    8021e4 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8021ad:	83 ec 0c             	sub    $0xc,%esp
  8021b0:	ff 75 08             	pushl  0x8(%ebp)
  8021b3:	e8 a7 07 00 00       	call   80295f <alloc_block_BF>
  8021b8:	83 c4 10             	add    $0x10,%esp
  8021bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021be:	eb 24                	jmp    8021e4 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8021c0:	83 ec 0c             	sub    $0xc,%esp
  8021c3:	ff 75 08             	pushl  0x8(%ebp)
  8021c6:	e8 b7 19 00 00       	call   803b82 <alloc_block_WF>
  8021cb:	83 c4 10             	add    $0x10,%esp
  8021ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021d1:	eb 11                	jmp    8021e4 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8021d3:	83 ec 0c             	sub    $0xc,%esp
  8021d6:	68 c4 45 80 00       	push   $0x8045c4
  8021db:	e8 60 e5 ff ff       	call   800740 <cprintf>
  8021e0:	83 c4 10             	add    $0x10,%esp
		break;
  8021e3:	90                   	nop
	}
	return va;
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	53                   	push   %ebx
  8021ed:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021f0:	83 ec 0c             	sub    $0xc,%esp
  8021f3:	68 e4 45 80 00       	push   $0x8045e4
  8021f8:	e8 43 e5 ff ff       	call   800740 <cprintf>
  8021fd:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802200:	83 ec 0c             	sub    $0xc,%esp
  802203:	68 0f 46 80 00       	push   $0x80460f
  802208:	e8 33 e5 ff ff       	call   800740 <cprintf>
  80220d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802216:	eb 37                	jmp    80224f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802218:	83 ec 0c             	sub    $0xc,%esp
  80221b:	ff 75 f4             	pushl  -0xc(%ebp)
  80221e:	e8 19 ff ff ff       	call   80213c <is_free_block>
  802223:	83 c4 10             	add    $0x10,%esp
  802226:	0f be d8             	movsbl %al,%ebx
  802229:	83 ec 0c             	sub    $0xc,%esp
  80222c:	ff 75 f4             	pushl  -0xc(%ebp)
  80222f:	e8 ef fe ff ff       	call   802123 <get_block_size>
  802234:	83 c4 10             	add    $0x10,%esp
  802237:	83 ec 04             	sub    $0x4,%esp
  80223a:	53                   	push   %ebx
  80223b:	50                   	push   %eax
  80223c:	68 27 46 80 00       	push   $0x804627
  802241:	e8 fa e4 ff ff       	call   800740 <cprintf>
  802246:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802249:	8b 45 10             	mov    0x10(%ebp),%eax
  80224c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802253:	74 07                	je     80225c <print_blocks_list+0x73>
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	8b 00                	mov    (%eax),%eax
  80225a:	eb 05                	jmp    802261 <print_blocks_list+0x78>
  80225c:	b8 00 00 00 00       	mov    $0x0,%eax
  802261:	89 45 10             	mov    %eax,0x10(%ebp)
  802264:	8b 45 10             	mov    0x10(%ebp),%eax
  802267:	85 c0                	test   %eax,%eax
  802269:	75 ad                	jne    802218 <print_blocks_list+0x2f>
  80226b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226f:	75 a7                	jne    802218 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802271:	83 ec 0c             	sub    $0xc,%esp
  802274:	68 e4 45 80 00       	push   $0x8045e4
  802279:	e8 c2 e4 ff ff       	call   800740 <cprintf>
  80227e:	83 c4 10             	add    $0x10,%esp

}
  802281:	90                   	nop
  802282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80228d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802290:	83 e0 01             	and    $0x1,%eax
  802293:	85 c0                	test   %eax,%eax
  802295:	74 03                	je     80229a <initialize_dynamic_allocator+0x13>
  802297:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80229a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80229e:	0f 84 c7 01 00 00    	je     80246b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8022a4:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8022ab:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8022ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b4:	01 d0                	add    %edx,%eax
  8022b6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8022bb:	0f 87 ad 01 00 00    	ja     80246e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	0f 89 a5 01 00 00    	jns    802471 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8022cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d2:	01 d0                	add    %edx,%eax
  8022d4:	83 e8 04             	sub    $0x4,%eax
  8022d7:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8022dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022e3:	a1 30 50 80 00       	mov    0x805030,%eax
  8022e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022eb:	e9 87 00 00 00       	jmp    802377 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f4:	75 14                	jne    80230a <initialize_dynamic_allocator+0x83>
  8022f6:	83 ec 04             	sub    $0x4,%esp
  8022f9:	68 3f 46 80 00       	push   $0x80463f
  8022fe:	6a 79                	push   $0x79
  802300:	68 5d 46 80 00       	push   $0x80465d
  802305:	e8 b2 18 00 00       	call   803bbc <_panic>
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 00                	mov    (%eax),%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 10                	je     802323 <initialize_dynamic_allocator+0x9c>
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231b:	8b 52 04             	mov    0x4(%edx),%edx
  80231e:	89 50 04             	mov    %edx,0x4(%eax)
  802321:	eb 0b                	jmp    80232e <initialize_dynamic_allocator+0xa7>
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 40 04             	mov    0x4(%eax),%eax
  802329:	a3 34 50 80 00       	mov    %eax,0x805034
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 40 04             	mov    0x4(%eax),%eax
  802334:	85 c0                	test   %eax,%eax
  802336:	74 0f                	je     802347 <initialize_dynamic_allocator+0xc0>
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	8b 40 04             	mov    0x4(%eax),%eax
  80233e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802341:	8b 12                	mov    (%edx),%edx
  802343:	89 10                	mov    %edx,(%eax)
  802345:	eb 0a                	jmp    802351 <initialize_dynamic_allocator+0xca>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	a3 30 50 80 00       	mov    %eax,0x805030
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802364:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802369:	48                   	dec    %eax
  80236a:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80236f:	a1 38 50 80 00       	mov    0x805038,%eax
  802374:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237b:	74 07                	je     802384 <initialize_dynamic_allocator+0xfd>
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	8b 00                	mov    (%eax),%eax
  802382:	eb 05                	jmp    802389 <initialize_dynamic_allocator+0x102>
  802384:	b8 00 00 00 00       	mov    $0x0,%eax
  802389:	a3 38 50 80 00       	mov    %eax,0x805038
  80238e:	a1 38 50 80 00       	mov    0x805038,%eax
  802393:	85 c0                	test   %eax,%eax
  802395:	0f 85 55 ff ff ff    	jne    8022f0 <initialize_dynamic_allocator+0x69>
  80239b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239f:	0f 85 4b ff ff ff    	jne    8022f0 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8023ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ae:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8023b4:	a1 48 50 80 00       	mov    0x805048,%eax
  8023b9:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8023be:	a1 44 50 80 00       	mov    0x805044,%eax
  8023c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	83 c0 08             	add    $0x8,%eax
  8023cf:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	83 c0 04             	add    $0x4,%eax
  8023d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023db:	83 ea 08             	sub    $0x8,%edx
  8023de:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	01 d0                	add    %edx,%eax
  8023e8:	83 e8 08             	sub    $0x8,%eax
  8023eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ee:	83 ea 08             	sub    $0x8,%edx
  8023f1:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802406:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80240a:	75 17                	jne    802423 <initialize_dynamic_allocator+0x19c>
  80240c:	83 ec 04             	sub    $0x4,%esp
  80240f:	68 78 46 80 00       	push   $0x804678
  802414:	68 90 00 00 00       	push   $0x90
  802419:	68 5d 46 80 00       	push   $0x80465d
  80241e:	e8 99 17 00 00       	call   803bbc <_panic>
  802423:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242c:	89 10                	mov    %edx,(%eax)
  80242e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802431:	8b 00                	mov    (%eax),%eax
  802433:	85 c0                	test   %eax,%eax
  802435:	74 0d                	je     802444 <initialize_dynamic_allocator+0x1bd>
  802437:	a1 30 50 80 00       	mov    0x805030,%eax
  80243c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80243f:	89 50 04             	mov    %edx,0x4(%eax)
  802442:	eb 08                	jmp    80244c <initialize_dynamic_allocator+0x1c5>
  802444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802447:	a3 34 50 80 00       	mov    %eax,0x805034
  80244c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244f:	a3 30 50 80 00       	mov    %eax,0x805030
  802454:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802457:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802463:	40                   	inc    %eax
  802464:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802469:	eb 07                	jmp    802472 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80246b:	90                   	nop
  80246c:	eb 04                	jmp    802472 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80246e:	90                   	nop
  80246f:	eb 01                	jmp    802472 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802471:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802477:	8b 45 10             	mov    0x10(%ebp),%eax
  80247a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	8d 50 fc             	lea    -0x4(%eax),%edx
  802483:	8b 45 0c             	mov    0xc(%ebp),%eax
  802486:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	83 e8 04             	sub    $0x4,%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	83 e0 fe             	and    $0xfffffffe,%eax
  802493:	8d 50 f8             	lea    -0x8(%eax),%edx
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	01 c2                	add    %eax,%edx
  80249b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249e:	89 02                	mov    %eax,(%edx)
}
  8024a0:	90                   	nop
  8024a1:	5d                   	pop    %ebp
  8024a2:	c3                   	ret    

008024a3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ac:	83 e0 01             	and    $0x1,%eax
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	74 03                	je     8024b6 <alloc_block_FF+0x13>
  8024b3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024b6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024ba:	77 07                	ja     8024c3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024bc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024c3:	a1 28 50 80 00       	mov    0x805028,%eax
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	75 73                	jne    80253f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	83 c0 10             	add    $0x10,%eax
  8024d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024d5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e2:	01 d0                	add    %edx,%eax
  8024e4:	48                   	dec    %eax
  8024e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f0:	f7 75 ec             	divl   -0x14(%ebp)
  8024f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f6:	29 d0                	sub    %edx,%eax
  8024f8:	c1 e8 0c             	shr    $0xc,%eax
  8024fb:	83 ec 0c             	sub    $0xc,%esp
  8024fe:	50                   	push   %eax
  8024ff:	e8 d6 ef ff ff       	call   8014da <sbrk>
  802504:	83 c4 10             	add    $0x10,%esp
  802507:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80250a:	83 ec 0c             	sub    $0xc,%esp
  80250d:	6a 00                	push   $0x0
  80250f:	e8 c6 ef ff ff       	call   8014da <sbrk>
  802514:	83 c4 10             	add    $0x10,%esp
  802517:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80251a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802520:	83 ec 08             	sub    $0x8,%esp
  802523:	50                   	push   %eax
  802524:	ff 75 e4             	pushl  -0x1c(%ebp)
  802527:	e8 5b fd ff ff       	call   802287 <initialize_dynamic_allocator>
  80252c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80252f:	83 ec 0c             	sub    $0xc,%esp
  802532:	68 9b 46 80 00       	push   $0x80469b
  802537:	e8 04 e2 ff ff       	call   800740 <cprintf>
  80253c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80253f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802543:	75 0a                	jne    80254f <alloc_block_FF+0xac>
	        return NULL;
  802545:	b8 00 00 00 00       	mov    $0x0,%eax
  80254a:	e9 0e 04 00 00       	jmp    80295d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80254f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802556:	a1 30 50 80 00       	mov    0x805030,%eax
  80255b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255e:	e9 f3 02 00 00       	jmp    802856 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802569:	83 ec 0c             	sub    $0xc,%esp
  80256c:	ff 75 bc             	pushl  -0x44(%ebp)
  80256f:	e8 af fb ff ff       	call   802123 <get_block_size>
  802574:	83 c4 10             	add    $0x10,%esp
  802577:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	83 c0 08             	add    $0x8,%eax
  802580:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802583:	0f 87 c5 02 00 00    	ja     80284e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	83 c0 18             	add    $0x18,%eax
  80258f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802592:	0f 87 19 02 00 00    	ja     8027b1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802598:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80259b:	2b 45 08             	sub    0x8(%ebp),%eax
  80259e:	83 e8 08             	sub    $0x8,%eax
  8025a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8025a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a7:	8d 50 08             	lea    0x8(%eax),%edx
  8025aa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025ad:	01 d0                	add    %edx,%eax
  8025af:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8025b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b5:	83 c0 08             	add    $0x8,%eax
  8025b8:	83 ec 04             	sub    $0x4,%esp
  8025bb:	6a 01                	push   $0x1
  8025bd:	50                   	push   %eax
  8025be:	ff 75 bc             	pushl  -0x44(%ebp)
  8025c1:	e8 ae fe ff ff       	call   802474 <set_block_data>
  8025c6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 40 04             	mov    0x4(%eax),%eax
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	75 68                	jne    80263b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025d3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025d7:	75 17                	jne    8025f0 <alloc_block_FF+0x14d>
  8025d9:	83 ec 04             	sub    $0x4,%esp
  8025dc:	68 78 46 80 00       	push   $0x804678
  8025e1:	68 d7 00 00 00       	push   $0xd7
  8025e6:	68 5d 46 80 00       	push   $0x80465d
  8025eb:	e8 cc 15 00 00       	call   803bbc <_panic>
  8025f0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8025f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f9:	89 10                	mov    %edx,(%eax)
  8025fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	74 0d                	je     802611 <alloc_block_FF+0x16e>
  802604:	a1 30 50 80 00       	mov    0x805030,%eax
  802609:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80260c:	89 50 04             	mov    %edx,0x4(%eax)
  80260f:	eb 08                	jmp    802619 <alloc_block_FF+0x176>
  802611:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802614:	a3 34 50 80 00       	mov    %eax,0x805034
  802619:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80261c:	a3 30 50 80 00       	mov    %eax,0x805030
  802621:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802624:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802630:	40                   	inc    %eax
  802631:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802636:	e9 dc 00 00 00       	jmp    802717 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 00                	mov    (%eax),%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	75 65                	jne    8026a9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802644:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802648:	75 17                	jne    802661 <alloc_block_FF+0x1be>
  80264a:	83 ec 04             	sub    $0x4,%esp
  80264d:	68 ac 46 80 00       	push   $0x8046ac
  802652:	68 db 00 00 00       	push   $0xdb
  802657:	68 5d 46 80 00       	push   $0x80465d
  80265c:	e8 5b 15 00 00       	call   803bbc <_panic>
  802661:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802667:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80266a:	89 50 04             	mov    %edx,0x4(%eax)
  80266d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802670:	8b 40 04             	mov    0x4(%eax),%eax
  802673:	85 c0                	test   %eax,%eax
  802675:	74 0c                	je     802683 <alloc_block_FF+0x1e0>
  802677:	a1 34 50 80 00       	mov    0x805034,%eax
  80267c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80267f:	89 10                	mov    %edx,(%eax)
  802681:	eb 08                	jmp    80268b <alloc_block_FF+0x1e8>
  802683:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802686:	a3 30 50 80 00       	mov    %eax,0x805030
  80268b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80268e:	a3 34 50 80 00       	mov    %eax,0x805034
  802693:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802696:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026a1:	40                   	inc    %eax
  8026a2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8026a7:	eb 6e                	jmp    802717 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8026a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ad:	74 06                	je     8026b5 <alloc_block_FF+0x212>
  8026af:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026b3:	75 17                	jne    8026cc <alloc_block_FF+0x229>
  8026b5:	83 ec 04             	sub    $0x4,%esp
  8026b8:	68 d0 46 80 00       	push   $0x8046d0
  8026bd:	68 df 00 00 00       	push   $0xdf
  8026c2:	68 5d 46 80 00       	push   $0x80465d
  8026c7:	e8 f0 14 00 00       	call   803bbc <_panic>
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 10                	mov    (%eax),%edx
  8026d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026d4:	89 10                	mov    %edx,(%eax)
  8026d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026d9:	8b 00                	mov    (%eax),%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 0b                	je     8026ea <alloc_block_FF+0x247>
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 00                	mov    (%eax),%eax
  8026e4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026e7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026f0:	89 10                	mov    %edx,(%eax)
  8026f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f8:	89 50 04             	mov    %edx,0x4(%eax)
  8026fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	75 08                	jne    80270c <alloc_block_FF+0x269>
  802704:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802707:	a3 34 50 80 00       	mov    %eax,0x805034
  80270c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802711:	40                   	inc    %eax
  802712:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802717:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271b:	75 17                	jne    802734 <alloc_block_FF+0x291>
  80271d:	83 ec 04             	sub    $0x4,%esp
  802720:	68 3f 46 80 00       	push   $0x80463f
  802725:	68 e1 00 00 00       	push   $0xe1
  80272a:	68 5d 46 80 00       	push   $0x80465d
  80272f:	e8 88 14 00 00       	call   803bbc <_panic>
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 00                	mov    (%eax),%eax
  802739:	85 c0                	test   %eax,%eax
  80273b:	74 10                	je     80274d <alloc_block_FF+0x2aa>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802745:	8b 52 04             	mov    0x4(%edx),%edx
  802748:	89 50 04             	mov    %edx,0x4(%eax)
  80274b:	eb 0b                	jmp    802758 <alloc_block_FF+0x2b5>
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 40 04             	mov    0x4(%eax),%eax
  802753:	a3 34 50 80 00       	mov    %eax,0x805034
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 40 04             	mov    0x4(%eax),%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	74 0f                	je     802771 <alloc_block_FF+0x2ce>
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 40 04             	mov    0x4(%eax),%eax
  802768:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276b:	8b 12                	mov    (%edx),%edx
  80276d:	89 10                	mov    %edx,(%eax)
  80276f:	eb 0a                	jmp    80277b <alloc_block_FF+0x2d8>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	a3 30 50 80 00       	mov    %eax,0x805030
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802793:	48                   	dec    %eax
  802794:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802799:	83 ec 04             	sub    $0x4,%esp
  80279c:	6a 00                	push   $0x0
  80279e:	ff 75 b4             	pushl  -0x4c(%ebp)
  8027a1:	ff 75 b0             	pushl  -0x50(%ebp)
  8027a4:	e8 cb fc ff ff       	call   802474 <set_block_data>
  8027a9:	83 c4 10             	add    $0x10,%esp
  8027ac:	e9 95 00 00 00       	jmp    802846 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8027b1:	83 ec 04             	sub    $0x4,%esp
  8027b4:	6a 01                	push   $0x1
  8027b6:	ff 75 b8             	pushl  -0x48(%ebp)
  8027b9:	ff 75 bc             	pushl  -0x44(%ebp)
  8027bc:	e8 b3 fc ff ff       	call   802474 <set_block_data>
  8027c1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8027c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c8:	75 17                	jne    8027e1 <alloc_block_FF+0x33e>
  8027ca:	83 ec 04             	sub    $0x4,%esp
  8027cd:	68 3f 46 80 00       	push   $0x80463f
  8027d2:	68 e8 00 00 00       	push   $0xe8
  8027d7:	68 5d 46 80 00       	push   $0x80465d
  8027dc:	e8 db 13 00 00       	call   803bbc <_panic>
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	74 10                	je     8027fa <alloc_block_FF+0x357>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f2:	8b 52 04             	mov    0x4(%edx),%edx
  8027f5:	89 50 04             	mov    %edx,0x4(%eax)
  8027f8:	eb 0b                	jmp    802805 <alloc_block_FF+0x362>
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 40 04             	mov    0x4(%eax),%eax
  802800:	a3 34 50 80 00       	mov    %eax,0x805034
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 40 04             	mov    0x4(%eax),%eax
  80280b:	85 c0                	test   %eax,%eax
  80280d:	74 0f                	je     80281e <alloc_block_FF+0x37b>
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 40 04             	mov    0x4(%eax),%eax
  802815:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802818:	8b 12                	mov    (%edx),%edx
  80281a:	89 10                	mov    %edx,(%eax)
  80281c:	eb 0a                	jmp    802828 <alloc_block_FF+0x385>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	a3 30 50 80 00       	mov    %eax,0x805030
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802840:	48                   	dec    %eax
  802841:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802846:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802849:	e9 0f 01 00 00       	jmp    80295d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80284e:	a1 38 50 80 00       	mov    0x805038,%eax
  802853:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802856:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285a:	74 07                	je     802863 <alloc_block_FF+0x3c0>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	eb 05                	jmp    802868 <alloc_block_FF+0x3c5>
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
  802868:	a3 38 50 80 00       	mov    %eax,0x805038
  80286d:	a1 38 50 80 00       	mov    0x805038,%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	0f 85 e9 fc ff ff    	jne    802563 <alloc_block_FF+0xc0>
  80287a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287e:	0f 85 df fc ff ff    	jne    802563 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	83 c0 08             	add    $0x8,%eax
  80288a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80288d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802894:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802897:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80289a:	01 d0                	add    %edx,%eax
  80289c:	48                   	dec    %eax
  80289d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a8:	f7 75 d8             	divl   -0x28(%ebp)
  8028ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028ae:	29 d0                	sub    %edx,%eax
  8028b0:	c1 e8 0c             	shr    $0xc,%eax
  8028b3:	83 ec 0c             	sub    $0xc,%esp
  8028b6:	50                   	push   %eax
  8028b7:	e8 1e ec ff ff       	call   8014da <sbrk>
  8028bc:	83 c4 10             	add    $0x10,%esp
  8028bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8028c2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8028c6:	75 0a                	jne    8028d2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8028c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cd:	e9 8b 00 00 00       	jmp    80295d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8028d2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028df:	01 d0                	add    %edx,%eax
  8028e1:	48                   	dec    %eax
  8028e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ed:	f7 75 cc             	divl   -0x34(%ebp)
  8028f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028f3:	29 d0                	sub    %edx,%eax
  8028f5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028fb:	01 d0                	add    %edx,%eax
  8028fd:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802902:	a1 44 50 80 00       	mov    0x805044,%eax
  802907:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80290d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802914:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802917:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80291a:	01 d0                	add    %edx,%eax
  80291c:	48                   	dec    %eax
  80291d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802920:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802923:	ba 00 00 00 00       	mov    $0x0,%edx
  802928:	f7 75 c4             	divl   -0x3c(%ebp)
  80292b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80292e:	29 d0                	sub    %edx,%eax
  802930:	83 ec 04             	sub    $0x4,%esp
  802933:	6a 01                	push   $0x1
  802935:	50                   	push   %eax
  802936:	ff 75 d0             	pushl  -0x30(%ebp)
  802939:	e8 36 fb ff ff       	call   802474 <set_block_data>
  80293e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802941:	83 ec 0c             	sub    $0xc,%esp
  802944:	ff 75 d0             	pushl  -0x30(%ebp)
  802947:	e8 1b 0a 00 00       	call   803367 <free_block>
  80294c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80294f:	83 ec 0c             	sub    $0xc,%esp
  802952:	ff 75 08             	pushl  0x8(%ebp)
  802955:	e8 49 fb ff ff       	call   8024a3 <alloc_block_FF>
  80295a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80295d:	c9                   	leave  
  80295e:	c3                   	ret    

0080295f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80295f:	55                   	push   %ebp
  802960:	89 e5                	mov    %esp,%ebp
  802962:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	83 e0 01             	and    $0x1,%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	74 03                	je     802972 <alloc_block_BF+0x13>
  80296f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802972:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802976:	77 07                	ja     80297f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802978:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80297f:	a1 28 50 80 00       	mov    0x805028,%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	75 73                	jne    8029fb <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	83 c0 10             	add    $0x10,%eax
  80298e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802991:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802998:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80299b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80299e:	01 d0                	add    %edx,%eax
  8029a0:	48                   	dec    %eax
  8029a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8029a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ac:	f7 75 e0             	divl   -0x20(%ebp)
  8029af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029b2:	29 d0                	sub    %edx,%eax
  8029b4:	c1 e8 0c             	shr    $0xc,%eax
  8029b7:	83 ec 0c             	sub    $0xc,%esp
  8029ba:	50                   	push   %eax
  8029bb:	e8 1a eb ff ff       	call   8014da <sbrk>
  8029c0:	83 c4 10             	add    $0x10,%esp
  8029c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029c6:	83 ec 0c             	sub    $0xc,%esp
  8029c9:	6a 00                	push   $0x0
  8029cb:	e8 0a eb ff ff       	call   8014da <sbrk>
  8029d0:	83 c4 10             	add    $0x10,%esp
  8029d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029d9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029dc:	83 ec 08             	sub    $0x8,%esp
  8029df:	50                   	push   %eax
  8029e0:	ff 75 d8             	pushl  -0x28(%ebp)
  8029e3:	e8 9f f8 ff ff       	call   802287 <initialize_dynamic_allocator>
  8029e8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029eb:	83 ec 0c             	sub    $0xc,%esp
  8029ee:	68 9b 46 80 00       	push   $0x80469b
  8029f3:	e8 48 dd ff ff       	call   800740 <cprintf>
  8029f8:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802a02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802a09:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802a10:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802a17:	a1 30 50 80 00       	mov    0x805030,%eax
  802a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1f:	e9 1d 01 00 00       	jmp    802b41 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802a2a:	83 ec 0c             	sub    $0xc,%esp
  802a2d:	ff 75 a8             	pushl  -0x58(%ebp)
  802a30:	e8 ee f6 ff ff       	call   802123 <get_block_size>
  802a35:	83 c4 10             	add    $0x10,%esp
  802a38:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	83 c0 08             	add    $0x8,%eax
  802a41:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a44:	0f 87 ef 00 00 00    	ja     802b39 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	83 c0 18             	add    $0x18,%eax
  802a50:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a53:	77 1d                	ja     802a72 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a58:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a5b:	0f 86 d8 00 00 00    	jbe    802b39 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a61:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a67:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a6d:	e9 c7 00 00 00       	jmp    802b39 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	83 c0 08             	add    $0x8,%eax
  802a78:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a7b:	0f 85 9d 00 00 00    	jne    802b1e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a81:	83 ec 04             	sub    $0x4,%esp
  802a84:	6a 01                	push   $0x1
  802a86:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a89:	ff 75 a8             	pushl  -0x58(%ebp)
  802a8c:	e8 e3 f9 ff ff       	call   802474 <set_block_data>
  802a91:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a98:	75 17                	jne    802ab1 <alloc_block_BF+0x152>
  802a9a:	83 ec 04             	sub    $0x4,%esp
  802a9d:	68 3f 46 80 00       	push   $0x80463f
  802aa2:	68 2c 01 00 00       	push   $0x12c
  802aa7:	68 5d 46 80 00       	push   $0x80465d
  802aac:	e8 0b 11 00 00       	call   803bbc <_panic>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 00                	mov    (%eax),%eax
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	74 10                	je     802aca <alloc_block_BF+0x16b>
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac2:	8b 52 04             	mov    0x4(%edx),%edx
  802ac5:	89 50 04             	mov    %edx,0x4(%eax)
  802ac8:	eb 0b                	jmp    802ad5 <alloc_block_BF+0x176>
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 40 04             	mov    0x4(%eax),%eax
  802ad0:	a3 34 50 80 00       	mov    %eax,0x805034
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 40 04             	mov    0x4(%eax),%eax
  802adb:	85 c0                	test   %eax,%eax
  802add:	74 0f                	je     802aee <alloc_block_BF+0x18f>
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 40 04             	mov    0x4(%eax),%eax
  802ae5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae8:	8b 12                	mov    (%edx),%edx
  802aea:	89 10                	mov    %edx,(%eax)
  802aec:	eb 0a                	jmp    802af8 <alloc_block_BF+0x199>
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	a3 30 50 80 00       	mov    %eax,0x805030
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b10:	48                   	dec    %eax
  802b11:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802b16:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b19:	e9 24 04 00 00       	jmp    802f42 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b21:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b24:	76 13                	jbe    802b39 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802b26:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802b2d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802b33:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b36:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b39:	a1 38 50 80 00       	mov    0x805038,%eax
  802b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b45:	74 07                	je     802b4e <alloc_block_BF+0x1ef>
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	eb 05                	jmp    802b53 <alloc_block_BF+0x1f4>
  802b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b53:	a3 38 50 80 00       	mov    %eax,0x805038
  802b58:	a1 38 50 80 00       	mov    0x805038,%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	0f 85 bf fe ff ff    	jne    802a24 <alloc_block_BF+0xc5>
  802b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b69:	0f 85 b5 fe ff ff    	jne    802a24 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b73:	0f 84 26 02 00 00    	je     802d9f <alloc_block_BF+0x440>
  802b79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b7d:	0f 85 1c 02 00 00    	jne    802d9f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b86:	2b 45 08             	sub    0x8(%ebp),%eax
  802b89:	83 e8 08             	sub    $0x8,%eax
  802b8c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	8d 50 08             	lea    0x8(%eax),%edx
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	01 d0                	add    %edx,%eax
  802b9a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	83 c0 08             	add    $0x8,%eax
  802ba3:	83 ec 04             	sub    $0x4,%esp
  802ba6:	6a 01                	push   $0x1
  802ba8:	50                   	push   %eax
  802ba9:	ff 75 f0             	pushl  -0x10(%ebp)
  802bac:	e8 c3 f8 ff ff       	call   802474 <set_block_data>
  802bb1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb7:	8b 40 04             	mov    0x4(%eax),%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	75 68                	jne    802c26 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bbe:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bc2:	75 17                	jne    802bdb <alloc_block_BF+0x27c>
  802bc4:	83 ec 04             	sub    $0x4,%esp
  802bc7:	68 78 46 80 00       	push   $0x804678
  802bcc:	68 45 01 00 00       	push   $0x145
  802bd1:	68 5d 46 80 00       	push   $0x80465d
  802bd6:	e8 e1 0f 00 00       	call   803bbc <_panic>
  802bdb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802be1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be4:	89 10                	mov    %edx,(%eax)
  802be6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 0d                	je     802bfc <alloc_block_BF+0x29d>
  802bef:	a1 30 50 80 00       	mov    0x805030,%eax
  802bf4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bf7:	89 50 04             	mov    %edx,0x4(%eax)
  802bfa:	eb 08                	jmp    802c04 <alloc_block_BF+0x2a5>
  802bfc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bff:	a3 34 50 80 00       	mov    %eax,0x805034
  802c04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c07:	a3 30 50 80 00       	mov    %eax,0x805030
  802c0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c16:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c1b:	40                   	inc    %eax
  802c1c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802c21:	e9 dc 00 00 00       	jmp    802d02 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	75 65                	jne    802c94 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c2f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c33:	75 17                	jne    802c4c <alloc_block_BF+0x2ed>
  802c35:	83 ec 04             	sub    $0x4,%esp
  802c38:	68 ac 46 80 00       	push   $0x8046ac
  802c3d:	68 4a 01 00 00       	push   $0x14a
  802c42:	68 5d 46 80 00       	push   $0x80465d
  802c47:	e8 70 0f 00 00       	call   803bbc <_panic>
  802c4c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802c52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c55:	89 50 04             	mov    %edx,0x4(%eax)
  802c58:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 0c                	je     802c6e <alloc_block_BF+0x30f>
  802c62:	a1 34 50 80 00       	mov    0x805034,%eax
  802c67:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c6a:	89 10                	mov    %edx,(%eax)
  802c6c:	eb 08                	jmp    802c76 <alloc_block_BF+0x317>
  802c6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c71:	a3 30 50 80 00       	mov    %eax,0x805030
  802c76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c79:	a3 34 50 80 00       	mov    %eax,0x805034
  802c7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c87:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c8c:	40                   	inc    %eax
  802c8d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802c92:	eb 6e                	jmp    802d02 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c98:	74 06                	je     802ca0 <alloc_block_BF+0x341>
  802c9a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c9e:	75 17                	jne    802cb7 <alloc_block_BF+0x358>
  802ca0:	83 ec 04             	sub    $0x4,%esp
  802ca3:	68 d0 46 80 00       	push   $0x8046d0
  802ca8:	68 4f 01 00 00       	push   $0x14f
  802cad:	68 5d 46 80 00       	push   $0x80465d
  802cb2:	e8 05 0f 00 00       	call   803bbc <_panic>
  802cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cba:	8b 10                	mov    (%eax),%edx
  802cbc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cbf:	89 10                	mov    %edx,(%eax)
  802cc1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	74 0b                	je     802cd5 <alloc_block_BF+0x376>
  802cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cd2:	89 50 04             	mov    %edx,0x4(%eax)
  802cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cdb:	89 10                	mov    %edx,(%eax)
  802cdd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ce0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce3:	89 50 04             	mov    %edx,0x4(%eax)
  802ce6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	75 08                	jne    802cf7 <alloc_block_BF+0x398>
  802cef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf2:	a3 34 50 80 00       	mov    %eax,0x805034
  802cf7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cfc:	40                   	inc    %eax
  802cfd:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802d02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d06:	75 17                	jne    802d1f <alloc_block_BF+0x3c0>
  802d08:	83 ec 04             	sub    $0x4,%esp
  802d0b:	68 3f 46 80 00       	push   $0x80463f
  802d10:	68 51 01 00 00       	push   $0x151
  802d15:	68 5d 46 80 00       	push   $0x80465d
  802d1a:	e8 9d 0e 00 00       	call   803bbc <_panic>
  802d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	85 c0                	test   %eax,%eax
  802d26:	74 10                	je     802d38 <alloc_block_BF+0x3d9>
  802d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d30:	8b 52 04             	mov    0x4(%edx),%edx
  802d33:	89 50 04             	mov    %edx,0x4(%eax)
  802d36:	eb 0b                	jmp    802d43 <alloc_block_BF+0x3e4>
  802d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3b:	8b 40 04             	mov    0x4(%eax),%eax
  802d3e:	a3 34 50 80 00       	mov    %eax,0x805034
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	8b 40 04             	mov    0x4(%eax),%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	74 0f                	je     802d5c <alloc_block_BF+0x3fd>
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 40 04             	mov    0x4(%eax),%eax
  802d53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d56:	8b 12                	mov    (%edx),%edx
  802d58:	89 10                	mov    %edx,(%eax)
  802d5a:	eb 0a                	jmp    802d66 <alloc_block_BF+0x407>
  802d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5f:	8b 00                	mov    (%eax),%eax
  802d61:	a3 30 50 80 00       	mov    %eax,0x805030
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d79:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d7e:	48                   	dec    %eax
  802d7f:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802d84:	83 ec 04             	sub    $0x4,%esp
  802d87:	6a 00                	push   $0x0
  802d89:	ff 75 d0             	pushl  -0x30(%ebp)
  802d8c:	ff 75 cc             	pushl  -0x34(%ebp)
  802d8f:	e8 e0 f6 ff ff       	call   802474 <set_block_data>
  802d94:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9a:	e9 a3 01 00 00       	jmp    802f42 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d9f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802da3:	0f 85 9d 00 00 00    	jne    802e46 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802da9:	83 ec 04             	sub    $0x4,%esp
  802dac:	6a 01                	push   $0x1
  802dae:	ff 75 ec             	pushl  -0x14(%ebp)
  802db1:	ff 75 f0             	pushl  -0x10(%ebp)
  802db4:	e8 bb f6 ff ff       	call   802474 <set_block_data>
  802db9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802dbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc0:	75 17                	jne    802dd9 <alloc_block_BF+0x47a>
  802dc2:	83 ec 04             	sub    $0x4,%esp
  802dc5:	68 3f 46 80 00       	push   $0x80463f
  802dca:	68 58 01 00 00       	push   $0x158
  802dcf:	68 5d 46 80 00       	push   $0x80465d
  802dd4:	e8 e3 0d 00 00       	call   803bbc <_panic>
  802dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddc:	8b 00                	mov    (%eax),%eax
  802dde:	85 c0                	test   %eax,%eax
  802de0:	74 10                	je     802df2 <alloc_block_BF+0x493>
  802de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dea:	8b 52 04             	mov    0x4(%edx),%edx
  802ded:	89 50 04             	mov    %edx,0x4(%eax)
  802df0:	eb 0b                	jmp    802dfd <alloc_block_BF+0x49e>
  802df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df5:	8b 40 04             	mov    0x4(%eax),%eax
  802df8:	a3 34 50 80 00       	mov    %eax,0x805034
  802dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e00:	8b 40 04             	mov    0x4(%eax),%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	74 0f                	je     802e16 <alloc_block_BF+0x4b7>
  802e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0a:	8b 40 04             	mov    0x4(%eax),%eax
  802e0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e10:	8b 12                	mov    (%edx),%edx
  802e12:	89 10                	mov    %edx,(%eax)
  802e14:	eb 0a                	jmp    802e20 <alloc_block_BF+0x4c1>
  802e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e19:	8b 00                	mov    (%eax),%eax
  802e1b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e33:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e38:	48                   	dec    %eax
  802e39:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e41:	e9 fc 00 00 00       	jmp    802f42 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	83 c0 08             	add    $0x8,%eax
  802e4c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e4f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e56:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e5c:	01 d0                	add    %edx,%eax
  802e5e:	48                   	dec    %eax
  802e5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e62:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e65:	ba 00 00 00 00       	mov    $0x0,%edx
  802e6a:	f7 75 c4             	divl   -0x3c(%ebp)
  802e6d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e70:	29 d0                	sub    %edx,%eax
  802e72:	c1 e8 0c             	shr    $0xc,%eax
  802e75:	83 ec 0c             	sub    $0xc,%esp
  802e78:	50                   	push   %eax
  802e79:	e8 5c e6 ff ff       	call   8014da <sbrk>
  802e7e:	83 c4 10             	add    $0x10,%esp
  802e81:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e84:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e88:	75 0a                	jne    802e94 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8f:	e9 ae 00 00 00       	jmp    802f42 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e94:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e9b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e9e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ea1:	01 d0                	add    %edx,%eax
  802ea3:	48                   	dec    %eax
  802ea4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ea7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802eaa:	ba 00 00 00 00       	mov    $0x0,%edx
  802eaf:	f7 75 b8             	divl   -0x48(%ebp)
  802eb2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802eb5:	29 d0                	sub    %edx,%eax
  802eb7:	8d 50 fc             	lea    -0x4(%eax),%edx
  802eba:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ebd:	01 d0                	add    %edx,%eax
  802ebf:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802ec4:	a1 44 50 80 00       	mov    0x805044,%eax
  802ec9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ecf:	83 ec 0c             	sub    $0xc,%esp
  802ed2:	68 04 47 80 00       	push   $0x804704
  802ed7:	e8 64 d8 ff ff       	call   800740 <cprintf>
  802edc:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802edf:	83 ec 08             	sub    $0x8,%esp
  802ee2:	ff 75 bc             	pushl  -0x44(%ebp)
  802ee5:	68 09 47 80 00       	push   $0x804709
  802eea:	e8 51 d8 ff ff       	call   800740 <cprintf>
  802eef:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ef2:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ef9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802efc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802eff:	01 d0                	add    %edx,%eax
  802f01:	48                   	dec    %eax
  802f02:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802f05:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f08:	ba 00 00 00 00       	mov    $0x0,%edx
  802f0d:	f7 75 b0             	divl   -0x50(%ebp)
  802f10:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f13:	29 d0                	sub    %edx,%eax
  802f15:	83 ec 04             	sub    $0x4,%esp
  802f18:	6a 01                	push   $0x1
  802f1a:	50                   	push   %eax
  802f1b:	ff 75 bc             	pushl  -0x44(%ebp)
  802f1e:	e8 51 f5 ff ff       	call   802474 <set_block_data>
  802f23:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802f26:	83 ec 0c             	sub    $0xc,%esp
  802f29:	ff 75 bc             	pushl  -0x44(%ebp)
  802f2c:	e8 36 04 00 00       	call   803367 <free_block>
  802f31:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802f34:	83 ec 0c             	sub    $0xc,%esp
  802f37:	ff 75 08             	pushl  0x8(%ebp)
  802f3a:	e8 20 fa ff ff       	call   80295f <alloc_block_BF>
  802f3f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f42:	c9                   	leave  
  802f43:	c3                   	ret    

00802f44 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f44:	55                   	push   %ebp
  802f45:	89 e5                	mov    %esp,%ebp
  802f47:	53                   	push   %ebx
  802f48:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f52:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5d:	74 1e                	je     802f7d <merging+0x39>
  802f5f:	ff 75 08             	pushl  0x8(%ebp)
  802f62:	e8 bc f1 ff ff       	call   802123 <get_block_size>
  802f67:	83 c4 04             	add    $0x4,%esp
  802f6a:	89 c2                	mov    %eax,%edx
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	01 d0                	add    %edx,%eax
  802f71:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f74:	75 07                	jne    802f7d <merging+0x39>
		prev_is_free = 1;
  802f76:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f81:	74 1e                	je     802fa1 <merging+0x5d>
  802f83:	ff 75 10             	pushl  0x10(%ebp)
  802f86:	e8 98 f1 ff ff       	call   802123 <get_block_size>
  802f8b:	83 c4 04             	add    $0x4,%esp
  802f8e:	89 c2                	mov    %eax,%edx
  802f90:	8b 45 10             	mov    0x10(%ebp),%eax
  802f93:	01 d0                	add    %edx,%eax
  802f95:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f98:	75 07                	jne    802fa1 <merging+0x5d>
		next_is_free = 1;
  802f9a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802fa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa5:	0f 84 cc 00 00 00    	je     803077 <merging+0x133>
  802fab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802faf:	0f 84 c2 00 00 00    	je     803077 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802fb5:	ff 75 08             	pushl  0x8(%ebp)
  802fb8:	e8 66 f1 ff ff       	call   802123 <get_block_size>
  802fbd:	83 c4 04             	add    $0x4,%esp
  802fc0:	89 c3                	mov    %eax,%ebx
  802fc2:	ff 75 10             	pushl  0x10(%ebp)
  802fc5:	e8 59 f1 ff ff       	call   802123 <get_block_size>
  802fca:	83 c4 04             	add    $0x4,%esp
  802fcd:	01 c3                	add    %eax,%ebx
  802fcf:	ff 75 0c             	pushl  0xc(%ebp)
  802fd2:	e8 4c f1 ff ff       	call   802123 <get_block_size>
  802fd7:	83 c4 04             	add    $0x4,%esp
  802fda:	01 d8                	add    %ebx,%eax
  802fdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fdf:	6a 00                	push   $0x0
  802fe1:	ff 75 ec             	pushl  -0x14(%ebp)
  802fe4:	ff 75 08             	pushl  0x8(%ebp)
  802fe7:	e8 88 f4 ff ff       	call   802474 <set_block_data>
  802fec:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ff3:	75 17                	jne    80300c <merging+0xc8>
  802ff5:	83 ec 04             	sub    $0x4,%esp
  802ff8:	68 3f 46 80 00       	push   $0x80463f
  802ffd:	68 7d 01 00 00       	push   $0x17d
  803002:	68 5d 46 80 00       	push   $0x80465d
  803007:	e8 b0 0b 00 00       	call   803bbc <_panic>
  80300c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	85 c0                	test   %eax,%eax
  803013:	74 10                	je     803025 <merging+0xe1>
  803015:	8b 45 0c             	mov    0xc(%ebp),%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80301d:	8b 52 04             	mov    0x4(%edx),%edx
  803020:	89 50 04             	mov    %edx,0x4(%eax)
  803023:	eb 0b                	jmp    803030 <merging+0xec>
  803025:	8b 45 0c             	mov    0xc(%ebp),%eax
  803028:	8b 40 04             	mov    0x4(%eax),%eax
  80302b:	a3 34 50 80 00       	mov    %eax,0x805034
  803030:	8b 45 0c             	mov    0xc(%ebp),%eax
  803033:	8b 40 04             	mov    0x4(%eax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	74 0f                	je     803049 <merging+0x105>
  80303a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303d:	8b 40 04             	mov    0x4(%eax),%eax
  803040:	8b 55 0c             	mov    0xc(%ebp),%edx
  803043:	8b 12                	mov    (%edx),%edx
  803045:	89 10                	mov    %edx,(%eax)
  803047:	eb 0a                	jmp    803053 <merging+0x10f>
  803049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	a3 30 50 80 00       	mov    %eax,0x805030
  803053:	8b 45 0c             	mov    0xc(%ebp),%eax
  803056:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803066:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80306b:	48                   	dec    %eax
  80306c:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803071:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803072:	e9 ea 02 00 00       	jmp    803361 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803077:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307b:	74 3b                	je     8030b8 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80307d:	83 ec 0c             	sub    $0xc,%esp
  803080:	ff 75 08             	pushl  0x8(%ebp)
  803083:	e8 9b f0 ff ff       	call   802123 <get_block_size>
  803088:	83 c4 10             	add    $0x10,%esp
  80308b:	89 c3                	mov    %eax,%ebx
  80308d:	83 ec 0c             	sub    $0xc,%esp
  803090:	ff 75 10             	pushl  0x10(%ebp)
  803093:	e8 8b f0 ff ff       	call   802123 <get_block_size>
  803098:	83 c4 10             	add    $0x10,%esp
  80309b:	01 d8                	add    %ebx,%eax
  80309d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8030a0:	83 ec 04             	sub    $0x4,%esp
  8030a3:	6a 00                	push   $0x0
  8030a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8030a8:	ff 75 08             	pushl  0x8(%ebp)
  8030ab:	e8 c4 f3 ff ff       	call   802474 <set_block_data>
  8030b0:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030b3:	e9 a9 02 00 00       	jmp    803361 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8030b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030bc:	0f 84 2d 01 00 00    	je     8031ef <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8030c2:	83 ec 0c             	sub    $0xc,%esp
  8030c5:	ff 75 10             	pushl  0x10(%ebp)
  8030c8:	e8 56 f0 ff ff       	call   802123 <get_block_size>
  8030cd:	83 c4 10             	add    $0x10,%esp
  8030d0:	89 c3                	mov    %eax,%ebx
  8030d2:	83 ec 0c             	sub    $0xc,%esp
  8030d5:	ff 75 0c             	pushl  0xc(%ebp)
  8030d8:	e8 46 f0 ff ff       	call   802123 <get_block_size>
  8030dd:	83 c4 10             	add    $0x10,%esp
  8030e0:	01 d8                	add    %ebx,%eax
  8030e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8030e5:	83 ec 04             	sub    $0x4,%esp
  8030e8:	6a 00                	push   $0x0
  8030ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030ed:	ff 75 10             	pushl  0x10(%ebp)
  8030f0:	e8 7f f3 ff ff       	call   802474 <set_block_data>
  8030f5:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8030fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803102:	74 06                	je     80310a <merging+0x1c6>
  803104:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803108:	75 17                	jne    803121 <merging+0x1dd>
  80310a:	83 ec 04             	sub    $0x4,%esp
  80310d:	68 18 47 80 00       	push   $0x804718
  803112:	68 8d 01 00 00       	push   $0x18d
  803117:	68 5d 46 80 00       	push   $0x80465d
  80311c:	e8 9b 0a 00 00       	call   803bbc <_panic>
  803121:	8b 45 0c             	mov    0xc(%ebp),%eax
  803124:	8b 50 04             	mov    0x4(%eax),%edx
  803127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80312a:	89 50 04             	mov    %edx,0x4(%eax)
  80312d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803130:	8b 55 0c             	mov    0xc(%ebp),%edx
  803133:	89 10                	mov    %edx,(%eax)
  803135:	8b 45 0c             	mov    0xc(%ebp),%eax
  803138:	8b 40 04             	mov    0x4(%eax),%eax
  80313b:	85 c0                	test   %eax,%eax
  80313d:	74 0d                	je     80314c <merging+0x208>
  80313f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803142:	8b 40 04             	mov    0x4(%eax),%eax
  803145:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803148:	89 10                	mov    %edx,(%eax)
  80314a:	eb 08                	jmp    803154 <merging+0x210>
  80314c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80314f:	a3 30 50 80 00       	mov    %eax,0x805030
  803154:	8b 45 0c             	mov    0xc(%ebp),%eax
  803157:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80315a:	89 50 04             	mov    %edx,0x4(%eax)
  80315d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803162:	40                   	inc    %eax
  803163:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803168:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80316c:	75 17                	jne    803185 <merging+0x241>
  80316e:	83 ec 04             	sub    $0x4,%esp
  803171:	68 3f 46 80 00       	push   $0x80463f
  803176:	68 8e 01 00 00       	push   $0x18e
  80317b:	68 5d 46 80 00       	push   $0x80465d
  803180:	e8 37 0a 00 00       	call   803bbc <_panic>
  803185:	8b 45 0c             	mov    0xc(%ebp),%eax
  803188:	8b 00                	mov    (%eax),%eax
  80318a:	85 c0                	test   %eax,%eax
  80318c:	74 10                	je     80319e <merging+0x25a>
  80318e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803191:	8b 00                	mov    (%eax),%eax
  803193:	8b 55 0c             	mov    0xc(%ebp),%edx
  803196:	8b 52 04             	mov    0x4(%edx),%edx
  803199:	89 50 04             	mov    %edx,0x4(%eax)
  80319c:	eb 0b                	jmp    8031a9 <merging+0x265>
  80319e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a1:	8b 40 04             	mov    0x4(%eax),%eax
  8031a4:	a3 34 50 80 00       	mov    %eax,0x805034
  8031a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ac:	8b 40 04             	mov    0x4(%eax),%eax
  8031af:	85 c0                	test   %eax,%eax
  8031b1:	74 0f                	je     8031c2 <merging+0x27e>
  8031b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b6:	8b 40 04             	mov    0x4(%eax),%eax
  8031b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031bc:	8b 12                	mov    (%edx),%edx
  8031be:	89 10                	mov    %edx,(%eax)
  8031c0:	eb 0a                	jmp    8031cc <merging+0x288>
  8031c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8031cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031df:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031e4:	48                   	dec    %eax
  8031e5:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031ea:	e9 72 01 00 00       	jmp    803361 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8031f2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f9:	74 79                	je     803274 <merging+0x330>
  8031fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031ff:	74 73                	je     803274 <merging+0x330>
  803201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803205:	74 06                	je     80320d <merging+0x2c9>
  803207:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80320b:	75 17                	jne    803224 <merging+0x2e0>
  80320d:	83 ec 04             	sub    $0x4,%esp
  803210:	68 d0 46 80 00       	push   $0x8046d0
  803215:	68 94 01 00 00       	push   $0x194
  80321a:	68 5d 46 80 00       	push   $0x80465d
  80321f:	e8 98 09 00 00       	call   803bbc <_panic>
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	8b 10                	mov    (%eax),%edx
  803229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80322c:	89 10                	mov    %edx,(%eax)
  80322e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803231:	8b 00                	mov    (%eax),%eax
  803233:	85 c0                	test   %eax,%eax
  803235:	74 0b                	je     803242 <merging+0x2fe>
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	8b 00                	mov    (%eax),%eax
  80323c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80323f:	89 50 04             	mov    %edx,0x4(%eax)
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803248:	89 10                	mov    %edx,(%eax)
  80324a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80324d:	8b 55 08             	mov    0x8(%ebp),%edx
  803250:	89 50 04             	mov    %edx,0x4(%eax)
  803253:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803256:	8b 00                	mov    (%eax),%eax
  803258:	85 c0                	test   %eax,%eax
  80325a:	75 08                	jne    803264 <merging+0x320>
  80325c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325f:	a3 34 50 80 00       	mov    %eax,0x805034
  803264:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803269:	40                   	inc    %eax
  80326a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80326f:	e9 ce 00 00 00       	jmp    803342 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803274:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803278:	74 65                	je     8032df <merging+0x39b>
  80327a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80327e:	75 17                	jne    803297 <merging+0x353>
  803280:	83 ec 04             	sub    $0x4,%esp
  803283:	68 ac 46 80 00       	push   $0x8046ac
  803288:	68 95 01 00 00       	push   $0x195
  80328d:	68 5d 46 80 00       	push   $0x80465d
  803292:	e8 25 09 00 00       	call   803bbc <_panic>
  803297:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80329d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a0:	89 50 04             	mov    %edx,0x4(%eax)
  8032a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a6:	8b 40 04             	mov    0x4(%eax),%eax
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	74 0c                	je     8032b9 <merging+0x375>
  8032ad:	a1 34 50 80 00       	mov    0x805034,%eax
  8032b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032b5:	89 10                	mov    %edx,(%eax)
  8032b7:	eb 08                	jmp    8032c1 <merging+0x37d>
  8032b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8032c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c4:	a3 34 50 80 00       	mov    %eax,0x805034
  8032c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032d7:	40                   	inc    %eax
  8032d8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8032dd:	eb 63                	jmp    803342 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8032df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032e3:	75 17                	jne    8032fc <merging+0x3b8>
  8032e5:	83 ec 04             	sub    $0x4,%esp
  8032e8:	68 78 46 80 00       	push   $0x804678
  8032ed:	68 98 01 00 00       	push   $0x198
  8032f2:	68 5d 46 80 00       	push   $0x80465d
  8032f7:	e8 c0 08 00 00       	call   803bbc <_panic>
  8032fc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803302:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803305:	89 10                	mov    %edx,(%eax)
  803307:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	74 0d                	je     80331d <merging+0x3d9>
  803310:	a1 30 50 80 00       	mov    0x805030,%eax
  803315:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803318:	89 50 04             	mov    %edx,0x4(%eax)
  80331b:	eb 08                	jmp    803325 <merging+0x3e1>
  80331d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803320:	a3 34 50 80 00       	mov    %eax,0x805034
  803325:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803328:	a3 30 50 80 00       	mov    %eax,0x805030
  80332d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803330:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803337:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80333c:	40                   	inc    %eax
  80333d:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803342:	83 ec 0c             	sub    $0xc,%esp
  803345:	ff 75 10             	pushl  0x10(%ebp)
  803348:	e8 d6 ed ff ff       	call   802123 <get_block_size>
  80334d:	83 c4 10             	add    $0x10,%esp
  803350:	83 ec 04             	sub    $0x4,%esp
  803353:	6a 00                	push   $0x0
  803355:	50                   	push   %eax
  803356:	ff 75 10             	pushl  0x10(%ebp)
  803359:	e8 16 f1 ff ff       	call   802474 <set_block_data>
  80335e:	83 c4 10             	add    $0x10,%esp
	}
}
  803361:	90                   	nop
  803362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803365:	c9                   	leave  
  803366:	c3                   	ret    

00803367 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803367:	55                   	push   %ebp
  803368:	89 e5                	mov    %esp,%ebp
  80336a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80336d:	a1 30 50 80 00       	mov    0x805030,%eax
  803372:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803375:	a1 34 50 80 00       	mov    0x805034,%eax
  80337a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80337d:	73 1b                	jae    80339a <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80337f:	a1 34 50 80 00       	mov    0x805034,%eax
  803384:	83 ec 04             	sub    $0x4,%esp
  803387:	ff 75 08             	pushl  0x8(%ebp)
  80338a:	6a 00                	push   $0x0
  80338c:	50                   	push   %eax
  80338d:	e8 b2 fb ff ff       	call   802f44 <merging>
  803392:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803395:	e9 8b 00 00 00       	jmp    803425 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80339a:	a1 30 50 80 00       	mov    0x805030,%eax
  80339f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033a2:	76 18                	jbe    8033bc <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8033a4:	a1 30 50 80 00       	mov    0x805030,%eax
  8033a9:	83 ec 04             	sub    $0x4,%esp
  8033ac:	ff 75 08             	pushl  0x8(%ebp)
  8033af:	50                   	push   %eax
  8033b0:	6a 00                	push   $0x0
  8033b2:	e8 8d fb ff ff       	call   802f44 <merging>
  8033b7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033ba:	eb 69                	jmp    803425 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033bc:	a1 30 50 80 00       	mov    0x805030,%eax
  8033c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c4:	eb 39                	jmp    8033ff <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033cc:	73 29                	jae    8033f7 <free_block+0x90>
  8033ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d1:	8b 00                	mov    (%eax),%eax
  8033d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033d6:	76 1f                	jbe    8033f7 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8033e0:	83 ec 04             	sub    $0x4,%esp
  8033e3:	ff 75 08             	pushl  0x8(%ebp)
  8033e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8033e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8033ec:	e8 53 fb ff ff       	call   802f44 <merging>
  8033f1:	83 c4 10             	add    $0x10,%esp
			break;
  8033f4:	90                   	nop
		}
	}
}
  8033f5:	eb 2e                	jmp    803425 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8033fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803403:	74 07                	je     80340c <free_block+0xa5>
  803405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803408:	8b 00                	mov    (%eax),%eax
  80340a:	eb 05                	jmp    803411 <free_block+0xaa>
  80340c:	b8 00 00 00 00       	mov    $0x0,%eax
  803411:	a3 38 50 80 00       	mov    %eax,0x805038
  803416:	a1 38 50 80 00       	mov    0x805038,%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	75 a7                	jne    8033c6 <free_block+0x5f>
  80341f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803423:	75 a1                	jne    8033c6 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803425:	90                   	nop
  803426:	c9                   	leave  
  803427:	c3                   	ret    

00803428 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803428:	55                   	push   %ebp
  803429:	89 e5                	mov    %esp,%ebp
  80342b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80342e:	ff 75 08             	pushl  0x8(%ebp)
  803431:	e8 ed ec ff ff       	call   802123 <get_block_size>
  803436:	83 c4 04             	add    $0x4,%esp
  803439:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80343c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803443:	eb 17                	jmp    80345c <copy_data+0x34>
  803445:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344b:	01 c2                	add    %eax,%edx
  80344d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	01 c8                	add    %ecx,%eax
  803455:	8a 00                	mov    (%eax),%al
  803457:	88 02                	mov    %al,(%edx)
  803459:	ff 45 fc             	incl   -0x4(%ebp)
  80345c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80345f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803462:	72 e1                	jb     803445 <copy_data+0x1d>
}
  803464:	90                   	nop
  803465:	c9                   	leave  
  803466:	c3                   	ret    

00803467 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803467:	55                   	push   %ebp
  803468:	89 e5                	mov    %esp,%ebp
  80346a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80346d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803471:	75 23                	jne    803496 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803473:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803477:	74 13                	je     80348c <realloc_block_FF+0x25>
  803479:	83 ec 0c             	sub    $0xc,%esp
  80347c:	ff 75 0c             	pushl  0xc(%ebp)
  80347f:	e8 1f f0 ff ff       	call   8024a3 <alloc_block_FF>
  803484:	83 c4 10             	add    $0x10,%esp
  803487:	e9 f4 06 00 00       	jmp    803b80 <realloc_block_FF+0x719>
		return NULL;
  80348c:	b8 00 00 00 00       	mov    $0x0,%eax
  803491:	e9 ea 06 00 00       	jmp    803b80 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803496:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80349a:	75 18                	jne    8034b4 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80349c:	83 ec 0c             	sub    $0xc,%esp
  80349f:	ff 75 08             	pushl  0x8(%ebp)
  8034a2:	e8 c0 fe ff ff       	call   803367 <free_block>
  8034a7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8034aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8034af:	e9 cc 06 00 00       	jmp    803b80 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8034b4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8034b8:	77 07                	ja     8034c1 <realloc_block_FF+0x5a>
  8034ba:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8034c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c4:	83 e0 01             	and    $0x1,%eax
  8034c7:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8034ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034cd:	83 c0 08             	add    $0x8,%eax
  8034d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8034d3:	83 ec 0c             	sub    $0xc,%esp
  8034d6:	ff 75 08             	pushl  0x8(%ebp)
  8034d9:	e8 45 ec ff ff       	call   802123 <get_block_size>
  8034de:	83 c4 10             	add    $0x10,%esp
  8034e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e7:	83 e8 08             	sub    $0x8,%eax
  8034ea:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	83 e8 04             	sub    $0x4,%eax
  8034f3:	8b 00                	mov    (%eax),%eax
  8034f5:	83 e0 fe             	and    $0xfffffffe,%eax
  8034f8:	89 c2                	mov    %eax,%edx
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	01 d0                	add    %edx,%eax
  8034ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803502:	83 ec 0c             	sub    $0xc,%esp
  803505:	ff 75 e4             	pushl  -0x1c(%ebp)
  803508:	e8 16 ec ff ff       	call   802123 <get_block_size>
  80350d:	83 c4 10             	add    $0x10,%esp
  803510:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803513:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803516:	83 e8 08             	sub    $0x8,%eax
  803519:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80351c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803522:	75 08                	jne    80352c <realloc_block_FF+0xc5>
	{
		 return va;
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	e9 54 06 00 00       	jmp    803b80 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80352c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803532:	0f 83 e5 03 00 00    	jae    80391d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803538:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80353e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803541:	83 ec 0c             	sub    $0xc,%esp
  803544:	ff 75 e4             	pushl  -0x1c(%ebp)
  803547:	e8 f0 eb ff ff       	call   80213c <is_free_block>
  80354c:	83 c4 10             	add    $0x10,%esp
  80354f:	84 c0                	test   %al,%al
  803551:	0f 84 3b 01 00 00    	je     803692 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803557:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80355a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80355d:	01 d0                	add    %edx,%eax
  80355f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803562:	83 ec 04             	sub    $0x4,%esp
  803565:	6a 01                	push   $0x1
  803567:	ff 75 f0             	pushl  -0x10(%ebp)
  80356a:	ff 75 08             	pushl  0x8(%ebp)
  80356d:	e8 02 ef ff ff       	call   802474 <set_block_data>
  803572:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803575:	8b 45 08             	mov    0x8(%ebp),%eax
  803578:	83 e8 04             	sub    $0x4,%eax
  80357b:	8b 00                	mov    (%eax),%eax
  80357d:	83 e0 fe             	and    $0xfffffffe,%eax
  803580:	89 c2                	mov    %eax,%edx
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	01 d0                	add    %edx,%eax
  803587:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80358a:	83 ec 04             	sub    $0x4,%esp
  80358d:	6a 00                	push   $0x0
  80358f:	ff 75 cc             	pushl  -0x34(%ebp)
  803592:	ff 75 c8             	pushl  -0x38(%ebp)
  803595:	e8 da ee ff ff       	call   802474 <set_block_data>
  80359a:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80359d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a1:	74 06                	je     8035a9 <realloc_block_FF+0x142>
  8035a3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8035a7:	75 17                	jne    8035c0 <realloc_block_FF+0x159>
  8035a9:	83 ec 04             	sub    $0x4,%esp
  8035ac:	68 d0 46 80 00       	push   $0x8046d0
  8035b1:	68 f6 01 00 00       	push   $0x1f6
  8035b6:	68 5d 46 80 00       	push   $0x80465d
  8035bb:	e8 fc 05 00 00       	call   803bbc <_panic>
  8035c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c3:	8b 10                	mov    (%eax),%edx
  8035c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035c8:	89 10                	mov    %edx,(%eax)
  8035ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035cd:	8b 00                	mov    (%eax),%eax
  8035cf:	85 c0                	test   %eax,%eax
  8035d1:	74 0b                	je     8035de <realloc_block_FF+0x177>
  8035d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035db:	89 50 04             	mov    %edx,0x4(%eax)
  8035de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035e4:	89 10                	mov    %edx,(%eax)
  8035e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ec:	89 50 04             	mov    %edx,0x4(%eax)
  8035ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035f2:	8b 00                	mov    (%eax),%eax
  8035f4:	85 c0                	test   %eax,%eax
  8035f6:	75 08                	jne    803600 <realloc_block_FF+0x199>
  8035f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035fb:	a3 34 50 80 00       	mov    %eax,0x805034
  803600:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803605:	40                   	inc    %eax
  803606:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80360b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80360f:	75 17                	jne    803628 <realloc_block_FF+0x1c1>
  803611:	83 ec 04             	sub    $0x4,%esp
  803614:	68 3f 46 80 00       	push   $0x80463f
  803619:	68 f7 01 00 00       	push   $0x1f7
  80361e:	68 5d 46 80 00       	push   $0x80465d
  803623:	e8 94 05 00 00       	call   803bbc <_panic>
  803628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	85 c0                	test   %eax,%eax
  80362f:	74 10                	je     803641 <realloc_block_FF+0x1da>
  803631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803634:	8b 00                	mov    (%eax),%eax
  803636:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803639:	8b 52 04             	mov    0x4(%edx),%edx
  80363c:	89 50 04             	mov    %edx,0x4(%eax)
  80363f:	eb 0b                	jmp    80364c <realloc_block_FF+0x1e5>
  803641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803644:	8b 40 04             	mov    0x4(%eax),%eax
  803647:	a3 34 50 80 00       	mov    %eax,0x805034
  80364c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364f:	8b 40 04             	mov    0x4(%eax),%eax
  803652:	85 c0                	test   %eax,%eax
  803654:	74 0f                	je     803665 <realloc_block_FF+0x1fe>
  803656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803659:	8b 40 04             	mov    0x4(%eax),%eax
  80365c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80365f:	8b 12                	mov    (%edx),%edx
  803661:	89 10                	mov    %edx,(%eax)
  803663:	eb 0a                	jmp    80366f <realloc_block_FF+0x208>
  803665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	a3 30 50 80 00       	mov    %eax,0x805030
  80366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803672:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803682:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803687:	48                   	dec    %eax
  803688:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80368d:	e9 83 02 00 00       	jmp    803915 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803692:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803696:	0f 86 69 02 00 00    	jbe    803905 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80369c:	83 ec 04             	sub    $0x4,%esp
  80369f:	6a 01                	push   $0x1
  8036a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8036a4:	ff 75 08             	pushl  0x8(%ebp)
  8036a7:	e8 c8 ed ff ff       	call   802474 <set_block_data>
  8036ac:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	83 e8 04             	sub    $0x4,%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	83 e0 fe             	and    $0xfffffffe,%eax
  8036ba:	89 c2                	mov    %eax,%edx
  8036bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bf:	01 d0                	add    %edx,%eax
  8036c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8036c4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8036cc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8036d0:	75 68                	jne    80373a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036d2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036d6:	75 17                	jne    8036ef <realloc_block_FF+0x288>
  8036d8:	83 ec 04             	sub    $0x4,%esp
  8036db:	68 78 46 80 00       	push   $0x804678
  8036e0:	68 06 02 00 00       	push   $0x206
  8036e5:	68 5d 46 80 00       	push   $0x80465d
  8036ea:	e8 cd 04 00 00       	call   803bbc <_panic>
  8036ef:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f8:	89 10                	mov    %edx,(%eax)
  8036fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fd:	8b 00                	mov    (%eax),%eax
  8036ff:	85 c0                	test   %eax,%eax
  803701:	74 0d                	je     803710 <realloc_block_FF+0x2a9>
  803703:	a1 30 50 80 00       	mov    0x805030,%eax
  803708:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80370b:	89 50 04             	mov    %edx,0x4(%eax)
  80370e:	eb 08                	jmp    803718 <realloc_block_FF+0x2b1>
  803710:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803713:	a3 34 50 80 00       	mov    %eax,0x805034
  803718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371b:	a3 30 50 80 00       	mov    %eax,0x805030
  803720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803723:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80372f:	40                   	inc    %eax
  803730:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803735:	e9 b0 01 00 00       	jmp    8038ea <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80373a:	a1 30 50 80 00       	mov    0x805030,%eax
  80373f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803742:	76 68                	jbe    8037ac <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803744:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803748:	75 17                	jne    803761 <realloc_block_FF+0x2fa>
  80374a:	83 ec 04             	sub    $0x4,%esp
  80374d:	68 78 46 80 00       	push   $0x804678
  803752:	68 0b 02 00 00       	push   $0x20b
  803757:	68 5d 46 80 00       	push   $0x80465d
  80375c:	e8 5b 04 00 00       	call   803bbc <_panic>
  803761:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376a:	89 10                	mov    %edx,(%eax)
  80376c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376f:	8b 00                	mov    (%eax),%eax
  803771:	85 c0                	test   %eax,%eax
  803773:	74 0d                	je     803782 <realloc_block_FF+0x31b>
  803775:	a1 30 50 80 00       	mov    0x805030,%eax
  80377a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80377d:	89 50 04             	mov    %edx,0x4(%eax)
  803780:	eb 08                	jmp    80378a <realloc_block_FF+0x323>
  803782:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803785:	a3 34 50 80 00       	mov    %eax,0x805034
  80378a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80378d:	a3 30 50 80 00       	mov    %eax,0x805030
  803792:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803795:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80379c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037a1:	40                   	inc    %eax
  8037a2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8037a7:	e9 3e 01 00 00       	jmp    8038ea <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8037ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8037b1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037b4:	73 68                	jae    80381e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8037b6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037ba:	75 17                	jne    8037d3 <realloc_block_FF+0x36c>
  8037bc:	83 ec 04             	sub    $0x4,%esp
  8037bf:	68 ac 46 80 00       	push   $0x8046ac
  8037c4:	68 10 02 00 00       	push   $0x210
  8037c9:	68 5d 46 80 00       	push   $0x80465d
  8037ce:	e8 e9 03 00 00       	call   803bbc <_panic>
  8037d3:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8037d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037dc:	89 50 04             	mov    %edx,0x4(%eax)
  8037df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e2:	8b 40 04             	mov    0x4(%eax),%eax
  8037e5:	85 c0                	test   %eax,%eax
  8037e7:	74 0c                	je     8037f5 <realloc_block_FF+0x38e>
  8037e9:	a1 34 50 80 00       	mov    0x805034,%eax
  8037ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037f1:	89 10                	mov    %edx,(%eax)
  8037f3:	eb 08                	jmp    8037fd <realloc_block_FF+0x396>
  8037f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8037fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803800:	a3 34 50 80 00       	mov    %eax,0x805034
  803805:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803808:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80380e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803813:	40                   	inc    %eax
  803814:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803819:	e9 cc 00 00 00       	jmp    8038ea <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80381e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803825:	a1 30 50 80 00       	mov    0x805030,%eax
  80382a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80382d:	e9 8a 00 00 00       	jmp    8038bc <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803835:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803838:	73 7a                	jae    8038b4 <realloc_block_FF+0x44d>
  80383a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383d:	8b 00                	mov    (%eax),%eax
  80383f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803842:	73 70                	jae    8038b4 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803848:	74 06                	je     803850 <realloc_block_FF+0x3e9>
  80384a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80384e:	75 17                	jne    803867 <realloc_block_FF+0x400>
  803850:	83 ec 04             	sub    $0x4,%esp
  803853:	68 d0 46 80 00       	push   $0x8046d0
  803858:	68 1a 02 00 00       	push   $0x21a
  80385d:	68 5d 46 80 00       	push   $0x80465d
  803862:	e8 55 03 00 00       	call   803bbc <_panic>
  803867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386a:	8b 10                	mov    (%eax),%edx
  80386c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80386f:	89 10                	mov    %edx,(%eax)
  803871:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	85 c0                	test   %eax,%eax
  803878:	74 0b                	je     803885 <realloc_block_FF+0x41e>
  80387a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387d:	8b 00                	mov    (%eax),%eax
  80387f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803882:	89 50 04             	mov    %edx,0x4(%eax)
  803885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803888:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80388b:	89 10                	mov    %edx,(%eax)
  80388d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803890:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803893:	89 50 04             	mov    %edx,0x4(%eax)
  803896:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803899:	8b 00                	mov    (%eax),%eax
  80389b:	85 c0                	test   %eax,%eax
  80389d:	75 08                	jne    8038a7 <realloc_block_FF+0x440>
  80389f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a2:	a3 34 50 80 00       	mov    %eax,0x805034
  8038a7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038ac:	40                   	inc    %eax
  8038ad:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  8038b2:	eb 36                	jmp    8038ea <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8038b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8038b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c0:	74 07                	je     8038c9 <realloc_block_FF+0x462>
  8038c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c5:	8b 00                	mov    (%eax),%eax
  8038c7:	eb 05                	jmp    8038ce <realloc_block_FF+0x467>
  8038c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ce:	a3 38 50 80 00       	mov    %eax,0x805038
  8038d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8038d8:	85 c0                	test   %eax,%eax
  8038da:	0f 85 52 ff ff ff    	jne    803832 <realloc_block_FF+0x3cb>
  8038e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038e4:	0f 85 48 ff ff ff    	jne    803832 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038ea:	83 ec 04             	sub    $0x4,%esp
  8038ed:	6a 00                	push   $0x0
  8038ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8038f2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038f5:	e8 7a eb ff ff       	call   802474 <set_block_data>
  8038fa:	83 c4 10             	add    $0x10,%esp
				return va;
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	e9 7b 02 00 00       	jmp    803b80 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803905:	83 ec 0c             	sub    $0xc,%esp
  803908:	68 4d 47 80 00       	push   $0x80474d
  80390d:	e8 2e ce ff ff       	call   800740 <cprintf>
  803912:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803915:	8b 45 08             	mov    0x8(%ebp),%eax
  803918:	e9 63 02 00 00       	jmp    803b80 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80391d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803920:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803923:	0f 86 4d 02 00 00    	jbe    803b76 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803929:	83 ec 0c             	sub    $0xc,%esp
  80392c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80392f:	e8 08 e8 ff ff       	call   80213c <is_free_block>
  803934:	83 c4 10             	add    $0x10,%esp
  803937:	84 c0                	test   %al,%al
  803939:	0f 84 37 02 00 00    	je     803b76 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80393f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803942:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803945:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803948:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80394b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80394e:	76 38                	jbe    803988 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803950:	83 ec 0c             	sub    $0xc,%esp
  803953:	ff 75 08             	pushl  0x8(%ebp)
  803956:	e8 0c fa ff ff       	call   803367 <free_block>
  80395b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80395e:	83 ec 0c             	sub    $0xc,%esp
  803961:	ff 75 0c             	pushl  0xc(%ebp)
  803964:	e8 3a eb ff ff       	call   8024a3 <alloc_block_FF>
  803969:	83 c4 10             	add    $0x10,%esp
  80396c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80396f:	83 ec 08             	sub    $0x8,%esp
  803972:	ff 75 c0             	pushl  -0x40(%ebp)
  803975:	ff 75 08             	pushl  0x8(%ebp)
  803978:	e8 ab fa ff ff       	call   803428 <copy_data>
  80397d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803980:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803983:	e9 f8 01 00 00       	jmp    803b80 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803988:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80398b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80398e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803991:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803995:	0f 87 a0 00 00 00    	ja     803a3b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80399b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80399f:	75 17                	jne    8039b8 <realloc_block_FF+0x551>
  8039a1:	83 ec 04             	sub    $0x4,%esp
  8039a4:	68 3f 46 80 00       	push   $0x80463f
  8039a9:	68 38 02 00 00       	push   $0x238
  8039ae:	68 5d 46 80 00       	push   $0x80465d
  8039b3:	e8 04 02 00 00       	call   803bbc <_panic>
  8039b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bb:	8b 00                	mov    (%eax),%eax
  8039bd:	85 c0                	test   %eax,%eax
  8039bf:	74 10                	je     8039d1 <realloc_block_FF+0x56a>
  8039c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c4:	8b 00                	mov    (%eax),%eax
  8039c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c9:	8b 52 04             	mov    0x4(%edx),%edx
  8039cc:	89 50 04             	mov    %edx,0x4(%eax)
  8039cf:	eb 0b                	jmp    8039dc <realloc_block_FF+0x575>
  8039d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d4:	8b 40 04             	mov    0x4(%eax),%eax
  8039d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8039dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039df:	8b 40 04             	mov    0x4(%eax),%eax
  8039e2:	85 c0                	test   %eax,%eax
  8039e4:	74 0f                	je     8039f5 <realloc_block_FF+0x58e>
  8039e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e9:	8b 40 04             	mov    0x4(%eax),%eax
  8039ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039ef:	8b 12                	mov    (%edx),%edx
  8039f1:	89 10                	mov    %edx,(%eax)
  8039f3:	eb 0a                	jmp    8039ff <realloc_block_FF+0x598>
  8039f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f8:	8b 00                	mov    (%eax),%eax
  8039fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8039ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a12:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a17:	48                   	dec    %eax
  803a18:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803a1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a23:	01 d0                	add    %edx,%eax
  803a25:	83 ec 04             	sub    $0x4,%esp
  803a28:	6a 01                	push   $0x1
  803a2a:	50                   	push   %eax
  803a2b:	ff 75 08             	pushl  0x8(%ebp)
  803a2e:	e8 41 ea ff ff       	call   802474 <set_block_data>
  803a33:	83 c4 10             	add    $0x10,%esp
  803a36:	e9 36 01 00 00       	jmp    803b71 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a3e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a41:	01 d0                	add    %edx,%eax
  803a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a46:	83 ec 04             	sub    $0x4,%esp
  803a49:	6a 01                	push   $0x1
  803a4b:	ff 75 f0             	pushl  -0x10(%ebp)
  803a4e:	ff 75 08             	pushl  0x8(%ebp)
  803a51:	e8 1e ea ff ff       	call   802474 <set_block_data>
  803a56:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a59:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5c:	83 e8 04             	sub    $0x4,%eax
  803a5f:	8b 00                	mov    (%eax),%eax
  803a61:	83 e0 fe             	and    $0xfffffffe,%eax
  803a64:	89 c2                	mov    %eax,%edx
  803a66:	8b 45 08             	mov    0x8(%ebp),%eax
  803a69:	01 d0                	add    %edx,%eax
  803a6b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a72:	74 06                	je     803a7a <realloc_block_FF+0x613>
  803a74:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a78:	75 17                	jne    803a91 <realloc_block_FF+0x62a>
  803a7a:	83 ec 04             	sub    $0x4,%esp
  803a7d:	68 d0 46 80 00       	push   $0x8046d0
  803a82:	68 44 02 00 00       	push   $0x244
  803a87:	68 5d 46 80 00       	push   $0x80465d
  803a8c:	e8 2b 01 00 00       	call   803bbc <_panic>
  803a91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a94:	8b 10                	mov    (%eax),%edx
  803a96:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a99:	89 10                	mov    %edx,(%eax)
  803a9b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a9e:	8b 00                	mov    (%eax),%eax
  803aa0:	85 c0                	test   %eax,%eax
  803aa2:	74 0b                	je     803aaf <realloc_block_FF+0x648>
  803aa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa7:	8b 00                	mov    (%eax),%eax
  803aa9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803aac:	89 50 04             	mov    %edx,0x4(%eax)
  803aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ab5:	89 10                	mov    %edx,(%eax)
  803ab7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803abd:	89 50 04             	mov    %edx,0x4(%eax)
  803ac0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ac3:	8b 00                	mov    (%eax),%eax
  803ac5:	85 c0                	test   %eax,%eax
  803ac7:	75 08                	jne    803ad1 <realloc_block_FF+0x66a>
  803ac9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803acc:	a3 34 50 80 00       	mov    %eax,0x805034
  803ad1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ad6:	40                   	inc    %eax
  803ad7:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803adc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ae0:	75 17                	jne    803af9 <realloc_block_FF+0x692>
  803ae2:	83 ec 04             	sub    $0x4,%esp
  803ae5:	68 3f 46 80 00       	push   $0x80463f
  803aea:	68 45 02 00 00       	push   $0x245
  803aef:	68 5d 46 80 00       	push   $0x80465d
  803af4:	e8 c3 00 00 00       	call   803bbc <_panic>
  803af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afc:	8b 00                	mov    (%eax),%eax
  803afe:	85 c0                	test   %eax,%eax
  803b00:	74 10                	je     803b12 <realloc_block_FF+0x6ab>
  803b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b05:	8b 00                	mov    (%eax),%eax
  803b07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b0a:	8b 52 04             	mov    0x4(%edx),%edx
  803b0d:	89 50 04             	mov    %edx,0x4(%eax)
  803b10:	eb 0b                	jmp    803b1d <realloc_block_FF+0x6b6>
  803b12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b15:	8b 40 04             	mov    0x4(%eax),%eax
  803b18:	a3 34 50 80 00       	mov    %eax,0x805034
  803b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b20:	8b 40 04             	mov    0x4(%eax),%eax
  803b23:	85 c0                	test   %eax,%eax
  803b25:	74 0f                	je     803b36 <realloc_block_FF+0x6cf>
  803b27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b2a:	8b 40 04             	mov    0x4(%eax),%eax
  803b2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b30:	8b 12                	mov    (%edx),%edx
  803b32:	89 10                	mov    %edx,(%eax)
  803b34:	eb 0a                	jmp    803b40 <realloc_block_FF+0x6d9>
  803b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b39:	8b 00                	mov    (%eax),%eax
  803b3b:	a3 30 50 80 00       	mov    %eax,0x805030
  803b40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b53:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b58:	48                   	dec    %eax
  803b59:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803b5e:	83 ec 04             	sub    $0x4,%esp
  803b61:	6a 00                	push   $0x0
  803b63:	ff 75 bc             	pushl  -0x44(%ebp)
  803b66:	ff 75 b8             	pushl  -0x48(%ebp)
  803b69:	e8 06 e9 ff ff       	call   802474 <set_block_data>
  803b6e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b71:	8b 45 08             	mov    0x8(%ebp),%eax
  803b74:	eb 0a                	jmp    803b80 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b76:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b80:	c9                   	leave  
  803b81:	c3                   	ret    

00803b82 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b82:	55                   	push   %ebp
  803b83:	89 e5                	mov    %esp,%ebp
  803b85:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b88:	83 ec 04             	sub    $0x4,%esp
  803b8b:	68 54 47 80 00       	push   $0x804754
  803b90:	68 58 02 00 00       	push   $0x258
  803b95:	68 5d 46 80 00       	push   $0x80465d
  803b9a:	e8 1d 00 00 00       	call   803bbc <_panic>

00803b9f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b9f:	55                   	push   %ebp
  803ba0:	89 e5                	mov    %esp,%ebp
  803ba2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803ba5:	83 ec 04             	sub    $0x4,%esp
  803ba8:	68 7c 47 80 00       	push   $0x80477c
  803bad:	68 61 02 00 00       	push   $0x261
  803bb2:	68 5d 46 80 00       	push   $0x80465d
  803bb7:	e8 00 00 00 00       	call   803bbc <_panic>

00803bbc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803bbc:	55                   	push   %ebp
  803bbd:	89 e5                	mov    %esp,%ebp
  803bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803bc2:	8d 45 10             	lea    0x10(%ebp),%eax
  803bc5:	83 c0 04             	add    $0x4,%eax
  803bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803bcb:	a1 60 90 18 01       	mov    0x1189060,%eax
  803bd0:	85 c0                	test   %eax,%eax
  803bd2:	74 16                	je     803bea <_panic+0x2e>
		cprintf("%s: ", argv0);
  803bd4:	a1 60 90 18 01       	mov    0x1189060,%eax
  803bd9:	83 ec 08             	sub    $0x8,%esp
  803bdc:	50                   	push   %eax
  803bdd:	68 a4 47 80 00       	push   $0x8047a4
  803be2:	e8 59 cb ff ff       	call   800740 <cprintf>
  803be7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803bea:	a1 00 50 80 00       	mov    0x805000,%eax
  803bef:	ff 75 0c             	pushl  0xc(%ebp)
  803bf2:	ff 75 08             	pushl  0x8(%ebp)
  803bf5:	50                   	push   %eax
  803bf6:	68 a9 47 80 00       	push   $0x8047a9
  803bfb:	e8 40 cb ff ff       	call   800740 <cprintf>
  803c00:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803c03:	8b 45 10             	mov    0x10(%ebp),%eax
  803c06:	83 ec 08             	sub    $0x8,%esp
  803c09:	ff 75 f4             	pushl  -0xc(%ebp)
  803c0c:	50                   	push   %eax
  803c0d:	e8 c3 ca ff ff       	call   8006d5 <vcprintf>
  803c12:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803c15:	83 ec 08             	sub    $0x8,%esp
  803c18:	6a 00                	push   $0x0
  803c1a:	68 c5 47 80 00       	push   $0x8047c5
  803c1f:	e8 b1 ca ff ff       	call   8006d5 <vcprintf>
  803c24:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803c27:	e8 32 ca ff ff       	call   80065e <exit>

	// should not return here
	while (1) ;
  803c2c:	eb fe                	jmp    803c2c <_panic+0x70>

00803c2e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803c2e:	55                   	push   %ebp
  803c2f:	89 e5                	mov    %esp,%ebp
  803c31:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803c34:	a1 20 50 80 00       	mov    0x805020,%eax
  803c39:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c42:	39 c2                	cmp    %eax,%edx
  803c44:	74 14                	je     803c5a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803c46:	83 ec 04             	sub    $0x4,%esp
  803c49:	68 c8 47 80 00       	push   $0x8047c8
  803c4e:	6a 26                	push   $0x26
  803c50:	68 14 48 80 00       	push   $0x804814
  803c55:	e8 62 ff ff ff       	call   803bbc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803c5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803c61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803c68:	e9 c5 00 00 00       	jmp    803d32 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803c77:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7a:	01 d0                	add    %edx,%eax
  803c7c:	8b 00                	mov    (%eax),%eax
  803c7e:	85 c0                	test   %eax,%eax
  803c80:	75 08                	jne    803c8a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803c82:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803c85:	e9 a5 00 00 00       	jmp    803d2f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803c8a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c91:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803c98:	eb 69                	jmp    803d03 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803c9a:	a1 20 50 80 00       	mov    0x805020,%eax
  803c9f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ca5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ca8:	89 d0                	mov    %edx,%eax
  803caa:	01 c0                	add    %eax,%eax
  803cac:	01 d0                	add    %edx,%eax
  803cae:	c1 e0 03             	shl    $0x3,%eax
  803cb1:	01 c8                	add    %ecx,%eax
  803cb3:	8a 40 04             	mov    0x4(%eax),%al
  803cb6:	84 c0                	test   %al,%al
  803cb8:	75 46                	jne    803d00 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803cba:	a1 20 50 80 00       	mov    0x805020,%eax
  803cbf:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803cc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cc8:	89 d0                	mov    %edx,%eax
  803cca:	01 c0                	add    %eax,%eax
  803ccc:	01 d0                	add    %edx,%eax
  803cce:	c1 e0 03             	shl    $0x3,%eax
  803cd1:	01 c8                	add    %ecx,%eax
  803cd3:	8b 00                	mov    (%eax),%eax
  803cd5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803cd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cdb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803ce0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ce5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803cec:	8b 45 08             	mov    0x8(%ebp),%eax
  803cef:	01 c8                	add    %ecx,%eax
  803cf1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803cf3:	39 c2                	cmp    %eax,%edx
  803cf5:	75 09                	jne    803d00 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803cf7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803cfe:	eb 15                	jmp    803d15 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d00:	ff 45 e8             	incl   -0x18(%ebp)
  803d03:	a1 20 50 80 00       	mov    0x805020,%eax
  803d08:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803d0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d11:	39 c2                	cmp    %eax,%edx
  803d13:	77 85                	ja     803c9a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803d15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d19:	75 14                	jne    803d2f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803d1b:	83 ec 04             	sub    $0x4,%esp
  803d1e:	68 20 48 80 00       	push   $0x804820
  803d23:	6a 3a                	push   $0x3a
  803d25:	68 14 48 80 00       	push   $0x804814
  803d2a:	e8 8d fe ff ff       	call   803bbc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803d2f:	ff 45 f0             	incl   -0x10(%ebp)
  803d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d35:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803d38:	0f 8c 2f ff ff ff    	jl     803c6d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803d3e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d45:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803d4c:	eb 26                	jmp    803d74 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803d4e:	a1 20 50 80 00       	mov    0x805020,%eax
  803d53:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803d59:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d5c:	89 d0                	mov    %edx,%eax
  803d5e:	01 c0                	add    %eax,%eax
  803d60:	01 d0                	add    %edx,%eax
  803d62:	c1 e0 03             	shl    $0x3,%eax
  803d65:	01 c8                	add    %ecx,%eax
  803d67:	8a 40 04             	mov    0x4(%eax),%al
  803d6a:	3c 01                	cmp    $0x1,%al
  803d6c:	75 03                	jne    803d71 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803d6e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d71:	ff 45 e0             	incl   -0x20(%ebp)
  803d74:	a1 20 50 80 00       	mov    0x805020,%eax
  803d79:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d82:	39 c2                	cmp    %eax,%edx
  803d84:	77 c8                	ja     803d4e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d89:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803d8c:	74 14                	je     803da2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803d8e:	83 ec 04             	sub    $0x4,%esp
  803d91:	68 74 48 80 00       	push   $0x804874
  803d96:	6a 44                	push   $0x44
  803d98:	68 14 48 80 00       	push   $0x804814
  803d9d:	e8 1a fe ff ff       	call   803bbc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803da2:	90                   	nop
  803da3:	c9                   	leave  
  803da4:	c3                   	ret    
  803da5:	66 90                	xchg   %ax,%ax
  803da7:	90                   	nop

00803da8 <__udivdi3>:
  803da8:	55                   	push   %ebp
  803da9:	57                   	push   %edi
  803daa:	56                   	push   %esi
  803dab:	53                   	push   %ebx
  803dac:	83 ec 1c             	sub    $0x1c,%esp
  803daf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803db3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803db7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dbb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803dbf:	89 ca                	mov    %ecx,%edx
  803dc1:	89 f8                	mov    %edi,%eax
  803dc3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803dc7:	85 f6                	test   %esi,%esi
  803dc9:	75 2d                	jne    803df8 <__udivdi3+0x50>
  803dcb:	39 cf                	cmp    %ecx,%edi
  803dcd:	77 65                	ja     803e34 <__udivdi3+0x8c>
  803dcf:	89 fd                	mov    %edi,%ebp
  803dd1:	85 ff                	test   %edi,%edi
  803dd3:	75 0b                	jne    803de0 <__udivdi3+0x38>
  803dd5:	b8 01 00 00 00       	mov    $0x1,%eax
  803dda:	31 d2                	xor    %edx,%edx
  803ddc:	f7 f7                	div    %edi
  803dde:	89 c5                	mov    %eax,%ebp
  803de0:	31 d2                	xor    %edx,%edx
  803de2:	89 c8                	mov    %ecx,%eax
  803de4:	f7 f5                	div    %ebp
  803de6:	89 c1                	mov    %eax,%ecx
  803de8:	89 d8                	mov    %ebx,%eax
  803dea:	f7 f5                	div    %ebp
  803dec:	89 cf                	mov    %ecx,%edi
  803dee:	89 fa                	mov    %edi,%edx
  803df0:	83 c4 1c             	add    $0x1c,%esp
  803df3:	5b                   	pop    %ebx
  803df4:	5e                   	pop    %esi
  803df5:	5f                   	pop    %edi
  803df6:	5d                   	pop    %ebp
  803df7:	c3                   	ret    
  803df8:	39 ce                	cmp    %ecx,%esi
  803dfa:	77 28                	ja     803e24 <__udivdi3+0x7c>
  803dfc:	0f bd fe             	bsr    %esi,%edi
  803dff:	83 f7 1f             	xor    $0x1f,%edi
  803e02:	75 40                	jne    803e44 <__udivdi3+0x9c>
  803e04:	39 ce                	cmp    %ecx,%esi
  803e06:	72 0a                	jb     803e12 <__udivdi3+0x6a>
  803e08:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e0c:	0f 87 9e 00 00 00    	ja     803eb0 <__udivdi3+0x108>
  803e12:	b8 01 00 00 00       	mov    $0x1,%eax
  803e17:	89 fa                	mov    %edi,%edx
  803e19:	83 c4 1c             	add    $0x1c,%esp
  803e1c:	5b                   	pop    %ebx
  803e1d:	5e                   	pop    %esi
  803e1e:	5f                   	pop    %edi
  803e1f:	5d                   	pop    %ebp
  803e20:	c3                   	ret    
  803e21:	8d 76 00             	lea    0x0(%esi),%esi
  803e24:	31 ff                	xor    %edi,%edi
  803e26:	31 c0                	xor    %eax,%eax
  803e28:	89 fa                	mov    %edi,%edx
  803e2a:	83 c4 1c             	add    $0x1c,%esp
  803e2d:	5b                   	pop    %ebx
  803e2e:	5e                   	pop    %esi
  803e2f:	5f                   	pop    %edi
  803e30:	5d                   	pop    %ebp
  803e31:	c3                   	ret    
  803e32:	66 90                	xchg   %ax,%ax
  803e34:	89 d8                	mov    %ebx,%eax
  803e36:	f7 f7                	div    %edi
  803e38:	31 ff                	xor    %edi,%edi
  803e3a:	89 fa                	mov    %edi,%edx
  803e3c:	83 c4 1c             	add    $0x1c,%esp
  803e3f:	5b                   	pop    %ebx
  803e40:	5e                   	pop    %esi
  803e41:	5f                   	pop    %edi
  803e42:	5d                   	pop    %ebp
  803e43:	c3                   	ret    
  803e44:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e49:	89 eb                	mov    %ebp,%ebx
  803e4b:	29 fb                	sub    %edi,%ebx
  803e4d:	89 f9                	mov    %edi,%ecx
  803e4f:	d3 e6                	shl    %cl,%esi
  803e51:	89 c5                	mov    %eax,%ebp
  803e53:	88 d9                	mov    %bl,%cl
  803e55:	d3 ed                	shr    %cl,%ebp
  803e57:	89 e9                	mov    %ebp,%ecx
  803e59:	09 f1                	or     %esi,%ecx
  803e5b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e5f:	89 f9                	mov    %edi,%ecx
  803e61:	d3 e0                	shl    %cl,%eax
  803e63:	89 c5                	mov    %eax,%ebp
  803e65:	89 d6                	mov    %edx,%esi
  803e67:	88 d9                	mov    %bl,%cl
  803e69:	d3 ee                	shr    %cl,%esi
  803e6b:	89 f9                	mov    %edi,%ecx
  803e6d:	d3 e2                	shl    %cl,%edx
  803e6f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e73:	88 d9                	mov    %bl,%cl
  803e75:	d3 e8                	shr    %cl,%eax
  803e77:	09 c2                	or     %eax,%edx
  803e79:	89 d0                	mov    %edx,%eax
  803e7b:	89 f2                	mov    %esi,%edx
  803e7d:	f7 74 24 0c          	divl   0xc(%esp)
  803e81:	89 d6                	mov    %edx,%esi
  803e83:	89 c3                	mov    %eax,%ebx
  803e85:	f7 e5                	mul    %ebp
  803e87:	39 d6                	cmp    %edx,%esi
  803e89:	72 19                	jb     803ea4 <__udivdi3+0xfc>
  803e8b:	74 0b                	je     803e98 <__udivdi3+0xf0>
  803e8d:	89 d8                	mov    %ebx,%eax
  803e8f:	31 ff                	xor    %edi,%edi
  803e91:	e9 58 ff ff ff       	jmp    803dee <__udivdi3+0x46>
  803e96:	66 90                	xchg   %ax,%ax
  803e98:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e9c:	89 f9                	mov    %edi,%ecx
  803e9e:	d3 e2                	shl    %cl,%edx
  803ea0:	39 c2                	cmp    %eax,%edx
  803ea2:	73 e9                	jae    803e8d <__udivdi3+0xe5>
  803ea4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ea7:	31 ff                	xor    %edi,%edi
  803ea9:	e9 40 ff ff ff       	jmp    803dee <__udivdi3+0x46>
  803eae:	66 90                	xchg   %ax,%ax
  803eb0:	31 c0                	xor    %eax,%eax
  803eb2:	e9 37 ff ff ff       	jmp    803dee <__udivdi3+0x46>
  803eb7:	90                   	nop

00803eb8 <__umoddi3>:
  803eb8:	55                   	push   %ebp
  803eb9:	57                   	push   %edi
  803eba:	56                   	push   %esi
  803ebb:	53                   	push   %ebx
  803ebc:	83 ec 1c             	sub    $0x1c,%esp
  803ebf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ec3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ec7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ecb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ecf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ed3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ed7:	89 f3                	mov    %esi,%ebx
  803ed9:	89 fa                	mov    %edi,%edx
  803edb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803edf:	89 34 24             	mov    %esi,(%esp)
  803ee2:	85 c0                	test   %eax,%eax
  803ee4:	75 1a                	jne    803f00 <__umoddi3+0x48>
  803ee6:	39 f7                	cmp    %esi,%edi
  803ee8:	0f 86 a2 00 00 00    	jbe    803f90 <__umoddi3+0xd8>
  803eee:	89 c8                	mov    %ecx,%eax
  803ef0:	89 f2                	mov    %esi,%edx
  803ef2:	f7 f7                	div    %edi
  803ef4:	89 d0                	mov    %edx,%eax
  803ef6:	31 d2                	xor    %edx,%edx
  803ef8:	83 c4 1c             	add    $0x1c,%esp
  803efb:	5b                   	pop    %ebx
  803efc:	5e                   	pop    %esi
  803efd:	5f                   	pop    %edi
  803efe:	5d                   	pop    %ebp
  803eff:	c3                   	ret    
  803f00:	39 f0                	cmp    %esi,%eax
  803f02:	0f 87 ac 00 00 00    	ja     803fb4 <__umoddi3+0xfc>
  803f08:	0f bd e8             	bsr    %eax,%ebp
  803f0b:	83 f5 1f             	xor    $0x1f,%ebp
  803f0e:	0f 84 ac 00 00 00    	je     803fc0 <__umoddi3+0x108>
  803f14:	bf 20 00 00 00       	mov    $0x20,%edi
  803f19:	29 ef                	sub    %ebp,%edi
  803f1b:	89 fe                	mov    %edi,%esi
  803f1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f21:	89 e9                	mov    %ebp,%ecx
  803f23:	d3 e0                	shl    %cl,%eax
  803f25:	89 d7                	mov    %edx,%edi
  803f27:	89 f1                	mov    %esi,%ecx
  803f29:	d3 ef                	shr    %cl,%edi
  803f2b:	09 c7                	or     %eax,%edi
  803f2d:	89 e9                	mov    %ebp,%ecx
  803f2f:	d3 e2                	shl    %cl,%edx
  803f31:	89 14 24             	mov    %edx,(%esp)
  803f34:	89 d8                	mov    %ebx,%eax
  803f36:	d3 e0                	shl    %cl,%eax
  803f38:	89 c2                	mov    %eax,%edx
  803f3a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f3e:	d3 e0                	shl    %cl,%eax
  803f40:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f44:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f48:	89 f1                	mov    %esi,%ecx
  803f4a:	d3 e8                	shr    %cl,%eax
  803f4c:	09 d0                	or     %edx,%eax
  803f4e:	d3 eb                	shr    %cl,%ebx
  803f50:	89 da                	mov    %ebx,%edx
  803f52:	f7 f7                	div    %edi
  803f54:	89 d3                	mov    %edx,%ebx
  803f56:	f7 24 24             	mull   (%esp)
  803f59:	89 c6                	mov    %eax,%esi
  803f5b:	89 d1                	mov    %edx,%ecx
  803f5d:	39 d3                	cmp    %edx,%ebx
  803f5f:	0f 82 87 00 00 00    	jb     803fec <__umoddi3+0x134>
  803f65:	0f 84 91 00 00 00    	je     803ffc <__umoddi3+0x144>
  803f6b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f6f:	29 f2                	sub    %esi,%edx
  803f71:	19 cb                	sbb    %ecx,%ebx
  803f73:	89 d8                	mov    %ebx,%eax
  803f75:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f79:	d3 e0                	shl    %cl,%eax
  803f7b:	89 e9                	mov    %ebp,%ecx
  803f7d:	d3 ea                	shr    %cl,%edx
  803f7f:	09 d0                	or     %edx,%eax
  803f81:	89 e9                	mov    %ebp,%ecx
  803f83:	d3 eb                	shr    %cl,%ebx
  803f85:	89 da                	mov    %ebx,%edx
  803f87:	83 c4 1c             	add    $0x1c,%esp
  803f8a:	5b                   	pop    %ebx
  803f8b:	5e                   	pop    %esi
  803f8c:	5f                   	pop    %edi
  803f8d:	5d                   	pop    %ebp
  803f8e:	c3                   	ret    
  803f8f:	90                   	nop
  803f90:	89 fd                	mov    %edi,%ebp
  803f92:	85 ff                	test   %edi,%edi
  803f94:	75 0b                	jne    803fa1 <__umoddi3+0xe9>
  803f96:	b8 01 00 00 00       	mov    $0x1,%eax
  803f9b:	31 d2                	xor    %edx,%edx
  803f9d:	f7 f7                	div    %edi
  803f9f:	89 c5                	mov    %eax,%ebp
  803fa1:	89 f0                	mov    %esi,%eax
  803fa3:	31 d2                	xor    %edx,%edx
  803fa5:	f7 f5                	div    %ebp
  803fa7:	89 c8                	mov    %ecx,%eax
  803fa9:	f7 f5                	div    %ebp
  803fab:	89 d0                	mov    %edx,%eax
  803fad:	e9 44 ff ff ff       	jmp    803ef6 <__umoddi3+0x3e>
  803fb2:	66 90                	xchg   %ax,%ax
  803fb4:	89 c8                	mov    %ecx,%eax
  803fb6:	89 f2                	mov    %esi,%edx
  803fb8:	83 c4 1c             	add    $0x1c,%esp
  803fbb:	5b                   	pop    %ebx
  803fbc:	5e                   	pop    %esi
  803fbd:	5f                   	pop    %edi
  803fbe:	5d                   	pop    %ebp
  803fbf:	c3                   	ret    
  803fc0:	3b 04 24             	cmp    (%esp),%eax
  803fc3:	72 06                	jb     803fcb <__umoddi3+0x113>
  803fc5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803fc9:	77 0f                	ja     803fda <__umoddi3+0x122>
  803fcb:	89 f2                	mov    %esi,%edx
  803fcd:	29 f9                	sub    %edi,%ecx
  803fcf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803fd3:	89 14 24             	mov    %edx,(%esp)
  803fd6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fda:	8b 44 24 04          	mov    0x4(%esp),%eax
  803fde:	8b 14 24             	mov    (%esp),%edx
  803fe1:	83 c4 1c             	add    $0x1c,%esp
  803fe4:	5b                   	pop    %ebx
  803fe5:	5e                   	pop    %esi
  803fe6:	5f                   	pop    %edi
  803fe7:	5d                   	pop    %ebp
  803fe8:	c3                   	ret    
  803fe9:	8d 76 00             	lea    0x0(%esi),%esi
  803fec:	2b 04 24             	sub    (%esp),%eax
  803fef:	19 fa                	sbb    %edi,%edx
  803ff1:	89 d1                	mov    %edx,%ecx
  803ff3:	89 c6                	mov    %eax,%esi
  803ff5:	e9 71 ff ff ff       	jmp    803f6b <__umoddi3+0xb3>
  803ffa:	66 90                	xchg   %ax,%ax
  803ffc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804000:	72 ea                	jb     803fec <__umoddi3+0x134>
  804002:	89 d9                	mov    %ebx,%ecx
  804004:	e9 62 ff ff ff       	jmp    803f6b <__umoddi3+0xb3>
