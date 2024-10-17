
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
  80003e:	e8 9f 18 00 00       	call   8018e2 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 c9 18 00 00       	call   801914 <sys_getparentenvid>
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
  80005f:	68 a0 20 80 00       	push   $0x8020a0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 04 15 00 00       	call   801570 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a4 20 80 00       	push   $0x8020a4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 ee 14 00 00       	call   801570 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ac 20 80 00       	push   $0x8020ac
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 d1 14 00 00       	call   801570 <sget>
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
  8000b3:	68 ba 20 80 00       	push   $0x8020ba
  8000b8:	e8 84 14 00 00       	call   801541 <smalloc>
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
  800126:	68 c4 20 80 00       	push   $0x8020c4
  80012b:	e8 1e 06 00 00       	call   80074e <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 e9 20 80 00       	push   $0x8020e9
  80013f:	e8 fd 13 00 00       	call   801541 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 ee 20 80 00       	push   $0x8020ee
  80015e:	e8 de 13 00 00       	call   801541 <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 f2 20 80 00       	push   $0x8020f2
  80017d:	e8 bf 13 00 00       	call   801541 <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 f6 20 80 00       	push   $0x8020f6
  80019c:	e8 a0 13 00 00       	call   801541 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 fa 20 80 00       	push   $0x8020fa
  8001bb:	e8 81 13 00 00       	call   801541 <smalloc>
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
  800230:	e8 12 17 00 00       	call   801947 <sys_get_virtual_time>
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
  800533:	e8 c3 13 00 00       	call   8018fb <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 06             	shl    $0x6,%eax
  800543:	29 d0                	sub    %edx,%eax
  800545:	c1 e0 02             	shl    $0x2,%eax
  800548:	01 d0                	add    %edx,%eax
  80054a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800551:	01 c8                	add    %ecx,%eax
  800553:	c1 e0 03             	shl    $0x3,%eax
  800556:	01 d0                	add    %edx,%eax
  800558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055f:	29 c2                	sub    %eax,%edx
  800561:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800568:	89 c2                	mov    %eax,%edx
  80056a:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800570:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800575:	a1 04 30 80 00       	mov    0x803004,%eax
  80057a:	8a 40 20             	mov    0x20(%eax),%al
  80057d:	84 c0                	test   %al,%al
  80057f:	74 0d                	je     80058e <libmain+0x61>
		binaryname = myEnv->prog_name;
  800581:	a1 04 30 80 00       	mov    0x803004,%eax
  800586:	83 c0 20             	add    $0x20,%eax
  800589:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80058e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800592:	7e 0a                	jle    80059e <libmain+0x71>
		binaryname = argv[0];
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	ff 75 0c             	pushl  0xc(%ebp)
  8005a4:	ff 75 08             	pushl  0x8(%ebp)
  8005a7:	e8 8c fa ff ff       	call   800038 <_main>
  8005ac:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8005af:	e8 cb 10 00 00       	call   80167f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	68 18 21 80 00       	push   $0x802118
  8005bc:	e8 8d 01 00 00       	call   80074e <cprintf>
  8005c1:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005c4:	a1 04 30 80 00       	mov    0x803004,%eax
  8005c9:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8005cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8005d4:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8005da:	83 ec 04             	sub    $0x4,%esp
  8005dd:	52                   	push   %edx
  8005de:	50                   	push   %eax
  8005df:	68 40 21 80 00       	push   $0x802140
  8005e4:	e8 65 01 00 00       	call   80074e <cprintf>
  8005e9:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8005f1:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8005f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8005fc:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800602:	a1 04 30 80 00       	mov    0x803004,%eax
  800607:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80060d:	51                   	push   %ecx
  80060e:	52                   	push   %edx
  80060f:	50                   	push   %eax
  800610:	68 68 21 80 00       	push   $0x802168
  800615:	e8 34 01 00 00       	call   80074e <cprintf>
  80061a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80061d:	a1 04 30 80 00       	mov    0x803004,%eax
  800622:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	50                   	push   %eax
  80062c:	68 c0 21 80 00       	push   $0x8021c0
  800631:	e8 18 01 00 00       	call   80074e <cprintf>
  800636:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	68 18 21 80 00       	push   $0x802118
  800641:	e8 08 01 00 00       	call   80074e <cprintf>
  800646:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800649:	e8 4b 10 00 00       	call   801699 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80064e:	e8 19 00 00 00       	call   80066c <exit>
}
  800653:	90                   	nop
  800654:	c9                   	leave  
  800655:	c3                   	ret    

00800656 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800656:	55                   	push   %ebp
  800657:	89 e5                	mov    %esp,%ebp
  800659:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	6a 00                	push   $0x0
  800661:	e8 61 12 00 00       	call   8018c7 <sys_destroy_env>
  800666:	83 c4 10             	add    $0x10,%esp
}
  800669:	90                   	nop
  80066a:	c9                   	leave  
  80066b:	c3                   	ret    

0080066c <exit>:

void
exit(void)
{
  80066c:	55                   	push   %ebp
  80066d:	89 e5                	mov    %esp,%ebp
  80066f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800672:	e8 b6 12 00 00       	call   80192d <sys_exit_env>
}
  800677:	90                   	nop
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800680:	8b 45 0c             	mov    0xc(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	8d 48 01             	lea    0x1(%eax),%ecx
  800688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068b:	89 0a                	mov    %ecx,(%edx)
  80068d:	8b 55 08             	mov    0x8(%ebp),%edx
  800690:	88 d1                	mov    %dl,%cl
  800692:	8b 55 0c             	mov    0xc(%ebp),%edx
  800695:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800699:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a3:	75 2c                	jne    8006d1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006a5:	a0 08 30 80 00       	mov    0x803008,%al
  8006aa:	0f b6 c0             	movzbl %al,%eax
  8006ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b0:	8b 12                	mov    (%edx),%edx
  8006b2:	89 d1                	mov    %edx,%ecx
  8006b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b7:	83 c2 08             	add    $0x8,%edx
  8006ba:	83 ec 04             	sub    $0x4,%esp
  8006bd:	50                   	push   %eax
  8006be:	51                   	push   %ecx
  8006bf:	52                   	push   %edx
  8006c0:	e8 78 0f 00 00       	call   80163d <sys_cputs>
  8006c5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d4:	8b 40 04             	mov    0x4(%eax),%eax
  8006d7:	8d 50 01             	lea    0x1(%eax),%edx
  8006da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e0:	90                   	nop
  8006e1:	c9                   	leave  
  8006e2:	c3                   	ret    

008006e3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
  8006e6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f3:	00 00 00 
	b.cnt = 0;
  8006f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800700:	ff 75 0c             	pushl  0xc(%ebp)
  800703:	ff 75 08             	pushl  0x8(%ebp)
  800706:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070c:	50                   	push   %eax
  80070d:	68 7a 06 80 00       	push   $0x80067a
  800712:	e8 11 02 00 00       	call   800928 <vprintfmt>
  800717:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80071a:	a0 08 30 80 00       	mov    0x803008,%al
  80071f:	0f b6 c0             	movzbl %al,%eax
  800722:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	50                   	push   %eax
  80072c:	52                   	push   %edx
  80072d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800733:	83 c0 08             	add    $0x8,%eax
  800736:	50                   	push   %eax
  800737:	e8 01 0f 00 00       	call   80163d <sys_cputs>
  80073c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80073f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800746:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074c:	c9                   	leave  
  80074d:	c3                   	ret    

0080074e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800754:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80075b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 f4             	pushl  -0xc(%ebp)
  80076a:	50                   	push   %eax
  80076b:	e8 73 ff ff ff       	call   8006e3 <vcprintf>
  800770:	83 c4 10             	add    $0x10,%esp
  800773:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800776:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800781:	e8 f9 0e 00 00       	call   80167f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800786:	8d 45 0c             	lea    0xc(%ebp),%eax
  800789:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 f4             	pushl  -0xc(%ebp)
  800795:	50                   	push   %eax
  800796:	e8 48 ff ff ff       	call   8006e3 <vcprintf>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007a1:	e8 f3 0e 00 00       	call   801699 <sys_unlock_cons>
	return cnt;
  8007a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	53                   	push   %ebx
  8007af:	83 ec 14             	sub    $0x14,%esp
  8007b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007be:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c9:	77 55                	ja     800820 <printnum+0x75>
  8007cb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ce:	72 05                	jb     8007d5 <printnum+0x2a>
  8007d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d3:	77 4b                	ja     800820 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007db:	8b 45 18             	mov    0x18(%ebp),%eax
  8007de:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e3:	52                   	push   %edx
  8007e4:	50                   	push   %eax
  8007e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8007eb:	e8 38 16 00 00       	call   801e28 <__udivdi3>
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	83 ec 04             	sub    $0x4,%esp
  8007f6:	ff 75 20             	pushl  0x20(%ebp)
  8007f9:	53                   	push   %ebx
  8007fa:	ff 75 18             	pushl  0x18(%ebp)
  8007fd:	52                   	push   %edx
  8007fe:	50                   	push   %eax
  8007ff:	ff 75 0c             	pushl  0xc(%ebp)
  800802:	ff 75 08             	pushl  0x8(%ebp)
  800805:	e8 a1 ff ff ff       	call   8007ab <printnum>
  80080a:	83 c4 20             	add    $0x20,%esp
  80080d:	eb 1a                	jmp    800829 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	ff 75 0c             	pushl  0xc(%ebp)
  800815:	ff 75 20             	pushl  0x20(%ebp)
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	ff d0                	call   *%eax
  80081d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800820:	ff 4d 1c             	decl   0x1c(%ebp)
  800823:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800827:	7f e6                	jg     80080f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800829:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800834:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800837:	53                   	push   %ebx
  800838:	51                   	push   %ecx
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	e8 f8 16 00 00       	call   801f38 <__umoddi3>
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	05 f4 23 80 00       	add    $0x8023f4,%eax
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f be c0             	movsbl %al,%eax
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	50                   	push   %eax
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
}
  80085c:	90                   	nop
  80085d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800860:	c9                   	leave  
  800861:	c3                   	ret    

00800862 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800865:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800869:	7e 1c                	jle    800887 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	8d 50 08             	lea    0x8(%eax),%edx
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	89 10                	mov    %edx,(%eax)
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	83 e8 08             	sub    $0x8,%eax
  800880:	8b 50 04             	mov    0x4(%eax),%edx
  800883:	8b 00                	mov    (%eax),%eax
  800885:	eb 40                	jmp    8008c7 <getuint+0x65>
	else if (lflag)
  800887:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088b:	74 1e                	je     8008ab <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	8d 50 04             	lea    0x4(%eax),%edx
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	89 10                	mov    %edx,(%eax)
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	83 e8 04             	sub    $0x4,%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a9:	eb 1c                	jmp    8008c7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	8d 50 04             	lea    0x4(%eax),%edx
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	89 10                	mov    %edx,(%eax)
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d0:	7e 1c                	jle    8008ee <getint+0x25>
		return va_arg(*ap, long long);
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	8d 50 08             	lea    0x8(%eax),%edx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	89 10                	mov    %edx,(%eax)
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	83 e8 08             	sub    $0x8,%eax
  8008e7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	eb 38                	jmp    800926 <getint+0x5d>
	else if (lflag)
  8008ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f2:	74 1a                	je     80090e <getint+0x45>
		return va_arg(*ap, long);
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	8d 50 04             	lea    0x4(%eax),%edx
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	89 10                	mov    %edx,(%eax)
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	83 e8 04             	sub    $0x4,%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	99                   	cltd   
  80090c:	eb 18                	jmp    800926 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 04             	lea    0x4(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 04             	sub    $0x4,%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	99                   	cltd   
}
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800930:	eb 17                	jmp    800949 <vprintfmt+0x21>
			if (ch == '\0')
  800932:	85 db                	test   %ebx,%ebx
  800934:	0f 84 c1 03 00 00    	je     800cfb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	53                   	push   %ebx
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800949:	8b 45 10             	mov    0x10(%ebp),%eax
  80094c:	8d 50 01             	lea    0x1(%eax),%edx
  80094f:	89 55 10             	mov    %edx,0x10(%ebp)
  800952:	8a 00                	mov    (%eax),%al
  800954:	0f b6 d8             	movzbl %al,%ebx
  800957:	83 fb 25             	cmp    $0x25,%ebx
  80095a:	75 d6                	jne    800932 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800960:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800967:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80096e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800975:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097c:	8b 45 10             	mov    0x10(%ebp),%eax
  80097f:	8d 50 01             	lea    0x1(%eax),%edx
  800982:	89 55 10             	mov    %edx,0x10(%ebp)
  800985:	8a 00                	mov    (%eax),%al
  800987:	0f b6 d8             	movzbl %al,%ebx
  80098a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80098d:	83 f8 5b             	cmp    $0x5b,%eax
  800990:	0f 87 3d 03 00 00    	ja     800cd3 <vprintfmt+0x3ab>
  800996:	8b 04 85 18 24 80 00 	mov    0x802418(,%eax,4),%eax
  80099d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80099f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a3:	eb d7                	jmp    80097c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a9:	eb d1                	jmp    80097c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b5:	89 d0                	mov    %edx,%eax
  8009b7:	c1 e0 02             	shl    $0x2,%eax
  8009ba:	01 d0                	add    %edx,%eax
  8009bc:	01 c0                	add    %eax,%eax
  8009be:	01 d8                	add    %ebx,%eax
  8009c0:	83 e8 30             	sub    $0x30,%eax
  8009c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c9:	8a 00                	mov    (%eax),%al
  8009cb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ce:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d1:	7e 3e                	jle    800a11 <vprintfmt+0xe9>
  8009d3:	83 fb 39             	cmp    $0x39,%ebx
  8009d6:	7f 39                	jg     800a11 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009db:	eb d5                	jmp    8009b2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e0:	83 c0 04             	add    $0x4,%eax
  8009e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	83 e8 04             	sub    $0x4,%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f1:	eb 1f                	jmp    800a12 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f7:	79 83                	jns    80097c <vprintfmt+0x54>
				width = 0;
  8009f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a00:	e9 77 ff ff ff       	jmp    80097c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a05:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0c:	e9 6b ff ff ff       	jmp    80097c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a11:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a16:	0f 89 60 ff ff ff    	jns    80097c <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a22:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a29:	e9 4e ff ff ff       	jmp    80097c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a2e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a31:	e9 46 ff ff ff       	jmp    80097c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 c0 04             	add    $0x4,%eax
  800a3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	83 e8 04             	sub    $0x4,%eax
  800a45:	8b 00                	mov    (%eax),%eax
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	50                   	push   %eax
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	ff d0                	call   *%eax
  800a53:	83 c4 10             	add    $0x10,%esp
			break;
  800a56:	e9 9b 02 00 00       	jmp    800cf6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5e:	83 c0 04             	add    $0x4,%eax
  800a61:	89 45 14             	mov    %eax,0x14(%ebp)
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 e8 04             	sub    $0x4,%eax
  800a6a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6c:	85 db                	test   %ebx,%ebx
  800a6e:	79 02                	jns    800a72 <vprintfmt+0x14a>
				err = -err;
  800a70:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a72:	83 fb 64             	cmp    $0x64,%ebx
  800a75:	7f 0b                	jg     800a82 <vprintfmt+0x15a>
  800a77:	8b 34 9d 60 22 80 00 	mov    0x802260(,%ebx,4),%esi
  800a7e:	85 f6                	test   %esi,%esi
  800a80:	75 19                	jne    800a9b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a82:	53                   	push   %ebx
  800a83:	68 05 24 80 00       	push   $0x802405
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 70 02 00 00       	call   800d03 <printfmt>
  800a93:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a96:	e9 5b 02 00 00       	jmp    800cf6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9b:	56                   	push   %esi
  800a9c:	68 0e 24 80 00       	push   $0x80240e
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	ff 75 08             	pushl  0x8(%ebp)
  800aa7:	e8 57 02 00 00       	call   800d03 <printfmt>
  800aac:	83 c4 10             	add    $0x10,%esp
			break;
  800aaf:	e9 42 02 00 00       	jmp    800cf6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab7:	83 c0 04             	add    $0x4,%eax
  800aba:	89 45 14             	mov    %eax,0x14(%ebp)
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	83 e8 04             	sub    $0x4,%eax
  800ac3:	8b 30                	mov    (%eax),%esi
  800ac5:	85 f6                	test   %esi,%esi
  800ac7:	75 05                	jne    800ace <vprintfmt+0x1a6>
				p = "(null)";
  800ac9:	be 11 24 80 00       	mov    $0x802411,%esi
			if (width > 0 && padc != '-')
  800ace:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad2:	7e 6d                	jle    800b41 <vprintfmt+0x219>
  800ad4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad8:	74 67                	je     800b41 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ada:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	50                   	push   %eax
  800ae1:	56                   	push   %esi
  800ae2:	e8 1e 03 00 00       	call   800e05 <strnlen>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aed:	eb 16                	jmp    800b05 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aef:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	50                   	push   %eax
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	ff d0                	call   *%eax
  800aff:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b02:	ff 4d e4             	decl   -0x1c(%ebp)
  800b05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b09:	7f e4                	jg     800aef <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0b:	eb 34                	jmp    800b41 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b11:	74 1c                	je     800b2f <vprintfmt+0x207>
  800b13:	83 fb 1f             	cmp    $0x1f,%ebx
  800b16:	7e 05                	jle    800b1d <vprintfmt+0x1f5>
  800b18:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1b:	7e 12                	jle    800b2f <vprintfmt+0x207>
					putch('?', putdat);
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	6a 3f                	push   $0x3f
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
  800b2d:	eb 0f                	jmp    800b3e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	53                   	push   %ebx
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	89 f0                	mov    %esi,%eax
  800b43:	8d 70 01             	lea    0x1(%eax),%esi
  800b46:	8a 00                	mov    (%eax),%al
  800b48:	0f be d8             	movsbl %al,%ebx
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	74 24                	je     800b73 <vprintfmt+0x24b>
  800b4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b53:	78 b8                	js     800b0d <vprintfmt+0x1e5>
  800b55:	ff 4d e0             	decl   -0x20(%ebp)
  800b58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5c:	79 af                	jns    800b0d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5e:	eb 13                	jmp    800b73 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	6a 20                	push   $0x20
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	ff d0                	call   *%eax
  800b6d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b70:	ff 4d e4             	decl   -0x1c(%ebp)
  800b73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b77:	7f e7                	jg     800b60 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b79:	e9 78 01 00 00       	jmp    800cf6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 e8             	pushl  -0x18(%ebp)
  800b84:	8d 45 14             	lea    0x14(%ebp),%eax
  800b87:	50                   	push   %eax
  800b88:	e8 3c fd ff ff       	call   8008c9 <getint>
  800b8d:	83 c4 10             	add    $0x10,%esp
  800b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b93:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9c:	85 d2                	test   %edx,%edx
  800b9e:	79 23                	jns    800bc3 <vprintfmt+0x29b>
				putch('-', putdat);
  800ba0:	83 ec 08             	sub    $0x8,%esp
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	6a 2d                	push   $0x2d
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	ff d0                	call   *%eax
  800bad:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb6:	f7 d8                	neg    %eax
  800bb8:	83 d2 00             	adc    $0x0,%edx
  800bbb:	f7 da                	neg    %edx
  800bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bca:	e9 bc 00 00 00       	jmp    800c8b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd5:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd8:	50                   	push   %eax
  800bd9:	e8 84 fc ff ff       	call   800862 <getuint>
  800bde:	83 c4 10             	add    $0x10,%esp
  800be1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800be7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bee:	e9 98 00 00 00       	jmp    800c8b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bf3:	83 ec 08             	sub    $0x8,%esp
  800bf6:	ff 75 0c             	pushl  0xc(%ebp)
  800bf9:	6a 58                	push   $0x58
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff d0                	call   *%eax
  800c00:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	6a 58                	push   $0x58
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	ff d0                	call   *%eax
  800c10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c13:	83 ec 08             	sub    $0x8,%esp
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	6a 58                	push   $0x58
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
			break;
  800c23:	e9 ce 00 00 00       	jmp    800cf6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c28:	83 ec 08             	sub    $0x8,%esp
  800c2b:	ff 75 0c             	pushl  0xc(%ebp)
  800c2e:	6a 30                	push   $0x30
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	ff d0                	call   *%eax
  800c35:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c38:	83 ec 08             	sub    $0x8,%esp
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	6a 78                	push   $0x78
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	ff d0                	call   *%eax
  800c45:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c48:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4b:	83 c0 04             	add    $0x4,%eax
  800c4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800c51:	8b 45 14             	mov    0x14(%ebp),%eax
  800c54:	83 e8 04             	sub    $0x4,%eax
  800c57:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c63:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c6a:	eb 1f                	jmp    800c8b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 e8             	pushl  -0x18(%ebp)
  800c72:	8d 45 14             	lea    0x14(%ebp),%eax
  800c75:	50                   	push   %eax
  800c76:	e8 e7 fb ff ff       	call   800862 <getuint>
  800c7b:	83 c4 10             	add    $0x10,%esp
  800c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c81:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c92:	83 ec 04             	sub    $0x4,%esp
  800c95:	52                   	push   %edx
  800c96:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c99:	50                   	push   %eax
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	ff 75 f0             	pushl  -0x10(%ebp)
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	ff 75 08             	pushl  0x8(%ebp)
  800ca6:	e8 00 fb ff ff       	call   8007ab <printnum>
  800cab:	83 c4 20             	add    $0x20,%esp
			break;
  800cae:	eb 46                	jmp    800cf6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	53                   	push   %ebx
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	ff d0                	call   *%eax
  800cbc:	83 c4 10             	add    $0x10,%esp
			break;
  800cbf:	eb 35                	jmp    800cf6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cc1:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800cc8:	eb 2c                	jmp    800cf6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cca:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800cd1:	eb 23                	jmp    800cf6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	6a 25                	push   $0x25
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	ff d0                	call   *%eax
  800ce0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ce3:	ff 4d 10             	decl   0x10(%ebp)
  800ce6:	eb 03                	jmp    800ceb <vprintfmt+0x3c3>
  800ce8:	ff 4d 10             	decl   0x10(%ebp)
  800ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cee:	48                   	dec    %eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	3c 25                	cmp    $0x25,%al
  800cf3:	75 f3                	jne    800ce8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cf5:	90                   	nop
		}
	}
  800cf6:	e9 35 fc ff ff       	jmp    800930 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cfb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d09:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0c:	83 c0 04             	add    $0x4,%eax
  800d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	ff 75 f4             	pushl  -0xc(%ebp)
  800d18:	50                   	push   %eax
  800d19:	ff 75 0c             	pushl  0xc(%ebp)
  800d1c:	ff 75 08             	pushl  0x8(%ebp)
  800d1f:	e8 04 fc ff ff       	call   800928 <vprintfmt>
  800d24:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d27:	90                   	nop
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d30:	8b 40 08             	mov    0x8(%eax),%eax
  800d33:	8d 50 01             	lea    0x1(%eax),%edx
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 10                	mov    (%eax),%edx
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	8b 40 04             	mov    0x4(%eax),%eax
  800d47:	39 c2                	cmp    %eax,%edx
  800d49:	73 12                	jae    800d5d <sprintputch+0x33>
		*b->buf++ = ch;
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	8d 48 01             	lea    0x1(%eax),%ecx
  800d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d56:	89 0a                	mov    %ecx,(%edx)
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	88 10                	mov    %dl,(%eax)
}
  800d5d:	90                   	nop
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	01 d0                	add    %edx,%eax
  800d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d85:	74 06                	je     800d8d <vsnprintf+0x2d>
  800d87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8b:	7f 07                	jg     800d94 <vsnprintf+0x34>
		return -E_INVAL;
  800d8d:	b8 03 00 00 00       	mov    $0x3,%eax
  800d92:	eb 20                	jmp    800db4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d94:	ff 75 14             	pushl  0x14(%ebp)
  800d97:	ff 75 10             	pushl  0x10(%ebp)
  800d9a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d9d:	50                   	push   %eax
  800d9e:	68 2a 0d 80 00       	push   $0x800d2a
  800da3:	e8 80 fb ff ff       	call   800928 <vprintfmt>
  800da8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dae:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    

00800db6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dbc:	8d 45 10             	lea    0x10(%ebp),%eax
  800dbf:	83 c0 04             	add    $0x4,%eax
  800dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc8:	ff 75 f4             	pushl  -0xc(%ebp)
  800dcb:	50                   	push   %eax
  800dcc:	ff 75 0c             	pushl  0xc(%ebp)
  800dcf:	ff 75 08             	pushl  0x8(%ebp)
  800dd2:	e8 89 ff ff ff       	call   800d60 <vsnprintf>
  800dd7:	83 c4 10             	add    $0x10,%esp
  800dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800def:	eb 06                	jmp    800df7 <strlen+0x15>
		n++;
  800df1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800df4:	ff 45 08             	incl   0x8(%ebp)
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	84 c0                	test   %al,%al
  800dfe:	75 f1                	jne    800df1 <strlen+0xf>
		n++;
	return n;
  800e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    

00800e05 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e12:	eb 09                	jmp    800e1d <strnlen+0x18>
		n++;
  800e14:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e17:	ff 45 08             	incl   0x8(%ebp)
  800e1a:	ff 4d 0c             	decl   0xc(%ebp)
  800e1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e21:	74 09                	je     800e2c <strnlen+0x27>
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 e8                	jne    800e14 <strnlen+0xf>
		n++;
	return n;
  800e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e3d:	90                   	nop
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8d 50 01             	lea    0x1(%eax),%edx
  800e44:	89 55 08             	mov    %edx,0x8(%ebp)
  800e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e50:	8a 12                	mov    (%edx),%dl
  800e52:	88 10                	mov    %dl,(%eax)
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	84 c0                	test   %al,%al
  800e58:	75 e4                	jne    800e3e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e72:	eb 1f                	jmp    800e93 <strncpy+0x34>
		*dst++ = *src;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e80:	8a 12                	mov    (%edx),%dl
  800e82:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	84 c0                	test   %al,%al
  800e8b:	74 03                	je     800e90 <strncpy+0x31>
			src++;
  800e8d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e90:	ff 45 fc             	incl   -0x4(%ebp)
  800e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e96:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e99:	72 d9                	jb     800e74 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e9e:	c9                   	leave  
  800e9f:	c3                   	ret    

00800ea0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800eac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb0:	74 30                	je     800ee2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eb2:	eb 16                	jmp    800eca <strlcpy+0x2a>
			*dst++ = *src++;
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	8d 50 01             	lea    0x1(%eax),%edx
  800eba:	89 55 08             	mov    %edx,0x8(%ebp)
  800ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eca:	ff 4d 10             	decl   0x10(%ebp)
  800ecd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed1:	74 09                	je     800edc <strlcpy+0x3c>
  800ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	84 c0                	test   %al,%al
  800eda:	75 d8                	jne    800eb4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee8:	29 c2                	sub    %eax,%edx
  800eea:	89 d0                	mov    %edx,%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ef1:	eb 06                	jmp    800ef9 <strcmp+0xb>
		p++, q++;
  800ef3:	ff 45 08             	incl   0x8(%ebp)
  800ef6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	84 c0                	test   %al,%al
  800f00:	74 0e                	je     800f10 <strcmp+0x22>
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 10                	mov    (%eax),%dl
  800f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	38 c2                	cmp    %al,%dl
  800f0e:	74 e3                	je     800ef3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f b6 d0             	movzbl %al,%edx
  800f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	0f b6 c0             	movzbl %al,%eax
  800f20:	29 c2                	sub    %eax,%edx
  800f22:	89 d0                	mov    %edx,%eax
}
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f29:	eb 09                	jmp    800f34 <strncmp+0xe>
		n--, p++, q++;
  800f2b:	ff 4d 10             	decl   0x10(%ebp)
  800f2e:	ff 45 08             	incl   0x8(%ebp)
  800f31:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f38:	74 17                	je     800f51 <strncmp+0x2b>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	84 c0                	test   %al,%al
  800f41:	74 0e                	je     800f51 <strncmp+0x2b>
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 10                	mov    (%eax),%dl
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	38 c2                	cmp    %al,%dl
  800f4f:	74 da                	je     800f2b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f55:	75 07                	jne    800f5e <strncmp+0x38>
		return 0;
  800f57:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5c:	eb 14                	jmp    800f72 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 d0             	movzbl %al,%edx
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	0f b6 c0             	movzbl %al,%eax
  800f6e:	29 c2                	sub    %eax,%edx
  800f70:	89 d0                	mov    %edx,%eax
}
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	83 ec 04             	sub    $0x4,%esp
  800f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f80:	eb 12                	jmp    800f94 <strchr+0x20>
		if (*s == c)
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f8a:	75 05                	jne    800f91 <strchr+0x1d>
			return (char *) s;
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	eb 11                	jmp    800fa2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	84 c0                	test   %al,%al
  800f9b:	75 e5                	jne    800f82 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 04             	sub    $0x4,%esp
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fb0:	eb 0d                	jmp    800fbf <strfind+0x1b>
		if (*s == c)
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fba:	74 0e                	je     800fca <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fbc:	ff 45 08             	incl   0x8(%ebp)
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	84 c0                	test   %al,%al
  800fc6:	75 ea                	jne    800fb2 <strfind+0xe>
  800fc8:	eb 01                	jmp    800fcb <strfind+0x27>
		if (*s == c)
			break;
  800fca:	90                   	nop
	return (char *) s;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    

00800fd0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fe2:	eb 0e                	jmp    800ff2 <memset+0x22>
		*p++ = c;
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	8d 50 01             	lea    0x1(%eax),%edx
  800fea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ff2:	ff 4d f8             	decl   -0x8(%ebp)
  800ff5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ff9:	79 e9                	jns    800fe4 <memset+0x14>
		*p++ = c;

	return v;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801012:	eb 16                	jmp    80102a <memcpy+0x2a>
		*d++ = *s++;
  801014:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801017:	8d 50 01             	lea    0x1(%eax),%edx
  80101a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80101d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801020:	8d 4a 01             	lea    0x1(%edx),%ecx
  801023:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801026:	8a 12                	mov    (%edx),%dl
  801028:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80102a:	8b 45 10             	mov    0x10(%ebp),%eax
  80102d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801030:	89 55 10             	mov    %edx,0x10(%ebp)
  801033:	85 c0                	test   %eax,%eax
  801035:	75 dd                	jne    801014 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80104e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801051:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801054:	73 50                	jae    8010a6 <memmove+0x6a>
  801056:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801059:	8b 45 10             	mov    0x10(%ebp),%eax
  80105c:	01 d0                	add    %edx,%eax
  80105e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801061:	76 43                	jbe    8010a6 <memmove+0x6a>
		s += n;
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801069:	8b 45 10             	mov    0x10(%ebp),%eax
  80106c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106f:	eb 10                	jmp    801081 <memmove+0x45>
			*--d = *--s;
  801071:	ff 4d f8             	decl   -0x8(%ebp)
  801074:	ff 4d fc             	decl   -0x4(%ebp)
  801077:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107a:	8a 10                	mov    (%eax),%dl
  80107c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801081:	8b 45 10             	mov    0x10(%ebp),%eax
  801084:	8d 50 ff             	lea    -0x1(%eax),%edx
  801087:	89 55 10             	mov    %edx,0x10(%ebp)
  80108a:	85 c0                	test   %eax,%eax
  80108c:	75 e3                	jne    801071 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80108e:	eb 23                	jmp    8010b3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801090:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801093:	8d 50 01             	lea    0x1(%eax),%edx
  801096:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801099:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010a2:	8a 12                	mov    (%edx),%dl
  8010a4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	75 dd                	jne    801090 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010ca:	eb 2a                	jmp    8010f6 <memcmp+0x3e>
		if (*s1 != *s2)
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cf:	8a 10                	mov    (%eax),%dl
  8010d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d4:	8a 00                	mov    (%eax),%al
  8010d6:	38 c2                	cmp    %al,%dl
  8010d8:	74 16                	je     8010f0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	0f b6 d0             	movzbl %al,%edx
  8010e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	0f b6 c0             	movzbl %al,%eax
  8010ea:	29 c2                	sub    %eax,%edx
  8010ec:	89 d0                	mov    %edx,%eax
  8010ee:	eb 18                	jmp    801108 <memcmp+0x50>
		s1++, s2++;
  8010f0:	ff 45 fc             	incl   -0x4(%ebp)
  8010f3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ff:	85 c0                	test   %eax,%eax
  801101:	75 c9                	jne    8010cc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801103:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801110:	8b 55 08             	mov    0x8(%ebp),%edx
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80111b:	eb 15                	jmp    801132 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	0f b6 d0             	movzbl %al,%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	0f b6 c0             	movzbl %al,%eax
  80112b:	39 c2                	cmp    %eax,%edx
  80112d:	74 0d                	je     80113c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80112f:	ff 45 08             	incl   0x8(%ebp)
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801138:	72 e3                	jb     80111d <memfind+0x13>
  80113a:	eb 01                	jmp    80113d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80113c:	90                   	nop
	return (void *) s;
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801140:	c9                   	leave  
  801141:	c3                   	ret    

00801142 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801148:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80114f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801156:	eb 03                	jmp    80115b <strtol+0x19>
		s++;
  801158:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	3c 20                	cmp    $0x20,%al
  801162:	74 f4                	je     801158 <strtol+0x16>
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	3c 09                	cmp    $0x9,%al
  80116b:	74 eb                	je     801158 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 2b                	cmp    $0x2b,%al
  801174:	75 05                	jne    80117b <strtol+0x39>
		s++;
  801176:	ff 45 08             	incl   0x8(%ebp)
  801179:	eb 13                	jmp    80118e <strtol+0x4c>
	else if (*s == '-')
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	3c 2d                	cmp    $0x2d,%al
  801182:	75 0a                	jne    80118e <strtol+0x4c>
		s++, neg = 1;
  801184:	ff 45 08             	incl   0x8(%ebp)
  801187:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80118e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801192:	74 06                	je     80119a <strtol+0x58>
  801194:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801198:	75 20                	jne    8011ba <strtol+0x78>
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	3c 30                	cmp    $0x30,%al
  8011a1:	75 17                	jne    8011ba <strtol+0x78>
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	40                   	inc    %eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	3c 78                	cmp    $0x78,%al
  8011ab:	75 0d                	jne    8011ba <strtol+0x78>
		s += 2, base = 16;
  8011ad:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011b1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b8:	eb 28                	jmp    8011e2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011be:	75 15                	jne    8011d5 <strtol+0x93>
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	3c 30                	cmp    $0x30,%al
  8011c7:	75 0c                	jne    8011d5 <strtol+0x93>
		s++, base = 8;
  8011c9:	ff 45 08             	incl   0x8(%ebp)
  8011cc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011d3:	eb 0d                	jmp    8011e2 <strtol+0xa0>
	else if (base == 0)
  8011d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d9:	75 07                	jne    8011e2 <strtol+0xa0>
		base = 10;
  8011db:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 2f                	cmp    $0x2f,%al
  8011e9:	7e 19                	jle    801204 <strtol+0xc2>
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	3c 39                	cmp    $0x39,%al
  8011f2:	7f 10                	jg     801204 <strtol+0xc2>
			dig = *s - '0';
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	0f be c0             	movsbl %al,%eax
  8011fc:	83 e8 30             	sub    $0x30,%eax
  8011ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801202:	eb 42                	jmp    801246 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8a 00                	mov    (%eax),%al
  801209:	3c 60                	cmp    $0x60,%al
  80120b:	7e 19                	jle    801226 <strtol+0xe4>
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	3c 7a                	cmp    $0x7a,%al
  801214:	7f 10                	jg     801226 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	0f be c0             	movsbl %al,%eax
  80121e:	83 e8 57             	sub    $0x57,%eax
  801221:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801224:	eb 20                	jmp    801246 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	3c 40                	cmp    $0x40,%al
  80122d:	7e 39                	jle    801268 <strtol+0x126>
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3c 5a                	cmp    $0x5a,%al
  801236:	7f 30                	jg     801268 <strtol+0x126>
			dig = *s - 'A' + 10;
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	0f be c0             	movsbl %al,%eax
  801240:	83 e8 37             	sub    $0x37,%eax
  801243:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801249:	3b 45 10             	cmp    0x10(%ebp),%eax
  80124c:	7d 19                	jge    801267 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80124e:	ff 45 08             	incl   0x8(%ebp)
  801251:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801254:	0f af 45 10          	imul   0x10(%ebp),%eax
  801258:	89 c2                	mov    %eax,%edx
  80125a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801262:	e9 7b ff ff ff       	jmp    8011e2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801267:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801268:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80126c:	74 08                	je     801276 <strtol+0x134>
		*endptr = (char *) s;
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	8b 55 08             	mov    0x8(%ebp),%edx
  801274:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801276:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127a:	74 07                	je     801283 <strtol+0x141>
  80127c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127f:	f7 d8                	neg    %eax
  801281:	eb 03                	jmp    801286 <strtol+0x144>
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801286:	c9                   	leave  
  801287:	c3                   	ret    

00801288 <ltostr>:

void
ltostr(long value, char *str)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80128e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801295:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80129c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a0:	79 13                	jns    8012b5 <ltostr+0x2d>
	{
		neg = 1;
  8012a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ac:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012af:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012b2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012bd:	99                   	cltd   
  8012be:	f7 f9                	idiv   %ecx
  8012c0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c6:	8d 50 01             	lea    0x1(%eax),%edx
  8012c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012cc:	89 c2                	mov    %eax,%edx
  8012ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d1:	01 d0                	add    %edx,%eax
  8012d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d6:	83 c2 30             	add    $0x30,%edx
  8012d9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012de:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e3:	f7 e9                	imul   %ecx
  8012e5:	c1 fa 02             	sar    $0x2,%edx
  8012e8:	89 c8                	mov    %ecx,%eax
  8012ea:	c1 f8 1f             	sar    $0x1f,%eax
  8012ed:	29 c2                	sub    %eax,%edx
  8012ef:	89 d0                	mov    %edx,%eax
  8012f1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f8:	75 bb                	jne    8012b5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801301:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801304:	48                   	dec    %eax
  801305:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801308:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80130c:	74 3d                	je     80134b <ltostr+0xc3>
		start = 1 ;
  80130e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801315:	eb 34                	jmp    80134b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132a:	01 c2                	add    %eax,%edx
  80132c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801332:	01 c8                	add    %ecx,%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801338:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c2                	add    %eax,%edx
  801340:	8a 45 eb             	mov    -0x15(%ebp),%al
  801343:	88 02                	mov    %al,(%edx)
		start++ ;
  801345:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801348:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80134b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801351:	7c c4                	jl     801317 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801353:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801356:	8b 45 0c             	mov    0xc(%ebp),%eax
  801359:	01 d0                	add    %edx,%eax
  80135b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80135e:	90                   	nop
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801367:	ff 75 08             	pushl  0x8(%ebp)
  80136a:	e8 73 fa ff ff       	call   800de2 <strlen>
  80136f:	83 c4 04             	add    $0x4,%esp
  801372:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 65 fa ff ff       	call   800de2 <strlen>
  80137d:	83 c4 04             	add    $0x4,%esp
  801380:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801383:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80138a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801391:	eb 17                	jmp    8013aa <strcconcat+0x49>
		final[s] = str1[s] ;
  801393:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 c2                	add    %eax,%edx
  80139b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	01 c8                	add    %ecx,%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a7:	ff 45 fc             	incl   -0x4(%ebp)
  8013aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013b0:	7c e1                	jl     801393 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013c0:	eb 1f                	jmp    8013e1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c5:	8d 50 01             	lea    0x1(%eax),%edx
  8013c8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013cb:	89 c2                	mov    %eax,%edx
  8013cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d0:	01 c2                	add    %eax,%edx
  8013d2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	01 c8                	add    %ecx,%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013de:	ff 45 f8             	incl   -0x8(%ebp)
  8013e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e7:	7c d9                	jl     8013c2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ef:	01 d0                	add    %edx,%eax
  8013f1:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f4:	90                   	nop
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801403:	8b 45 14             	mov    0x14(%ebp),%eax
  801406:	8b 00                	mov    (%eax),%eax
  801408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140f:	8b 45 10             	mov    0x10(%ebp),%eax
  801412:	01 d0                	add    %edx,%eax
  801414:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141a:	eb 0c                	jmp    801428 <strsplit+0x31>
			*string++ = 0;
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	8d 50 01             	lea    0x1(%eax),%edx
  801422:	89 55 08             	mov    %edx,0x8(%ebp)
  801425:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	74 18                	je     801449 <strsplit+0x52>
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	0f be c0             	movsbl %al,%eax
  801439:	50                   	push   %eax
  80143a:	ff 75 0c             	pushl  0xc(%ebp)
  80143d:	e8 32 fb ff ff       	call   800f74 <strchr>
  801442:	83 c4 08             	add    $0x8,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	75 d3                	jne    80141c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	84 c0                	test   %al,%al
  801450:	74 5a                	je     8014ac <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801452:	8b 45 14             	mov    0x14(%ebp),%eax
  801455:	8b 00                	mov    (%eax),%eax
  801457:	83 f8 0f             	cmp    $0xf,%eax
  80145a:	75 07                	jne    801463 <strsplit+0x6c>
		{
			return 0;
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
  801461:	eb 66                	jmp    8014c9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801463:	8b 45 14             	mov    0x14(%ebp),%eax
  801466:	8b 00                	mov    (%eax),%eax
  801468:	8d 48 01             	lea    0x1(%eax),%ecx
  80146b:	8b 55 14             	mov    0x14(%ebp),%edx
  80146e:	89 0a                	mov    %ecx,(%edx)
  801470:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801477:	8b 45 10             	mov    0x10(%ebp),%eax
  80147a:	01 c2                	add    %eax,%edx
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801481:	eb 03                	jmp    801486 <strsplit+0x8f>
			string++;
  801483:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	8a 00                	mov    (%eax),%al
  80148b:	84 c0                	test   %al,%al
  80148d:	74 8b                	je     80141a <strsplit+0x23>
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	0f be c0             	movsbl %al,%eax
  801497:	50                   	push   %eax
  801498:	ff 75 0c             	pushl  0xc(%ebp)
  80149b:	e8 d4 fa ff ff       	call   800f74 <strchr>
  8014a0:	83 c4 08             	add    $0x8,%esp
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	74 dc                	je     801483 <strsplit+0x8c>
			string++;
	}
  8014a7:	e9 6e ff ff ff       	jmp    80141a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014ac:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b0:	8b 00                	mov    (%eax),%eax
  8014b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	68 88 25 80 00       	push   $0x802588
  8014d9:	68 3f 01 00 00       	push   $0x13f
  8014de:	68 aa 25 80 00       	push   $0x8025aa
  8014e3:	e8 57 07 00 00       	call   801c3f <_panic>

008014e8 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8014ee:	83 ec 0c             	sub    $0xc,%esp
  8014f1:	ff 75 08             	pushl  0x8(%ebp)
  8014f4:	e8 ef 06 00 00       	call   801be8 <sys_sbrk>
  8014f9:	83 c4 10             	add    $0x10,%esp
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801504:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801508:	75 07                	jne    801511 <malloc+0x13>
  80150a:	b8 00 00 00 00       	mov    $0x0,%eax
  80150f:	eb 14                	jmp    801525 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	68 b8 25 80 00       	push   $0x8025b8
  801519:	6a 1b                	push   $0x1b
  80151b:	68 dd 25 80 00       	push   $0x8025dd
  801520:	e8 1a 07 00 00       	call   801c3f <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80152d:	83 ec 04             	sub    $0x4,%esp
  801530:	68 ec 25 80 00       	push   $0x8025ec
  801535:	6a 29                	push   $0x29
  801537:	68 dd 25 80 00       	push   $0x8025dd
  80153c:	e8 fe 06 00 00       	call   801c3f <_panic>

00801541 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 18             	sub    $0x18,%esp
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80154d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801551:	75 07                	jne    80155a <smalloc+0x19>
  801553:	b8 00 00 00 00       	mov    $0x0,%eax
  801558:	eb 14                	jmp    80156e <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80155a:	83 ec 04             	sub    $0x4,%esp
  80155d:	68 10 26 80 00       	push   $0x802610
  801562:	6a 38                	push   $0x38
  801564:	68 dd 25 80 00       	push   $0x8025dd
  801569:	e8 d1 06 00 00       	call   801c3f <_panic>
	return NULL;
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 38 26 80 00       	push   $0x802638
  80157e:	6a 43                	push   $0x43
  801580:	68 dd 25 80 00       	push   $0x8025dd
  801585:	e8 b5 06 00 00       	call   801c3f <_panic>

0080158a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801590:	83 ec 04             	sub    $0x4,%esp
  801593:	68 5c 26 80 00       	push   $0x80265c
  801598:	6a 5b                	push   $0x5b
  80159a:	68 dd 25 80 00       	push   $0x8025dd
  80159f:	e8 9b 06 00 00       	call   801c3f <_panic>

008015a4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015aa:	83 ec 04             	sub    $0x4,%esp
  8015ad:	68 80 26 80 00       	push   $0x802680
  8015b2:	6a 72                	push   $0x72
  8015b4:	68 dd 25 80 00       	push   $0x8025dd
  8015b9:	e8 81 06 00 00       	call   801c3f <_panic>

008015be <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	68 a6 26 80 00       	push   $0x8026a6
  8015cc:	6a 7e                	push   $0x7e
  8015ce:	68 dd 25 80 00       	push   $0x8025dd
  8015d3:	e8 67 06 00 00       	call   801c3f <_panic>

008015d8 <shrink>:

}
void shrink(uint32 newSize)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 a6 26 80 00       	push   $0x8026a6
  8015e6:	68 83 00 00 00       	push   $0x83
  8015eb:	68 dd 25 80 00       	push   $0x8025dd
  8015f0:	e8 4a 06 00 00       	call   801c3f <_panic>

008015f5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015fb:	83 ec 04             	sub    $0x4,%esp
  8015fe:	68 a6 26 80 00       	push   $0x8026a6
  801603:	68 88 00 00 00       	push   $0x88
  801608:	68 dd 25 80 00       	push   $0x8025dd
  80160d:	e8 2d 06 00 00       	call   801c3f <_panic>

00801612 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	57                   	push   %edi
  801616:	56                   	push   %esi
  801617:	53                   	push   %ebx
  801618:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801624:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801627:	8b 7d 18             	mov    0x18(%ebp),%edi
  80162a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80162d:	cd 30                	int    $0x30
  80162f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801632:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	5b                   	pop    %ebx
  801639:	5e                   	pop    %esi
  80163a:	5f                   	pop    %edi
  80163b:	5d                   	pop    %ebp
  80163c:	c3                   	ret    

0080163d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	8b 45 10             	mov    0x10(%ebp),%eax
  801646:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801649:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	52                   	push   %edx
  801655:	ff 75 0c             	pushl  0xc(%ebp)
  801658:	50                   	push   %eax
  801659:	6a 00                	push   $0x0
  80165b:	e8 b2 ff ff ff       	call   801612 <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
}
  801663:	90                   	nop
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_cgetc>:

int
sys_cgetc(void)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 02                	push   $0x2
  801675:	e8 98 ff ff ff       	call   801612 <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 03                	push   $0x3
  80168e:	e8 7f ff ff ff       	call   801612 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	90                   	nop
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 04                	push   $0x4
  8016a8:	e8 65 ff ff ff       	call   801612 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	90                   	nop
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	52                   	push   %edx
  8016c3:	50                   	push   %eax
  8016c4:	6a 08                	push   $0x8
  8016c6:	e8 47 ff ff ff       	call   801612 <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016d5:	8b 75 18             	mov    0x18(%ebp),%esi
  8016d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	56                   	push   %esi
  8016e5:	53                   	push   %ebx
  8016e6:	51                   	push   %ecx
  8016e7:	52                   	push   %edx
  8016e8:	50                   	push   %eax
  8016e9:	6a 09                	push   $0x9
  8016eb:	e8 22 ff ff ff       	call   801612 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5e                   	pop    %esi
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    

008016fa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	52                   	push   %edx
  80170a:	50                   	push   %eax
  80170b:	6a 0a                	push   $0xa
  80170d:	e8 00 ff ff ff       	call   801612 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	ff 75 0c             	pushl  0xc(%ebp)
  801723:	ff 75 08             	pushl  0x8(%ebp)
  801726:	6a 0b                	push   $0xb
  801728:	e8 e5 fe ff ff       	call   801612 <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 0c                	push   $0xc
  801741:	e8 cc fe ff ff       	call   801612 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 0d                	push   $0xd
  80175a:	e8 b3 fe ff ff       	call   801612 <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 0e                	push   $0xe
  801773:	e8 9a fe ff ff       	call   801612 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 0f                	push   $0xf
  80178c:	e8 81 fe ff ff       	call   801612 <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	ff 75 08             	pushl  0x8(%ebp)
  8017a4:	6a 10                	push   $0x10
  8017a6:	e8 67 fe ff ff       	call   801612 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 11                	push   $0x11
  8017bf:	e8 4e fe ff ff       	call   801612 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	90                   	nop
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_cputc>:

void
sys_cputc(const char c)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017d6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	50                   	push   %eax
  8017e3:	6a 01                	push   $0x1
  8017e5:	e8 28 fe ff ff       	call   801612 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	90                   	nop
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 14                	push   $0x14
  8017ff:	e8 0e fe ff ff       	call   801612 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	8b 45 10             	mov    0x10(%ebp),%eax
  801813:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801816:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801819:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	6a 00                	push   $0x0
  801822:	51                   	push   %ecx
  801823:	52                   	push   %edx
  801824:	ff 75 0c             	pushl  0xc(%ebp)
  801827:	50                   	push   %eax
  801828:	6a 15                	push   $0x15
  80182a:	e8 e3 fd ff ff       	call   801612 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	52                   	push   %edx
  801844:	50                   	push   %eax
  801845:	6a 16                	push   $0x16
  801847:	e8 c6 fd ff ff       	call   801612 <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801854:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	51                   	push   %ecx
  801862:	52                   	push   %edx
  801863:	50                   	push   %eax
  801864:	6a 17                	push   $0x17
  801866:	e8 a7 fd ff ff       	call   801612 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801873:	8b 55 0c             	mov    0xc(%ebp),%edx
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	52                   	push   %edx
  801880:	50                   	push   %eax
  801881:	6a 18                	push   $0x18
  801883:	e8 8a fd ff ff       	call   801612 <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	6a 00                	push   $0x0
  801895:	ff 75 14             	pushl  0x14(%ebp)
  801898:	ff 75 10             	pushl  0x10(%ebp)
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	50                   	push   %eax
  80189f:	6a 19                	push   $0x19
  8018a1:	e8 6c fd ff ff       	call   801612 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	50                   	push   %eax
  8018ba:	6a 1a                	push   $0x1a
  8018bc:	e8 51 fd ff ff       	call   801612 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	90                   	nop
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	50                   	push   %eax
  8018d6:	6a 1b                	push   $0x1b
  8018d8:	e8 35 fd ff ff       	call   801612 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 05                	push   $0x5
  8018f1:	e8 1c fd ff ff       	call   801612 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 06                	push   $0x6
  80190a:	e8 03 fd ff ff       	call   801612 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 07                	push   $0x7
  801923:	e8 ea fc ff ff       	call   801612 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_exit_env>:


void sys_exit_env(void)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 1c                	push   $0x1c
  80193c:	e8 d1 fc ff ff       	call   801612 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	90                   	nop
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80194d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801950:	8d 50 04             	lea    0x4(%eax),%edx
  801953:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	52                   	push   %edx
  80195d:	50                   	push   %eax
  80195e:	6a 1d                	push   $0x1d
  801960:	e8 ad fc ff ff       	call   801612 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
	return result;
  801968:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80196b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80196e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801971:	89 01                	mov    %eax,(%ecx)
  801973:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	c9                   	leave  
  80197a:	c2 04 00             	ret    $0x4

0080197d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	ff 75 10             	pushl  0x10(%ebp)
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	ff 75 08             	pushl  0x8(%ebp)
  80198d:	6a 13                	push   $0x13
  80198f:	e8 7e fc ff ff       	call   801612 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
	return ;
  801997:	90                   	nop
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_rcr2>:
uint32 sys_rcr2()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 1e                	push   $0x1e
  8019a9:	e8 64 fc ff ff       	call   801612 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 04             	sub    $0x4,%esp
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019bf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	50                   	push   %eax
  8019cc:	6a 1f                	push   $0x1f
  8019ce:	e8 3f fc ff ff       	call   801612 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d6:	90                   	nop
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <rsttst>:
void rsttst()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 21                	push   $0x21
  8019e8:	e8 25 fc ff ff       	call   801612 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f0:	90                   	nop
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019ff:	8b 55 18             	mov    0x18(%ebp),%edx
  801a02:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a06:	52                   	push   %edx
  801a07:	50                   	push   %eax
  801a08:	ff 75 10             	pushl  0x10(%ebp)
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	ff 75 08             	pushl  0x8(%ebp)
  801a11:	6a 20                	push   $0x20
  801a13:	e8 fa fb ff ff       	call   801612 <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1b:	90                   	nop
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <chktst>:
void chktst(uint32 n)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	ff 75 08             	pushl  0x8(%ebp)
  801a2c:	6a 22                	push   $0x22
  801a2e:	e8 df fb ff ff       	call   801612 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
	return ;
  801a36:	90                   	nop
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <inctst>:

void inctst()
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 23                	push   $0x23
  801a48:	e8 c5 fb ff ff       	call   801612 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a50:	90                   	nop
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <gettst>:
uint32 gettst()
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 24                	push   $0x24
  801a62:	e8 ab fb ff ff       	call   801612 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 25                	push   $0x25
  801a7e:	e8 8f fb ff ff       	call   801612 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
  801a86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a89:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a8d:	75 07                	jne    801a96 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a94:	eb 05                	jmp    801a9b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 25                	push   $0x25
  801aaf:	e8 5e fb ff ff       	call   801612 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
  801ab7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801aba:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801abe:	75 07                	jne    801ac7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ac0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac5:	eb 05                	jmp    801acc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 25                	push   $0x25
  801ae0:	e8 2d fb ff ff       	call   801612 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
  801ae8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801aeb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801aef:	75 07                	jne    801af8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801af1:	b8 01 00 00 00       	mov    $0x1,%eax
  801af6:	eb 05                	jmp    801afd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801af8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 25                	push   $0x25
  801b11:	e8 fc fa ff ff       	call   801612 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
  801b19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b1c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b20:	75 07                	jne    801b29 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b22:	b8 01 00 00 00       	mov    $0x1,%eax
  801b27:	eb 05                	jmp    801b2e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 08             	pushl  0x8(%ebp)
  801b3e:	6a 26                	push   $0x26
  801b40:	e8 cd fa ff ff       	call   801612 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
	return ;
  801b48:	90                   	nop
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b4f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	53                   	push   %ebx
  801b5e:	51                   	push   %ecx
  801b5f:	52                   	push   %edx
  801b60:	50                   	push   %eax
  801b61:	6a 27                	push   $0x27
  801b63:	e8 aa fa ff ff       	call   801612 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 28                	push   $0x28
  801b83:	e8 8a fa ff ff       	call   801612 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b90:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	51                   	push   %ecx
  801b9c:	ff 75 10             	pushl  0x10(%ebp)
  801b9f:	52                   	push   %edx
  801ba0:	50                   	push   %eax
  801ba1:	6a 29                	push   $0x29
  801ba3:	e8 6a fa ff ff       	call   801612 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	ff 75 10             	pushl  0x10(%ebp)
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	ff 75 08             	pushl  0x8(%ebp)
  801bbd:	6a 12                	push   $0x12
  801bbf:	e8 4e fa ff ff       	call   801612 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc7:	90                   	nop
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	52                   	push   %edx
  801bda:	50                   	push   %eax
  801bdb:	6a 2a                	push   $0x2a
  801bdd:	e8 30 fa ff ff       	call   801612 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
	return;
  801be5:	90                   	nop
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	68 b6 26 80 00       	push   $0x8026b6
  801bf6:	68 2e 01 00 00       	push   $0x12e
  801bfb:	68 ca 26 80 00       	push   $0x8026ca
  801c00:	e8 3a 00 00 00       	call   801c3f <_panic>

00801c05 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	68 b6 26 80 00       	push   $0x8026b6
  801c13:	68 35 01 00 00       	push   $0x135
  801c18:	68 ca 26 80 00       	push   $0x8026ca
  801c1d:	e8 1d 00 00 00       	call   801c3f <_panic>

00801c22 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	68 b6 26 80 00       	push   $0x8026b6
  801c30:	68 3b 01 00 00       	push   $0x13b
  801c35:	68 ca 26 80 00       	push   $0x8026ca
  801c3a:	e8 00 00 00 00       	call   801c3f <_panic>

00801c3f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801c45:	8d 45 10             	lea    0x10(%ebp),%eax
  801c48:	83 c0 04             	add    $0x4,%eax
  801c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801c4e:	a1 24 30 80 00       	mov    0x803024,%eax
  801c53:	85 c0                	test   %eax,%eax
  801c55:	74 16                	je     801c6d <_panic+0x2e>
		cprintf("%s: ", argv0);
  801c57:	a1 24 30 80 00       	mov    0x803024,%eax
  801c5c:	83 ec 08             	sub    $0x8,%esp
  801c5f:	50                   	push   %eax
  801c60:	68 d8 26 80 00       	push   $0x8026d8
  801c65:	e8 e4 ea ff ff       	call   80074e <cprintf>
  801c6a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801c6d:	a1 00 30 80 00       	mov    0x803000,%eax
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	50                   	push   %eax
  801c79:	68 dd 26 80 00       	push   $0x8026dd
  801c7e:	e8 cb ea ff ff       	call   80074e <cprintf>
  801c83:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801c86:	8b 45 10             	mov    0x10(%ebp),%eax
  801c89:	83 ec 08             	sub    $0x8,%esp
  801c8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c8f:	50                   	push   %eax
  801c90:	e8 4e ea ff ff       	call   8006e3 <vcprintf>
  801c95:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801c98:	83 ec 08             	sub    $0x8,%esp
  801c9b:	6a 00                	push   $0x0
  801c9d:	68 f9 26 80 00       	push   $0x8026f9
  801ca2:	e8 3c ea ff ff       	call   8006e3 <vcprintf>
  801ca7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801caa:	e8 bd e9 ff ff       	call   80066c <exit>

	// should not return here
	while (1) ;
  801caf:	eb fe                	jmp    801caf <_panic+0x70>

00801cb1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801cb7:	a1 04 30 80 00       	mov    0x803004,%eax
  801cbc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc5:	39 c2                	cmp    %eax,%edx
  801cc7:	74 14                	je     801cdd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	68 fc 26 80 00       	push   $0x8026fc
  801cd1:	6a 26                	push   $0x26
  801cd3:	68 48 27 80 00       	push   $0x802748
  801cd8:	e8 62 ff ff ff       	call   801c3f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801cdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801ce4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ceb:	e9 c5 00 00 00       	jmp    801db5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	01 d0                	add    %edx,%eax
  801cff:	8b 00                	mov    (%eax),%eax
  801d01:	85 c0                	test   %eax,%eax
  801d03:	75 08                	jne    801d0d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801d05:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801d08:	e9 a5 00 00 00       	jmp    801db2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801d0d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d14:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d1b:	eb 69                	jmp    801d86 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801d1d:	a1 04 30 80 00       	mov    0x803004,%eax
  801d22:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801d28:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d2b:	89 d0                	mov    %edx,%eax
  801d2d:	01 c0                	add    %eax,%eax
  801d2f:	01 d0                	add    %edx,%eax
  801d31:	c1 e0 03             	shl    $0x3,%eax
  801d34:	01 c8                	add    %ecx,%eax
  801d36:	8a 40 04             	mov    0x4(%eax),%al
  801d39:	84 c0                	test   %al,%al
  801d3b:	75 46                	jne    801d83 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d3d:	a1 04 30 80 00       	mov    0x803004,%eax
  801d42:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801d48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d4b:	89 d0                	mov    %edx,%eax
  801d4d:	01 c0                	add    %eax,%eax
  801d4f:	01 d0                	add    %edx,%eax
  801d51:	c1 e0 03             	shl    $0x3,%eax
  801d54:	01 c8                	add    %ecx,%eax
  801d56:	8b 00                	mov    (%eax),%eax
  801d58:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d63:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d68:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	01 c8                	add    %ecx,%eax
  801d74:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d76:	39 c2                	cmp    %eax,%edx
  801d78:	75 09                	jne    801d83 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801d7a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801d81:	eb 15                	jmp    801d98 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d83:	ff 45 e8             	incl   -0x18(%ebp)
  801d86:	a1 04 30 80 00       	mov    0x803004,%eax
  801d8b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801d91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d94:	39 c2                	cmp    %eax,%edx
  801d96:	77 85                	ja     801d1d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801d98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d9c:	75 14                	jne    801db2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	68 54 27 80 00       	push   $0x802754
  801da6:	6a 3a                	push   $0x3a
  801da8:	68 48 27 80 00       	push   $0x802748
  801dad:	e8 8d fe ff ff       	call   801c3f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801db2:	ff 45 f0             	incl   -0x10(%ebp)
  801db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801dbb:	0f 8c 2f ff ff ff    	jl     801cf0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801dc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801dc8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801dcf:	eb 26                	jmp    801df7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801dd1:	a1 04 30 80 00       	mov    0x803004,%eax
  801dd6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801ddc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ddf:	89 d0                	mov    %edx,%eax
  801de1:	01 c0                	add    %eax,%eax
  801de3:	01 d0                	add    %edx,%eax
  801de5:	c1 e0 03             	shl    $0x3,%eax
  801de8:	01 c8                	add    %ecx,%eax
  801dea:	8a 40 04             	mov    0x4(%eax),%al
  801ded:	3c 01                	cmp    $0x1,%al
  801def:	75 03                	jne    801df4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801df1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801df4:	ff 45 e0             	incl   -0x20(%ebp)
  801df7:	a1 04 30 80 00       	mov    0x803004,%eax
  801dfc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e05:	39 c2                	cmp    %eax,%edx
  801e07:	77 c8                	ja     801dd1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e0f:	74 14                	je     801e25 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	68 a8 27 80 00       	push   $0x8027a8
  801e19:	6a 44                	push   $0x44
  801e1b:	68 48 27 80 00       	push   $0x802748
  801e20:	e8 1a fe ff ff       	call   801c3f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801e25:	90                   	nop
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <__udivdi3>:
  801e28:	55                   	push   %ebp
  801e29:	57                   	push   %edi
  801e2a:	56                   	push   %esi
  801e2b:	53                   	push   %ebx
  801e2c:	83 ec 1c             	sub    $0x1c,%esp
  801e2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e3f:	89 ca                	mov    %ecx,%edx
  801e41:	89 f8                	mov    %edi,%eax
  801e43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e47:	85 f6                	test   %esi,%esi
  801e49:	75 2d                	jne    801e78 <__udivdi3+0x50>
  801e4b:	39 cf                	cmp    %ecx,%edi
  801e4d:	77 65                	ja     801eb4 <__udivdi3+0x8c>
  801e4f:	89 fd                	mov    %edi,%ebp
  801e51:	85 ff                	test   %edi,%edi
  801e53:	75 0b                	jne    801e60 <__udivdi3+0x38>
  801e55:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5a:	31 d2                	xor    %edx,%edx
  801e5c:	f7 f7                	div    %edi
  801e5e:	89 c5                	mov    %eax,%ebp
  801e60:	31 d2                	xor    %edx,%edx
  801e62:	89 c8                	mov    %ecx,%eax
  801e64:	f7 f5                	div    %ebp
  801e66:	89 c1                	mov    %eax,%ecx
  801e68:	89 d8                	mov    %ebx,%eax
  801e6a:	f7 f5                	div    %ebp
  801e6c:	89 cf                	mov    %ecx,%edi
  801e6e:	89 fa                	mov    %edi,%edx
  801e70:	83 c4 1c             	add    $0x1c,%esp
  801e73:	5b                   	pop    %ebx
  801e74:	5e                   	pop    %esi
  801e75:	5f                   	pop    %edi
  801e76:	5d                   	pop    %ebp
  801e77:	c3                   	ret    
  801e78:	39 ce                	cmp    %ecx,%esi
  801e7a:	77 28                	ja     801ea4 <__udivdi3+0x7c>
  801e7c:	0f bd fe             	bsr    %esi,%edi
  801e7f:	83 f7 1f             	xor    $0x1f,%edi
  801e82:	75 40                	jne    801ec4 <__udivdi3+0x9c>
  801e84:	39 ce                	cmp    %ecx,%esi
  801e86:	72 0a                	jb     801e92 <__udivdi3+0x6a>
  801e88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e8c:	0f 87 9e 00 00 00    	ja     801f30 <__udivdi3+0x108>
  801e92:	b8 01 00 00 00       	mov    $0x1,%eax
  801e97:	89 fa                	mov    %edi,%edx
  801e99:	83 c4 1c             	add    $0x1c,%esp
  801e9c:	5b                   	pop    %ebx
  801e9d:	5e                   	pop    %esi
  801e9e:	5f                   	pop    %edi
  801e9f:	5d                   	pop    %ebp
  801ea0:	c3                   	ret    
  801ea1:	8d 76 00             	lea    0x0(%esi),%esi
  801ea4:	31 ff                	xor    %edi,%edi
  801ea6:	31 c0                	xor    %eax,%eax
  801ea8:	89 fa                	mov    %edi,%edx
  801eaa:	83 c4 1c             	add    $0x1c,%esp
  801ead:	5b                   	pop    %ebx
  801eae:	5e                   	pop    %esi
  801eaf:	5f                   	pop    %edi
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    
  801eb2:	66 90                	xchg   %ax,%ax
  801eb4:	89 d8                	mov    %ebx,%eax
  801eb6:	f7 f7                	div    %edi
  801eb8:	31 ff                	xor    %edi,%edi
  801eba:	89 fa                	mov    %edi,%edx
  801ebc:	83 c4 1c             	add    $0x1c,%esp
  801ebf:	5b                   	pop    %ebx
  801ec0:	5e                   	pop    %esi
  801ec1:	5f                   	pop    %edi
  801ec2:	5d                   	pop    %ebp
  801ec3:	c3                   	ret    
  801ec4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ec9:	89 eb                	mov    %ebp,%ebx
  801ecb:	29 fb                	sub    %edi,%ebx
  801ecd:	89 f9                	mov    %edi,%ecx
  801ecf:	d3 e6                	shl    %cl,%esi
  801ed1:	89 c5                	mov    %eax,%ebp
  801ed3:	88 d9                	mov    %bl,%cl
  801ed5:	d3 ed                	shr    %cl,%ebp
  801ed7:	89 e9                	mov    %ebp,%ecx
  801ed9:	09 f1                	or     %esi,%ecx
  801edb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801edf:	89 f9                	mov    %edi,%ecx
  801ee1:	d3 e0                	shl    %cl,%eax
  801ee3:	89 c5                	mov    %eax,%ebp
  801ee5:	89 d6                	mov    %edx,%esi
  801ee7:	88 d9                	mov    %bl,%cl
  801ee9:	d3 ee                	shr    %cl,%esi
  801eeb:	89 f9                	mov    %edi,%ecx
  801eed:	d3 e2                	shl    %cl,%edx
  801eef:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ef3:	88 d9                	mov    %bl,%cl
  801ef5:	d3 e8                	shr    %cl,%eax
  801ef7:	09 c2                	or     %eax,%edx
  801ef9:	89 d0                	mov    %edx,%eax
  801efb:	89 f2                	mov    %esi,%edx
  801efd:	f7 74 24 0c          	divl   0xc(%esp)
  801f01:	89 d6                	mov    %edx,%esi
  801f03:	89 c3                	mov    %eax,%ebx
  801f05:	f7 e5                	mul    %ebp
  801f07:	39 d6                	cmp    %edx,%esi
  801f09:	72 19                	jb     801f24 <__udivdi3+0xfc>
  801f0b:	74 0b                	je     801f18 <__udivdi3+0xf0>
  801f0d:	89 d8                	mov    %ebx,%eax
  801f0f:	31 ff                	xor    %edi,%edi
  801f11:	e9 58 ff ff ff       	jmp    801e6e <__udivdi3+0x46>
  801f16:	66 90                	xchg   %ax,%ax
  801f18:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f1c:	89 f9                	mov    %edi,%ecx
  801f1e:	d3 e2                	shl    %cl,%edx
  801f20:	39 c2                	cmp    %eax,%edx
  801f22:	73 e9                	jae    801f0d <__udivdi3+0xe5>
  801f24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f27:	31 ff                	xor    %edi,%edi
  801f29:	e9 40 ff ff ff       	jmp    801e6e <__udivdi3+0x46>
  801f2e:	66 90                	xchg   %ax,%ax
  801f30:	31 c0                	xor    %eax,%eax
  801f32:	e9 37 ff ff ff       	jmp    801e6e <__udivdi3+0x46>
  801f37:	90                   	nop

00801f38 <__umoddi3>:
  801f38:	55                   	push   %ebp
  801f39:	57                   	push   %edi
  801f3a:	56                   	push   %esi
  801f3b:	53                   	push   %ebx
  801f3c:	83 ec 1c             	sub    $0x1c,%esp
  801f3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f43:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f57:	89 f3                	mov    %esi,%ebx
  801f59:	89 fa                	mov    %edi,%edx
  801f5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f5f:	89 34 24             	mov    %esi,(%esp)
  801f62:	85 c0                	test   %eax,%eax
  801f64:	75 1a                	jne    801f80 <__umoddi3+0x48>
  801f66:	39 f7                	cmp    %esi,%edi
  801f68:	0f 86 a2 00 00 00    	jbe    802010 <__umoddi3+0xd8>
  801f6e:	89 c8                	mov    %ecx,%eax
  801f70:	89 f2                	mov    %esi,%edx
  801f72:	f7 f7                	div    %edi
  801f74:	89 d0                	mov    %edx,%eax
  801f76:	31 d2                	xor    %edx,%edx
  801f78:	83 c4 1c             	add    $0x1c,%esp
  801f7b:	5b                   	pop    %ebx
  801f7c:	5e                   	pop    %esi
  801f7d:	5f                   	pop    %edi
  801f7e:	5d                   	pop    %ebp
  801f7f:	c3                   	ret    
  801f80:	39 f0                	cmp    %esi,%eax
  801f82:	0f 87 ac 00 00 00    	ja     802034 <__umoddi3+0xfc>
  801f88:	0f bd e8             	bsr    %eax,%ebp
  801f8b:	83 f5 1f             	xor    $0x1f,%ebp
  801f8e:	0f 84 ac 00 00 00    	je     802040 <__umoddi3+0x108>
  801f94:	bf 20 00 00 00       	mov    $0x20,%edi
  801f99:	29 ef                	sub    %ebp,%edi
  801f9b:	89 fe                	mov    %edi,%esi
  801f9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fa1:	89 e9                	mov    %ebp,%ecx
  801fa3:	d3 e0                	shl    %cl,%eax
  801fa5:	89 d7                	mov    %edx,%edi
  801fa7:	89 f1                	mov    %esi,%ecx
  801fa9:	d3 ef                	shr    %cl,%edi
  801fab:	09 c7                	or     %eax,%edi
  801fad:	89 e9                	mov    %ebp,%ecx
  801faf:	d3 e2                	shl    %cl,%edx
  801fb1:	89 14 24             	mov    %edx,(%esp)
  801fb4:	89 d8                	mov    %ebx,%eax
  801fb6:	d3 e0                	shl    %cl,%eax
  801fb8:	89 c2                	mov    %eax,%edx
  801fba:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fbe:	d3 e0                	shl    %cl,%eax
  801fc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fc8:	89 f1                	mov    %esi,%ecx
  801fca:	d3 e8                	shr    %cl,%eax
  801fcc:	09 d0                	or     %edx,%eax
  801fce:	d3 eb                	shr    %cl,%ebx
  801fd0:	89 da                	mov    %ebx,%edx
  801fd2:	f7 f7                	div    %edi
  801fd4:	89 d3                	mov    %edx,%ebx
  801fd6:	f7 24 24             	mull   (%esp)
  801fd9:	89 c6                	mov    %eax,%esi
  801fdb:	89 d1                	mov    %edx,%ecx
  801fdd:	39 d3                	cmp    %edx,%ebx
  801fdf:	0f 82 87 00 00 00    	jb     80206c <__umoddi3+0x134>
  801fe5:	0f 84 91 00 00 00    	je     80207c <__umoddi3+0x144>
  801feb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fef:	29 f2                	sub    %esi,%edx
  801ff1:	19 cb                	sbb    %ecx,%ebx
  801ff3:	89 d8                	mov    %ebx,%eax
  801ff5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ff9:	d3 e0                	shl    %cl,%eax
  801ffb:	89 e9                	mov    %ebp,%ecx
  801ffd:	d3 ea                	shr    %cl,%edx
  801fff:	09 d0                	or     %edx,%eax
  802001:	89 e9                	mov    %ebp,%ecx
  802003:	d3 eb                	shr    %cl,%ebx
  802005:	89 da                	mov    %ebx,%edx
  802007:	83 c4 1c             	add    $0x1c,%esp
  80200a:	5b                   	pop    %ebx
  80200b:	5e                   	pop    %esi
  80200c:	5f                   	pop    %edi
  80200d:	5d                   	pop    %ebp
  80200e:	c3                   	ret    
  80200f:	90                   	nop
  802010:	89 fd                	mov    %edi,%ebp
  802012:	85 ff                	test   %edi,%edi
  802014:	75 0b                	jne    802021 <__umoddi3+0xe9>
  802016:	b8 01 00 00 00       	mov    $0x1,%eax
  80201b:	31 d2                	xor    %edx,%edx
  80201d:	f7 f7                	div    %edi
  80201f:	89 c5                	mov    %eax,%ebp
  802021:	89 f0                	mov    %esi,%eax
  802023:	31 d2                	xor    %edx,%edx
  802025:	f7 f5                	div    %ebp
  802027:	89 c8                	mov    %ecx,%eax
  802029:	f7 f5                	div    %ebp
  80202b:	89 d0                	mov    %edx,%eax
  80202d:	e9 44 ff ff ff       	jmp    801f76 <__umoddi3+0x3e>
  802032:	66 90                	xchg   %ax,%ax
  802034:	89 c8                	mov    %ecx,%eax
  802036:	89 f2                	mov    %esi,%edx
  802038:	83 c4 1c             	add    $0x1c,%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5f                   	pop    %edi
  80203e:	5d                   	pop    %ebp
  80203f:	c3                   	ret    
  802040:	3b 04 24             	cmp    (%esp),%eax
  802043:	72 06                	jb     80204b <__umoddi3+0x113>
  802045:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802049:	77 0f                	ja     80205a <__umoddi3+0x122>
  80204b:	89 f2                	mov    %esi,%edx
  80204d:	29 f9                	sub    %edi,%ecx
  80204f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802053:	89 14 24             	mov    %edx,(%esp)
  802056:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80205a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80205e:	8b 14 24             	mov    (%esp),%edx
  802061:	83 c4 1c             	add    $0x1c,%esp
  802064:	5b                   	pop    %ebx
  802065:	5e                   	pop    %esi
  802066:	5f                   	pop    %edi
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    
  802069:	8d 76 00             	lea    0x0(%esi),%esi
  80206c:	2b 04 24             	sub    (%esp),%eax
  80206f:	19 fa                	sbb    %edi,%edx
  802071:	89 d1                	mov    %edx,%ecx
  802073:	89 c6                	mov    %eax,%esi
  802075:	e9 71 ff ff ff       	jmp    801feb <__umoddi3+0xb3>
  80207a:	66 90                	xchg   %ax,%ax
  80207c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802080:	72 ea                	jb     80206c <__umoddi3+0x134>
  802082:	89 d9                	mov    %ebx,%ecx
  802084:	e9 62 ff ff ff       	jmp    801feb <__umoddi3+0xb3>
