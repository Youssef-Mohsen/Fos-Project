
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 1c 0b 00 00       	call   800b52 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
	int envID = sys_getenvid();
  800044:	e8 8f 25 00 00       	call   8025d8 <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 66 ff ff ff    	lea    -0x9a(%ebp),%eax
  80007c:	bb d2 49 80 00       	mov    $0x8049d2,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800094:	bb dc 49 80 00       	mov    $0x8049dc,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  8000ac:	bb e8 49 80 00       	mov    $0x8049e8,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000c4:	bb f7 49 80 00       	mov    $0x8049f7,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8000dc:	bb 06 4a 80 00       	mov    $0x804a06,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8000f4:	bb 1b 4a 80 00       	mov    $0x804a1b,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  80010c:	bb 30 4a 80 00       	mov    $0x804a30,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	bb 41 4a 80 00       	mov    $0x804a41,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80013c:	bb 52 4a 80 00       	mov    $0x804a52,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800154:	bb 63 4a 80 00       	mov    $0x804a63,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80016c:	bb 6c 4a 80 00       	mov    $0x804a6c,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  800184:	bb 76 4a 80 00       	mov    $0x804a76,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b5 fe ff ff    	lea    -0x14b(%ebp),%eax
  80019c:	bb 81 4a 80 00       	mov    $0x804a81,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 ab fe ff ff    	lea    -0x155(%ebp),%eax
  8001b4:	bb 8d 4a 80 00       	mov    $0x804a8d,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a1 fe ff ff    	lea    -0x15f(%ebp),%eax
  8001cc:	bb 97 4a 80 00       	mov    $0x804a97,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9b fe ff ff 63 	movl   $0x72656c63,-0x165(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 9f fe ff ff 	movw   $0x6b,-0x161(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 8d fe ff ff    	lea    -0x173(%ebp),%eax
  8001f7:	bb a1 4a 80 00       	mov    $0x804aa1,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 7e fe ff ff    	lea    -0x182(%ebp),%eax
  80020f:	bb af 4a 80 00       	mov    $0x804aaf,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800227:	bb be 4a 80 00       	mov    $0x804abe,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  80023f:	bb c5 4a 80 00       	mov    $0x804ac5,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 66 ff ff ff    	lea    -0x9a(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 b3 1d 00 00       	call   80201c <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 d5 1c 00 00       	call   80201c <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 b3 1c 00 00       	call   80201c <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 92 1c 00 00       	call   80201c <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 71 1c 00 00       	call   80201c <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 4f 1c 00 00       	call   80201c <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 28 1c 00 00       	call   80201c <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 0a 1c 00 00       	call   80201c <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 ec 1b 00 00       	call   80201c <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 d3 1b 00 00       	call   80201c <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 ab 1b 00 00       	call   80201c <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************

	struct semaphore flight1CS = create_semaphore(_flight1CS, 1);
  800486:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  80048c:	83 ec 04             	sub    $0x4,%esp
  80048f:	6a 01                	push   $0x1
  800491:	8d 95 ab fe ff ff    	lea    -0x155(%ebp),%edx
  800497:	52                   	push   %edx
  800498:	50                   	push   %eax
  800499:	e8 2c 3f 00 00       	call   8043ca <create_semaphore>
  80049e:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  8004a1:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	6a 01                	push   $0x1
  8004ac:	8d 95 a1 fe ff ff    	lea    -0x15f(%ebp),%edx
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	e8 11 3f 00 00       	call   8043ca <create_semaphore>
  8004b9:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  8004bc:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 95 8d fe ff ff    	lea    -0x173(%ebp),%edx
  8004cd:	52                   	push   %edx
  8004ce:	50                   	push   %eax
  8004cf:	e8 f6 3e 00 00       	call   8043ca <create_semaphore>
  8004d4:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  8004d7:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	6a 01                	push   $0x1
  8004e2:	8d 95 b5 fe ff ff    	lea    -0x14b(%ebp),%edx
  8004e8:	52                   	push   %edx
  8004e9:	50                   	push   %eax
  8004ea:	e8 db 3e 00 00       	call   8043ca <create_semaphore>
  8004ef:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  8004f2:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	6a 03                	push   $0x3
  8004fd:	8d 95 9b fe ff ff    	lea    -0x165(%ebp),%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	e8 c0 3e 00 00       	call   8043ca <create_semaphore>
  80050a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  80050d:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	6a 00                	push   $0x0
  800518:	8d 95 c1 fe ff ff    	lea    -0x13f(%ebp),%edx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	e8 a5 3e 00 00       	call   8043ca <create_semaphore>
  800525:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  800528:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	6a 00                	push   $0x0
  800533:	8d 95 7e fe ff ff    	lea    -0x182(%ebp),%edx
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	e8 8a 3e 00 00       	call   8043ca <create_semaphore>
  800540:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  800543:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	6a 01                	push   $0x1
  80054e:	50                   	push   %eax
  80054f:	68 60 47 80 00       	push   $0x804760
  800554:	e8 c3 1a 00 00       	call   80201c <smalloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

	int s=0;
  800562:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800569:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800570:	e9 9a 00 00 00       	jmp    80060f <_main+0x5d7>
	{
		char prefix[30]="cust_finished";
  800575:	8d 85 36 fe ff ff    	lea    -0x1ca(%ebp),%eax
  80057b:	bb cc 4a 80 00       	mov    $0x804acc,%ebx
  800580:	ba 0e 00 00 00       	mov    $0xe,%edx
  800585:	89 c7                	mov    %eax,%edi
  800587:	89 de                	mov    %ebx,%esi
  800589:	89 d1                	mov    %edx,%ecx
  80058b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80058d:	8d 95 44 fe ff ff    	lea    -0x1bc(%ebp),%edx
  800593:	b9 04 00 00 00       	mov    $0x4,%ecx
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 d7                	mov    %edx,%edi
  80059f:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	8d 85 31 fe ff ff    	lea    -0x1cf(%ebp),%eax
  8005aa:	50                   	push   %eax
  8005ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8005ae:	e8 d5 14 00 00       	call   801a88 <ltostr>
  8005b3:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	8d 85 ff fd ff ff    	lea    -0x201(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	8d 85 31 fe ff ff    	lea    -0x1cf(%ebp),%eax
  8005c6:	50                   	push   %eax
  8005c7:	8d 85 36 fe ff ff    	lea    -0x1ca(%ebp),%eax
  8005cd:	50                   	push   %eax
  8005ce:	e8 8e 15 00 00       	call   801b61 <strcconcat>
  8005d3:	83 c4 10             	add    $0x10,%esp
		//sys_createSemaphore(sname, 0);
		cust_finished[s] = create_semaphore(sname, 0);
  8005d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8005e9:	8d 85 f4 fd ff ff    	lea    -0x20c(%ebp),%eax
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	6a 00                	push   $0x0
  8005f4:	8d 95 ff fd ff ff    	lea    -0x201(%ebp),%edx
  8005fa:	52                   	push   %edx
  8005fb:	50                   	push   %eax
  8005fc:	e8 c9 3d 00 00       	call   8043ca <create_semaphore>
  800601:	83 c4 0c             	add    $0xc,%esp
  800604:	8b 85 f4 fd ff ff    	mov    -0x20c(%ebp),%eax
  80060a:	89 03                	mov    %eax,(%ebx)
	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  80060c:	ff 45 d8             	incl   -0x28(%ebp)
  80060f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800612:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800615:	0f 8c 5a ff ff ff    	jl     800575 <_main+0x53d>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80061b:	a1 20 60 80 00       	mov    0x806020,%eax
  800620:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800626:	a1 20 60 80 00       	mov    0x806020,%eax
  80062b:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800631:	89 c1                	mov    %eax,%ecx
  800633:	a1 20 60 80 00       	mov    0x806020,%eax
  800638:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80063e:	52                   	push   %edx
  80063f:	51                   	push   %ecx
  800640:	50                   	push   %eax
  800641:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800647:	50                   	push   %eax
  800648:	e8 36 1f 00 00       	call   802583 <sys_create_env>
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  800656:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 3c 1f 00 00       	call   8025a1 <sys_run_env>
  800665:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800668:	a1 20 60 80 00       	mov    0x806020,%eax
  80066d:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800673:	a1 20 60 80 00       	mov    0x806020,%eax
  800678:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80067e:	89 c1                	mov    %eax,%ecx
  800680:	a1 20 60 80 00       	mov    0x806020,%eax
  800685:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80068b:	52                   	push   %edx
  80068c:	51                   	push   %ecx
  80068d:	50                   	push   %eax
  80068e:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800694:	50                   	push   %eax
  800695:	e8 e9 1e 00 00       	call   802583 <sys_create_env>
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006a3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	50                   	push   %eax
  8006ad:	e8 ef 1e 00 00       	call   8025a1 <sys_run_env>
  8006b2:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8006b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8006ba:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8006c0:	a1 20 60 80 00       	mov    0x806020,%eax
  8006c5:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8006cb:	89 c1                	mov    %eax,%ecx
  8006cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8006d2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8006d8:	52                   	push   %edx
  8006d9:	51                   	push   %ecx
  8006da:	50                   	push   %eax
  8006db:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8006e1:	50                   	push   %eax
  8006e2:	e8 9c 1e 00 00       	call   802583 <sys_create_env>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	50                   	push   %eax
  8006fa:	e8 a2 1e 00 00       	call   8025a1 <sys_run_env>
  8006ff:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800702:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800709:	eb 70                	jmp    80077b <_main+0x743>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80070b:	a1 20 60 80 00       	mov    0x806020,%eax
  800710:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800716:	a1 20 60 80 00       	mov    0x806020,%eax
  80071b:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800721:	89 c1                	mov    %eax,%ecx
  800723:	a1 20 60 80 00       	mov    0x806020,%eax
  800728:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80072e:	52                   	push   %edx
  80072f:	51                   	push   %ecx
  800730:	50                   	push   %eax
  800731:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  800737:	50                   	push   %eax
  800738:	e8 46 1e 00 00       	call   802583 <sys_create_env>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800746:	83 bd 70 ff ff ff ef 	cmpl   $0xffffffef,-0x90(%ebp)
  80074d:	75 17                	jne    800766 <_main+0x72e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	68 74 47 80 00       	push   $0x804774
  800757:	68 98 00 00 00       	push   $0x98
  80075c:	68 ba 47 80 00       	push   $0x8047ba
  800761:	e8 2b 05 00 00       	call   800c91 <_panic>

		sys_run_env(envId);
  800766:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	50                   	push   %eax
  800770:	e8 2c 1e 00 00       	call   8025a1 <sys_run_env>
  800775:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800778:	ff 45 d4             	incl   -0x2c(%ebp)
  80077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80077e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800781:	7c 88                	jl     80070b <_main+0x6d3>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  800783:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  80078a:	eb 14                	jmp    8007a0 <_main+0x768>
	{
		wait_semaphore(custTerminated);
  80078c:	83 ec 0c             	sub    $0xc,%esp
  80078f:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800795:	e8 64 3c 00 00       	call   8043fe <wait_semaphore>
  80079a:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80079d:	ff 45 d4             	incl   -0x2c(%ebp)
  8007a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007a3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8007a6:	7c e4                	jl     80078c <_main+0x754>
	{
		wait_semaphore(custTerminated);
	}

	env_sleep(1500);
  8007a8:	83 ec 0c             	sub    $0xc,%esp
  8007ab:	68 dc 05 00 00       	push   $0x5dc
  8007b0:	e8 88 3c 00 00       	call   80443d <env_sleep>
  8007b5:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  8007b8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8007bf:	eb 45                	jmp    800806 <_main+0x7ce>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  8007c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007cb:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007d9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007ea:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ed:	01 c8                	add    %ecx,%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	83 ec 04             	sub    $0x4,%esp
  8007f4:	52                   	push   %edx
  8007f5:	50                   	push   %eax
  8007f6:	68 cc 47 80 00       	push   $0x8047cc
  8007fb:	e8 4e 07 00 00       	call   800f4e <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800803:	ff 45 d0             	incl   -0x30(%ebp)
  800806:	8b 45 90             	mov    -0x70(%ebp),%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80080e:	7f b1                	jg     8007c1 <_main+0x789>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800810:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800817:	eb 45                	jmp    80085e <_main+0x826>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800819:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800823:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800826:	01 d0                	add    %edx,%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800831:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800834:	01 d0                	add    %edx,%eax
  800836:	8b 10                	mov    (%eax),%edx
  800838:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80083b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800842:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800845:	01 c8                	add    %ecx,%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	83 ec 04             	sub    $0x4,%esp
  80084c:	52                   	push   %edx
  80084d:	50                   	push   %eax
  80084e:	68 fc 47 80 00       	push   $0x8047fc
  800853:	e8 f6 06 00 00       	call   800f4e <cprintf>
  800858:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80085b:	ff 45 d0             	incl   -0x30(%ebp)
  80085e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800866:	7f b1                	jg     800819 <_main+0x7e1>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  800868:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  80086f:	eb 33                	jmp    8008a4 <_main+0x86c>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  800871:	83 ec 04             	sub    $0x4,%esp
  800874:	ff 75 cc             	pushl  -0x34(%ebp)
  800877:	ff 75 a8             	pushl  -0x58(%ebp)
  80087a:	ff 75 88             	pushl  -0x78(%ebp)
  80087d:	e8 8b 02 00 00       	call   800b0d <find>
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	83 f8 01             	cmp    $0x1,%eax
  800888:	74 17                	je     8008a1 <_main+0x869>
			{
				panic("Error, wrong booking for user %d\n", f1);
  80088a:	ff 75 cc             	pushl  -0x34(%ebp)
  80088d:	68 2c 48 80 00       	push   $0x80482c
  800892:	68 b8 00 00 00       	push   $0xb8
  800897:	68 ba 47 80 00       	push   $0x8047ba
  80089c:	e8 f0 03 00 00       	call   800c91 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8008a1:	ff 45 cc             	incl   -0x34(%ebp)
  8008a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008a7:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8008aa:	7c c5                	jl     800871 <_main+0x839>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  8008ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008af:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8008b2:	eb 33                	jmp    8008e7 <_main+0x8af>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	ff 75 c8             	pushl  -0x38(%ebp)
  8008ba:	ff 75 a4             	pushl  -0x5c(%ebp)
  8008bd:	ff 75 84             	pushl  -0x7c(%ebp)
  8008c0:	e8 48 02 00 00       	call   800b0d <find>
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	83 f8 01             	cmp    $0x1,%eax
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
			{
				panic("Error, wrong booking for user %d\n", f2);
  8008cd:	ff 75 c8             	pushl  -0x38(%ebp)
  8008d0:	68 2c 48 80 00       	push   $0x80482c
  8008d5:	68 c1 00 00 00       	push   $0xc1
  8008da:	68 ba 47 80 00       	push   $0x8047ba
  8008df:	e8 ad 03 00 00       	call   800c91 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8008e4:	ff 45 c8             	incl   -0x38(%ebp)
  8008e7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8008ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008ed:	01 d0                	add    %edx,%eax
  8008ef:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8008f2:	7f c0                	jg     8008b4 <_main+0x87c>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  8008f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008f7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8008fa:	eb 4c                	jmp    800948 <_main+0x910>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  8008fc:	83 ec 04             	sub    $0x4,%esp
  8008ff:	ff 75 c4             	pushl  -0x3c(%ebp)
  800902:	ff 75 a8             	pushl  -0x58(%ebp)
  800905:	ff 75 88             	pushl  -0x78(%ebp)
  800908:	e8 00 02 00 00       	call   800b0d <find>
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	83 f8 01             	cmp    $0x1,%eax
  800913:	75 19                	jne    80092e <_main+0x8f6>
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	ff 75 c4             	pushl  -0x3c(%ebp)
  80091b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80091e:	ff 75 84             	pushl  -0x7c(%ebp)
  800921:	e8 e7 01 00 00       	call   800b0d <find>
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	83 f8 01             	cmp    $0x1,%eax
  80092c:	74 17                	je     800945 <_main+0x90d>
			{
				panic("Error, wrong booking for user %d\n", f3);
  80092e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800931:	68 2c 48 80 00       	push   $0x80482c
  800936:	68 ca 00 00 00       	push   $0xca
  80093b:	68 ba 47 80 00       	push   $0x8047ba
  800940:	e8 4c 03 00 00       	call   800c91 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800945:	ff 45 c4             	incl   -0x3c(%ebp)
  800948:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80094b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80094e:	01 d0                	add    %edx,%eax
  800950:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800953:	7f a7                	jg     8008fc <_main+0x8c4>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(semaphore_count(flight1CS) == 1);
  800955:	83 ec 0c             	sub    $0xc,%esp
  800958:	ff b5 6c fe ff ff    	pushl  -0x194(%ebp)
  80095e:	e8 cf 3a 00 00       	call   804432 <semaphore_count>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	83 f8 01             	cmp    $0x1,%eax
  800969:	74 19                	je     800984 <_main+0x94c>
  80096b:	68 50 48 80 00       	push   $0x804850
  800970:	68 70 48 80 00       	push   $0x804870
  800975:	68 ce 00 00 00       	push   $0xce
  80097a:	68 ba 47 80 00       	push   $0x8047ba
  80097f:	e8 0d 03 00 00       	call   800c91 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80098d:	e8 a0 3a 00 00       	call   804432 <semaphore_count>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	83 f8 01             	cmp    $0x1,%eax
  800998:	74 19                	je     8009b3 <_main+0x97b>
  80099a:	68 88 48 80 00       	push   $0x804888
  80099f:	68 70 48 80 00       	push   $0x804870
  8009a4:	68 cf 00 00 00       	push   $0xcf
  8009a9:	68 ba 47 80 00       	push   $0x8047ba
  8009ae:	e8 de 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8009bc:	e8 71 3a 00 00       	call   804432 <semaphore_count>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	83 f8 01             	cmp    $0x1,%eax
  8009c7:	74 19                	je     8009e2 <_main+0x9aa>
  8009c9:	68 a8 48 80 00       	push   $0x8048a8
  8009ce:	68 70 48 80 00       	push   $0x804870
  8009d3:	68 d1 00 00 00       	push   $0xd1
  8009d8:	68 ba 47 80 00       	push   $0x8047ba
  8009dd:	e8 af 02 00 00       	call   800c91 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8009eb:	e8 42 3a 00 00       	call   804432 <semaphore_count>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	83 f8 01             	cmp    $0x1,%eax
  8009f6:	74 19                	je     800a11 <_main+0x9d9>
  8009f8:	68 cc 48 80 00       	push   $0x8048cc
  8009fd:	68 70 48 80 00       	push   $0x804870
  800a02:	68 d2 00 00 00       	push   $0xd2
  800a07:	68 ba 47 80 00       	push   $0x8047ba
  800a0c:	e8 80 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800a1a:	e8 13 3a 00 00       	call   804432 <semaphore_count>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	83 f8 03             	cmp    $0x3,%eax
  800a25:	74 19                	je     800a40 <_main+0xa08>
  800a27:	68 ee 48 80 00       	push   $0x8048ee
  800a2c:	68 70 48 80 00       	push   $0x804870
  800a31:	68 d4 00 00 00       	push   $0xd4
  800a36:	68 ba 47 80 00       	push   $0x8047ba
  800a3b:	e8 51 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800a40:	83 ec 0c             	sub    $0xc,%esp
  800a43:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800a49:	e8 e4 39 00 00       	call   804432 <semaphore_count>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800a54:	74 19                	je     800a6f <_main+0xa37>
  800a56:	68 0c 49 80 00       	push   $0x80490c
  800a5b:	68 70 48 80 00       	push   $0x804870
  800a60:	68 d6 00 00 00       	push   $0xd6
  800a65:	68 ba 47 80 00       	push   $0x8047ba
  800a6a:	e8 22 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800a78:	e8 b5 39 00 00       	call   804432 <semaphore_count>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	85 c0                	test   %eax,%eax
  800a82:	74 19                	je     800a9d <_main+0xa65>
  800a84:	68 30 49 80 00       	push   $0x804930
  800a89:	68 70 48 80 00       	push   $0x804870
  800a8e:	68 d8 00 00 00       	push   $0xd8
  800a93:	68 ba 47 80 00       	push   $0x8047ba
  800a98:	e8 f4 01 00 00       	call   800c91 <_panic>

		int s=0;
  800a9d:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800aa4:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800aab:	eb 3f                	jmp    800aec <_main+0xab4>
//			char prefix[30]="cust_finished";
//			char id[5]; char cust_finishedSemaphoreName[50];
//			ltostr(s, id);
//			strcconcat(prefix, id, cust_finishedSemaphoreName);
//			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
			assert(semaphore_count(cust_finished[s]) ==  0);
  800aad:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ab0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ab7:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800abd:	01 d0                	add    %edx,%eax
  800abf:	83 ec 0c             	sub    $0xc,%esp
  800ac2:	ff 30                	pushl  (%eax)
  800ac4:	e8 69 39 00 00       	call   804432 <semaphore_count>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	85 c0                	test   %eax,%eax
  800ace:	74 19                	je     800ae9 <_main+0xab1>
  800ad0:	68 58 49 80 00       	push   $0x804958
  800ad5:	68 70 48 80 00       	push   $0x804870
  800ada:	68 e2 00 00 00       	push   $0xe2
  800adf:	68 ba 47 80 00       	push   $0x8047ba
  800ae4:	e8 a8 01 00 00       	call   800c91 <_panic>
		assert(semaphore_count(cust_ready) == -3);

		assert(semaphore_count(custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ae9:	ff 45 c0             	incl   -0x40(%ebp)
  800aec:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aef:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800af2:	7c b9                	jl     800aad <_main+0xa75>
//			strcconcat(prefix, id, cust_finishedSemaphoreName);
//			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
			assert(semaphore_count(cust_finished[s]) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800af4:	83 ec 0c             	sub    $0xc,%esp
  800af7:	68 80 49 80 00       	push   $0x804980
  800afc:	e8 4d 04 00 00       	call   800f4e <cprintf>
  800b01:	83 c4 10             	add    $0x10,%esp
	}

}
  800b04:	90                   	nop
  800b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5f                   	pop    %edi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <find>:


int find(int* arr, int size, int val)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b21:	eb 22                	jmp    800b45 <find+0x38>
	{
		if(arr[i] == val)
  800b23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b26:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	01 d0                	add    %edx,%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b37:	75 09                	jne    800b42 <find+0x35>
		{
			result = 1;
  800b39:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b40:	eb 0b                	jmp    800b4d <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b42:	ff 45 f8             	incl   -0x8(%ebp)
  800b45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b4b:	7c d6                	jl     800b23 <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    

00800b52 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b58:	e8 94 1a 00 00       	call   8025f1 <sys_getenvindex>
  800b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b63:	89 d0                	mov    %edx,%eax
  800b65:	c1 e0 03             	shl    $0x3,%eax
  800b68:	01 d0                	add    %edx,%eax
  800b6a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b71:	01 c8                	add    %ecx,%eax
  800b73:	01 c0                	add    %eax,%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b7e:	01 c8                	add    %ecx,%eax
  800b80:	01 d0                	add    %edx,%eax
  800b82:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b87:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b8c:	a1 20 60 80 00       	mov    0x806020,%eax
  800b91:	8a 40 20             	mov    0x20(%eax),%al
  800b94:	84 c0                	test   %al,%al
  800b96:	74 0d                	je     800ba5 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800b98:	a1 20 60 80 00       	mov    0x806020,%eax
  800b9d:	83 c0 20             	add    $0x20,%eax
  800ba0:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800ba5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba9:	7e 0a                	jle    800bb5 <libmain+0x63>
		binaryname = argv[0];
  800bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bae:	8b 00                	mov    (%eax),%eax
  800bb0:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	ff 75 08             	pushl  0x8(%ebp)
  800bbe:	e8 75 f4 ff ff       	call   800038 <_main>
  800bc3:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800bc6:	e8 aa 17 00 00       	call   802375 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800bcb:	83 ec 0c             	sub    $0xc,%esp
  800bce:	68 04 4b 80 00       	push   $0x804b04
  800bd3:	e8 76 03 00 00       	call   800f4e <cprintf>
  800bd8:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bdb:	a1 20 60 80 00       	mov    0x806020,%eax
  800be0:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800be6:	a1 20 60 80 00       	mov    0x806020,%eax
  800beb:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800bf1:	83 ec 04             	sub    $0x4,%esp
  800bf4:	52                   	push   %edx
  800bf5:	50                   	push   %eax
  800bf6:	68 2c 4b 80 00       	push   $0x804b2c
  800bfb:	e8 4e 03 00 00       	call   800f4e <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c03:	a1 20 60 80 00       	mov    0x806020,%eax
  800c08:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800c0e:	a1 20 60 80 00       	mov    0x806020,%eax
  800c13:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800c19:	a1 20 60 80 00       	mov    0x806020,%eax
  800c1e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800c24:	51                   	push   %ecx
  800c25:	52                   	push   %edx
  800c26:	50                   	push   %eax
  800c27:	68 54 4b 80 00       	push   $0x804b54
  800c2c:	e8 1d 03 00 00       	call   800f4e <cprintf>
  800c31:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c34:	a1 20 60 80 00       	mov    0x806020,%eax
  800c39:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	50                   	push   %eax
  800c43:	68 ac 4b 80 00       	push   $0x804bac
  800c48:	e8 01 03 00 00       	call   800f4e <cprintf>
  800c4d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800c50:	83 ec 0c             	sub    $0xc,%esp
  800c53:	68 04 4b 80 00       	push   $0x804b04
  800c58:	e8 f1 02 00 00       	call   800f4e <cprintf>
  800c5d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800c60:	e8 2a 17 00 00       	call   80238f <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800c65:	e8 19 00 00 00       	call   800c83 <exit>
}
  800c6a:	90                   	nop
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c73:	83 ec 0c             	sub    $0xc,%esp
  800c76:	6a 00                	push   $0x0
  800c78:	e8 40 19 00 00       	call   8025bd <sys_destroy_env>
  800c7d:	83 c4 10             	add    $0x10,%esp
}
  800c80:	90                   	nop
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <exit>:

void
exit(void)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c89:	e8 95 19 00 00       	call   802623 <sys_exit_env>
}
  800c8e:	90                   	nop
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c97:	8d 45 10             	lea    0x10(%ebp),%eax
  800c9a:	83 c0 04             	add    $0x4,%eax
  800c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ca0:	a1 50 60 80 00       	mov    0x806050,%eax
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	74 16                	je     800cbf <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ca9:	a1 50 60 80 00       	mov    0x806050,%eax
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	50                   	push   %eax
  800cb2:	68 c0 4b 80 00       	push   $0x804bc0
  800cb7:	e8 92 02 00 00       	call   800f4e <cprintf>
  800cbc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cbf:	a1 00 60 80 00       	mov    0x806000,%eax
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	ff 75 08             	pushl  0x8(%ebp)
  800cca:	50                   	push   %eax
  800ccb:	68 c5 4b 80 00       	push   $0x804bc5
  800cd0:	e8 79 02 00 00       	call   800f4e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce1:	50                   	push   %eax
  800ce2:	e8 fc 01 00 00       	call   800ee3 <vcprintf>
  800ce7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	6a 00                	push   $0x0
  800cef:	68 e1 4b 80 00       	push   $0x804be1
  800cf4:	e8 ea 01 00 00       	call   800ee3 <vcprintf>
  800cf9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cfc:	e8 82 ff ff ff       	call   800c83 <exit>

	// should not return here
	while (1) ;
  800d01:	eb fe                	jmp    800d01 <_panic+0x70>

00800d03 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d09:	a1 20 60 80 00       	mov    0x806020,%eax
  800d0e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	39 c2                	cmp    %eax,%edx
  800d19:	74 14                	je     800d2f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d1b:	83 ec 04             	sub    $0x4,%esp
  800d1e:	68 e4 4b 80 00       	push   $0x804be4
  800d23:	6a 26                	push   $0x26
  800d25:	68 30 4c 80 00       	push   $0x804c30
  800d2a:	e8 62 ff ff ff       	call   800c91 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d3d:	e9 c5 00 00 00       	jmp    800e07 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d45:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	85 c0                	test   %eax,%eax
  800d55:	75 08                	jne    800d5f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800d57:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d5a:	e9 a5 00 00 00       	jmp    800e04 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800d5f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d66:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d6d:	eb 69                	jmp    800dd8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d6f:	a1 20 60 80 00       	mov    0x806020,%eax
  800d74:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800d7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d7d:	89 d0                	mov    %edx,%eax
  800d7f:	01 c0                	add    %eax,%eax
  800d81:	01 d0                	add    %edx,%eax
  800d83:	c1 e0 03             	shl    $0x3,%eax
  800d86:	01 c8                	add    %ecx,%eax
  800d88:	8a 40 04             	mov    0x4(%eax),%al
  800d8b:	84 c0                	test   %al,%al
  800d8d:	75 46                	jne    800dd5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d8f:	a1 20 60 80 00       	mov    0x806020,%eax
  800d94:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800d9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d9d:	89 d0                	mov    %edx,%eax
  800d9f:	01 c0                	add    %eax,%eax
  800da1:	01 d0                	add    %edx,%eax
  800da3:	c1 e0 03             	shl    $0x3,%eax
  800da6:	01 c8                	add    %ecx,%eax
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	01 c8                	add    %ecx,%eax
  800dc6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dc8:	39 c2                	cmp    %eax,%edx
  800dca:	75 09                	jne    800dd5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800dcc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dd3:	eb 15                	jmp    800dea <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dd5:	ff 45 e8             	incl   -0x18(%ebp)
  800dd8:	a1 20 60 80 00       	mov    0x806020,%eax
  800ddd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800de3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800de6:	39 c2                	cmp    %eax,%edx
  800de8:	77 85                	ja     800d6f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dee:	75 14                	jne    800e04 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800df0:	83 ec 04             	sub    $0x4,%esp
  800df3:	68 3c 4c 80 00       	push   $0x804c3c
  800df8:	6a 3a                	push   $0x3a
  800dfa:	68 30 4c 80 00       	push   $0x804c30
  800dff:	e8 8d fe ff ff       	call   800c91 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e04:	ff 45 f0             	incl   -0x10(%ebp)
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e0d:	0f 8c 2f ff ff ff    	jl     800d42 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e13:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e1a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e21:	eb 26                	jmp    800e49 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e23:	a1 20 60 80 00       	mov    0x806020,%eax
  800e28:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800e2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	c1 e0 03             	shl    $0x3,%eax
  800e3a:	01 c8                	add    %ecx,%eax
  800e3c:	8a 40 04             	mov    0x4(%eax),%al
  800e3f:	3c 01                	cmp    $0x1,%al
  800e41:	75 03                	jne    800e46 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800e43:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e46:	ff 45 e0             	incl   -0x20(%ebp)
  800e49:	a1 20 60 80 00       	mov    0x806020,%eax
  800e4e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e57:	39 c2                	cmp    %eax,%edx
  800e59:	77 c8                	ja     800e23 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e5e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e61:	74 14                	je     800e77 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800e63:	83 ec 04             	sub    $0x4,%esp
  800e66:	68 90 4c 80 00       	push   $0x804c90
  800e6b:	6a 44                	push   $0x44
  800e6d:	68 30 4c 80 00       	push   $0x804c30
  800e72:	e8 1a fe ff ff       	call   800c91 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e77:	90                   	nop
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	8b 00                	mov    (%eax),%eax
  800e85:	8d 48 01             	lea    0x1(%eax),%ecx
  800e88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8b:	89 0a                	mov    %ecx,(%edx)
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	88 d1                	mov    %dl,%cl
  800e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e95:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	8b 00                	mov    (%eax),%eax
  800e9e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ea3:	75 2c                	jne    800ed1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ea5:	a0 2c 60 80 00       	mov    0x80602c,%al
  800eaa:	0f b6 c0             	movzbl %al,%eax
  800ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb0:	8b 12                	mov    (%edx),%edx
  800eb2:	89 d1                	mov    %edx,%ecx
  800eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb7:	83 c2 08             	add    $0x8,%edx
  800eba:	83 ec 04             	sub    $0x4,%esp
  800ebd:	50                   	push   %eax
  800ebe:	51                   	push   %ecx
  800ebf:	52                   	push   %edx
  800ec0:	e8 6e 14 00 00       	call   802333 <sys_cputs>
  800ec5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	8b 40 04             	mov    0x4(%eax),%eax
  800ed7:	8d 50 01             	lea    0x1(%eax),%edx
  800eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edd:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ee0:	90                   	nop
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800eec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ef3:	00 00 00 
	b.cnt = 0;
  800ef6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800efd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f00:	ff 75 0c             	pushl  0xc(%ebp)
  800f03:	ff 75 08             	pushl  0x8(%ebp)
  800f06:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f0c:	50                   	push   %eax
  800f0d:	68 7a 0e 80 00       	push   $0x800e7a
  800f12:	e8 11 02 00 00       	call   801128 <vprintfmt>
  800f17:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f1a:	a0 2c 60 80 00       	mov    0x80602c,%al
  800f1f:	0f b6 c0             	movzbl %al,%eax
  800f22:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f28:	83 ec 04             	sub    $0x4,%esp
  800f2b:	50                   	push   %eax
  800f2c:	52                   	push   %edx
  800f2d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f33:	83 c0 08             	add    $0x8,%eax
  800f36:	50                   	push   %eax
  800f37:	e8 f7 13 00 00       	call   802333 <sys_cputs>
  800f3c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f3f:	c6 05 2c 60 80 00 00 	movb   $0x0,0x80602c
	return b.cnt;
  800f46:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    

00800f4e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f54:	c6 05 2c 60 80 00 01 	movb   $0x1,0x80602c
	va_start(ap, fmt);
  800f5b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	83 ec 08             	sub    $0x8,%esp
  800f67:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6a:	50                   	push   %eax
  800f6b:	e8 73 ff ff ff       	call   800ee3 <vcprintf>
  800f70:	83 c4 10             	add    $0x10,%esp
  800f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800f81:	e8 ef 13 00 00       	call   802375 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800f86:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 f4             	pushl  -0xc(%ebp)
  800f95:	50                   	push   %eax
  800f96:	e8 48 ff ff ff       	call   800ee3 <vcprintf>
  800f9b:	83 c4 10             	add    $0x10,%esp
  800f9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800fa1:	e8 e9 13 00 00       	call   80238f <sys_unlock_cons>
	return cnt;
  800fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	53                   	push   %ebx
  800faf:	83 ec 14             	sub    $0x14,%esp
  800fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fbe:	8b 45 18             	mov    0x18(%ebp),%eax
  800fc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fc9:	77 55                	ja     801020 <printnum+0x75>
  800fcb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fce:	72 05                	jb     800fd5 <printnum+0x2a>
  800fd0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fd3:	77 4b                	ja     801020 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fd5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fd8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fdb:	8b 45 18             	mov    0x18(%ebp),%eax
  800fde:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe3:	52                   	push   %edx
  800fe4:	50                   	push   %eax
  800fe5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe8:	ff 75 f0             	pushl  -0x10(%ebp)
  800feb:	e8 04 35 00 00       	call   8044f4 <__udivdi3>
  800ff0:	83 c4 10             	add    $0x10,%esp
  800ff3:	83 ec 04             	sub    $0x4,%esp
  800ff6:	ff 75 20             	pushl  0x20(%ebp)
  800ff9:	53                   	push   %ebx
  800ffa:	ff 75 18             	pushl  0x18(%ebp)
  800ffd:	52                   	push   %edx
  800ffe:	50                   	push   %eax
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 08             	pushl  0x8(%ebp)
  801005:	e8 a1 ff ff ff       	call   800fab <printnum>
  80100a:	83 c4 20             	add    $0x20,%esp
  80100d:	eb 1a                	jmp    801029 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80100f:	83 ec 08             	sub    $0x8,%esp
  801012:	ff 75 0c             	pushl  0xc(%ebp)
  801015:	ff 75 20             	pushl  0x20(%ebp)
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	ff d0                	call   *%eax
  80101d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801020:	ff 4d 1c             	decl   0x1c(%ebp)
  801023:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801027:	7f e6                	jg     80100f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801029:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80102c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801037:	53                   	push   %ebx
  801038:	51                   	push   %ecx
  801039:	52                   	push   %edx
  80103a:	50                   	push   %eax
  80103b:	e8 c4 35 00 00       	call   804604 <__umoddi3>
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	05 f4 4e 80 00       	add    $0x804ef4,%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	0f be c0             	movsbl %al,%eax
  80104d:	83 ec 08             	sub    $0x8,%esp
  801050:	ff 75 0c             	pushl  0xc(%ebp)
  801053:	50                   	push   %eax
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
}
  80105c:	90                   	nop
  80105d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801065:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801069:	7e 1c                	jle    801087 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8b 00                	mov    (%eax),%eax
  801070:	8d 50 08             	lea    0x8(%eax),%edx
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	89 10                	mov    %edx,(%eax)
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8b 00                	mov    (%eax),%eax
  80107d:	83 e8 08             	sub    $0x8,%eax
  801080:	8b 50 04             	mov    0x4(%eax),%edx
  801083:	8b 00                	mov    (%eax),%eax
  801085:	eb 40                	jmp    8010c7 <getuint+0x65>
	else if (lflag)
  801087:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108b:	74 1e                	je     8010ab <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	8d 50 04             	lea    0x4(%eax),%edx
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	89 10                	mov    %edx,(%eax)
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8b 00                	mov    (%eax),%eax
  80109f:	83 e8 04             	sub    $0x4,%eax
  8010a2:	8b 00                	mov    (%eax),%eax
  8010a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a9:	eb 1c                	jmp    8010c7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	8d 50 04             	lea    0x4(%eax),%edx
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	89 10                	mov    %edx,(%eax)
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	83 e8 04             	sub    $0x4,%eax
  8010c0:	8b 00                	mov    (%eax),%eax
  8010c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010c7:	5d                   	pop    %ebp
  8010c8:	c3                   	ret    

008010c9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010d0:	7e 1c                	jle    8010ee <getint+0x25>
		return va_arg(*ap, long long);
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8b 00                	mov    (%eax),%eax
  8010d7:	8d 50 08             	lea    0x8(%eax),%edx
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	89 10                	mov    %edx,(%eax)
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8b 00                	mov    (%eax),%eax
  8010e4:	83 e8 08             	sub    $0x8,%eax
  8010e7:	8b 50 04             	mov    0x4(%eax),%edx
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	eb 38                	jmp    801126 <getint+0x5d>
	else if (lflag)
  8010ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f2:	74 1a                	je     80110e <getint+0x45>
		return va_arg(*ap, long);
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	8b 00                	mov    (%eax),%eax
  8010f9:	8d 50 04             	lea    0x4(%eax),%edx
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	89 10                	mov    %edx,(%eax)
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8b 00                	mov    (%eax),%eax
  801106:	83 e8 04             	sub    $0x4,%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	99                   	cltd   
  80110c:	eb 18                	jmp    801126 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8b 00                	mov    (%eax),%eax
  801113:	8d 50 04             	lea    0x4(%eax),%edx
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	89 10                	mov    %edx,(%eax)
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	83 e8 04             	sub    $0x4,%eax
  801123:	8b 00                	mov    (%eax),%eax
  801125:	99                   	cltd   
}
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	56                   	push   %esi
  80112c:	53                   	push   %ebx
  80112d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801130:	eb 17                	jmp    801149 <vprintfmt+0x21>
			if (ch == '\0')
  801132:	85 db                	test   %ebx,%ebx
  801134:	0f 84 c1 03 00 00    	je     8014fb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80113a:	83 ec 08             	sub    $0x8,%esp
  80113d:	ff 75 0c             	pushl  0xc(%ebp)
  801140:	53                   	push   %ebx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	ff d0                	call   *%eax
  801146:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	8d 50 01             	lea    0x1(%eax),%edx
  80114f:	89 55 10             	mov    %edx,0x10(%ebp)
  801152:	8a 00                	mov    (%eax),%al
  801154:	0f b6 d8             	movzbl %al,%ebx
  801157:	83 fb 25             	cmp    $0x25,%ebx
  80115a:	75 d6                	jne    801132 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80115c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801160:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801167:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80116e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801175:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	8d 50 01             	lea    0x1(%eax),%edx
  801182:	89 55 10             	mov    %edx,0x10(%ebp)
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d8             	movzbl %al,%ebx
  80118a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80118d:	83 f8 5b             	cmp    $0x5b,%eax
  801190:	0f 87 3d 03 00 00    	ja     8014d3 <vprintfmt+0x3ab>
  801196:	8b 04 85 18 4f 80 00 	mov    0x804f18(,%eax,4),%eax
  80119d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80119f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011a3:	eb d7                	jmp    80117c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011a5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011a9:	eb d1                	jmp    80117c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011b5:	89 d0                	mov    %edx,%eax
  8011b7:	c1 e0 02             	shl    $0x2,%eax
  8011ba:	01 d0                	add    %edx,%eax
  8011bc:	01 c0                	add    %eax,%eax
  8011be:	01 d8                	add    %ebx,%eax
  8011c0:	83 e8 30             	sub    $0x30,%eax
  8011c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011ce:	83 fb 2f             	cmp    $0x2f,%ebx
  8011d1:	7e 3e                	jle    801211 <vprintfmt+0xe9>
  8011d3:	83 fb 39             	cmp    $0x39,%ebx
  8011d6:	7f 39                	jg     801211 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011d8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011db:	eb d5                	jmp    8011b2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e0:	83 c0 04             	add    $0x4,%eax
  8011e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	83 e8 04             	sub    $0x4,%eax
  8011ec:	8b 00                	mov    (%eax),%eax
  8011ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011f1:	eb 1f                	jmp    801212 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011f7:	79 83                	jns    80117c <vprintfmt+0x54>
				width = 0;
  8011f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801200:	e9 77 ff ff ff       	jmp    80117c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801205:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80120c:	e9 6b ff ff ff       	jmp    80117c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801211:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801212:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801216:	0f 89 60 ff ff ff    	jns    80117c <vprintfmt+0x54>
				width = precision, precision = -1;
  80121c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801222:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801229:	e9 4e ff ff ff       	jmp    80117c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80122e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801231:	e9 46 ff ff ff       	jmp    80117c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	83 c0 04             	add    $0x4,%eax
  80123c:	89 45 14             	mov    %eax,0x14(%ebp)
  80123f:	8b 45 14             	mov    0x14(%ebp),%eax
  801242:	83 e8 04             	sub    $0x4,%eax
  801245:	8b 00                	mov    (%eax),%eax
  801247:	83 ec 08             	sub    $0x8,%esp
  80124a:	ff 75 0c             	pushl  0xc(%ebp)
  80124d:	50                   	push   %eax
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	ff d0                	call   *%eax
  801253:	83 c4 10             	add    $0x10,%esp
			break;
  801256:	e9 9b 02 00 00       	jmp    8014f6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80125b:	8b 45 14             	mov    0x14(%ebp),%eax
  80125e:	83 c0 04             	add    $0x4,%eax
  801261:	89 45 14             	mov    %eax,0x14(%ebp)
  801264:	8b 45 14             	mov    0x14(%ebp),%eax
  801267:	83 e8 04             	sub    $0x4,%eax
  80126a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80126c:	85 db                	test   %ebx,%ebx
  80126e:	79 02                	jns    801272 <vprintfmt+0x14a>
				err = -err;
  801270:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801272:	83 fb 64             	cmp    $0x64,%ebx
  801275:	7f 0b                	jg     801282 <vprintfmt+0x15a>
  801277:	8b 34 9d 60 4d 80 00 	mov    0x804d60(,%ebx,4),%esi
  80127e:	85 f6                	test   %esi,%esi
  801280:	75 19                	jne    80129b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801282:	53                   	push   %ebx
  801283:	68 05 4f 80 00       	push   $0x804f05
  801288:	ff 75 0c             	pushl  0xc(%ebp)
  80128b:	ff 75 08             	pushl  0x8(%ebp)
  80128e:	e8 70 02 00 00       	call   801503 <printfmt>
  801293:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801296:	e9 5b 02 00 00       	jmp    8014f6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80129b:	56                   	push   %esi
  80129c:	68 0e 4f 80 00       	push   $0x804f0e
  8012a1:	ff 75 0c             	pushl  0xc(%ebp)
  8012a4:	ff 75 08             	pushl  0x8(%ebp)
  8012a7:	e8 57 02 00 00       	call   801503 <printfmt>
  8012ac:	83 c4 10             	add    $0x10,%esp
			break;
  8012af:	e9 42 02 00 00       	jmp    8014f6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b7:	83 c0 04             	add    $0x4,%eax
  8012ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8012bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c0:	83 e8 04             	sub    $0x4,%eax
  8012c3:	8b 30                	mov    (%eax),%esi
  8012c5:	85 f6                	test   %esi,%esi
  8012c7:	75 05                	jne    8012ce <vprintfmt+0x1a6>
				p = "(null)";
  8012c9:	be 11 4f 80 00       	mov    $0x804f11,%esi
			if (width > 0 && padc != '-')
  8012ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012d2:	7e 6d                	jle    801341 <vprintfmt+0x219>
  8012d4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012d8:	74 67                	je     801341 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	50                   	push   %eax
  8012e1:	56                   	push   %esi
  8012e2:	e8 1e 03 00 00       	call   801605 <strnlen>
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012ed:	eb 16                	jmp    801305 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ef:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012f3:	83 ec 08             	sub    $0x8,%esp
  8012f6:	ff 75 0c             	pushl  0xc(%ebp)
  8012f9:	50                   	push   %eax
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	ff d0                	call   *%eax
  8012ff:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801302:	ff 4d e4             	decl   -0x1c(%ebp)
  801305:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801309:	7f e4                	jg     8012ef <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80130b:	eb 34                	jmp    801341 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80130d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801311:	74 1c                	je     80132f <vprintfmt+0x207>
  801313:	83 fb 1f             	cmp    $0x1f,%ebx
  801316:	7e 05                	jle    80131d <vprintfmt+0x1f5>
  801318:	83 fb 7e             	cmp    $0x7e,%ebx
  80131b:	7e 12                	jle    80132f <vprintfmt+0x207>
					putch('?', putdat);
  80131d:	83 ec 08             	sub    $0x8,%esp
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	6a 3f                	push   $0x3f
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	ff d0                	call   *%eax
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	eb 0f                	jmp    80133e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80132f:	83 ec 08             	sub    $0x8,%esp
  801332:	ff 75 0c             	pushl  0xc(%ebp)
  801335:	53                   	push   %ebx
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	ff d0                	call   *%eax
  80133b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80133e:	ff 4d e4             	decl   -0x1c(%ebp)
  801341:	89 f0                	mov    %esi,%eax
  801343:	8d 70 01             	lea    0x1(%eax),%esi
  801346:	8a 00                	mov    (%eax),%al
  801348:	0f be d8             	movsbl %al,%ebx
  80134b:	85 db                	test   %ebx,%ebx
  80134d:	74 24                	je     801373 <vprintfmt+0x24b>
  80134f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801353:	78 b8                	js     80130d <vprintfmt+0x1e5>
  801355:	ff 4d e0             	decl   -0x20(%ebp)
  801358:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80135c:	79 af                	jns    80130d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80135e:	eb 13                	jmp    801373 <vprintfmt+0x24b>
				putch(' ', putdat);
  801360:	83 ec 08             	sub    $0x8,%esp
  801363:	ff 75 0c             	pushl  0xc(%ebp)
  801366:	6a 20                	push   $0x20
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	ff d0                	call   *%eax
  80136d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801370:	ff 4d e4             	decl   -0x1c(%ebp)
  801373:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801377:	7f e7                	jg     801360 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801379:	e9 78 01 00 00       	jmp    8014f6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80137e:	83 ec 08             	sub    $0x8,%esp
  801381:	ff 75 e8             	pushl  -0x18(%ebp)
  801384:	8d 45 14             	lea    0x14(%ebp),%eax
  801387:	50                   	push   %eax
  801388:	e8 3c fd ff ff       	call   8010c9 <getint>
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801393:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139c:	85 d2                	test   %edx,%edx
  80139e:	79 23                	jns    8013c3 <vprintfmt+0x29b>
				putch('-', putdat);
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	6a 2d                	push   $0x2d
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	ff d0                	call   *%eax
  8013ad:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b6:	f7 d8                	neg    %eax
  8013b8:	83 d2 00             	adc    $0x0,%edx
  8013bb:	f7 da                	neg    %edx
  8013bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013c3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013ca:	e9 bc 00 00 00       	jmp    80148b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013cf:	83 ec 08             	sub    $0x8,%esp
  8013d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	e8 84 fc ff ff       	call   801062 <getuint>
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013e7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013ee:	e9 98 00 00 00       	jmp    80148b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013f3:	83 ec 08             	sub    $0x8,%esp
  8013f6:	ff 75 0c             	pushl  0xc(%ebp)
  8013f9:	6a 58                	push   $0x58
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	ff d0                	call   *%eax
  801400:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	6a 58                	push   $0x58
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	ff d0                	call   *%eax
  801410:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	6a 58                	push   $0x58
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	ff d0                	call   *%eax
  801420:	83 c4 10             	add    $0x10,%esp
			break;
  801423:	e9 ce 00 00 00       	jmp    8014f6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801428:	83 ec 08             	sub    $0x8,%esp
  80142b:	ff 75 0c             	pushl  0xc(%ebp)
  80142e:	6a 30                	push   $0x30
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	ff d0                	call   *%eax
  801435:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	6a 78                	push   $0x78
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	ff d0                	call   *%eax
  801445:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801448:	8b 45 14             	mov    0x14(%ebp),%eax
  80144b:	83 c0 04             	add    $0x4,%eax
  80144e:	89 45 14             	mov    %eax,0x14(%ebp)
  801451:	8b 45 14             	mov    0x14(%ebp),%eax
  801454:	83 e8 04             	sub    $0x4,%eax
  801457:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801459:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80145c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801463:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80146a:	eb 1f                	jmp    80148b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80146c:	83 ec 08             	sub    $0x8,%esp
  80146f:	ff 75 e8             	pushl  -0x18(%ebp)
  801472:	8d 45 14             	lea    0x14(%ebp),%eax
  801475:	50                   	push   %eax
  801476:	e8 e7 fb ff ff       	call   801062 <getuint>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801481:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801484:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80148b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80148f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	52                   	push   %edx
  801496:	ff 75 e4             	pushl  -0x1c(%ebp)
  801499:	50                   	push   %eax
  80149a:	ff 75 f4             	pushl  -0xc(%ebp)
  80149d:	ff 75 f0             	pushl  -0x10(%ebp)
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	e8 00 fb ff ff       	call   800fab <printnum>
  8014ab:	83 c4 20             	add    $0x20,%esp
			break;
  8014ae:	eb 46                	jmp    8014f6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014b0:	83 ec 08             	sub    $0x8,%esp
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	53                   	push   %ebx
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	ff d0                	call   *%eax
  8014bc:	83 c4 10             	add    $0x10,%esp
			break;
  8014bf:	eb 35                	jmp    8014f6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8014c1:	c6 05 2c 60 80 00 00 	movb   $0x0,0x80602c
			break;
  8014c8:	eb 2c                	jmp    8014f6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8014ca:	c6 05 2c 60 80 00 01 	movb   $0x1,0x80602c
			break;
  8014d1:	eb 23                	jmp    8014f6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014d3:	83 ec 08             	sub    $0x8,%esp
  8014d6:	ff 75 0c             	pushl  0xc(%ebp)
  8014d9:	6a 25                	push   $0x25
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	ff d0                	call   *%eax
  8014e0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014e3:	ff 4d 10             	decl   0x10(%ebp)
  8014e6:	eb 03                	jmp    8014eb <vprintfmt+0x3c3>
  8014e8:	ff 4d 10             	decl   0x10(%ebp)
  8014eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ee:	48                   	dec    %eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	3c 25                	cmp    $0x25,%al
  8014f3:	75 f3                	jne    8014e8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8014f5:	90                   	nop
		}
	}
  8014f6:	e9 35 fc ff ff       	jmp    801130 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014fb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ff:	5b                   	pop    %ebx
  801500:	5e                   	pop    %esi
  801501:	5d                   	pop    %ebp
  801502:	c3                   	ret    

00801503 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801509:	8d 45 10             	lea    0x10(%ebp),%eax
  80150c:	83 c0 04             	add    $0x4,%eax
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801512:	8b 45 10             	mov    0x10(%ebp),%eax
  801515:	ff 75 f4             	pushl  -0xc(%ebp)
  801518:	50                   	push   %eax
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	e8 04 fc ff ff       	call   801128 <vprintfmt>
  801524:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	8b 40 08             	mov    0x8(%eax),%eax
  801533:	8d 50 01             	lea    0x1(%eax),%edx
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80153c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153f:	8b 10                	mov    (%eax),%edx
  801541:	8b 45 0c             	mov    0xc(%ebp),%eax
  801544:	8b 40 04             	mov    0x4(%eax),%eax
  801547:	39 c2                	cmp    %eax,%edx
  801549:	73 12                	jae    80155d <sprintputch+0x33>
		*b->buf++ = ch;
  80154b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154e:	8b 00                	mov    (%eax),%eax
  801550:	8d 48 01             	lea    0x1(%eax),%ecx
  801553:	8b 55 0c             	mov    0xc(%ebp),%edx
  801556:	89 0a                	mov    %ecx,(%edx)
  801558:	8b 55 08             	mov    0x8(%ebp),%edx
  80155b:	88 10                	mov    %dl,(%eax)
}
  80155d:	90                   	nop
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	01 d0                	add    %edx,%eax
  801577:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80157a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801581:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801585:	74 06                	je     80158d <vsnprintf+0x2d>
  801587:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80158b:	7f 07                	jg     801594 <vsnprintf+0x34>
		return -E_INVAL;
  80158d:	b8 03 00 00 00       	mov    $0x3,%eax
  801592:	eb 20                	jmp    8015b4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801594:	ff 75 14             	pushl  0x14(%ebp)
  801597:	ff 75 10             	pushl  0x10(%ebp)
  80159a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80159d:	50                   	push   %eax
  80159e:	68 2a 15 80 00       	push   $0x80152a
  8015a3:	e8 80 fb ff ff       	call   801128 <vprintfmt>
  8015a8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ae:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8015bf:	83 c0 04             	add    $0x4,%eax
  8015c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cb:	50                   	push   %eax
  8015cc:	ff 75 0c             	pushl  0xc(%ebp)
  8015cf:	ff 75 08             	pushl  0x8(%ebp)
  8015d2:	e8 89 ff ff ff       	call   801560 <vsnprintf>
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ef:	eb 06                	jmp    8015f7 <strlen+0x15>
		n++;
  8015f1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f4:	ff 45 08             	incl   0x8(%ebp)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	84 c0                	test   %al,%al
  8015fe:	75 f1                	jne    8015f1 <strlen+0xf>
		n++;
	return n;
  801600:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80160b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801612:	eb 09                	jmp    80161d <strnlen+0x18>
		n++;
  801614:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	ff 4d 0c             	decl   0xc(%ebp)
  80161d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801621:	74 09                	je     80162c <strnlen+0x27>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	84 c0                	test   %al,%al
  80162a:	75 e8                	jne    801614 <strnlen+0xf>
		n++;
	return n;
  80162c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80163d:	90                   	nop
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8d 50 01             	lea    0x1(%eax),%edx
  801644:	89 55 08             	mov    %edx,0x8(%ebp)
  801647:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801650:	8a 12                	mov    (%edx),%dl
  801652:	88 10                	mov    %dl,(%eax)
  801654:	8a 00                	mov    (%eax),%al
  801656:	84 c0                	test   %al,%al
  801658:	75 e4                	jne    80163e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80165a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80166b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801672:	eb 1f                	jmp    801693 <strncpy+0x34>
		*dst++ = *src;
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8d 50 01             	lea    0x1(%eax),%edx
  80167a:	89 55 08             	mov    %edx,0x8(%ebp)
  80167d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801680:	8a 12                	mov    (%edx),%dl
  801682:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801684:	8b 45 0c             	mov    0xc(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	84 c0                	test   %al,%al
  80168b:	74 03                	je     801690 <strncpy+0x31>
			src++;
  80168d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801690:	ff 45 fc             	incl   -0x4(%ebp)
  801693:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801696:	3b 45 10             	cmp    0x10(%ebp),%eax
  801699:	72 d9                	jb     801674 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80169b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b0:	74 30                	je     8016e2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016b2:	eb 16                	jmp    8016ca <strlcpy+0x2a>
			*dst++ = *src++;
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	8d 50 01             	lea    0x1(%eax),%edx
  8016ba:	89 55 08             	mov    %edx,0x8(%ebp)
  8016bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016c6:	8a 12                	mov    (%edx),%dl
  8016c8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016ca:	ff 4d 10             	decl   0x10(%ebp)
  8016cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d1:	74 09                	je     8016dc <strlcpy+0x3c>
  8016d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	84 c0                	test   %al,%al
  8016da:	75 d8                	jne    8016b4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e8:	29 c2                	sub    %eax,%edx
  8016ea:	89 d0                	mov    %edx,%eax
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016f1:	eb 06                	jmp    8016f9 <strcmp+0xb>
		p++, q++;
  8016f3:	ff 45 08             	incl   0x8(%ebp)
  8016f6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	8a 00                	mov    (%eax),%al
  8016fe:	84 c0                	test   %al,%al
  801700:	74 0e                	je     801710 <strcmp+0x22>
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	8a 10                	mov    (%eax),%dl
  801707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170a:	8a 00                	mov    (%eax),%al
  80170c:	38 c2                	cmp    %al,%dl
  80170e:	74 e3                	je     8016f3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8a 00                	mov    (%eax),%al
  801715:	0f b6 d0             	movzbl %al,%edx
  801718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171b:	8a 00                	mov    (%eax),%al
  80171d:	0f b6 c0             	movzbl %al,%eax
  801720:	29 c2                	sub    %eax,%edx
  801722:	89 d0                	mov    %edx,%eax
}
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    

00801726 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801729:	eb 09                	jmp    801734 <strncmp+0xe>
		n--, p++, q++;
  80172b:	ff 4d 10             	decl   0x10(%ebp)
  80172e:	ff 45 08             	incl   0x8(%ebp)
  801731:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801734:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801738:	74 17                	je     801751 <strncmp+0x2b>
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8a 00                	mov    (%eax),%al
  80173f:	84 c0                	test   %al,%al
  801741:	74 0e                	je     801751 <strncmp+0x2b>
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	8a 10                	mov    (%eax),%dl
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	8a 00                	mov    (%eax),%al
  80174d:	38 c2                	cmp    %al,%dl
  80174f:	74 da                	je     80172b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801751:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801755:	75 07                	jne    80175e <strncmp+0x38>
		return 0;
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
  80175c:	eb 14                	jmp    801772 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	8a 00                	mov    (%eax),%al
  801763:	0f b6 d0             	movzbl %al,%edx
  801766:	8b 45 0c             	mov    0xc(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	0f b6 c0             	movzbl %al,%eax
  80176e:	29 c2                	sub    %eax,%edx
  801770:	89 d0                	mov    %edx,%eax
}
  801772:	5d                   	pop    %ebp
  801773:	c3                   	ret    

00801774 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801780:	eb 12                	jmp    801794 <strchr+0x20>
		if (*s == c)
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80178a:	75 05                	jne    801791 <strchr+0x1d>
			return (char *) s;
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	eb 11                	jmp    8017a2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801791:	ff 45 08             	incl   0x8(%ebp)
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	84 c0                	test   %al,%al
  80179b:	75 e5                	jne    801782 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017b0:	eb 0d                	jmp    8017bf <strfind+0x1b>
		if (*s == c)
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	8a 00                	mov    (%eax),%al
  8017b7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017ba:	74 0e                	je     8017ca <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017bc:	ff 45 08             	incl   0x8(%ebp)
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	84 c0                	test   %al,%al
  8017c6:	75 ea                	jne    8017b2 <strfind+0xe>
  8017c8:	eb 01                	jmp    8017cb <strfind+0x27>
		if (*s == c)
			break;
  8017ca:	90                   	nop
	return (char *) s;
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017df:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017e2:	eb 0e                	jmp    8017f2 <memset+0x22>
		*p++ = c;
  8017e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e7:	8d 50 01             	lea    0x1(%eax),%edx
  8017ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017f2:	ff 4d f8             	decl   -0x8(%ebp)
  8017f5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017f9:	79 e9                	jns    8017e4 <memset+0x14>
		*p++ = c;

	return v;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801806:	8b 45 0c             	mov    0xc(%ebp),%eax
  801809:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801812:	eb 16                	jmp    80182a <memcpy+0x2a>
		*d++ = *s++;
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	8d 50 01             	lea    0x1(%eax),%edx
  80181a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801820:	8d 4a 01             	lea    0x1(%edx),%ecx
  801823:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801826:	8a 12                	mov    (%edx),%dl
  801828:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80182a:	8b 45 10             	mov    0x10(%ebp),%eax
  80182d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801830:	89 55 10             	mov    %edx,0x10(%ebp)
  801833:	85 c0                	test   %eax,%eax
  801835:	75 dd                	jne    801814 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801842:	8b 45 0c             	mov    0xc(%ebp),%eax
  801845:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80184e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801851:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801854:	73 50                	jae    8018a6 <memmove+0x6a>
  801856:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801859:	8b 45 10             	mov    0x10(%ebp),%eax
  80185c:	01 d0                	add    %edx,%eax
  80185e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801861:	76 43                	jbe    8018a6 <memmove+0x6a>
		s += n;
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
  801866:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801869:	8b 45 10             	mov    0x10(%ebp),%eax
  80186c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80186f:	eb 10                	jmp    801881 <memmove+0x45>
			*--d = *--s;
  801871:	ff 4d f8             	decl   -0x8(%ebp)
  801874:	ff 4d fc             	decl   -0x4(%ebp)
  801877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187a:	8a 10                	mov    (%eax),%dl
  80187c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	8d 50 ff             	lea    -0x1(%eax),%edx
  801887:	89 55 10             	mov    %edx,0x10(%ebp)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 e3                	jne    801871 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80188e:	eb 23                	jmp    8018b3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	8d 50 01             	lea    0x1(%eax),%edx
  801896:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801899:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a2:	8a 12                	mov    (%edx),%dl
  8018a4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	75 dd                	jne    801890 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018ca:	eb 2a                	jmp    8018f6 <memcmp+0x3e>
		if (*s1 != *s2)
  8018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cf:	8a 10                	mov    (%eax),%dl
  8018d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d4:	8a 00                	mov    (%eax),%al
  8018d6:	38 c2                	cmp    %al,%dl
  8018d8:	74 16                	je     8018f0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018dd:	8a 00                	mov    (%eax),%al
  8018df:	0f b6 d0             	movzbl %al,%edx
  8018e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e5:	8a 00                	mov    (%eax),%al
  8018e7:	0f b6 c0             	movzbl %al,%eax
  8018ea:	29 c2                	sub    %eax,%edx
  8018ec:	89 d0                	mov    %edx,%eax
  8018ee:	eb 18                	jmp    801908 <memcmp+0x50>
		s1++, s2++;
  8018f0:	ff 45 fc             	incl   -0x4(%ebp)
  8018f3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8018ff:	85 c0                	test   %eax,%eax
  801901:	75 c9                	jne    8018cc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801910:	8b 55 08             	mov    0x8(%ebp),%edx
  801913:	8b 45 10             	mov    0x10(%ebp),%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80191b:	eb 15                	jmp    801932 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	0f b6 d0             	movzbl %al,%edx
  801925:	8b 45 0c             	mov    0xc(%ebp),%eax
  801928:	0f b6 c0             	movzbl %al,%eax
  80192b:	39 c2                	cmp    %eax,%edx
  80192d:	74 0d                	je     80193c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192f:	ff 45 08             	incl   0x8(%ebp)
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801938:	72 e3                	jb     80191d <memfind+0x13>
  80193a:	eb 01                	jmp    80193d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80193c:	90                   	nop
	return (void *) s;
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801948:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80194f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801956:	eb 03                	jmp    80195b <strtol+0x19>
		s++;
  801958:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	8a 00                	mov    (%eax),%al
  801960:	3c 20                	cmp    $0x20,%al
  801962:	74 f4                	je     801958 <strtol+0x16>
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	8a 00                	mov    (%eax),%al
  801969:	3c 09                	cmp    $0x9,%al
  80196b:	74 eb                	je     801958 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8a 00                	mov    (%eax),%al
  801972:	3c 2b                	cmp    $0x2b,%al
  801974:	75 05                	jne    80197b <strtol+0x39>
		s++;
  801976:	ff 45 08             	incl   0x8(%ebp)
  801979:	eb 13                	jmp    80198e <strtol+0x4c>
	else if (*s == '-')
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	8a 00                	mov    (%eax),%al
  801980:	3c 2d                	cmp    $0x2d,%al
  801982:	75 0a                	jne    80198e <strtol+0x4c>
		s++, neg = 1;
  801984:	ff 45 08             	incl   0x8(%ebp)
  801987:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80198e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801992:	74 06                	je     80199a <strtol+0x58>
  801994:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801998:	75 20                	jne    8019ba <strtol+0x78>
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	8a 00                	mov    (%eax),%al
  80199f:	3c 30                	cmp    $0x30,%al
  8019a1:	75 17                	jne    8019ba <strtol+0x78>
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	40                   	inc    %eax
  8019a7:	8a 00                	mov    (%eax),%al
  8019a9:	3c 78                	cmp    $0x78,%al
  8019ab:	75 0d                	jne    8019ba <strtol+0x78>
		s += 2, base = 16;
  8019ad:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019b1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019b8:	eb 28                	jmp    8019e2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019be:	75 15                	jne    8019d5 <strtol+0x93>
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	8a 00                	mov    (%eax),%al
  8019c5:	3c 30                	cmp    $0x30,%al
  8019c7:	75 0c                	jne    8019d5 <strtol+0x93>
		s++, base = 8;
  8019c9:	ff 45 08             	incl   0x8(%ebp)
  8019cc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019d3:	eb 0d                	jmp    8019e2 <strtol+0xa0>
	else if (base == 0)
  8019d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d9:	75 07                	jne    8019e2 <strtol+0xa0>
		base = 10;
  8019db:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	8a 00                	mov    (%eax),%al
  8019e7:	3c 2f                	cmp    $0x2f,%al
  8019e9:	7e 19                	jle    801a04 <strtol+0xc2>
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	8a 00                	mov    (%eax),%al
  8019f0:	3c 39                	cmp    $0x39,%al
  8019f2:	7f 10                	jg     801a04 <strtol+0xc2>
			dig = *s - '0';
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	8a 00                	mov    (%eax),%al
  8019f9:	0f be c0             	movsbl %al,%eax
  8019fc:	83 e8 30             	sub    $0x30,%eax
  8019ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a02:	eb 42                	jmp    801a46 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	3c 60                	cmp    $0x60,%al
  801a0b:	7e 19                	jle    801a26 <strtol+0xe4>
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	8a 00                	mov    (%eax),%al
  801a12:	3c 7a                	cmp    $0x7a,%al
  801a14:	7f 10                	jg     801a26 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	0f be c0             	movsbl %al,%eax
  801a1e:	83 e8 57             	sub    $0x57,%eax
  801a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a24:	eb 20                	jmp    801a46 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	8a 00                	mov    (%eax),%al
  801a2b:	3c 40                	cmp    $0x40,%al
  801a2d:	7e 39                	jle    801a68 <strtol+0x126>
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8a 00                	mov    (%eax),%al
  801a34:	3c 5a                	cmp    $0x5a,%al
  801a36:	7f 30                	jg     801a68 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	8a 00                	mov    (%eax),%al
  801a3d:	0f be c0             	movsbl %al,%eax
  801a40:	83 e8 37             	sub    $0x37,%eax
  801a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a49:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a4c:	7d 19                	jge    801a67 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a4e:	ff 45 08             	incl   0x8(%ebp)
  801a51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a54:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a58:	89 c2                	mov    %eax,%edx
  801a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a62:	e9 7b ff ff ff       	jmp    8019e2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a67:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6c:	74 08                	je     801a76 <strtol+0x134>
		*endptr = (char *) s;
  801a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a71:	8b 55 08             	mov    0x8(%ebp),%edx
  801a74:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a76:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a7a:	74 07                	je     801a83 <strtol+0x141>
  801a7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7f:	f7 d8                	neg    %eax
  801a81:	eb 03                	jmp    801a86 <strtol+0x144>
  801a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <ltostr>:

void
ltostr(long value, char *str)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a95:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aa0:	79 13                	jns    801ab5 <ltostr+0x2d>
	{
		neg = 1;
  801aa2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801aaf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ab2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801abd:	99                   	cltd   
  801abe:	f7 f9                	idiv   %ecx
  801ac0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ac3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac6:	8d 50 01             	lea    0x1(%eax),%edx
  801ac9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801acc:	89 c2                	mov    %eax,%edx
  801ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad1:	01 d0                	add    %edx,%eax
  801ad3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ad6:	83 c2 30             	add    $0x30,%edx
  801ad9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801adb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ade:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ae3:	f7 e9                	imul   %ecx
  801ae5:	c1 fa 02             	sar    $0x2,%edx
  801ae8:	89 c8                	mov    %ecx,%eax
  801aea:	c1 f8 1f             	sar    $0x1f,%eax
  801aed:	29 c2                	sub    %eax,%edx
  801aef:	89 d0                	mov    %edx,%eax
  801af1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801af4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801af8:	75 bb                	jne    801ab5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801afa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b04:	48                   	dec    %eax
  801b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b08:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b0c:	74 3d                	je     801b4b <ltostr+0xc3>
		start = 1 ;
  801b0e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b15:	eb 34                	jmp    801b4b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1d:	01 d0                	add    %edx,%eax
  801b1f:	8a 00                	mov    (%eax),%al
  801b21:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2a:	01 c2                	add    %eax,%edx
  801b2c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b32:	01 c8                	add    %ecx,%eax
  801b34:	8a 00                	mov    (%eax),%al
  801b36:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3e:	01 c2                	add    %eax,%edx
  801b40:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b43:	88 02                	mov    %al,(%edx)
		start++ ;
  801b45:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b48:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b51:	7c c4                	jl     801b17 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b53:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b59:	01 d0                	add    %edx,%eax
  801b5b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b5e:	90                   	nop
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b67:	ff 75 08             	pushl  0x8(%ebp)
  801b6a:	e8 73 fa ff ff       	call   8015e2 <strlen>
  801b6f:	83 c4 04             	add    $0x4,%esp
  801b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	e8 65 fa ff ff       	call   8015e2 <strlen>
  801b7d:	83 c4 04             	add    $0x4,%esp
  801b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b91:	eb 17                	jmp    801baa <strcconcat+0x49>
		final[s] = str1[s] ;
  801b93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b96:	8b 45 10             	mov    0x10(%ebp),%eax
  801b99:	01 c2                	add    %eax,%edx
  801b9b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	01 c8                	add    %ecx,%eax
  801ba3:	8a 00                	mov    (%eax),%al
  801ba5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ba7:	ff 45 fc             	incl   -0x4(%ebp)
  801baa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bb0:	7c e1                	jl     801b93 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bb2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bc0:	eb 1f                	jmp    801be1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bc5:	8d 50 01             	lea    0x1(%eax),%edx
  801bc8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bcb:	89 c2                	mov    %eax,%edx
  801bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd0:	01 c2                	add    %eax,%edx
  801bd2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd8:	01 c8                	add    %ecx,%eax
  801bda:	8a 00                	mov    (%eax),%al
  801bdc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bde:	ff 45 f8             	incl   -0x8(%ebp)
  801be1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801be4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801be7:	7c d9                	jl     801bc2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bec:	8b 45 10             	mov    0x10(%ebp),%eax
  801bef:	01 d0                	add    %edx,%eax
  801bf1:	c6 00 00             	movb   $0x0,(%eax)
}
  801bf4:	90                   	nop
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bfa:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c03:	8b 45 14             	mov    0x14(%ebp),%eax
  801c06:	8b 00                	mov    (%eax),%eax
  801c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c12:	01 d0                	add    %edx,%eax
  801c14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c1a:	eb 0c                	jmp    801c28 <strsplit+0x31>
			*string++ = 0;
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	8d 50 01             	lea    0x1(%eax),%edx
  801c22:	89 55 08             	mov    %edx,0x8(%ebp)
  801c25:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	8a 00                	mov    (%eax),%al
  801c2d:	84 c0                	test   %al,%al
  801c2f:	74 18                	je     801c49 <strsplit+0x52>
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	8a 00                	mov    (%eax),%al
  801c36:	0f be c0             	movsbl %al,%eax
  801c39:	50                   	push   %eax
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	e8 32 fb ff ff       	call   801774 <strchr>
  801c42:	83 c4 08             	add    $0x8,%esp
  801c45:	85 c0                	test   %eax,%eax
  801c47:	75 d3                	jne    801c1c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	8a 00                	mov    (%eax),%al
  801c4e:	84 c0                	test   %al,%al
  801c50:	74 5a                	je     801cac <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c52:	8b 45 14             	mov    0x14(%ebp),%eax
  801c55:	8b 00                	mov    (%eax),%eax
  801c57:	83 f8 0f             	cmp    $0xf,%eax
  801c5a:	75 07                	jne    801c63 <strsplit+0x6c>
		{
			return 0;
  801c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c61:	eb 66                	jmp    801cc9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c63:	8b 45 14             	mov    0x14(%ebp),%eax
  801c66:	8b 00                	mov    (%eax),%eax
  801c68:	8d 48 01             	lea    0x1(%eax),%ecx
  801c6b:	8b 55 14             	mov    0x14(%ebp),%edx
  801c6e:	89 0a                	mov    %ecx,(%edx)
  801c70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c77:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7a:	01 c2                	add    %eax,%edx
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c81:	eb 03                	jmp    801c86 <strsplit+0x8f>
			string++;
  801c83:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	8a 00                	mov    (%eax),%al
  801c8b:	84 c0                	test   %al,%al
  801c8d:	74 8b                	je     801c1a <strsplit+0x23>
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	8a 00                	mov    (%eax),%al
  801c94:	0f be c0             	movsbl %al,%eax
  801c97:	50                   	push   %eax
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	e8 d4 fa ff ff       	call   801774 <strchr>
  801ca0:	83 c4 08             	add    $0x8,%esp
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	74 dc                	je     801c83 <strsplit+0x8c>
			string++;
	}
  801ca7:	e9 6e ff ff ff       	jmp    801c1a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cac:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cad:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb0:	8b 00                	mov    (%eax),%eax
  801cb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbc:	01 d0                	add    %edx,%eax
  801cbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cc4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	68 88 50 80 00       	push   $0x805088
  801cd9:	68 3f 01 00 00       	push   $0x13f
  801cde:	68 aa 50 80 00       	push   $0x8050aa
  801ce3:	e8 a9 ef ff ff       	call   800c91 <_panic>

00801ce8 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801cee:	83 ec 0c             	sub    $0xc,%esp
  801cf1:	ff 75 08             	pushl  0x8(%ebp)
  801cf4:	e8 e5 0b 00 00       	call   8028de <sys_sbrk>
  801cf9:	83 c4 10             	add    $0x10,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801d04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d08:	75 0a                	jne    801d14 <malloc+0x16>
  801d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0f:	e9 07 02 00 00       	jmp    801f1b <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801d14:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d21:	01 d0                	add    %edx,%eax
  801d23:	48                   	dec    %eax
  801d24:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d27:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2f:	f7 75 dc             	divl   -0x24(%ebp)
  801d32:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d35:	29 d0                	sub    %edx,%eax
  801d37:	c1 e8 0c             	shr    $0xc,%eax
  801d3a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801d3d:	a1 20 60 80 00       	mov    0x806020,%eax
  801d42:	8b 40 78             	mov    0x78(%eax),%eax
  801d45:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801d4a:	29 c2                	sub    %eax,%edx
  801d4c:	89 d0                	mov    %edx,%eax
  801d4e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801d51:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d59:	c1 e8 0c             	shr    $0xc,%eax
  801d5c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801d5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801d66:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801d6d:	77 42                	ja     801db1 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d6f:	e8 ee 09 00 00       	call   802762 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d74:	85 c0                	test   %eax,%eax
  801d76:	74 16                	je     801d8e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	ff 75 08             	pushl  0x8(%ebp)
  801d7e:	e8 2e 0f 00 00       	call   802cb1 <alloc_block_FF>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d89:	e9 8a 01 00 00       	jmp    801f18 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d8e:	e8 00 0a 00 00       	call   802793 <sys_isUHeapPlacementStrategyBESTFIT>
  801d93:	85 c0                	test   %eax,%eax
  801d95:	0f 84 7d 01 00 00    	je     801f18 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	e8 c7 13 00 00       	call   80316d <alloc_block_BF>
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dac:	e9 67 01 00 00       	jmp    801f18 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801db1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801db4:	48                   	dec    %eax
  801db5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801db8:	0f 86 53 01 00 00    	jbe    801f11 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801dbe:	a1 20 60 80 00       	mov    0x806020,%eax
  801dc3:	8b 40 78             	mov    0x78(%eax),%eax
  801dc6:	05 00 10 00 00       	add    $0x1000,%eax
  801dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801dce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801dd5:	e9 de 00 00 00       	jmp    801eb8 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801dda:	a1 20 60 80 00       	mov    0x806020,%eax
  801ddf:	8b 40 78             	mov    0x78(%eax),%eax
  801de2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801de5:	29 c2                	sub    %eax,%edx
  801de7:	89 d0                	mov    %edx,%eax
  801de9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dee:	c1 e8 0c             	shr    $0xc,%eax
  801df1:	8b 04 85 60 a0 08 01 	mov    0x108a060(,%eax,4),%eax
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	0f 85 ab 00 00 00    	jne    801eab <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e03:	05 00 10 00 00       	add    $0x1000,%eax
  801e08:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801e0b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801e12:	eb 47                	jmp    801e5b <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801e14:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801e1b:	76 0a                	jbe    801e27 <malloc+0x129>
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e22:	e9 f4 00 00 00       	jmp    801f1b <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801e27:	a1 20 60 80 00       	mov    0x806020,%eax
  801e2c:	8b 40 78             	mov    0x78(%eax),%eax
  801e2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e32:	29 c2                	sub    %eax,%edx
  801e34:	89 d0                	mov    %edx,%eax
  801e36:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e3b:	c1 e8 0c             	shr    $0xc,%eax
  801e3e:	8b 04 85 60 a0 08 01 	mov    0x108a060(,%eax,4),%eax
  801e45:	85 c0                	test   %eax,%eax
  801e47:	74 08                	je     801e51 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801e4f:	eb 5a                	jmp    801eab <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801e51:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801e58:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801e5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5e:	48                   	dec    %eax
  801e5f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e62:	77 b0                	ja     801e14 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801e64:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801e6b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801e72:	eb 2f                	jmp    801ea3 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e77:	c1 e0 0c             	shl    $0xc,%eax
  801e7a:	89 c2                	mov    %eax,%edx
  801e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7f:	01 c2                	add    %eax,%edx
  801e81:	a1 20 60 80 00       	mov    0x806020,%eax
  801e86:	8b 40 78             	mov    0x78(%eax),%eax
  801e89:	29 c2                	sub    %eax,%edx
  801e8b:	89 d0                	mov    %edx,%eax
  801e8d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e92:	c1 e8 0c             	shr    $0xc,%eax
  801e95:	c7 04 85 60 a0 08 01 	movl   $0x1,0x108a060(,%eax,4)
  801e9c:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801ea0:	ff 45 e0             	incl   -0x20(%ebp)
  801ea3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ea9:	72 c9                	jb     801e74 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801eab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801eaf:	75 16                	jne    801ec7 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801eb1:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801eb8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801ebf:	0f 86 15 ff ff ff    	jbe    801dda <malloc+0xdc>
  801ec5:	eb 01                	jmp    801ec8 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801ec7:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801ec8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ecc:	75 07                	jne    801ed5 <malloc+0x1d7>
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	eb 46                	jmp    801f1b <malloc+0x21d>
		ptr = (void*)i;
  801ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801edb:	a1 20 60 80 00       	mov    0x806020,%eax
  801ee0:	8b 40 78             	mov    0x78(%eax),%eax
  801ee3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ee6:	29 c2                	sub    %eax,%edx
  801ee8:	89 d0                	mov    %edx,%eax
  801eea:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eef:	c1 e8 0c             	shr    $0xc,%eax
  801ef2:	89 c2                	mov    %eax,%edx
  801ef4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ef7:	89 04 95 60 a0 10 01 	mov    %eax,0x110a060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801efe:	83 ec 08             	sub    $0x8,%esp
  801f01:	ff 75 08             	pushl  0x8(%ebp)
  801f04:	ff 75 f0             	pushl  -0x10(%ebp)
  801f07:	e8 09 0a 00 00       	call   802915 <sys_allocate_user_mem>
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	eb 07                	jmp    801f18 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
  801f16:	eb 03                	jmp    801f1b <malloc+0x21d>
	}
	return ptr;
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801f23:	a1 20 60 80 00       	mov    0x806020,%eax
  801f28:	8b 40 78             	mov    0x78(%eax),%eax
  801f2b:	05 00 10 00 00       	add    $0x1000,%eax
  801f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801f33:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801f3a:	a1 20 60 80 00       	mov    0x806020,%eax
  801f3f:	8b 50 78             	mov    0x78(%eax),%edx
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	39 c2                	cmp    %eax,%edx
  801f47:	76 24                	jbe    801f6d <free+0x50>
		size = get_block_size(va);
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	ff 75 08             	pushl  0x8(%ebp)
  801f4f:	e8 dd 09 00 00       	call   802931 <get_block_size>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	ff 75 08             	pushl  0x8(%ebp)
  801f60:	e8 10 1c 00 00       	call   803b75 <free_block>
  801f65:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801f68:	e9 ac 00 00 00       	jmp    802019 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f73:	0f 82 89 00 00 00    	jb     802002 <free+0xe5>
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801f81:	77 7f                	ja     802002 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801f83:	8b 55 08             	mov    0x8(%ebp),%edx
  801f86:	a1 20 60 80 00       	mov    0x806020,%eax
  801f8b:	8b 40 78             	mov    0x78(%eax),%eax
  801f8e:	29 c2                	sub    %eax,%edx
  801f90:	89 d0                	mov    %edx,%eax
  801f92:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f97:	c1 e8 0c             	shr    $0xc,%eax
  801f9a:	8b 04 85 60 a0 10 01 	mov    0x110a060(,%eax,4),%eax
  801fa1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa7:	c1 e0 0c             	shl    $0xc,%eax
  801faa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801fad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fb4:	eb 42                	jmp    801ff8 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	c1 e0 0c             	shl    $0xc,%eax
  801fbc:	89 c2                	mov    %eax,%edx
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	01 c2                	add    %eax,%edx
  801fc3:	a1 20 60 80 00       	mov    0x806020,%eax
  801fc8:	8b 40 78             	mov    0x78(%eax),%eax
  801fcb:	29 c2                	sub    %eax,%edx
  801fcd:	89 d0                	mov    %edx,%eax
  801fcf:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fd4:	c1 e8 0c             	shr    $0xc,%eax
  801fd7:	c7 04 85 60 a0 08 01 	movl   $0x0,0x108a060(,%eax,4)
  801fde:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801fe2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	83 ec 08             	sub    $0x8,%esp
  801feb:	52                   	push   %edx
  801fec:	50                   	push   %eax
  801fed:	e8 07 09 00 00       	call   8028f9 <sys_free_user_mem>
  801ff2:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801ff5:	ff 45 f4             	incl   -0xc(%ebp)
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ffe:	72 b6                	jb     801fb6 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802000:	eb 17                	jmp    802019 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	68 b8 50 80 00       	push   $0x8050b8
  80200a:	68 88 00 00 00       	push   $0x88
  80200f:	68 e2 50 80 00       	push   $0x8050e2
  802014:	e8 78 ec ff ff       	call   800c91 <_panic>
	}
}
  802019:	90                   	nop
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	83 ec 28             	sub    $0x28,%esp
  802022:	8b 45 10             	mov    0x10(%ebp),%eax
  802025:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802028:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80202c:	75 0a                	jne    802038 <smalloc+0x1c>
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
  802033:	e9 ec 00 00 00       	jmp    802124 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802045:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	39 d0                	cmp    %edx,%eax
  80204d:	73 02                	jae    802051 <smalloc+0x35>
  80204f:	89 d0                	mov    %edx,%eax
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	50                   	push   %eax
  802055:	e8 a4 fc ff ff       	call   801cfe <malloc>
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802060:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802064:	75 0a                	jne    802070 <smalloc+0x54>
  802066:	b8 00 00 00 00       	mov    $0x0,%eax
  80206b:	e9 b4 00 00 00       	jmp    802124 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802070:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802074:	ff 75 ec             	pushl  -0x14(%ebp)
  802077:	50                   	push   %eax
  802078:	ff 75 0c             	pushl  0xc(%ebp)
  80207b:	ff 75 08             	pushl  0x8(%ebp)
  80207e:	e8 7d 04 00 00       	call   802500 <sys_createSharedObject>
  802083:	83 c4 10             	add    $0x10,%esp
  802086:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802089:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80208d:	74 06                	je     802095 <smalloc+0x79>
  80208f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802093:	75 0a                	jne    80209f <smalloc+0x83>
  802095:	b8 00 00 00 00       	mov    $0x0,%eax
  80209a:	e9 85 00 00 00       	jmp    802124 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  80209f:	83 ec 08             	sub    $0x8,%esp
  8020a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8020a5:	68 ee 50 80 00       	push   $0x8050ee
  8020aa:	e8 9f ee ff ff       	call   800f4e <cprintf>
  8020af:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8020b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8020ba:	8b 40 78             	mov    0x78(%eax),%eax
  8020bd:	29 c2                	sub    %eax,%edx
  8020bf:	89 d0                	mov    %edx,%eax
  8020c1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8020c6:	c1 e8 0c             	shr    $0xc,%eax
  8020c9:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8020cf:	42                   	inc    %edx
  8020d0:	89 15 24 60 80 00    	mov    %edx,0x806024
  8020d6:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8020dc:	89 14 85 60 a0 00 01 	mov    %edx,0x100a060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8020e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020e6:	a1 20 60 80 00       	mov    0x806020,%eax
  8020eb:	8b 40 78             	mov    0x78(%eax),%eax
  8020ee:	29 c2                	sub    %eax,%edx
  8020f0:	89 d0                	mov    %edx,%eax
  8020f2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8020f7:	c1 e8 0c             	shr    $0xc,%eax
  8020fa:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  802101:	a1 20 60 80 00       	mov    0x806020,%eax
  802106:	8b 50 10             	mov    0x10(%eax),%edx
  802109:	89 c8                	mov    %ecx,%eax
  80210b:	c1 e0 02             	shl    $0x2,%eax
  80210e:	89 c1                	mov    %eax,%ecx
  802110:	c1 e1 09             	shl    $0x9,%ecx
  802113:	01 c8                	add    %ecx,%eax
  802115:	01 c2                	add    %eax,%edx
  802117:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80211a:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  802121:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80212c:	83 ec 08             	sub    $0x8,%esp
  80212f:	ff 75 0c             	pushl  0xc(%ebp)
  802132:	ff 75 08             	pushl  0x8(%ebp)
  802135:	e8 f0 03 00 00       	call   80252a <sys_getSizeOfSharedObject>
  80213a:	83 c4 10             	add    $0x10,%esp
  80213d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802140:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802144:	75 0a                	jne    802150 <sget+0x2a>
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
  80214b:	e9 e7 00 00 00       	jmp    802237 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802153:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802156:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80215d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802163:	39 d0                	cmp    %edx,%eax
  802165:	73 02                	jae    802169 <sget+0x43>
  802167:	89 d0                	mov    %edx,%eax
  802169:	83 ec 0c             	sub    $0xc,%esp
  80216c:	50                   	push   %eax
  80216d:	e8 8c fb ff ff       	call   801cfe <malloc>
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802178:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80217c:	75 0a                	jne    802188 <sget+0x62>
  80217e:	b8 00 00 00 00       	mov    $0x0,%eax
  802183:	e9 af 00 00 00       	jmp    802237 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802188:	83 ec 04             	sub    $0x4,%esp
  80218b:	ff 75 e8             	pushl  -0x18(%ebp)
  80218e:	ff 75 0c             	pushl  0xc(%ebp)
  802191:	ff 75 08             	pushl  0x8(%ebp)
  802194:	e8 ae 03 00 00       	call   802547 <sys_getSharedObject>
  802199:	83 c4 10             	add    $0x10,%esp
  80219c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  80219f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8021a7:	8b 40 78             	mov    0x78(%eax),%eax
  8021aa:	29 c2                	sub    %eax,%edx
  8021ac:	89 d0                	mov    %edx,%eax
  8021ae:	2d 00 10 00 00       	sub    $0x1000,%eax
  8021b3:	c1 e8 0c             	shr    $0xc,%eax
  8021b6:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8021bc:	42                   	inc    %edx
  8021bd:	89 15 24 60 80 00    	mov    %edx,0x806024
  8021c3:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8021c9:	89 14 85 60 a0 00 01 	mov    %edx,0x100a060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8021d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021d3:	a1 20 60 80 00       	mov    0x806020,%eax
  8021d8:	8b 40 78             	mov    0x78(%eax),%eax
  8021db:	29 c2                	sub    %eax,%edx
  8021dd:	89 d0                	mov    %edx,%eax
  8021df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8021e4:	c1 e8 0c             	shr    $0xc,%eax
  8021e7:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  8021ee:	a1 20 60 80 00       	mov    0x806020,%eax
  8021f3:	8b 50 10             	mov    0x10(%eax),%edx
  8021f6:	89 c8                	mov    %ecx,%eax
  8021f8:	c1 e0 02             	shl    $0x2,%eax
  8021fb:	89 c1                	mov    %eax,%ecx
  8021fd:	c1 e1 09             	shl    $0x9,%ecx
  802200:	01 c8                	add    %ecx,%eax
  802202:	01 c2                	add    %eax,%edx
  802204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802207:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  80220e:	a1 20 60 80 00       	mov    0x806020,%eax
  802213:	8b 40 10             	mov    0x10(%eax),%eax
  802216:	83 ec 08             	sub    $0x8,%esp
  802219:	50                   	push   %eax
  80221a:	68 fd 50 80 00       	push   $0x8050fd
  80221f:	e8 2a ed ff ff       	call   800f4e <cprintf>
  802224:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802227:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80222b:	75 07                	jne    802234 <sget+0x10e>
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
  802232:	eb 03                	jmp    802237 <sget+0x111>
	return ptr;
  802234:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80223f:	8b 55 08             	mov    0x8(%ebp),%edx
  802242:	a1 20 60 80 00       	mov    0x806020,%eax
  802247:	8b 40 78             	mov    0x78(%eax),%eax
  80224a:	29 c2                	sub    %eax,%edx
  80224c:	89 d0                	mov    %edx,%eax
  80224e:	2d 00 10 00 00       	sub    $0x1000,%eax
  802253:	c1 e8 0c             	shr    $0xc,%eax
  802256:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  80225d:	a1 20 60 80 00       	mov    0x806020,%eax
  802262:	8b 50 10             	mov    0x10(%eax),%edx
  802265:	89 c8                	mov    %ecx,%eax
  802267:	c1 e0 02             	shl    $0x2,%eax
  80226a:	89 c1                	mov    %eax,%ecx
  80226c:	c1 e1 09             	shl    $0x9,%ecx
  80226f:	01 c8                	add    %ecx,%eax
  802271:	01 d0                	add    %edx,%eax
  802273:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80227a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80227d:	83 ec 08             	sub    $0x8,%esp
  802280:	ff 75 08             	pushl  0x8(%ebp)
  802283:	ff 75 f4             	pushl  -0xc(%ebp)
  802286:	e8 db 02 00 00       	call   802566 <sys_freeSharedObject>
  80228b:	83 c4 10             	add    $0x10,%esp
  80228e:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802291:	90                   	nop
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80229a:	83 ec 04             	sub    $0x4,%esp
  80229d:	68 0c 51 80 00       	push   $0x80510c
  8022a2:	68 e5 00 00 00       	push   $0xe5
  8022a7:	68 e2 50 80 00       	push   $0x8050e2
  8022ac:	e8 e0 e9 ff ff       	call   800c91 <_panic>

008022b1 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	68 32 51 80 00       	push   $0x805132
  8022bf:	68 f1 00 00 00       	push   $0xf1
  8022c4:	68 e2 50 80 00       	push   $0x8050e2
  8022c9:	e8 c3 e9 ff ff       	call   800c91 <_panic>

008022ce <shrink>:

}
void shrink(uint32 newSize)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	68 32 51 80 00       	push   $0x805132
  8022dc:	68 f6 00 00 00       	push   $0xf6
  8022e1:	68 e2 50 80 00       	push   $0x8050e2
  8022e6:	e8 a6 e9 ff ff       	call   800c91 <_panic>

008022eb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022f1:	83 ec 04             	sub    $0x4,%esp
  8022f4:	68 32 51 80 00       	push   $0x805132
  8022f9:	68 fb 00 00 00       	push   $0xfb
  8022fe:	68 e2 50 80 00       	push   $0x8050e2
  802303:	e8 89 e9 ff ff       	call   800c91 <_panic>

00802308 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	57                   	push   %edi
  80230c:	56                   	push   %esi
  80230d:	53                   	push   %ebx
  80230e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	8b 55 0c             	mov    0xc(%ebp),%edx
  802317:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80231a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80231d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802320:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802323:	cd 30                	int    $0x30
  802325:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802328:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80232b:	83 c4 10             	add    $0x10,%esp
  80232e:	5b                   	pop    %ebx
  80232f:	5e                   	pop    %esi
  802330:	5f                   	pop    %edi
  802331:	5d                   	pop    %ebp
  802332:	c3                   	ret    

00802333 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 04             	sub    $0x4,%esp
  802339:	8b 45 10             	mov    0x10(%ebp),%eax
  80233c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80233f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	52                   	push   %edx
  80234b:	ff 75 0c             	pushl  0xc(%ebp)
  80234e:	50                   	push   %eax
  80234f:	6a 00                	push   $0x0
  802351:	e8 b2 ff ff ff       	call   802308 <syscall>
  802356:	83 c4 18             	add    $0x18,%esp
}
  802359:	90                   	nop
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <sys_cgetc>:

int
sys_cgetc(void)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 02                	push   $0x2
  80236b:	e8 98 ff ff ff       	call   802308 <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 03                	push   $0x3
  802384:	e8 7f ff ff ff       	call   802308 <syscall>
  802389:	83 c4 18             	add    $0x18,%esp
}
  80238c:	90                   	nop
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 04                	push   $0x4
  80239e:	e8 65 ff ff ff       	call   802308 <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
}
  8023a6:	90                   	nop
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	52                   	push   %edx
  8023b9:	50                   	push   %eax
  8023ba:	6a 08                	push   $0x8
  8023bc:	e8 47 ff ff ff       	call   802308 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	56                   	push   %esi
  8023ca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023cb:	8b 75 18             	mov    0x18(%ebp),%esi
  8023ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	56                   	push   %esi
  8023db:	53                   	push   %ebx
  8023dc:	51                   	push   %ecx
  8023dd:	52                   	push   %edx
  8023de:	50                   	push   %eax
  8023df:	6a 09                	push   $0x9
  8023e1:	e8 22 ff ff ff       	call   802308 <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
}
  8023e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5e                   	pop    %esi
  8023ee:	5d                   	pop    %ebp
  8023ef:	c3                   	ret    

008023f0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8023f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	52                   	push   %edx
  802400:	50                   	push   %eax
  802401:	6a 0a                	push   $0xa
  802403:	e8 00 ff ff ff       	call   802308 <syscall>
  802408:	83 c4 18             	add    $0x18,%esp
}
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	ff 75 0c             	pushl  0xc(%ebp)
  802419:	ff 75 08             	pushl  0x8(%ebp)
  80241c:	6a 0b                	push   $0xb
  80241e:	e8 e5 fe ff ff       	call   802308 <syscall>
  802423:	83 c4 18             	add    $0x18,%esp
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 0c                	push   $0xc
  802437:	e8 cc fe ff ff       	call   802308 <syscall>
  80243c:	83 c4 18             	add    $0x18,%esp
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 0d                	push   $0xd
  802450:	e8 b3 fe ff ff       	call   802308 <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 0e                	push   $0xe
  802469:	e8 9a fe ff ff       	call   802308 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 0f                	push   $0xf
  802482:	e8 81 fe ff ff       	call   802308 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
}
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	ff 75 08             	pushl  0x8(%ebp)
  80249a:	6a 10                	push   $0x10
  80249c:	e8 67 fe ff ff       	call   802308 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 11                	push   $0x11
  8024b5:	e8 4e fe ff ff       	call   802308 <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
}
  8024bd:	90                   	nop
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 04             	sub    $0x4,%esp
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	50                   	push   %eax
  8024d9:	6a 01                	push   $0x1
  8024db:	e8 28 fe ff ff       	call   802308 <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
}
  8024e3:	90                   	nop
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 14                	push   $0x14
  8024f5:	e8 0e fe ff ff       	call   802308 <syscall>
  8024fa:	83 c4 18             	add    $0x18,%esp
}
  8024fd:	90                   	nop
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 04             	sub    $0x4,%esp
  802506:	8b 45 10             	mov    0x10(%ebp),%eax
  802509:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80250c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80250f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	6a 00                	push   $0x0
  802518:	51                   	push   %ecx
  802519:	52                   	push   %edx
  80251a:	ff 75 0c             	pushl  0xc(%ebp)
  80251d:	50                   	push   %eax
  80251e:	6a 15                	push   $0x15
  802520:	e8 e3 fd ff ff       	call   802308 <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80252d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	52                   	push   %edx
  80253a:	50                   	push   %eax
  80253b:	6a 16                	push   $0x16
  80253d:	e8 c6 fd ff ff       	call   802308 <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80254a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80254d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	51                   	push   %ecx
  802558:	52                   	push   %edx
  802559:	50                   	push   %eax
  80255a:	6a 17                	push   $0x17
  80255c:	e8 a7 fd ff ff       	call   802308 <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802569:	8b 55 0c             	mov    0xc(%ebp),%edx
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	52                   	push   %edx
  802576:	50                   	push   %eax
  802577:	6a 18                	push   $0x18
  802579:	e8 8a fd ff ff       	call   802308 <syscall>
  80257e:	83 c4 18             	add    $0x18,%esp
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802586:	8b 45 08             	mov    0x8(%ebp),%eax
  802589:	6a 00                	push   $0x0
  80258b:	ff 75 14             	pushl  0x14(%ebp)
  80258e:	ff 75 10             	pushl  0x10(%ebp)
  802591:	ff 75 0c             	pushl  0xc(%ebp)
  802594:	50                   	push   %eax
  802595:	6a 19                	push   $0x19
  802597:	e8 6c fd ff ff       	call   802308 <syscall>
  80259c:	83 c4 18             	add    $0x18,%esp
}
  80259f:	c9                   	leave  
  8025a0:	c3                   	ret    

008025a1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	50                   	push   %eax
  8025b0:	6a 1a                	push   $0x1a
  8025b2:	e8 51 fd ff ff       	call   802308 <syscall>
  8025b7:	83 c4 18             	add    $0x18,%esp
}
  8025ba:	90                   	nop
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	50                   	push   %eax
  8025cc:	6a 1b                	push   $0x1b
  8025ce:	e8 35 fd ff ff       	call   802308 <syscall>
  8025d3:	83 c4 18             	add    $0x18,%esp
}
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 05                	push   $0x5
  8025e7:	e8 1c fd ff ff       	call   802308 <syscall>
  8025ec:	83 c4 18             	add    $0x18,%esp
}
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 06                	push   $0x6
  802600:	e8 03 fd ff ff       	call   802308 <syscall>
  802605:	83 c4 18             	add    $0x18,%esp
}
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	6a 07                	push   $0x7
  802619:	e8 ea fc ff ff       	call   802308 <syscall>
  80261e:	83 c4 18             	add    $0x18,%esp
}
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <sys_exit_env>:


void sys_exit_env(void)
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 1c                	push   $0x1c
  802632:	e8 d1 fc ff ff       	call   802308 <syscall>
  802637:	83 c4 18             	add    $0x18,%esp
}
  80263a:	90                   	nop
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802643:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802646:	8d 50 04             	lea    0x4(%eax),%edx
  802649:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	52                   	push   %edx
  802653:	50                   	push   %eax
  802654:	6a 1d                	push   $0x1d
  802656:	e8 ad fc ff ff       	call   802308 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
	return result;
  80265e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802664:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802667:	89 01                	mov    %eax,(%ecx)
  802669:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	c9                   	leave  
  802670:	c2 04 00             	ret    $0x4

00802673 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	ff 75 10             	pushl  0x10(%ebp)
  80267d:	ff 75 0c             	pushl  0xc(%ebp)
  802680:	ff 75 08             	pushl  0x8(%ebp)
  802683:	6a 13                	push   $0x13
  802685:	e8 7e fc ff ff       	call   802308 <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
	return ;
  80268d:	90                   	nop
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_rcr2>:
uint32 sys_rcr2()
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 00                	push   $0x0
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 1e                	push   $0x1e
  80269f:	e8 64 fc ff ff       	call   802308 <syscall>
  8026a4:	83 c4 18             	add    $0x18,%esp
}
  8026a7:	c9                   	leave  
  8026a8:	c3                   	ret    

008026a9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026b5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	50                   	push   %eax
  8026c2:	6a 1f                	push   $0x1f
  8026c4:	e8 3f fc ff ff       	call   802308 <syscall>
  8026c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8026cc:	90                   	nop
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <rsttst>:
void rsttst()
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 21                	push   $0x21
  8026de:	e8 25 fc ff ff       	call   802308 <syscall>
  8026e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e6:	90                   	nop
}
  8026e7:	c9                   	leave  
  8026e8:	c3                   	ret    

008026e9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
  8026ec:	83 ec 04             	sub    $0x4,%esp
  8026ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8026f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026f5:	8b 55 18             	mov    0x18(%ebp),%edx
  8026f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026fc:	52                   	push   %edx
  8026fd:	50                   	push   %eax
  8026fe:	ff 75 10             	pushl  0x10(%ebp)
  802701:	ff 75 0c             	pushl  0xc(%ebp)
  802704:	ff 75 08             	pushl  0x8(%ebp)
  802707:	6a 20                	push   $0x20
  802709:	e8 fa fb ff ff       	call   802308 <syscall>
  80270e:	83 c4 18             	add    $0x18,%esp
	return ;
  802711:	90                   	nop
}
  802712:	c9                   	leave  
  802713:	c3                   	ret    

00802714 <chktst>:
void chktst(uint32 n)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	ff 75 08             	pushl  0x8(%ebp)
  802722:	6a 22                	push   $0x22
  802724:	e8 df fb ff ff       	call   802308 <syscall>
  802729:	83 c4 18             	add    $0x18,%esp
	return ;
  80272c:	90                   	nop
}
  80272d:	c9                   	leave  
  80272e:	c3                   	ret    

0080272f <inctst>:

void inctst()
{
  80272f:	55                   	push   %ebp
  802730:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 23                	push   $0x23
  80273e:	e8 c5 fb ff ff       	call   802308 <syscall>
  802743:	83 c4 18             	add    $0x18,%esp
	return ;
  802746:	90                   	nop
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <gettst>:
uint32 gettst()
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 24                	push   $0x24
  802758:	e8 ab fb ff ff       	call   802308 <syscall>
  80275d:	83 c4 18             	add    $0x18,%esp
}
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802768:	6a 00                	push   $0x0
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	6a 25                	push   $0x25
  802774:	e8 8f fb ff ff       	call   802308 <syscall>
  802779:	83 c4 18             	add    $0x18,%esp
  80277c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80277f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802783:	75 07                	jne    80278c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802785:	b8 01 00 00 00       	mov    $0x1,%eax
  80278a:	eb 05                	jmp    802791 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80278c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
  802796:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 25                	push   $0x25
  8027a5:	e8 5e fb ff ff       	call   802308 <syscall>
  8027aa:	83 c4 18             	add    $0x18,%esp
  8027ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027b0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027b4:	75 07                	jne    8027bd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027bb:	eb 05                	jmp    8027c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 25                	push   $0x25
  8027d6:	e8 2d fb ff ff       	call   802308 <syscall>
  8027db:	83 c4 18             	add    $0x18,%esp
  8027de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027e1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027e5:	75 07                	jne    8027ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ec:	eb 05                	jmp    8027f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f3:	c9                   	leave  
  8027f4:	c3                   	ret    

008027f5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
  8027f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	6a 00                	push   $0x0
  802805:	6a 25                	push   $0x25
  802807:	e8 fc fa ff ff       	call   802308 <syscall>
  80280c:	83 c4 18             	add    $0x18,%esp
  80280f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802812:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802816:	75 07                	jne    80281f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802818:	b8 01 00 00 00       	mov    $0x1,%eax
  80281d:	eb 05                	jmp    802824 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	ff 75 08             	pushl  0x8(%ebp)
  802834:	6a 26                	push   $0x26
  802836:	e8 cd fa ff ff       	call   802308 <syscall>
  80283b:	83 c4 18             	add    $0x18,%esp
	return ;
  80283e:	90                   	nop
}
  80283f:	c9                   	leave  
  802840:	c3                   	ret    

00802841 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802845:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802848:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80284b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	6a 00                	push   $0x0
  802853:	53                   	push   %ebx
  802854:	51                   	push   %ecx
  802855:	52                   	push   %edx
  802856:	50                   	push   %eax
  802857:	6a 27                	push   $0x27
  802859:	e8 aa fa ff ff       	call   802308 <syscall>
  80285e:	83 c4 18             	add    $0x18,%esp
}
  802861:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	52                   	push   %edx
  802876:	50                   	push   %eax
  802877:	6a 28                	push   $0x28
  802879:	e8 8a fa ff ff       	call   802308 <syscall>
  80287e:	83 c4 18             	add    $0x18,%esp
}
  802881:	c9                   	leave  
  802882:	c3                   	ret    

00802883 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802886:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802889:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	6a 00                	push   $0x0
  802891:	51                   	push   %ecx
  802892:	ff 75 10             	pushl  0x10(%ebp)
  802895:	52                   	push   %edx
  802896:	50                   	push   %eax
  802897:	6a 29                	push   $0x29
  802899:	e8 6a fa ff ff       	call   802308 <syscall>
  80289e:	83 c4 18             	add    $0x18,%esp
}
  8028a1:	c9                   	leave  
  8028a2:	c3                   	ret    

008028a3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8028a3:	55                   	push   %ebp
  8028a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 00                	push   $0x0
  8028aa:	ff 75 10             	pushl  0x10(%ebp)
  8028ad:	ff 75 0c             	pushl  0xc(%ebp)
  8028b0:	ff 75 08             	pushl  0x8(%ebp)
  8028b3:	6a 12                	push   $0x12
  8028b5:	e8 4e fa ff ff       	call   802308 <syscall>
  8028ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8028bd:	90                   	nop
}
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8028c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 00                	push   $0x0
  8028cf:	52                   	push   %edx
  8028d0:	50                   	push   %eax
  8028d1:	6a 2a                	push   $0x2a
  8028d3:	e8 30 fa ff ff       	call   802308 <syscall>
  8028d8:	83 c4 18             	add    $0x18,%esp
	return;
  8028db:	90                   	nop
}
  8028dc:	c9                   	leave  
  8028dd:	c3                   	ret    

008028de <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8028de:	55                   	push   %ebp
  8028df:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8028e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 00                	push   $0x0
  8028ea:	6a 00                	push   $0x0
  8028ec:	50                   	push   %eax
  8028ed:	6a 2b                	push   $0x2b
  8028ef:	e8 14 fa ff ff       	call   802308 <syscall>
  8028f4:	83 c4 18             	add    $0x18,%esp
}
  8028f7:	c9                   	leave  
  8028f8:	c3                   	ret    

008028f9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 00                	push   $0x0
  802902:	ff 75 0c             	pushl  0xc(%ebp)
  802905:	ff 75 08             	pushl  0x8(%ebp)
  802908:	6a 2c                	push   $0x2c
  80290a:	e8 f9 f9 ff ff       	call   802308 <syscall>
  80290f:	83 c4 18             	add    $0x18,%esp
	return;
  802912:	90                   	nop
}
  802913:	c9                   	leave  
  802914:	c3                   	ret    

00802915 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	ff 75 0c             	pushl  0xc(%ebp)
  802921:	ff 75 08             	pushl  0x8(%ebp)
  802924:	6a 2d                	push   $0x2d
  802926:	e8 dd f9 ff ff       	call   802308 <syscall>
  80292b:	83 c4 18             	add    $0x18,%esp
	return;
  80292e:	90                   	nop
}
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	83 e8 04             	sub    $0x4,%eax
  80293d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802940:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802948:	c9                   	leave  
  802949:	c3                   	ret    

0080294a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	83 e8 04             	sub    $0x4,%eax
  802956:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802959:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	83 e0 01             	and    $0x1,%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	0f 94 c0             	sete   %al
}
  802966:	c9                   	leave  
  802967:	c3                   	ret    

00802968 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80296e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802975:	8b 45 0c             	mov    0xc(%ebp),%eax
  802978:	83 f8 02             	cmp    $0x2,%eax
  80297b:	74 2b                	je     8029a8 <alloc_block+0x40>
  80297d:	83 f8 02             	cmp    $0x2,%eax
  802980:	7f 07                	jg     802989 <alloc_block+0x21>
  802982:	83 f8 01             	cmp    $0x1,%eax
  802985:	74 0e                	je     802995 <alloc_block+0x2d>
  802987:	eb 58                	jmp    8029e1 <alloc_block+0x79>
  802989:	83 f8 03             	cmp    $0x3,%eax
  80298c:	74 2d                	je     8029bb <alloc_block+0x53>
  80298e:	83 f8 04             	cmp    $0x4,%eax
  802991:	74 3b                	je     8029ce <alloc_block+0x66>
  802993:	eb 4c                	jmp    8029e1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802995:	83 ec 0c             	sub    $0xc,%esp
  802998:	ff 75 08             	pushl  0x8(%ebp)
  80299b:	e8 11 03 00 00       	call   802cb1 <alloc_block_FF>
  8029a0:	83 c4 10             	add    $0x10,%esp
  8029a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029a6:	eb 4a                	jmp    8029f2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8029a8:	83 ec 0c             	sub    $0xc,%esp
  8029ab:	ff 75 08             	pushl  0x8(%ebp)
  8029ae:	e8 fa 19 00 00       	call   8043ad <alloc_block_NF>
  8029b3:	83 c4 10             	add    $0x10,%esp
  8029b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029b9:	eb 37                	jmp    8029f2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8029bb:	83 ec 0c             	sub    $0xc,%esp
  8029be:	ff 75 08             	pushl  0x8(%ebp)
  8029c1:	e8 a7 07 00 00       	call   80316d <alloc_block_BF>
  8029c6:	83 c4 10             	add    $0x10,%esp
  8029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029cc:	eb 24                	jmp    8029f2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8029ce:	83 ec 0c             	sub    $0xc,%esp
  8029d1:	ff 75 08             	pushl  0x8(%ebp)
  8029d4:	e8 b7 19 00 00       	call   804390 <alloc_block_WF>
  8029d9:	83 c4 10             	add    $0x10,%esp
  8029dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029df:	eb 11                	jmp    8029f2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8029e1:	83 ec 0c             	sub    $0xc,%esp
  8029e4:	68 44 51 80 00       	push   $0x805144
  8029e9:	e8 60 e5 ff ff       	call   800f4e <cprintf>
  8029ee:	83 c4 10             	add    $0x10,%esp
		break;
  8029f1:	90                   	nop
	}
	return va;
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	53                   	push   %ebx
  8029fb:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8029fe:	83 ec 0c             	sub    $0xc,%esp
  802a01:	68 64 51 80 00       	push   $0x805164
  802a06:	e8 43 e5 ff ff       	call   800f4e <cprintf>
  802a0b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802a0e:	83 ec 0c             	sub    $0xc,%esp
  802a11:	68 8f 51 80 00       	push   $0x80518f
  802a16:	e8 33 e5 ff ff       	call   800f4e <cprintf>
  802a1b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a24:	eb 37                	jmp    802a5d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802a26:	83 ec 0c             	sub    $0xc,%esp
  802a29:	ff 75 f4             	pushl  -0xc(%ebp)
  802a2c:	e8 19 ff ff ff       	call   80294a <is_free_block>
  802a31:	83 c4 10             	add    $0x10,%esp
  802a34:	0f be d8             	movsbl %al,%ebx
  802a37:	83 ec 0c             	sub    $0xc,%esp
  802a3a:	ff 75 f4             	pushl  -0xc(%ebp)
  802a3d:	e8 ef fe ff ff       	call   802931 <get_block_size>
  802a42:	83 c4 10             	add    $0x10,%esp
  802a45:	83 ec 04             	sub    $0x4,%esp
  802a48:	53                   	push   %ebx
  802a49:	50                   	push   %eax
  802a4a:	68 a7 51 80 00       	push   $0x8051a7
  802a4f:	e8 fa e4 ff ff       	call   800f4e <cprintf>
  802a54:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802a57:	8b 45 10             	mov    0x10(%ebp),%eax
  802a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a61:	74 07                	je     802a6a <print_blocks_list+0x73>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	eb 05                	jmp    802a6f <print_blocks_list+0x78>
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	89 45 10             	mov    %eax,0x10(%ebp)
  802a72:	8b 45 10             	mov    0x10(%ebp),%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	75 ad                	jne    802a26 <print_blocks_list+0x2f>
  802a79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7d:	75 a7                	jne    802a26 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802a7f:	83 ec 0c             	sub    $0xc,%esp
  802a82:	68 64 51 80 00       	push   $0x805164
  802a87:	e8 c2 e4 ff ff       	call   800f4e <cprintf>
  802a8c:	83 c4 10             	add    $0x10,%esp

}
  802a8f:	90                   	nop
  802a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a93:	c9                   	leave  
  802a94:	c3                   	ret    

00802a95 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802a95:	55                   	push   %ebp
  802a96:	89 e5                	mov    %esp,%ebp
  802a98:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a9e:	83 e0 01             	and    $0x1,%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	74 03                	je     802aa8 <initialize_dynamic_allocator+0x13>
  802aa5:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802aa8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802aac:	0f 84 c7 01 00 00    	je     802c79 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802ab2:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  802ab9:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802abc:	8b 55 08             	mov    0x8(%ebp),%edx
  802abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ac2:	01 d0                	add    %edx,%eax
  802ac4:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802ac9:	0f 87 ad 01 00 00    	ja     802c7c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	0f 89 a5 01 00 00    	jns    802c7f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802ada:	8b 55 08             	mov    0x8(%ebp),%edx
  802add:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae0:	01 d0                	add    %edx,%eax
  802ae2:	83 e8 04             	sub    $0x4,%eax
  802ae5:	a3 48 60 80 00       	mov    %eax,0x806048
     struct BlockElement * element = NULL;
  802aea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802af1:	a1 30 60 80 00       	mov    0x806030,%eax
  802af6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af9:	e9 87 00 00 00       	jmp    802b85 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b02:	75 14                	jne    802b18 <initialize_dynamic_allocator+0x83>
  802b04:	83 ec 04             	sub    $0x4,%esp
  802b07:	68 bf 51 80 00       	push   $0x8051bf
  802b0c:	6a 79                	push   $0x79
  802b0e:	68 dd 51 80 00       	push   $0x8051dd
  802b13:	e8 79 e1 ff ff       	call   800c91 <_panic>
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	85 c0                	test   %eax,%eax
  802b1f:	74 10                	je     802b31 <initialize_dynamic_allocator+0x9c>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b29:	8b 52 04             	mov    0x4(%edx),%edx
  802b2c:	89 50 04             	mov    %edx,0x4(%eax)
  802b2f:	eb 0b                	jmp    802b3c <initialize_dynamic_allocator+0xa7>
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 40 04             	mov    0x4(%eax),%eax
  802b37:	a3 34 60 80 00       	mov    %eax,0x806034
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 40 04             	mov    0x4(%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 0f                	je     802b55 <initialize_dynamic_allocator+0xc0>
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 40 04             	mov    0x4(%eax),%eax
  802b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4f:	8b 12                	mov    (%edx),%edx
  802b51:	89 10                	mov    %edx,(%eax)
  802b53:	eb 0a                	jmp    802b5f <initialize_dynamic_allocator+0xca>
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	a3 30 60 80 00       	mov    %eax,0x806030
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b72:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802b77:	48                   	dec    %eax
  802b78:	a3 3c 60 80 00       	mov    %eax,0x80603c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802b7d:	a1 38 60 80 00       	mov    0x806038,%eax
  802b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b89:	74 07                	je     802b92 <initialize_dynamic_allocator+0xfd>
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	eb 05                	jmp    802b97 <initialize_dynamic_allocator+0x102>
  802b92:	b8 00 00 00 00       	mov    $0x0,%eax
  802b97:	a3 38 60 80 00       	mov    %eax,0x806038
  802b9c:	a1 38 60 80 00       	mov    0x806038,%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	0f 85 55 ff ff ff    	jne    802afe <initialize_dynamic_allocator+0x69>
  802ba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bad:	0f 85 4b ff ff ff    	jne    802afe <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802bc2:	a1 48 60 80 00       	mov    0x806048,%eax
  802bc7:	a3 44 60 80 00       	mov    %eax,0x806044
    end_block->info = 1;
  802bcc:	a1 44 60 80 00       	mov    0x806044,%eax
  802bd1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	83 c0 08             	add    $0x8,%eax
  802bdd:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	83 c0 04             	add    $0x4,%eax
  802be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802be9:	83 ea 08             	sub    $0x8,%edx
  802bec:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	01 d0                	add    %edx,%eax
  802bf6:	83 e8 08             	sub    $0x8,%eax
  802bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bfc:	83 ea 08             	sub    $0x8,%edx
  802bff:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802c0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802c14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c18:	75 17                	jne    802c31 <initialize_dynamic_allocator+0x19c>
  802c1a:	83 ec 04             	sub    $0x4,%esp
  802c1d:	68 f8 51 80 00       	push   $0x8051f8
  802c22:	68 90 00 00 00       	push   $0x90
  802c27:	68 dd 51 80 00       	push   $0x8051dd
  802c2c:	e8 60 e0 ff ff       	call   800c91 <_panic>
  802c31:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3a:	89 10                	mov    %edx,(%eax)
  802c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3f:	8b 00                	mov    (%eax),%eax
  802c41:	85 c0                	test   %eax,%eax
  802c43:	74 0d                	je     802c52 <initialize_dynamic_allocator+0x1bd>
  802c45:	a1 30 60 80 00       	mov    0x806030,%eax
  802c4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c4d:	89 50 04             	mov    %edx,0x4(%eax)
  802c50:	eb 08                	jmp    802c5a <initialize_dynamic_allocator+0x1c5>
  802c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c55:	a3 34 60 80 00       	mov    %eax,0x806034
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	a3 30 60 80 00       	mov    %eax,0x806030
  802c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6c:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802c71:	40                   	inc    %eax
  802c72:	a3 3c 60 80 00       	mov    %eax,0x80603c
  802c77:	eb 07                	jmp    802c80 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802c79:	90                   	nop
  802c7a:	eb 04                	jmp    802c80 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802c7c:	90                   	nop
  802c7d:	eb 01                	jmp    802c80 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802c7f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802c80:	c9                   	leave  
  802c81:	c3                   	ret    

00802c82 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802c82:	55                   	push   %ebp
  802c83:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802c85:	8b 45 10             	mov    0x10(%ebp),%eax
  802c88:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c94:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	83 e8 04             	sub    $0x4,%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	83 e0 fe             	and    $0xfffffffe,%eax
  802ca1:	8d 50 f8             	lea    -0x8(%eax),%edx
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	01 c2                	add    %eax,%edx
  802ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cac:	89 02                	mov    %eax,(%edx)
}
  802cae:	90                   	nop
  802caf:	5d                   	pop    %ebp
  802cb0:	c3                   	ret    

00802cb1 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802cb1:	55                   	push   %ebp
  802cb2:	89 e5                	mov    %esp,%ebp
  802cb4:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	83 e0 01             	and    $0x1,%eax
  802cbd:	85 c0                	test   %eax,%eax
  802cbf:	74 03                	je     802cc4 <alloc_block_FF+0x13>
  802cc1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802cc4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802cc8:	77 07                	ja     802cd1 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802cca:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802cd1:	a1 28 60 80 00       	mov    0x806028,%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	75 73                	jne    802d4d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	83 c0 10             	add    $0x10,%eax
  802ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ce3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802cea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ced:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf0:	01 d0                	add    %edx,%eax
  802cf2:	48                   	dec    %eax
  802cf3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802cf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf9:	ba 00 00 00 00       	mov    $0x0,%edx
  802cfe:	f7 75 ec             	divl   -0x14(%ebp)
  802d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d04:	29 d0                	sub    %edx,%eax
  802d06:	c1 e8 0c             	shr    $0xc,%eax
  802d09:	83 ec 0c             	sub    $0xc,%esp
  802d0c:	50                   	push   %eax
  802d0d:	e8 d6 ef ff ff       	call   801ce8 <sbrk>
  802d12:	83 c4 10             	add    $0x10,%esp
  802d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d18:	83 ec 0c             	sub    $0xc,%esp
  802d1b:	6a 00                	push   $0x0
  802d1d:	e8 c6 ef ff ff       	call   801ce8 <sbrk>
  802d22:	83 c4 10             	add    $0x10,%esp
  802d25:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d2b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802d2e:	83 ec 08             	sub    $0x8,%esp
  802d31:	50                   	push   %eax
  802d32:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d35:	e8 5b fd ff ff       	call   802a95 <initialize_dynamic_allocator>
  802d3a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802d3d:	83 ec 0c             	sub    $0xc,%esp
  802d40:	68 1b 52 80 00       	push   $0x80521b
  802d45:	e8 04 e2 ff ff       	call   800f4e <cprintf>
  802d4a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802d4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d51:	75 0a                	jne    802d5d <alloc_block_FF+0xac>
	        return NULL;
  802d53:	b8 00 00 00 00       	mov    $0x0,%eax
  802d58:	e9 0e 04 00 00       	jmp    80316b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802d5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d64:	a1 30 60 80 00       	mov    0x806030,%eax
  802d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6c:	e9 f3 02 00 00       	jmp    803064 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802d77:	83 ec 0c             	sub    $0xc,%esp
  802d7a:	ff 75 bc             	pushl  -0x44(%ebp)
  802d7d:	e8 af fb ff ff       	call   802931 <get_block_size>
  802d82:	83 c4 10             	add    $0x10,%esp
  802d85:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	83 c0 08             	add    $0x8,%eax
  802d8e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802d91:	0f 87 c5 02 00 00    	ja     80305c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	83 c0 18             	add    $0x18,%eax
  802d9d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802da0:	0f 87 19 02 00 00    	ja     802fbf <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802da6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802da9:	2b 45 08             	sub    0x8(%ebp),%eax
  802dac:	83 e8 08             	sub    $0x8,%eax
  802daf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	8d 50 08             	lea    0x8(%eax),%edx
  802db8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dbb:	01 d0                	add    %edx,%eax
  802dbd:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	83 c0 08             	add    $0x8,%eax
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	6a 01                	push   $0x1
  802dcb:	50                   	push   %eax
  802dcc:	ff 75 bc             	pushl  -0x44(%ebp)
  802dcf:	e8 ae fe ff ff       	call   802c82 <set_block_data>
  802dd4:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	75 68                	jne    802e49 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802de1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802de5:	75 17                	jne    802dfe <alloc_block_FF+0x14d>
  802de7:	83 ec 04             	sub    $0x4,%esp
  802dea:	68 f8 51 80 00       	push   $0x8051f8
  802def:	68 d7 00 00 00       	push   $0xd7
  802df4:	68 dd 51 80 00       	push   $0x8051dd
  802df9:	e8 93 de ff ff       	call   800c91 <_panic>
  802dfe:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802e04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e07:	89 10                	mov    %edx,(%eax)
  802e09:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	74 0d                	je     802e1f <alloc_block_FF+0x16e>
  802e12:	a1 30 60 80 00       	mov    0x806030,%eax
  802e17:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e1a:	89 50 04             	mov    %edx,0x4(%eax)
  802e1d:	eb 08                	jmp    802e27 <alloc_block_FF+0x176>
  802e1f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e22:	a3 34 60 80 00       	mov    %eax,0x806034
  802e27:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e2a:	a3 30 60 80 00       	mov    %eax,0x806030
  802e2f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e39:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802e3e:	40                   	inc    %eax
  802e3f:	a3 3c 60 80 00       	mov    %eax,0x80603c
  802e44:	e9 dc 00 00 00       	jmp    802f25 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 00                	mov    (%eax),%eax
  802e4e:	85 c0                	test   %eax,%eax
  802e50:	75 65                	jne    802eb7 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e52:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802e56:	75 17                	jne    802e6f <alloc_block_FF+0x1be>
  802e58:	83 ec 04             	sub    $0x4,%esp
  802e5b:	68 2c 52 80 00       	push   $0x80522c
  802e60:	68 db 00 00 00       	push   $0xdb
  802e65:	68 dd 51 80 00       	push   $0x8051dd
  802e6a:	e8 22 de ff ff       	call   800c91 <_panic>
  802e6f:	8b 15 34 60 80 00    	mov    0x806034,%edx
  802e75:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e78:	89 50 04             	mov    %edx,0x4(%eax)
  802e7b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e7e:	8b 40 04             	mov    0x4(%eax),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 0c                	je     802e91 <alloc_block_FF+0x1e0>
  802e85:	a1 34 60 80 00       	mov    0x806034,%eax
  802e8a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e8d:	89 10                	mov    %edx,(%eax)
  802e8f:	eb 08                	jmp    802e99 <alloc_block_FF+0x1e8>
  802e91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e94:	a3 30 60 80 00       	mov    %eax,0x806030
  802e99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e9c:	a3 34 60 80 00       	mov    %eax,0x806034
  802ea1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ea4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eaa:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802eaf:	40                   	inc    %eax
  802eb0:	a3 3c 60 80 00       	mov    %eax,0x80603c
  802eb5:	eb 6e                	jmp    802f25 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802eb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebb:	74 06                	je     802ec3 <alloc_block_FF+0x212>
  802ebd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ec1:	75 17                	jne    802eda <alloc_block_FF+0x229>
  802ec3:	83 ec 04             	sub    $0x4,%esp
  802ec6:	68 50 52 80 00       	push   $0x805250
  802ecb:	68 df 00 00 00       	push   $0xdf
  802ed0:	68 dd 51 80 00       	push   $0x8051dd
  802ed5:	e8 b7 dd ff ff       	call   800c91 <_panic>
  802eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edd:	8b 10                	mov    (%eax),%edx
  802edf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ee2:	89 10                	mov    %edx,(%eax)
  802ee4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ee7:	8b 00                	mov    (%eax),%eax
  802ee9:	85 c0                	test   %eax,%eax
  802eeb:	74 0b                	je     802ef8 <alloc_block_FF+0x247>
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ef5:	89 50 04             	mov    %edx,0x4(%eax)
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802efe:	89 10                	mov    %edx,(%eax)
  802f00:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f06:	89 50 04             	mov    %edx,0x4(%eax)
  802f09:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	75 08                	jne    802f1a <alloc_block_FF+0x269>
  802f12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f15:	a3 34 60 80 00       	mov    %eax,0x806034
  802f1a:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802f1f:	40                   	inc    %eax
  802f20:	a3 3c 60 80 00       	mov    %eax,0x80603c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f29:	75 17                	jne    802f42 <alloc_block_FF+0x291>
  802f2b:	83 ec 04             	sub    $0x4,%esp
  802f2e:	68 bf 51 80 00       	push   $0x8051bf
  802f33:	68 e1 00 00 00       	push   $0xe1
  802f38:	68 dd 51 80 00       	push   $0x8051dd
  802f3d:	e8 4f dd ff ff       	call   800c91 <_panic>
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 10                	je     802f5b <alloc_block_FF+0x2aa>
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f53:	8b 52 04             	mov    0x4(%edx),%edx
  802f56:	89 50 04             	mov    %edx,0x4(%eax)
  802f59:	eb 0b                	jmp    802f66 <alloc_block_FF+0x2b5>
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	a3 34 60 80 00       	mov    %eax,0x806034
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0f                	je     802f7f <alloc_block_FF+0x2ce>
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f79:	8b 12                	mov    (%edx),%edx
  802f7b:	89 10                	mov    %edx,(%eax)
  802f7d:	eb 0a                	jmp    802f89 <alloc_block_FF+0x2d8>
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	8b 00                	mov    (%eax),%eax
  802f84:	a3 30 60 80 00       	mov    %eax,0x806030
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9c:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802fa1:	48                   	dec    %eax
  802fa2:	a3 3c 60 80 00       	mov    %eax,0x80603c
				set_block_data(new_block_va, remaining_size, 0);
  802fa7:	83 ec 04             	sub    $0x4,%esp
  802faa:	6a 00                	push   $0x0
  802fac:	ff 75 b4             	pushl  -0x4c(%ebp)
  802faf:	ff 75 b0             	pushl  -0x50(%ebp)
  802fb2:	e8 cb fc ff ff       	call   802c82 <set_block_data>
  802fb7:	83 c4 10             	add    $0x10,%esp
  802fba:	e9 95 00 00 00       	jmp    803054 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802fbf:	83 ec 04             	sub    $0x4,%esp
  802fc2:	6a 01                	push   $0x1
  802fc4:	ff 75 b8             	pushl  -0x48(%ebp)
  802fc7:	ff 75 bc             	pushl  -0x44(%ebp)
  802fca:	e8 b3 fc ff ff       	call   802c82 <set_block_data>
  802fcf:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802fd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd6:	75 17                	jne    802fef <alloc_block_FF+0x33e>
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 bf 51 80 00       	push   $0x8051bf
  802fe0:	68 e8 00 00 00       	push   $0xe8
  802fe5:	68 dd 51 80 00       	push   $0x8051dd
  802fea:	e8 a2 dc ff ff       	call   800c91 <_panic>
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	85 c0                	test   %eax,%eax
  802ff6:	74 10                	je     803008 <alloc_block_FF+0x357>
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803000:	8b 52 04             	mov    0x4(%edx),%edx
  803003:	89 50 04             	mov    %edx,0x4(%eax)
  803006:	eb 0b                	jmp    803013 <alloc_block_FF+0x362>
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	a3 34 60 80 00       	mov    %eax,0x806034
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 40 04             	mov    0x4(%eax),%eax
  803019:	85 c0                	test   %eax,%eax
  80301b:	74 0f                	je     80302c <alloc_block_FF+0x37b>
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 40 04             	mov    0x4(%eax),%eax
  803023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803026:	8b 12                	mov    (%edx),%edx
  803028:	89 10                	mov    %edx,(%eax)
  80302a:	eb 0a                	jmp    803036 <alloc_block_FF+0x385>
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	a3 30 60 80 00       	mov    %eax,0x806030
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803049:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80304e:	48                   	dec    %eax
  80304f:	a3 3c 60 80 00       	mov    %eax,0x80603c
	            }
	            return va;
  803054:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803057:	e9 0f 01 00 00       	jmp    80316b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80305c:	a1 38 60 80 00       	mov    0x806038,%eax
  803061:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803068:	74 07                	je     803071 <alloc_block_FF+0x3c0>
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	eb 05                	jmp    803076 <alloc_block_FF+0x3c5>
  803071:	b8 00 00 00 00       	mov    $0x0,%eax
  803076:	a3 38 60 80 00       	mov    %eax,0x806038
  80307b:	a1 38 60 80 00       	mov    0x806038,%eax
  803080:	85 c0                	test   %eax,%eax
  803082:	0f 85 e9 fc ff ff    	jne    802d71 <alloc_block_FF+0xc0>
  803088:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308c:	0f 85 df fc ff ff    	jne    802d71 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	83 c0 08             	add    $0x8,%eax
  803098:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80309b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8030a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030a8:	01 d0                	add    %edx,%eax
  8030aa:	48                   	dec    %eax
  8030ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8030ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8030b6:	f7 75 d8             	divl   -0x28(%ebp)
  8030b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030bc:	29 d0                	sub    %edx,%eax
  8030be:	c1 e8 0c             	shr    $0xc,%eax
  8030c1:	83 ec 0c             	sub    $0xc,%esp
  8030c4:	50                   	push   %eax
  8030c5:	e8 1e ec ff ff       	call   801ce8 <sbrk>
  8030ca:	83 c4 10             	add    $0x10,%esp
  8030cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8030d0:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8030d4:	75 0a                	jne    8030e0 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8030d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030db:	e9 8b 00 00 00       	jmp    80316b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8030e0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8030e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ed:	01 d0                	add    %edx,%eax
  8030ef:	48                   	dec    %eax
  8030f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8030f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8030fb:	f7 75 cc             	divl   -0x34(%ebp)
  8030fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803101:	29 d0                	sub    %edx,%eax
  803103:	8d 50 fc             	lea    -0x4(%eax),%edx
  803106:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803109:	01 d0                	add    %edx,%eax
  80310b:	a3 44 60 80 00       	mov    %eax,0x806044
			end_block->info = 1;
  803110:	a1 44 60 80 00       	mov    0x806044,%eax
  803115:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80311b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803122:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803125:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803128:	01 d0                	add    %edx,%eax
  80312a:	48                   	dec    %eax
  80312b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80312e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803131:	ba 00 00 00 00       	mov    $0x0,%edx
  803136:	f7 75 c4             	divl   -0x3c(%ebp)
  803139:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80313c:	29 d0                	sub    %edx,%eax
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	6a 01                	push   $0x1
  803143:	50                   	push   %eax
  803144:	ff 75 d0             	pushl  -0x30(%ebp)
  803147:	e8 36 fb ff ff       	call   802c82 <set_block_data>
  80314c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80314f:	83 ec 0c             	sub    $0xc,%esp
  803152:	ff 75 d0             	pushl  -0x30(%ebp)
  803155:	e8 1b 0a 00 00       	call   803b75 <free_block>
  80315a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80315d:	83 ec 0c             	sub    $0xc,%esp
  803160:	ff 75 08             	pushl  0x8(%ebp)
  803163:	e8 49 fb ff ff       	call   802cb1 <alloc_block_FF>
  803168:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80316b:	c9                   	leave  
  80316c:	c3                   	ret    

0080316d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80316d:	55                   	push   %ebp
  80316e:	89 e5                	mov    %esp,%ebp
  803170:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	83 e0 01             	and    $0x1,%eax
  803179:	85 c0                	test   %eax,%eax
  80317b:	74 03                	je     803180 <alloc_block_BF+0x13>
  80317d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803180:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803184:	77 07                	ja     80318d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803186:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80318d:	a1 28 60 80 00       	mov    0x806028,%eax
  803192:	85 c0                	test   %eax,%eax
  803194:	75 73                	jne    803209 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	83 c0 10             	add    $0x10,%eax
  80319c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80319f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8031a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ac:	01 d0                	add    %edx,%eax
  8031ae:	48                   	dec    %eax
  8031af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8031b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8031ba:	f7 75 e0             	divl   -0x20(%ebp)
  8031bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c0:	29 d0                	sub    %edx,%eax
  8031c2:	c1 e8 0c             	shr    $0xc,%eax
  8031c5:	83 ec 0c             	sub    $0xc,%esp
  8031c8:	50                   	push   %eax
  8031c9:	e8 1a eb ff ff       	call   801ce8 <sbrk>
  8031ce:	83 c4 10             	add    $0x10,%esp
  8031d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8031d4:	83 ec 0c             	sub    $0xc,%esp
  8031d7:	6a 00                	push   $0x0
  8031d9:	e8 0a eb ff ff       	call   801ce8 <sbrk>
  8031de:	83 c4 10             	add    $0x10,%esp
  8031e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8031e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031e7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8031ea:	83 ec 08             	sub    $0x8,%esp
  8031ed:	50                   	push   %eax
  8031ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8031f1:	e8 9f f8 ff ff       	call   802a95 <initialize_dynamic_allocator>
  8031f6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8031f9:	83 ec 0c             	sub    $0xc,%esp
  8031fc:	68 1b 52 80 00       	push   $0x80521b
  803201:	e8 48 dd ff ff       	call   800f4e <cprintf>
  803206:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803209:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803210:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803217:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80321e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803225:	a1 30 60 80 00       	mov    0x806030,%eax
  80322a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80322d:	e9 1d 01 00 00       	jmp    80334f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803238:	83 ec 0c             	sub    $0xc,%esp
  80323b:	ff 75 a8             	pushl  -0x58(%ebp)
  80323e:	e8 ee f6 ff ff       	call   802931 <get_block_size>
  803243:	83 c4 10             	add    $0x10,%esp
  803246:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	83 c0 08             	add    $0x8,%eax
  80324f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803252:	0f 87 ef 00 00 00    	ja     803347 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803258:	8b 45 08             	mov    0x8(%ebp),%eax
  80325b:	83 c0 18             	add    $0x18,%eax
  80325e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803261:	77 1d                	ja     803280 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803266:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803269:	0f 86 d8 00 00 00    	jbe    803347 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80326f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803272:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803275:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803278:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80327b:	e9 c7 00 00 00       	jmp    803347 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	83 c0 08             	add    $0x8,%eax
  803286:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803289:	0f 85 9d 00 00 00    	jne    80332c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	6a 01                	push   $0x1
  803294:	ff 75 a4             	pushl  -0x5c(%ebp)
  803297:	ff 75 a8             	pushl  -0x58(%ebp)
  80329a:	e8 e3 f9 ff ff       	call   802c82 <set_block_data>
  80329f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8032a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a6:	75 17                	jne    8032bf <alloc_block_BF+0x152>
  8032a8:	83 ec 04             	sub    $0x4,%esp
  8032ab:	68 bf 51 80 00       	push   $0x8051bf
  8032b0:	68 2c 01 00 00       	push   $0x12c
  8032b5:	68 dd 51 80 00       	push   $0x8051dd
  8032ba:	e8 d2 d9 ff ff       	call   800c91 <_panic>
  8032bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c2:	8b 00                	mov    (%eax),%eax
  8032c4:	85 c0                	test   %eax,%eax
  8032c6:	74 10                	je     8032d8 <alloc_block_BF+0x16b>
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d0:	8b 52 04             	mov    0x4(%edx),%edx
  8032d3:	89 50 04             	mov    %edx,0x4(%eax)
  8032d6:	eb 0b                	jmp    8032e3 <alloc_block_BF+0x176>
  8032d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032db:	8b 40 04             	mov    0x4(%eax),%eax
  8032de:	a3 34 60 80 00       	mov    %eax,0x806034
  8032e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e6:	8b 40 04             	mov    0x4(%eax),%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	74 0f                	je     8032fc <alloc_block_BF+0x18f>
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	8b 40 04             	mov    0x4(%eax),%eax
  8032f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f6:	8b 12                	mov    (%edx),%edx
  8032f8:	89 10                	mov    %edx,(%eax)
  8032fa:	eb 0a                	jmp    803306 <alloc_block_BF+0x199>
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 00                	mov    (%eax),%eax
  803301:	a3 30 60 80 00       	mov    %eax,0x806030
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80330f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803312:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803319:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80331e:	48                   	dec    %eax
  80331f:	a3 3c 60 80 00       	mov    %eax,0x80603c
					return va;
  803324:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803327:	e9 24 04 00 00       	jmp    803750 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80332c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803332:	76 13                	jbe    803347 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803334:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80333b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80333e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803341:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803344:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803347:	a1 38 60 80 00       	mov    0x806038,%eax
  80334c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80334f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803353:	74 07                	je     80335c <alloc_block_BF+0x1ef>
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 00                	mov    (%eax),%eax
  80335a:	eb 05                	jmp    803361 <alloc_block_BF+0x1f4>
  80335c:	b8 00 00 00 00       	mov    $0x0,%eax
  803361:	a3 38 60 80 00       	mov    %eax,0x806038
  803366:	a1 38 60 80 00       	mov    0x806038,%eax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	0f 85 bf fe ff ff    	jne    803232 <alloc_block_BF+0xc5>
  803373:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803377:	0f 85 b5 fe ff ff    	jne    803232 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80337d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803381:	0f 84 26 02 00 00    	je     8035ad <alloc_block_BF+0x440>
  803387:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80338b:	0f 85 1c 02 00 00    	jne    8035ad <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803391:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803394:	2b 45 08             	sub    0x8(%ebp),%eax
  803397:	83 e8 08             	sub    $0x8,%eax
  80339a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	8d 50 08             	lea    0x8(%eax),%edx
  8033a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a6:	01 d0                	add    %edx,%eax
  8033a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	83 c0 08             	add    $0x8,%eax
  8033b1:	83 ec 04             	sub    $0x4,%esp
  8033b4:	6a 01                	push   $0x1
  8033b6:	50                   	push   %eax
  8033b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8033ba:	e8 c3 f8 ff ff       	call   802c82 <set_block_data>
  8033bf:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8033c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c5:	8b 40 04             	mov    0x4(%eax),%eax
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	75 68                	jne    803434 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8033cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8033d0:	75 17                	jne    8033e9 <alloc_block_BF+0x27c>
  8033d2:	83 ec 04             	sub    $0x4,%esp
  8033d5:	68 f8 51 80 00       	push   $0x8051f8
  8033da:	68 45 01 00 00       	push   $0x145
  8033df:	68 dd 51 80 00       	push   $0x8051dd
  8033e4:	e8 a8 d8 ff ff       	call   800c91 <_panic>
  8033e9:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8033ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033f2:	89 10                	mov    %edx,(%eax)
  8033f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	74 0d                	je     80340a <alloc_block_BF+0x29d>
  8033fd:	a1 30 60 80 00       	mov    0x806030,%eax
  803402:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803405:	89 50 04             	mov    %edx,0x4(%eax)
  803408:	eb 08                	jmp    803412 <alloc_block_BF+0x2a5>
  80340a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80340d:	a3 34 60 80 00       	mov    %eax,0x806034
  803412:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803415:	a3 30 60 80 00       	mov    %eax,0x806030
  80341a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80341d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803424:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803429:	40                   	inc    %eax
  80342a:	a3 3c 60 80 00       	mov    %eax,0x80603c
  80342f:	e9 dc 00 00 00       	jmp    803510 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803437:	8b 00                	mov    (%eax),%eax
  803439:	85 c0                	test   %eax,%eax
  80343b:	75 65                	jne    8034a2 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80343d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803441:	75 17                	jne    80345a <alloc_block_BF+0x2ed>
  803443:	83 ec 04             	sub    $0x4,%esp
  803446:	68 2c 52 80 00       	push   $0x80522c
  80344b:	68 4a 01 00 00       	push   $0x14a
  803450:	68 dd 51 80 00       	push   $0x8051dd
  803455:	e8 37 d8 ff ff       	call   800c91 <_panic>
  80345a:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803460:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803463:	89 50 04             	mov    %edx,0x4(%eax)
  803466:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803469:	8b 40 04             	mov    0x4(%eax),%eax
  80346c:	85 c0                	test   %eax,%eax
  80346e:	74 0c                	je     80347c <alloc_block_BF+0x30f>
  803470:	a1 34 60 80 00       	mov    0x806034,%eax
  803475:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803478:	89 10                	mov    %edx,(%eax)
  80347a:	eb 08                	jmp    803484 <alloc_block_BF+0x317>
  80347c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80347f:	a3 30 60 80 00       	mov    %eax,0x806030
  803484:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803487:	a3 34 60 80 00       	mov    %eax,0x806034
  80348c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80348f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803495:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80349a:	40                   	inc    %eax
  80349b:	a3 3c 60 80 00       	mov    %eax,0x80603c
  8034a0:	eb 6e                	jmp    803510 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8034a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034a6:	74 06                	je     8034ae <alloc_block_BF+0x341>
  8034a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8034ac:	75 17                	jne    8034c5 <alloc_block_BF+0x358>
  8034ae:	83 ec 04             	sub    $0x4,%esp
  8034b1:	68 50 52 80 00       	push   $0x805250
  8034b6:	68 4f 01 00 00       	push   $0x14f
  8034bb:	68 dd 51 80 00       	push   $0x8051dd
  8034c0:	e8 cc d7 ff ff       	call   800c91 <_panic>
  8034c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c8:	8b 10                	mov    (%eax),%edx
  8034ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034cd:	89 10                	mov    %edx,(%eax)
  8034cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034d2:	8b 00                	mov    (%eax),%eax
  8034d4:	85 c0                	test   %eax,%eax
  8034d6:	74 0b                	je     8034e3 <alloc_block_BF+0x376>
  8034d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8034e0:	89 50 04             	mov    %edx,0x4(%eax)
  8034e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8034e9:	89 10                	mov    %edx,(%eax)
  8034eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f1:	89 50 04             	mov    %edx,0x4(%eax)
  8034f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034f7:	8b 00                	mov    (%eax),%eax
  8034f9:	85 c0                	test   %eax,%eax
  8034fb:	75 08                	jne    803505 <alloc_block_BF+0x398>
  8034fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803500:	a3 34 60 80 00       	mov    %eax,0x806034
  803505:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80350a:	40                   	inc    %eax
  80350b:	a3 3c 60 80 00       	mov    %eax,0x80603c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803514:	75 17                	jne    80352d <alloc_block_BF+0x3c0>
  803516:	83 ec 04             	sub    $0x4,%esp
  803519:	68 bf 51 80 00       	push   $0x8051bf
  80351e:	68 51 01 00 00       	push   $0x151
  803523:	68 dd 51 80 00       	push   $0x8051dd
  803528:	e8 64 d7 ff ff       	call   800c91 <_panic>
  80352d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803530:	8b 00                	mov    (%eax),%eax
  803532:	85 c0                	test   %eax,%eax
  803534:	74 10                	je     803546 <alloc_block_BF+0x3d9>
  803536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803539:	8b 00                	mov    (%eax),%eax
  80353b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353e:	8b 52 04             	mov    0x4(%edx),%edx
  803541:	89 50 04             	mov    %edx,0x4(%eax)
  803544:	eb 0b                	jmp    803551 <alloc_block_BF+0x3e4>
  803546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803549:	8b 40 04             	mov    0x4(%eax),%eax
  80354c:	a3 34 60 80 00       	mov    %eax,0x806034
  803551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803554:	8b 40 04             	mov    0x4(%eax),%eax
  803557:	85 c0                	test   %eax,%eax
  803559:	74 0f                	je     80356a <alloc_block_BF+0x3fd>
  80355b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355e:	8b 40 04             	mov    0x4(%eax),%eax
  803561:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803564:	8b 12                	mov    (%edx),%edx
  803566:	89 10                	mov    %edx,(%eax)
  803568:	eb 0a                	jmp    803574 <alloc_block_BF+0x407>
  80356a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	a3 30 60 80 00       	mov    %eax,0x806030
  803574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803577:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803587:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80358c:	48                   	dec    %eax
  80358d:	a3 3c 60 80 00       	mov    %eax,0x80603c
			set_block_data(new_block_va, remaining_size, 0);
  803592:	83 ec 04             	sub    $0x4,%esp
  803595:	6a 00                	push   $0x0
  803597:	ff 75 d0             	pushl  -0x30(%ebp)
  80359a:	ff 75 cc             	pushl  -0x34(%ebp)
  80359d:	e8 e0 f6 ff ff       	call   802c82 <set_block_data>
  8035a2:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8035a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a8:	e9 a3 01 00 00       	jmp    803750 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8035ad:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8035b1:	0f 85 9d 00 00 00    	jne    803654 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8035b7:	83 ec 04             	sub    $0x4,%esp
  8035ba:	6a 01                	push   $0x1
  8035bc:	ff 75 ec             	pushl  -0x14(%ebp)
  8035bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8035c2:	e8 bb f6 ff ff       	call   802c82 <set_block_data>
  8035c7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8035ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035ce:	75 17                	jne    8035e7 <alloc_block_BF+0x47a>
  8035d0:	83 ec 04             	sub    $0x4,%esp
  8035d3:	68 bf 51 80 00       	push   $0x8051bf
  8035d8:	68 58 01 00 00       	push   $0x158
  8035dd:	68 dd 51 80 00       	push   $0x8051dd
  8035e2:	e8 aa d6 ff ff       	call   800c91 <_panic>
  8035e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ea:	8b 00                	mov    (%eax),%eax
  8035ec:	85 c0                	test   %eax,%eax
  8035ee:	74 10                	je     803600 <alloc_block_BF+0x493>
  8035f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f3:	8b 00                	mov    (%eax),%eax
  8035f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f8:	8b 52 04             	mov    0x4(%edx),%edx
  8035fb:	89 50 04             	mov    %edx,0x4(%eax)
  8035fe:	eb 0b                	jmp    80360b <alloc_block_BF+0x49e>
  803600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803603:	8b 40 04             	mov    0x4(%eax),%eax
  803606:	a3 34 60 80 00       	mov    %eax,0x806034
  80360b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360e:	8b 40 04             	mov    0x4(%eax),%eax
  803611:	85 c0                	test   %eax,%eax
  803613:	74 0f                	je     803624 <alloc_block_BF+0x4b7>
  803615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803618:	8b 40 04             	mov    0x4(%eax),%eax
  80361b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80361e:	8b 12                	mov    (%edx),%edx
  803620:	89 10                	mov    %edx,(%eax)
  803622:	eb 0a                	jmp    80362e <alloc_block_BF+0x4c1>
  803624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803627:	8b 00                	mov    (%eax),%eax
  803629:	a3 30 60 80 00       	mov    %eax,0x806030
  80362e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803631:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80363a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803641:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803646:	48                   	dec    %eax
  803647:	a3 3c 60 80 00       	mov    %eax,0x80603c
		return best_va;
  80364c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80364f:	e9 fc 00 00 00       	jmp    803750 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803654:	8b 45 08             	mov    0x8(%ebp),%eax
  803657:	83 c0 08             	add    $0x8,%eax
  80365a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80365d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803664:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803667:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80366a:	01 d0                	add    %edx,%eax
  80366c:	48                   	dec    %eax
  80366d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803670:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803673:	ba 00 00 00 00       	mov    $0x0,%edx
  803678:	f7 75 c4             	divl   -0x3c(%ebp)
  80367b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80367e:	29 d0                	sub    %edx,%eax
  803680:	c1 e8 0c             	shr    $0xc,%eax
  803683:	83 ec 0c             	sub    $0xc,%esp
  803686:	50                   	push   %eax
  803687:	e8 5c e6 ff ff       	call   801ce8 <sbrk>
  80368c:	83 c4 10             	add    $0x10,%esp
  80368f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803692:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803696:	75 0a                	jne    8036a2 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803698:	b8 00 00 00 00       	mov    $0x0,%eax
  80369d:	e9 ae 00 00 00       	jmp    803750 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8036a2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8036a9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036af:	01 d0                	add    %edx,%eax
  8036b1:	48                   	dec    %eax
  8036b2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8036b5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8036b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8036bd:	f7 75 b8             	divl   -0x48(%ebp)
  8036c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8036c3:	29 d0                	sub    %edx,%eax
  8036c5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8036c8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8036cb:	01 d0                	add    %edx,%eax
  8036cd:	a3 44 60 80 00       	mov    %eax,0x806044
				end_block->info = 1;
  8036d2:	a1 44 60 80 00       	mov    0x806044,%eax
  8036d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8036dd:	83 ec 0c             	sub    $0xc,%esp
  8036e0:	68 84 52 80 00       	push   $0x805284
  8036e5:	e8 64 d8 ff ff       	call   800f4e <cprintf>
  8036ea:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8036ed:	83 ec 08             	sub    $0x8,%esp
  8036f0:	ff 75 bc             	pushl  -0x44(%ebp)
  8036f3:	68 89 52 80 00       	push   $0x805289
  8036f8:	e8 51 d8 ff ff       	call   800f4e <cprintf>
  8036fd:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803700:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803707:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80370a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80370d:	01 d0                	add    %edx,%eax
  80370f:	48                   	dec    %eax
  803710:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803713:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803716:	ba 00 00 00 00       	mov    $0x0,%edx
  80371b:	f7 75 b0             	divl   -0x50(%ebp)
  80371e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803721:	29 d0                	sub    %edx,%eax
  803723:	83 ec 04             	sub    $0x4,%esp
  803726:	6a 01                	push   $0x1
  803728:	50                   	push   %eax
  803729:	ff 75 bc             	pushl  -0x44(%ebp)
  80372c:	e8 51 f5 ff ff       	call   802c82 <set_block_data>
  803731:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803734:	83 ec 0c             	sub    $0xc,%esp
  803737:	ff 75 bc             	pushl  -0x44(%ebp)
  80373a:	e8 36 04 00 00       	call   803b75 <free_block>
  80373f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803742:	83 ec 0c             	sub    $0xc,%esp
  803745:	ff 75 08             	pushl  0x8(%ebp)
  803748:	e8 20 fa ff ff       	call   80316d <alloc_block_BF>
  80374d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803750:	c9                   	leave  
  803751:	c3                   	ret    

00803752 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803752:	55                   	push   %ebp
  803753:	89 e5                	mov    %esp,%ebp
  803755:	53                   	push   %ebx
  803756:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803759:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803760:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803767:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80376b:	74 1e                	je     80378b <merging+0x39>
  80376d:	ff 75 08             	pushl  0x8(%ebp)
  803770:	e8 bc f1 ff ff       	call   802931 <get_block_size>
  803775:	83 c4 04             	add    $0x4,%esp
  803778:	89 c2                	mov    %eax,%edx
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	01 d0                	add    %edx,%eax
  80377f:	3b 45 10             	cmp    0x10(%ebp),%eax
  803782:	75 07                	jne    80378b <merging+0x39>
		prev_is_free = 1;
  803784:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80378b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80378f:	74 1e                	je     8037af <merging+0x5d>
  803791:	ff 75 10             	pushl  0x10(%ebp)
  803794:	e8 98 f1 ff ff       	call   802931 <get_block_size>
  803799:	83 c4 04             	add    $0x4,%esp
  80379c:	89 c2                	mov    %eax,%edx
  80379e:	8b 45 10             	mov    0x10(%ebp),%eax
  8037a1:	01 d0                	add    %edx,%eax
  8037a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037a6:	75 07                	jne    8037af <merging+0x5d>
		next_is_free = 1;
  8037a8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8037af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b3:	0f 84 cc 00 00 00    	je     803885 <merging+0x133>
  8037b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037bd:	0f 84 c2 00 00 00    	je     803885 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8037c3:	ff 75 08             	pushl  0x8(%ebp)
  8037c6:	e8 66 f1 ff ff       	call   802931 <get_block_size>
  8037cb:	83 c4 04             	add    $0x4,%esp
  8037ce:	89 c3                	mov    %eax,%ebx
  8037d0:	ff 75 10             	pushl  0x10(%ebp)
  8037d3:	e8 59 f1 ff ff       	call   802931 <get_block_size>
  8037d8:	83 c4 04             	add    $0x4,%esp
  8037db:	01 c3                	add    %eax,%ebx
  8037dd:	ff 75 0c             	pushl  0xc(%ebp)
  8037e0:	e8 4c f1 ff ff       	call   802931 <get_block_size>
  8037e5:	83 c4 04             	add    $0x4,%esp
  8037e8:	01 d8                	add    %ebx,%eax
  8037ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8037ed:	6a 00                	push   $0x0
  8037ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8037f2:	ff 75 08             	pushl  0x8(%ebp)
  8037f5:	e8 88 f4 ff ff       	call   802c82 <set_block_data>
  8037fa:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8037fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803801:	75 17                	jne    80381a <merging+0xc8>
  803803:	83 ec 04             	sub    $0x4,%esp
  803806:	68 bf 51 80 00       	push   $0x8051bf
  80380b:	68 7d 01 00 00       	push   $0x17d
  803810:	68 dd 51 80 00       	push   $0x8051dd
  803815:	e8 77 d4 ff ff       	call   800c91 <_panic>
  80381a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80381d:	8b 00                	mov    (%eax),%eax
  80381f:	85 c0                	test   %eax,%eax
  803821:	74 10                	je     803833 <merging+0xe1>
  803823:	8b 45 0c             	mov    0xc(%ebp),%eax
  803826:	8b 00                	mov    (%eax),%eax
  803828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80382b:	8b 52 04             	mov    0x4(%edx),%edx
  80382e:	89 50 04             	mov    %edx,0x4(%eax)
  803831:	eb 0b                	jmp    80383e <merging+0xec>
  803833:	8b 45 0c             	mov    0xc(%ebp),%eax
  803836:	8b 40 04             	mov    0x4(%eax),%eax
  803839:	a3 34 60 80 00       	mov    %eax,0x806034
  80383e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803841:	8b 40 04             	mov    0x4(%eax),%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	74 0f                	je     803857 <merging+0x105>
  803848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80384b:	8b 40 04             	mov    0x4(%eax),%eax
  80384e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803851:	8b 12                	mov    (%edx),%edx
  803853:	89 10                	mov    %edx,(%eax)
  803855:	eb 0a                	jmp    803861 <merging+0x10f>
  803857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80385a:	8b 00                	mov    (%eax),%eax
  80385c:	a3 30 60 80 00       	mov    %eax,0x806030
  803861:	8b 45 0c             	mov    0xc(%ebp),%eax
  803864:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80386a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80386d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803874:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803879:	48                   	dec    %eax
  80387a:	a3 3c 60 80 00       	mov    %eax,0x80603c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80387f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803880:	e9 ea 02 00 00       	jmp    803b6f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803889:	74 3b                	je     8038c6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80388b:	83 ec 0c             	sub    $0xc,%esp
  80388e:	ff 75 08             	pushl  0x8(%ebp)
  803891:	e8 9b f0 ff ff       	call   802931 <get_block_size>
  803896:	83 c4 10             	add    $0x10,%esp
  803899:	89 c3                	mov    %eax,%ebx
  80389b:	83 ec 0c             	sub    $0xc,%esp
  80389e:	ff 75 10             	pushl  0x10(%ebp)
  8038a1:	e8 8b f0 ff ff       	call   802931 <get_block_size>
  8038a6:	83 c4 10             	add    $0x10,%esp
  8038a9:	01 d8                	add    %ebx,%eax
  8038ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8038ae:	83 ec 04             	sub    $0x4,%esp
  8038b1:	6a 00                	push   $0x0
  8038b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8038b6:	ff 75 08             	pushl  0x8(%ebp)
  8038b9:	e8 c4 f3 ff ff       	call   802c82 <set_block_data>
  8038be:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8038c1:	e9 a9 02 00 00       	jmp    803b6f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8038c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038ca:	0f 84 2d 01 00 00    	je     8039fd <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8038d0:	83 ec 0c             	sub    $0xc,%esp
  8038d3:	ff 75 10             	pushl  0x10(%ebp)
  8038d6:	e8 56 f0 ff ff       	call   802931 <get_block_size>
  8038db:	83 c4 10             	add    $0x10,%esp
  8038de:	89 c3                	mov    %eax,%ebx
  8038e0:	83 ec 0c             	sub    $0xc,%esp
  8038e3:	ff 75 0c             	pushl  0xc(%ebp)
  8038e6:	e8 46 f0 ff ff       	call   802931 <get_block_size>
  8038eb:	83 c4 10             	add    $0x10,%esp
  8038ee:	01 d8                	add    %ebx,%eax
  8038f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8038f3:	83 ec 04             	sub    $0x4,%esp
  8038f6:	6a 00                	push   $0x0
  8038f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038fb:	ff 75 10             	pushl  0x10(%ebp)
  8038fe:	e8 7f f3 ff ff       	call   802c82 <set_block_data>
  803903:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803906:	8b 45 10             	mov    0x10(%ebp),%eax
  803909:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80390c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803910:	74 06                	je     803918 <merging+0x1c6>
  803912:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803916:	75 17                	jne    80392f <merging+0x1dd>
  803918:	83 ec 04             	sub    $0x4,%esp
  80391b:	68 98 52 80 00       	push   $0x805298
  803920:	68 8d 01 00 00       	push   $0x18d
  803925:	68 dd 51 80 00       	push   $0x8051dd
  80392a:	e8 62 d3 ff ff       	call   800c91 <_panic>
  80392f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803932:	8b 50 04             	mov    0x4(%eax),%edx
  803935:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803938:	89 50 04             	mov    %edx,0x4(%eax)
  80393b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80393e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803941:	89 10                	mov    %edx,(%eax)
  803943:	8b 45 0c             	mov    0xc(%ebp),%eax
  803946:	8b 40 04             	mov    0x4(%eax),%eax
  803949:	85 c0                	test   %eax,%eax
  80394b:	74 0d                	je     80395a <merging+0x208>
  80394d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803950:	8b 40 04             	mov    0x4(%eax),%eax
  803953:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803956:	89 10                	mov    %edx,(%eax)
  803958:	eb 08                	jmp    803962 <merging+0x210>
  80395a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80395d:	a3 30 60 80 00       	mov    %eax,0x806030
  803962:	8b 45 0c             	mov    0xc(%ebp),%eax
  803965:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803968:	89 50 04             	mov    %edx,0x4(%eax)
  80396b:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803970:	40                   	inc    %eax
  803971:	a3 3c 60 80 00       	mov    %eax,0x80603c
		LIST_REMOVE(&freeBlocksList, next_block);
  803976:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80397a:	75 17                	jne    803993 <merging+0x241>
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	68 bf 51 80 00       	push   $0x8051bf
  803984:	68 8e 01 00 00       	push   $0x18e
  803989:	68 dd 51 80 00       	push   $0x8051dd
  80398e:	e8 fe d2 ff ff       	call   800c91 <_panic>
  803993:	8b 45 0c             	mov    0xc(%ebp),%eax
  803996:	8b 00                	mov    (%eax),%eax
  803998:	85 c0                	test   %eax,%eax
  80399a:	74 10                	je     8039ac <merging+0x25a>
  80399c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80399f:	8b 00                	mov    (%eax),%eax
  8039a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039a4:	8b 52 04             	mov    0x4(%edx),%edx
  8039a7:	89 50 04             	mov    %edx,0x4(%eax)
  8039aa:	eb 0b                	jmp    8039b7 <merging+0x265>
  8039ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039af:	8b 40 04             	mov    0x4(%eax),%eax
  8039b2:	a3 34 60 80 00       	mov    %eax,0x806034
  8039b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ba:	8b 40 04             	mov    0x4(%eax),%eax
  8039bd:	85 c0                	test   %eax,%eax
  8039bf:	74 0f                	je     8039d0 <merging+0x27e>
  8039c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039c4:	8b 40 04             	mov    0x4(%eax),%eax
  8039c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039ca:	8b 12                	mov    (%edx),%edx
  8039cc:	89 10                	mov    %edx,(%eax)
  8039ce:	eb 0a                	jmp    8039da <merging+0x288>
  8039d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039d3:	8b 00                	mov    (%eax),%eax
  8039d5:	a3 30 60 80 00       	mov    %eax,0x806030
  8039da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ed:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8039f2:	48                   	dec    %eax
  8039f3:	a3 3c 60 80 00       	mov    %eax,0x80603c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8039f8:	e9 72 01 00 00       	jmp    803b6f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8039fd:	8b 45 10             	mov    0x10(%ebp),%eax
  803a00:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803a03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a07:	74 79                	je     803a82 <merging+0x330>
  803a09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a0d:	74 73                	je     803a82 <merging+0x330>
  803a0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a13:	74 06                	je     803a1b <merging+0x2c9>
  803a15:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a19:	75 17                	jne    803a32 <merging+0x2e0>
  803a1b:	83 ec 04             	sub    $0x4,%esp
  803a1e:	68 50 52 80 00       	push   $0x805250
  803a23:	68 94 01 00 00       	push   $0x194
  803a28:	68 dd 51 80 00       	push   $0x8051dd
  803a2d:	e8 5f d2 ff ff       	call   800c91 <_panic>
  803a32:	8b 45 08             	mov    0x8(%ebp),%eax
  803a35:	8b 10                	mov    (%eax),%edx
  803a37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a3a:	89 10                	mov    %edx,(%eax)
  803a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a3f:	8b 00                	mov    (%eax),%eax
  803a41:	85 c0                	test   %eax,%eax
  803a43:	74 0b                	je     803a50 <merging+0x2fe>
  803a45:	8b 45 08             	mov    0x8(%ebp),%eax
  803a48:	8b 00                	mov    (%eax),%eax
  803a4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a4d:	89 50 04             	mov    %edx,0x4(%eax)
  803a50:	8b 45 08             	mov    0x8(%ebp),%eax
  803a53:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a56:	89 10                	mov    %edx,(%eax)
  803a58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a5b:	8b 55 08             	mov    0x8(%ebp),%edx
  803a5e:	89 50 04             	mov    %edx,0x4(%eax)
  803a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a64:	8b 00                	mov    (%eax),%eax
  803a66:	85 c0                	test   %eax,%eax
  803a68:	75 08                	jne    803a72 <merging+0x320>
  803a6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a6d:	a3 34 60 80 00       	mov    %eax,0x806034
  803a72:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803a77:	40                   	inc    %eax
  803a78:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803a7d:	e9 ce 00 00 00       	jmp    803b50 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803a82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a86:	74 65                	je     803aed <merging+0x39b>
  803a88:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a8c:	75 17                	jne    803aa5 <merging+0x353>
  803a8e:	83 ec 04             	sub    $0x4,%esp
  803a91:	68 2c 52 80 00       	push   $0x80522c
  803a96:	68 95 01 00 00       	push   $0x195
  803a9b:	68 dd 51 80 00       	push   $0x8051dd
  803aa0:	e8 ec d1 ff ff       	call   800c91 <_panic>
  803aa5:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803aab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aae:	89 50 04             	mov    %edx,0x4(%eax)
  803ab1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ab4:	8b 40 04             	mov    0x4(%eax),%eax
  803ab7:	85 c0                	test   %eax,%eax
  803ab9:	74 0c                	je     803ac7 <merging+0x375>
  803abb:	a1 34 60 80 00       	mov    0x806034,%eax
  803ac0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ac3:	89 10                	mov    %edx,(%eax)
  803ac5:	eb 08                	jmp    803acf <merging+0x37d>
  803ac7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aca:	a3 30 60 80 00       	mov    %eax,0x806030
  803acf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ad2:	a3 34 60 80 00       	mov    %eax,0x806034
  803ad7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ada:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae0:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803ae5:	40                   	inc    %eax
  803ae6:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803aeb:	eb 63                	jmp    803b50 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803aed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803af1:	75 17                	jne    803b0a <merging+0x3b8>
  803af3:	83 ec 04             	sub    $0x4,%esp
  803af6:	68 f8 51 80 00       	push   $0x8051f8
  803afb:	68 98 01 00 00       	push   $0x198
  803b00:	68 dd 51 80 00       	push   $0x8051dd
  803b05:	e8 87 d1 ff ff       	call   800c91 <_panic>
  803b0a:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803b10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b13:	89 10                	mov    %edx,(%eax)
  803b15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b18:	8b 00                	mov    (%eax),%eax
  803b1a:	85 c0                	test   %eax,%eax
  803b1c:	74 0d                	je     803b2b <merging+0x3d9>
  803b1e:	a1 30 60 80 00       	mov    0x806030,%eax
  803b23:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b26:	89 50 04             	mov    %edx,0x4(%eax)
  803b29:	eb 08                	jmp    803b33 <merging+0x3e1>
  803b2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b2e:	a3 34 60 80 00       	mov    %eax,0x806034
  803b33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b36:	a3 30 60 80 00       	mov    %eax,0x806030
  803b3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b45:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803b4a:	40                   	inc    %eax
  803b4b:	a3 3c 60 80 00       	mov    %eax,0x80603c
		}
		set_block_data(va, get_block_size(va), 0);
  803b50:	83 ec 0c             	sub    $0xc,%esp
  803b53:	ff 75 10             	pushl  0x10(%ebp)
  803b56:	e8 d6 ed ff ff       	call   802931 <get_block_size>
  803b5b:	83 c4 10             	add    $0x10,%esp
  803b5e:	83 ec 04             	sub    $0x4,%esp
  803b61:	6a 00                	push   $0x0
  803b63:	50                   	push   %eax
  803b64:	ff 75 10             	pushl  0x10(%ebp)
  803b67:	e8 16 f1 ff ff       	call   802c82 <set_block_data>
  803b6c:	83 c4 10             	add    $0x10,%esp
	}
}
  803b6f:	90                   	nop
  803b70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803b73:	c9                   	leave  
  803b74:	c3                   	ret    

00803b75 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803b75:	55                   	push   %ebp
  803b76:	89 e5                	mov    %esp,%ebp
  803b78:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803b7b:	a1 30 60 80 00       	mov    0x806030,%eax
  803b80:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803b83:	a1 34 60 80 00       	mov    0x806034,%eax
  803b88:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b8b:	73 1b                	jae    803ba8 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803b8d:	a1 34 60 80 00       	mov    0x806034,%eax
  803b92:	83 ec 04             	sub    $0x4,%esp
  803b95:	ff 75 08             	pushl  0x8(%ebp)
  803b98:	6a 00                	push   $0x0
  803b9a:	50                   	push   %eax
  803b9b:	e8 b2 fb ff ff       	call   803752 <merging>
  803ba0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803ba3:	e9 8b 00 00 00       	jmp    803c33 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803ba8:	a1 30 60 80 00       	mov    0x806030,%eax
  803bad:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bb0:	76 18                	jbe    803bca <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803bb2:	a1 30 60 80 00       	mov    0x806030,%eax
  803bb7:	83 ec 04             	sub    $0x4,%esp
  803bba:	ff 75 08             	pushl  0x8(%ebp)
  803bbd:	50                   	push   %eax
  803bbe:	6a 00                	push   $0x0
  803bc0:	e8 8d fb ff ff       	call   803752 <merging>
  803bc5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803bc8:	eb 69                	jmp    803c33 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803bca:	a1 30 60 80 00       	mov    0x806030,%eax
  803bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bd2:	eb 39                	jmp    803c0d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bda:	73 29                	jae    803c05 <free_block+0x90>
  803bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdf:	8b 00                	mov    (%eax),%eax
  803be1:	3b 45 08             	cmp    0x8(%ebp),%eax
  803be4:	76 1f                	jbe    803c05 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be9:	8b 00                	mov    (%eax),%eax
  803beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803bee:	83 ec 04             	sub    $0x4,%esp
  803bf1:	ff 75 08             	pushl  0x8(%ebp)
  803bf4:	ff 75 f0             	pushl  -0x10(%ebp)
  803bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  803bfa:	e8 53 fb ff ff       	call   803752 <merging>
  803bff:	83 c4 10             	add    $0x10,%esp
			break;
  803c02:	90                   	nop
		}
	}
}
  803c03:	eb 2e                	jmp    803c33 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803c05:	a1 38 60 80 00       	mov    0x806038,%eax
  803c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c11:	74 07                	je     803c1a <free_block+0xa5>
  803c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c16:	8b 00                	mov    (%eax),%eax
  803c18:	eb 05                	jmp    803c1f <free_block+0xaa>
  803c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1f:	a3 38 60 80 00       	mov    %eax,0x806038
  803c24:	a1 38 60 80 00       	mov    0x806038,%eax
  803c29:	85 c0                	test   %eax,%eax
  803c2b:	75 a7                	jne    803bd4 <free_block+0x5f>
  803c2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c31:	75 a1                	jne    803bd4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803c33:	90                   	nop
  803c34:	c9                   	leave  
  803c35:	c3                   	ret    

00803c36 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803c36:	55                   	push   %ebp
  803c37:	89 e5                	mov    %esp,%ebp
  803c39:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803c3c:	ff 75 08             	pushl  0x8(%ebp)
  803c3f:	e8 ed ec ff ff       	call   802931 <get_block_size>
  803c44:	83 c4 04             	add    $0x4,%esp
  803c47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803c4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803c51:	eb 17                	jmp    803c6a <copy_data+0x34>
  803c53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c59:	01 c2                	add    %eax,%edx
  803c5b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c61:	01 c8                	add    %ecx,%eax
  803c63:	8a 00                	mov    (%eax),%al
  803c65:	88 02                	mov    %al,(%edx)
  803c67:	ff 45 fc             	incl   -0x4(%ebp)
  803c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803c6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803c70:	72 e1                	jb     803c53 <copy_data+0x1d>
}
  803c72:	90                   	nop
  803c73:	c9                   	leave  
  803c74:	c3                   	ret    

00803c75 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803c75:	55                   	push   %ebp
  803c76:	89 e5                	mov    %esp,%ebp
  803c78:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803c7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c7f:	75 23                	jne    803ca4 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803c81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c85:	74 13                	je     803c9a <realloc_block_FF+0x25>
  803c87:	83 ec 0c             	sub    $0xc,%esp
  803c8a:	ff 75 0c             	pushl  0xc(%ebp)
  803c8d:	e8 1f f0 ff ff       	call   802cb1 <alloc_block_FF>
  803c92:	83 c4 10             	add    $0x10,%esp
  803c95:	e9 f4 06 00 00       	jmp    80438e <realloc_block_FF+0x719>
		return NULL;
  803c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c9f:	e9 ea 06 00 00       	jmp    80438e <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803ca4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ca8:	75 18                	jne    803cc2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803caa:	83 ec 0c             	sub    $0xc,%esp
  803cad:	ff 75 08             	pushl  0x8(%ebp)
  803cb0:	e8 c0 fe ff ff       	call   803b75 <free_block>
  803cb5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803cb8:	b8 00 00 00 00       	mov    $0x0,%eax
  803cbd:	e9 cc 06 00 00       	jmp    80438e <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803cc2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803cc6:	77 07                	ja     803ccf <realloc_block_FF+0x5a>
  803cc8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd2:	83 e0 01             	and    $0x1,%eax
  803cd5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cdb:	83 c0 08             	add    $0x8,%eax
  803cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803ce1:	83 ec 0c             	sub    $0xc,%esp
  803ce4:	ff 75 08             	pushl  0x8(%ebp)
  803ce7:	e8 45 ec ff ff       	call   802931 <get_block_size>
  803cec:	83 c4 10             	add    $0x10,%esp
  803cef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cf5:	83 e8 08             	sub    $0x8,%eax
  803cf8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfe:	83 e8 04             	sub    $0x4,%eax
  803d01:	8b 00                	mov    (%eax),%eax
  803d03:	83 e0 fe             	and    $0xfffffffe,%eax
  803d06:	89 c2                	mov    %eax,%edx
  803d08:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0b:	01 d0                	add    %edx,%eax
  803d0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803d10:	83 ec 0c             	sub    $0xc,%esp
  803d13:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d16:	e8 16 ec ff ff       	call   802931 <get_block_size>
  803d1b:	83 c4 10             	add    $0x10,%esp
  803d1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d24:	83 e8 08             	sub    $0x8,%eax
  803d27:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d2d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d30:	75 08                	jne    803d3a <realloc_block_FF+0xc5>
	{
		 return va;
  803d32:	8b 45 08             	mov    0x8(%ebp),%eax
  803d35:	e9 54 06 00 00       	jmp    80438e <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d3d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d40:	0f 83 e5 03 00 00    	jae    80412b <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803d46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d49:	2b 45 0c             	sub    0xc(%ebp),%eax
  803d4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803d4f:	83 ec 0c             	sub    $0xc,%esp
  803d52:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d55:	e8 f0 eb ff ff       	call   80294a <is_free_block>
  803d5a:	83 c4 10             	add    $0x10,%esp
  803d5d:	84 c0                	test   %al,%al
  803d5f:	0f 84 3b 01 00 00    	je     803ea0 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803d65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d6b:	01 d0                	add    %edx,%eax
  803d6d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803d70:	83 ec 04             	sub    $0x4,%esp
  803d73:	6a 01                	push   $0x1
  803d75:	ff 75 f0             	pushl  -0x10(%ebp)
  803d78:	ff 75 08             	pushl  0x8(%ebp)
  803d7b:	e8 02 ef ff ff       	call   802c82 <set_block_data>
  803d80:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803d83:	8b 45 08             	mov    0x8(%ebp),%eax
  803d86:	83 e8 04             	sub    $0x4,%eax
  803d89:	8b 00                	mov    (%eax),%eax
  803d8b:	83 e0 fe             	and    $0xfffffffe,%eax
  803d8e:	89 c2                	mov    %eax,%edx
  803d90:	8b 45 08             	mov    0x8(%ebp),%eax
  803d93:	01 d0                	add    %edx,%eax
  803d95:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803d98:	83 ec 04             	sub    $0x4,%esp
  803d9b:	6a 00                	push   $0x0
  803d9d:	ff 75 cc             	pushl  -0x34(%ebp)
  803da0:	ff 75 c8             	pushl  -0x38(%ebp)
  803da3:	e8 da ee ff ff       	call   802c82 <set_block_data>
  803da8:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803dab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803daf:	74 06                	je     803db7 <realloc_block_FF+0x142>
  803db1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803db5:	75 17                	jne    803dce <realloc_block_FF+0x159>
  803db7:	83 ec 04             	sub    $0x4,%esp
  803dba:	68 50 52 80 00       	push   $0x805250
  803dbf:	68 f6 01 00 00       	push   $0x1f6
  803dc4:	68 dd 51 80 00       	push   $0x8051dd
  803dc9:	e8 c3 ce ff ff       	call   800c91 <_panic>
  803dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd1:	8b 10                	mov    (%eax),%edx
  803dd3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803dd6:	89 10                	mov    %edx,(%eax)
  803dd8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ddb:	8b 00                	mov    (%eax),%eax
  803ddd:	85 c0                	test   %eax,%eax
  803ddf:	74 0b                	je     803dec <realloc_block_FF+0x177>
  803de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de4:	8b 00                	mov    (%eax),%eax
  803de6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803de9:	89 50 04             	mov    %edx,0x4(%eax)
  803dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803def:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803df2:	89 10                	mov    %edx,(%eax)
  803df4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803df7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dfa:	89 50 04             	mov    %edx,0x4(%eax)
  803dfd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803e00:	8b 00                	mov    (%eax),%eax
  803e02:	85 c0                	test   %eax,%eax
  803e04:	75 08                	jne    803e0e <realloc_block_FF+0x199>
  803e06:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803e09:	a3 34 60 80 00       	mov    %eax,0x806034
  803e0e:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803e13:	40                   	inc    %eax
  803e14:	a3 3c 60 80 00       	mov    %eax,0x80603c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803e19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e1d:	75 17                	jne    803e36 <realloc_block_FF+0x1c1>
  803e1f:	83 ec 04             	sub    $0x4,%esp
  803e22:	68 bf 51 80 00       	push   $0x8051bf
  803e27:	68 f7 01 00 00       	push   $0x1f7
  803e2c:	68 dd 51 80 00       	push   $0x8051dd
  803e31:	e8 5b ce ff ff       	call   800c91 <_panic>
  803e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e39:	8b 00                	mov    (%eax),%eax
  803e3b:	85 c0                	test   %eax,%eax
  803e3d:	74 10                	je     803e4f <realloc_block_FF+0x1da>
  803e3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e42:	8b 00                	mov    (%eax),%eax
  803e44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e47:	8b 52 04             	mov    0x4(%edx),%edx
  803e4a:	89 50 04             	mov    %edx,0x4(%eax)
  803e4d:	eb 0b                	jmp    803e5a <realloc_block_FF+0x1e5>
  803e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e52:	8b 40 04             	mov    0x4(%eax),%eax
  803e55:	a3 34 60 80 00       	mov    %eax,0x806034
  803e5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e5d:	8b 40 04             	mov    0x4(%eax),%eax
  803e60:	85 c0                	test   %eax,%eax
  803e62:	74 0f                	je     803e73 <realloc_block_FF+0x1fe>
  803e64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e67:	8b 40 04             	mov    0x4(%eax),%eax
  803e6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e6d:	8b 12                	mov    (%edx),%edx
  803e6f:	89 10                	mov    %edx,(%eax)
  803e71:	eb 0a                	jmp    803e7d <realloc_block_FF+0x208>
  803e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e76:	8b 00                	mov    (%eax),%eax
  803e78:	a3 30 60 80 00       	mov    %eax,0x806030
  803e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e90:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803e95:	48                   	dec    %eax
  803e96:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803e9b:	e9 83 02 00 00       	jmp    804123 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803ea0:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803ea4:	0f 86 69 02 00 00    	jbe    804113 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803eaa:	83 ec 04             	sub    $0x4,%esp
  803ead:	6a 01                	push   $0x1
  803eaf:	ff 75 f0             	pushl  -0x10(%ebp)
  803eb2:	ff 75 08             	pushl  0x8(%ebp)
  803eb5:	e8 c8 ed ff ff       	call   802c82 <set_block_data>
  803eba:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec0:	83 e8 04             	sub    $0x4,%eax
  803ec3:	8b 00                	mov    (%eax),%eax
  803ec5:	83 e0 fe             	and    $0xfffffffe,%eax
  803ec8:	89 c2                	mov    %eax,%edx
  803eca:	8b 45 08             	mov    0x8(%ebp),%eax
  803ecd:	01 d0                	add    %edx,%eax
  803ecf:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803ed2:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803ed7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803eda:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ede:	75 68                	jne    803f48 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ee0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ee4:	75 17                	jne    803efd <realloc_block_FF+0x288>
  803ee6:	83 ec 04             	sub    $0x4,%esp
  803ee9:	68 f8 51 80 00       	push   $0x8051f8
  803eee:	68 06 02 00 00       	push   $0x206
  803ef3:	68 dd 51 80 00       	push   $0x8051dd
  803ef8:	e8 94 cd ff ff       	call   800c91 <_panic>
  803efd:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803f03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f06:	89 10                	mov    %edx,(%eax)
  803f08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f0b:	8b 00                	mov    (%eax),%eax
  803f0d:	85 c0                	test   %eax,%eax
  803f0f:	74 0d                	je     803f1e <realloc_block_FF+0x2a9>
  803f11:	a1 30 60 80 00       	mov    0x806030,%eax
  803f16:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f19:	89 50 04             	mov    %edx,0x4(%eax)
  803f1c:	eb 08                	jmp    803f26 <realloc_block_FF+0x2b1>
  803f1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f21:	a3 34 60 80 00       	mov    %eax,0x806034
  803f26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f29:	a3 30 60 80 00       	mov    %eax,0x806030
  803f2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f38:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803f3d:	40                   	inc    %eax
  803f3e:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803f43:	e9 b0 01 00 00       	jmp    8040f8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803f48:	a1 30 60 80 00       	mov    0x806030,%eax
  803f4d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f50:	76 68                	jbe    803fba <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803f52:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f56:	75 17                	jne    803f6f <realloc_block_FF+0x2fa>
  803f58:	83 ec 04             	sub    $0x4,%esp
  803f5b:	68 f8 51 80 00       	push   $0x8051f8
  803f60:	68 0b 02 00 00       	push   $0x20b
  803f65:	68 dd 51 80 00       	push   $0x8051dd
  803f6a:	e8 22 cd ff ff       	call   800c91 <_panic>
  803f6f:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803f75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f78:	89 10                	mov    %edx,(%eax)
  803f7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f7d:	8b 00                	mov    (%eax),%eax
  803f7f:	85 c0                	test   %eax,%eax
  803f81:	74 0d                	je     803f90 <realloc_block_FF+0x31b>
  803f83:	a1 30 60 80 00       	mov    0x806030,%eax
  803f88:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f8b:	89 50 04             	mov    %edx,0x4(%eax)
  803f8e:	eb 08                	jmp    803f98 <realloc_block_FF+0x323>
  803f90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f93:	a3 34 60 80 00       	mov    %eax,0x806034
  803f98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f9b:	a3 30 60 80 00       	mov    %eax,0x806030
  803fa0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803faa:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803faf:	40                   	inc    %eax
  803fb0:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803fb5:	e9 3e 01 00 00       	jmp    8040f8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803fba:	a1 30 60 80 00       	mov    0x806030,%eax
  803fbf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803fc2:	73 68                	jae    80402c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803fc4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803fc8:	75 17                	jne    803fe1 <realloc_block_FF+0x36c>
  803fca:	83 ec 04             	sub    $0x4,%esp
  803fcd:	68 2c 52 80 00       	push   $0x80522c
  803fd2:	68 10 02 00 00       	push   $0x210
  803fd7:	68 dd 51 80 00       	push   $0x8051dd
  803fdc:	e8 b0 cc ff ff       	call   800c91 <_panic>
  803fe1:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803fe7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fea:	89 50 04             	mov    %edx,0x4(%eax)
  803fed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ff0:	8b 40 04             	mov    0x4(%eax),%eax
  803ff3:	85 c0                	test   %eax,%eax
  803ff5:	74 0c                	je     804003 <realloc_block_FF+0x38e>
  803ff7:	a1 34 60 80 00       	mov    0x806034,%eax
  803ffc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803fff:	89 10                	mov    %edx,(%eax)
  804001:	eb 08                	jmp    80400b <realloc_block_FF+0x396>
  804003:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804006:	a3 30 60 80 00       	mov    %eax,0x806030
  80400b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80400e:	a3 34 60 80 00       	mov    %eax,0x806034
  804013:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804016:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80401c:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804021:	40                   	inc    %eax
  804022:	a3 3c 60 80 00       	mov    %eax,0x80603c
  804027:	e9 cc 00 00 00       	jmp    8040f8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80402c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804033:	a1 30 60 80 00       	mov    0x806030,%eax
  804038:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80403b:	e9 8a 00 00 00       	jmp    8040ca <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804043:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804046:	73 7a                	jae    8040c2 <realloc_block_FF+0x44d>
  804048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80404b:	8b 00                	mov    (%eax),%eax
  80404d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804050:	73 70                	jae    8040c2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804052:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804056:	74 06                	je     80405e <realloc_block_FF+0x3e9>
  804058:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80405c:	75 17                	jne    804075 <realloc_block_FF+0x400>
  80405e:	83 ec 04             	sub    $0x4,%esp
  804061:	68 50 52 80 00       	push   $0x805250
  804066:	68 1a 02 00 00       	push   $0x21a
  80406b:	68 dd 51 80 00       	push   $0x8051dd
  804070:	e8 1c cc ff ff       	call   800c91 <_panic>
  804075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804078:	8b 10                	mov    (%eax),%edx
  80407a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80407d:	89 10                	mov    %edx,(%eax)
  80407f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804082:	8b 00                	mov    (%eax),%eax
  804084:	85 c0                	test   %eax,%eax
  804086:	74 0b                	je     804093 <realloc_block_FF+0x41e>
  804088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80408b:	8b 00                	mov    (%eax),%eax
  80408d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804090:	89 50 04             	mov    %edx,0x4(%eax)
  804093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804096:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804099:	89 10                	mov    %edx,(%eax)
  80409b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80409e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040a1:	89 50 04             	mov    %edx,0x4(%eax)
  8040a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040a7:	8b 00                	mov    (%eax),%eax
  8040a9:	85 c0                	test   %eax,%eax
  8040ab:	75 08                	jne    8040b5 <realloc_block_FF+0x440>
  8040ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040b0:	a3 34 60 80 00       	mov    %eax,0x806034
  8040b5:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8040ba:	40                   	inc    %eax
  8040bb:	a3 3c 60 80 00       	mov    %eax,0x80603c
							break;
  8040c0:	eb 36                	jmp    8040f8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8040c2:	a1 38 60 80 00       	mov    0x806038,%eax
  8040c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040ce:	74 07                	je     8040d7 <realloc_block_FF+0x462>
  8040d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040d3:	8b 00                	mov    (%eax),%eax
  8040d5:	eb 05                	jmp    8040dc <realloc_block_FF+0x467>
  8040d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8040dc:	a3 38 60 80 00       	mov    %eax,0x806038
  8040e1:	a1 38 60 80 00       	mov    0x806038,%eax
  8040e6:	85 c0                	test   %eax,%eax
  8040e8:	0f 85 52 ff ff ff    	jne    804040 <realloc_block_FF+0x3cb>
  8040ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040f2:	0f 85 48 ff ff ff    	jne    804040 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8040f8:	83 ec 04             	sub    $0x4,%esp
  8040fb:	6a 00                	push   $0x0
  8040fd:	ff 75 d8             	pushl  -0x28(%ebp)
  804100:	ff 75 d4             	pushl  -0x2c(%ebp)
  804103:	e8 7a eb ff ff       	call   802c82 <set_block_data>
  804108:	83 c4 10             	add    $0x10,%esp
				return va;
  80410b:	8b 45 08             	mov    0x8(%ebp),%eax
  80410e:	e9 7b 02 00 00       	jmp    80438e <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804113:	83 ec 0c             	sub    $0xc,%esp
  804116:	68 cd 52 80 00       	push   $0x8052cd
  80411b:	e8 2e ce ff ff       	call   800f4e <cprintf>
  804120:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804123:	8b 45 08             	mov    0x8(%ebp),%eax
  804126:	e9 63 02 00 00       	jmp    80438e <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80412b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80412e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804131:	0f 86 4d 02 00 00    	jbe    804384 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804137:	83 ec 0c             	sub    $0xc,%esp
  80413a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80413d:	e8 08 e8 ff ff       	call   80294a <is_free_block>
  804142:	83 c4 10             	add    $0x10,%esp
  804145:	84 c0                	test   %al,%al
  804147:	0f 84 37 02 00 00    	je     804384 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80414d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804150:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804153:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804156:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804159:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80415c:	76 38                	jbe    804196 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80415e:	83 ec 0c             	sub    $0xc,%esp
  804161:	ff 75 08             	pushl  0x8(%ebp)
  804164:	e8 0c fa ff ff       	call   803b75 <free_block>
  804169:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80416c:	83 ec 0c             	sub    $0xc,%esp
  80416f:	ff 75 0c             	pushl  0xc(%ebp)
  804172:	e8 3a eb ff ff       	call   802cb1 <alloc_block_FF>
  804177:	83 c4 10             	add    $0x10,%esp
  80417a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80417d:	83 ec 08             	sub    $0x8,%esp
  804180:	ff 75 c0             	pushl  -0x40(%ebp)
  804183:	ff 75 08             	pushl  0x8(%ebp)
  804186:	e8 ab fa ff ff       	call   803c36 <copy_data>
  80418b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80418e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804191:	e9 f8 01 00 00       	jmp    80438e <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804199:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80419c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80419f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8041a3:	0f 87 a0 00 00 00    	ja     804249 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8041a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041ad:	75 17                	jne    8041c6 <realloc_block_FF+0x551>
  8041af:	83 ec 04             	sub    $0x4,%esp
  8041b2:	68 bf 51 80 00       	push   $0x8051bf
  8041b7:	68 38 02 00 00       	push   $0x238
  8041bc:	68 dd 51 80 00       	push   $0x8051dd
  8041c1:	e8 cb ca ff ff       	call   800c91 <_panic>
  8041c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c9:	8b 00                	mov    (%eax),%eax
  8041cb:	85 c0                	test   %eax,%eax
  8041cd:	74 10                	je     8041df <realloc_block_FF+0x56a>
  8041cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d2:	8b 00                	mov    (%eax),%eax
  8041d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041d7:	8b 52 04             	mov    0x4(%edx),%edx
  8041da:	89 50 04             	mov    %edx,0x4(%eax)
  8041dd:	eb 0b                	jmp    8041ea <realloc_block_FF+0x575>
  8041df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041e2:	8b 40 04             	mov    0x4(%eax),%eax
  8041e5:	a3 34 60 80 00       	mov    %eax,0x806034
  8041ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ed:	8b 40 04             	mov    0x4(%eax),%eax
  8041f0:	85 c0                	test   %eax,%eax
  8041f2:	74 0f                	je     804203 <realloc_block_FF+0x58e>
  8041f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f7:	8b 40 04             	mov    0x4(%eax),%eax
  8041fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041fd:	8b 12                	mov    (%edx),%edx
  8041ff:	89 10                	mov    %edx,(%eax)
  804201:	eb 0a                	jmp    80420d <realloc_block_FF+0x598>
  804203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804206:	8b 00                	mov    (%eax),%eax
  804208:	a3 30 60 80 00       	mov    %eax,0x806030
  80420d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804210:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804219:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804220:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804225:	48                   	dec    %eax
  804226:	a3 3c 60 80 00       	mov    %eax,0x80603c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80422b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80422e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804231:	01 d0                	add    %edx,%eax
  804233:	83 ec 04             	sub    $0x4,%esp
  804236:	6a 01                	push   $0x1
  804238:	50                   	push   %eax
  804239:	ff 75 08             	pushl  0x8(%ebp)
  80423c:	e8 41 ea ff ff       	call   802c82 <set_block_data>
  804241:	83 c4 10             	add    $0x10,%esp
  804244:	e9 36 01 00 00       	jmp    80437f <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804249:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80424c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80424f:	01 d0                	add    %edx,%eax
  804251:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804254:	83 ec 04             	sub    $0x4,%esp
  804257:	6a 01                	push   $0x1
  804259:	ff 75 f0             	pushl  -0x10(%ebp)
  80425c:	ff 75 08             	pushl  0x8(%ebp)
  80425f:	e8 1e ea ff ff       	call   802c82 <set_block_data>
  804264:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804267:	8b 45 08             	mov    0x8(%ebp),%eax
  80426a:	83 e8 04             	sub    $0x4,%eax
  80426d:	8b 00                	mov    (%eax),%eax
  80426f:	83 e0 fe             	and    $0xfffffffe,%eax
  804272:	89 c2                	mov    %eax,%edx
  804274:	8b 45 08             	mov    0x8(%ebp),%eax
  804277:	01 d0                	add    %edx,%eax
  804279:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80427c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804280:	74 06                	je     804288 <realloc_block_FF+0x613>
  804282:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804286:	75 17                	jne    80429f <realloc_block_FF+0x62a>
  804288:	83 ec 04             	sub    $0x4,%esp
  80428b:	68 50 52 80 00       	push   $0x805250
  804290:	68 44 02 00 00       	push   $0x244
  804295:	68 dd 51 80 00       	push   $0x8051dd
  80429a:	e8 f2 c9 ff ff       	call   800c91 <_panic>
  80429f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042a2:	8b 10                	mov    (%eax),%edx
  8042a4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8042a7:	89 10                	mov    %edx,(%eax)
  8042a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8042ac:	8b 00                	mov    (%eax),%eax
  8042ae:	85 c0                	test   %eax,%eax
  8042b0:	74 0b                	je     8042bd <realloc_block_FF+0x648>
  8042b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042b5:	8b 00                	mov    (%eax),%eax
  8042b7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8042ba:	89 50 04             	mov    %edx,0x4(%eax)
  8042bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042c0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8042c3:	89 10                	mov    %edx,(%eax)
  8042c5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8042c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042cb:	89 50 04             	mov    %edx,0x4(%eax)
  8042ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8042d1:	8b 00                	mov    (%eax),%eax
  8042d3:	85 c0                	test   %eax,%eax
  8042d5:	75 08                	jne    8042df <realloc_block_FF+0x66a>
  8042d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8042da:	a3 34 60 80 00       	mov    %eax,0x806034
  8042df:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8042e4:	40                   	inc    %eax
  8042e5:	a3 3c 60 80 00       	mov    %eax,0x80603c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8042ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8042ee:	75 17                	jne    804307 <realloc_block_FF+0x692>
  8042f0:	83 ec 04             	sub    $0x4,%esp
  8042f3:	68 bf 51 80 00       	push   $0x8051bf
  8042f8:	68 45 02 00 00       	push   $0x245
  8042fd:	68 dd 51 80 00       	push   $0x8051dd
  804302:	e8 8a c9 ff ff       	call   800c91 <_panic>
  804307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80430a:	8b 00                	mov    (%eax),%eax
  80430c:	85 c0                	test   %eax,%eax
  80430e:	74 10                	je     804320 <realloc_block_FF+0x6ab>
  804310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804313:	8b 00                	mov    (%eax),%eax
  804315:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804318:	8b 52 04             	mov    0x4(%edx),%edx
  80431b:	89 50 04             	mov    %edx,0x4(%eax)
  80431e:	eb 0b                	jmp    80432b <realloc_block_FF+0x6b6>
  804320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804323:	8b 40 04             	mov    0x4(%eax),%eax
  804326:	a3 34 60 80 00       	mov    %eax,0x806034
  80432b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80432e:	8b 40 04             	mov    0x4(%eax),%eax
  804331:	85 c0                	test   %eax,%eax
  804333:	74 0f                	je     804344 <realloc_block_FF+0x6cf>
  804335:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804338:	8b 40 04             	mov    0x4(%eax),%eax
  80433b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80433e:	8b 12                	mov    (%edx),%edx
  804340:	89 10                	mov    %edx,(%eax)
  804342:	eb 0a                	jmp    80434e <realloc_block_FF+0x6d9>
  804344:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804347:	8b 00                	mov    (%eax),%eax
  804349:	a3 30 60 80 00       	mov    %eax,0x806030
  80434e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804351:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80435a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804361:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804366:	48                   	dec    %eax
  804367:	a3 3c 60 80 00       	mov    %eax,0x80603c
				set_block_data(next_new_va, remaining_size, 0);
  80436c:	83 ec 04             	sub    $0x4,%esp
  80436f:	6a 00                	push   $0x0
  804371:	ff 75 bc             	pushl  -0x44(%ebp)
  804374:	ff 75 b8             	pushl  -0x48(%ebp)
  804377:	e8 06 e9 ff ff       	call   802c82 <set_block_data>
  80437c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80437f:	8b 45 08             	mov    0x8(%ebp),%eax
  804382:	eb 0a                	jmp    80438e <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804384:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80438b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80438e:	c9                   	leave  
  80438f:	c3                   	ret    

00804390 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804390:	55                   	push   %ebp
  804391:	89 e5                	mov    %esp,%ebp
  804393:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804396:	83 ec 04             	sub    $0x4,%esp
  804399:	68 d4 52 80 00       	push   $0x8052d4
  80439e:	68 58 02 00 00       	push   $0x258
  8043a3:	68 dd 51 80 00       	push   $0x8051dd
  8043a8:	e8 e4 c8 ff ff       	call   800c91 <_panic>

008043ad <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8043ad:	55                   	push   %ebp
  8043ae:	89 e5                	mov    %esp,%ebp
  8043b0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8043b3:	83 ec 04             	sub    $0x4,%esp
  8043b6:	68 fc 52 80 00       	push   $0x8052fc
  8043bb:	68 61 02 00 00       	push   $0x261
  8043c0:	68 dd 51 80 00       	push   $0x8051dd
  8043c5:	e8 c7 c8 ff ff       	call   800c91 <_panic>

008043ca <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8043ca:	55                   	push   %ebp
  8043cb:	89 e5                	mov    %esp,%ebp
  8043cd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8043d0:	83 ec 04             	sub    $0x4,%esp
  8043d3:	68 24 53 80 00       	push   $0x805324
  8043d8:	6a 09                	push   $0x9
  8043da:	68 4c 53 80 00       	push   $0x80534c
  8043df:	e8 ad c8 ff ff       	call   800c91 <_panic>

008043e4 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8043e4:	55                   	push   %ebp
  8043e5:	89 e5                	mov    %esp,%ebp
  8043e7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8043ea:	83 ec 04             	sub    $0x4,%esp
  8043ed:	68 5c 53 80 00       	push   $0x80535c
  8043f2:	6a 10                	push   $0x10
  8043f4:	68 4c 53 80 00       	push   $0x80534c
  8043f9:	e8 93 c8 ff ff       	call   800c91 <_panic>

008043fe <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8043fe:	55                   	push   %ebp
  8043ff:	89 e5                	mov    %esp,%ebp
  804401:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  804404:	83 ec 04             	sub    $0x4,%esp
  804407:	68 84 53 80 00       	push   $0x805384
  80440c:	6a 18                	push   $0x18
  80440e:	68 4c 53 80 00       	push   $0x80534c
  804413:	e8 79 c8 ff ff       	call   800c91 <_panic>

00804418 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  804418:	55                   	push   %ebp
  804419:	89 e5                	mov    %esp,%ebp
  80441b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  80441e:	83 ec 04             	sub    $0x4,%esp
  804421:	68 ac 53 80 00       	push   $0x8053ac
  804426:	6a 20                	push   $0x20
  804428:	68 4c 53 80 00       	push   $0x80534c
  80442d:	e8 5f c8 ff ff       	call   800c91 <_panic>

00804432 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  804432:	55                   	push   %ebp
  804433:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804435:	8b 45 08             	mov    0x8(%ebp),%eax
  804438:	8b 40 10             	mov    0x10(%eax),%eax
}
  80443b:	5d                   	pop    %ebp
  80443c:	c3                   	ret    

0080443d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80443d:	55                   	push   %ebp
  80443e:	89 e5                	mov    %esp,%ebp
  804440:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804443:	8b 55 08             	mov    0x8(%ebp),%edx
  804446:	89 d0                	mov    %edx,%eax
  804448:	c1 e0 02             	shl    $0x2,%eax
  80444b:	01 d0                	add    %edx,%eax
  80444d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804454:	01 d0                	add    %edx,%eax
  804456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80445d:	01 d0                	add    %edx,%eax
  80445f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804466:	01 d0                	add    %edx,%eax
  804468:	c1 e0 04             	shl    $0x4,%eax
  80446b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80446e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  804475:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804478:	83 ec 0c             	sub    $0xc,%esp
  80447b:	50                   	push   %eax
  80447c:	e8 bc e1 ff ff       	call   80263d <sys_get_virtual_time>
  804481:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  804484:	eb 41                	jmp    8044c7 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  804486:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804489:	83 ec 0c             	sub    $0xc,%esp
  80448c:	50                   	push   %eax
  80448d:	e8 ab e1 ff ff       	call   80263d <sys_get_virtual_time>
  804492:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804495:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804498:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80449b:	29 c2                	sub    %eax,%edx
  80449d:	89 d0                	mov    %edx,%eax
  80449f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8044a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044a8:	89 d1                	mov    %edx,%ecx
  8044aa:	29 c1                	sub    %eax,%ecx
  8044ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8044af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044b2:	39 c2                	cmp    %eax,%edx
  8044b4:	0f 97 c0             	seta   %al
  8044b7:	0f b6 c0             	movzbl %al,%eax
  8044ba:	29 c1                	sub    %eax,%ecx
  8044bc:	89 c8                	mov    %ecx,%eax
  8044be:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8044c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8044c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8044c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8044cd:	72 b7                	jb     804486 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8044cf:	90                   	nop
  8044d0:	c9                   	leave  
  8044d1:	c3                   	ret    

008044d2 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8044d2:	55                   	push   %ebp
  8044d3:	89 e5                	mov    %esp,%ebp
  8044d5:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8044d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8044df:	eb 03                	jmp    8044e4 <busy_wait+0x12>
  8044e1:	ff 45 fc             	incl   -0x4(%ebp)
  8044e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8044e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8044ea:	72 f5                	jb     8044e1 <busy_wait+0xf>
	return i;
  8044ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8044ef:	c9                   	leave  
  8044f0:	c3                   	ret    
  8044f1:	66 90                	xchg   %ax,%ax
  8044f3:	90                   	nop

008044f4 <__udivdi3>:
  8044f4:	55                   	push   %ebp
  8044f5:	57                   	push   %edi
  8044f6:	56                   	push   %esi
  8044f7:	53                   	push   %ebx
  8044f8:	83 ec 1c             	sub    $0x1c,%esp
  8044fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8044ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804503:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804507:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80450b:	89 ca                	mov    %ecx,%edx
  80450d:	89 f8                	mov    %edi,%eax
  80450f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804513:	85 f6                	test   %esi,%esi
  804515:	75 2d                	jne    804544 <__udivdi3+0x50>
  804517:	39 cf                	cmp    %ecx,%edi
  804519:	77 65                	ja     804580 <__udivdi3+0x8c>
  80451b:	89 fd                	mov    %edi,%ebp
  80451d:	85 ff                	test   %edi,%edi
  80451f:	75 0b                	jne    80452c <__udivdi3+0x38>
  804521:	b8 01 00 00 00       	mov    $0x1,%eax
  804526:	31 d2                	xor    %edx,%edx
  804528:	f7 f7                	div    %edi
  80452a:	89 c5                	mov    %eax,%ebp
  80452c:	31 d2                	xor    %edx,%edx
  80452e:	89 c8                	mov    %ecx,%eax
  804530:	f7 f5                	div    %ebp
  804532:	89 c1                	mov    %eax,%ecx
  804534:	89 d8                	mov    %ebx,%eax
  804536:	f7 f5                	div    %ebp
  804538:	89 cf                	mov    %ecx,%edi
  80453a:	89 fa                	mov    %edi,%edx
  80453c:	83 c4 1c             	add    $0x1c,%esp
  80453f:	5b                   	pop    %ebx
  804540:	5e                   	pop    %esi
  804541:	5f                   	pop    %edi
  804542:	5d                   	pop    %ebp
  804543:	c3                   	ret    
  804544:	39 ce                	cmp    %ecx,%esi
  804546:	77 28                	ja     804570 <__udivdi3+0x7c>
  804548:	0f bd fe             	bsr    %esi,%edi
  80454b:	83 f7 1f             	xor    $0x1f,%edi
  80454e:	75 40                	jne    804590 <__udivdi3+0x9c>
  804550:	39 ce                	cmp    %ecx,%esi
  804552:	72 0a                	jb     80455e <__udivdi3+0x6a>
  804554:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804558:	0f 87 9e 00 00 00    	ja     8045fc <__udivdi3+0x108>
  80455e:	b8 01 00 00 00       	mov    $0x1,%eax
  804563:	89 fa                	mov    %edi,%edx
  804565:	83 c4 1c             	add    $0x1c,%esp
  804568:	5b                   	pop    %ebx
  804569:	5e                   	pop    %esi
  80456a:	5f                   	pop    %edi
  80456b:	5d                   	pop    %ebp
  80456c:	c3                   	ret    
  80456d:	8d 76 00             	lea    0x0(%esi),%esi
  804570:	31 ff                	xor    %edi,%edi
  804572:	31 c0                	xor    %eax,%eax
  804574:	89 fa                	mov    %edi,%edx
  804576:	83 c4 1c             	add    $0x1c,%esp
  804579:	5b                   	pop    %ebx
  80457a:	5e                   	pop    %esi
  80457b:	5f                   	pop    %edi
  80457c:	5d                   	pop    %ebp
  80457d:	c3                   	ret    
  80457e:	66 90                	xchg   %ax,%ax
  804580:	89 d8                	mov    %ebx,%eax
  804582:	f7 f7                	div    %edi
  804584:	31 ff                	xor    %edi,%edi
  804586:	89 fa                	mov    %edi,%edx
  804588:	83 c4 1c             	add    $0x1c,%esp
  80458b:	5b                   	pop    %ebx
  80458c:	5e                   	pop    %esi
  80458d:	5f                   	pop    %edi
  80458e:	5d                   	pop    %ebp
  80458f:	c3                   	ret    
  804590:	bd 20 00 00 00       	mov    $0x20,%ebp
  804595:	89 eb                	mov    %ebp,%ebx
  804597:	29 fb                	sub    %edi,%ebx
  804599:	89 f9                	mov    %edi,%ecx
  80459b:	d3 e6                	shl    %cl,%esi
  80459d:	89 c5                	mov    %eax,%ebp
  80459f:	88 d9                	mov    %bl,%cl
  8045a1:	d3 ed                	shr    %cl,%ebp
  8045a3:	89 e9                	mov    %ebp,%ecx
  8045a5:	09 f1                	or     %esi,%ecx
  8045a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8045ab:	89 f9                	mov    %edi,%ecx
  8045ad:	d3 e0                	shl    %cl,%eax
  8045af:	89 c5                	mov    %eax,%ebp
  8045b1:	89 d6                	mov    %edx,%esi
  8045b3:	88 d9                	mov    %bl,%cl
  8045b5:	d3 ee                	shr    %cl,%esi
  8045b7:	89 f9                	mov    %edi,%ecx
  8045b9:	d3 e2                	shl    %cl,%edx
  8045bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045bf:	88 d9                	mov    %bl,%cl
  8045c1:	d3 e8                	shr    %cl,%eax
  8045c3:	09 c2                	or     %eax,%edx
  8045c5:	89 d0                	mov    %edx,%eax
  8045c7:	89 f2                	mov    %esi,%edx
  8045c9:	f7 74 24 0c          	divl   0xc(%esp)
  8045cd:	89 d6                	mov    %edx,%esi
  8045cf:	89 c3                	mov    %eax,%ebx
  8045d1:	f7 e5                	mul    %ebp
  8045d3:	39 d6                	cmp    %edx,%esi
  8045d5:	72 19                	jb     8045f0 <__udivdi3+0xfc>
  8045d7:	74 0b                	je     8045e4 <__udivdi3+0xf0>
  8045d9:	89 d8                	mov    %ebx,%eax
  8045db:	31 ff                	xor    %edi,%edi
  8045dd:	e9 58 ff ff ff       	jmp    80453a <__udivdi3+0x46>
  8045e2:	66 90                	xchg   %ax,%ax
  8045e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8045e8:	89 f9                	mov    %edi,%ecx
  8045ea:	d3 e2                	shl    %cl,%edx
  8045ec:	39 c2                	cmp    %eax,%edx
  8045ee:	73 e9                	jae    8045d9 <__udivdi3+0xe5>
  8045f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8045f3:	31 ff                	xor    %edi,%edi
  8045f5:	e9 40 ff ff ff       	jmp    80453a <__udivdi3+0x46>
  8045fa:	66 90                	xchg   %ax,%ax
  8045fc:	31 c0                	xor    %eax,%eax
  8045fe:	e9 37 ff ff ff       	jmp    80453a <__udivdi3+0x46>
  804603:	90                   	nop

00804604 <__umoddi3>:
  804604:	55                   	push   %ebp
  804605:	57                   	push   %edi
  804606:	56                   	push   %esi
  804607:	53                   	push   %ebx
  804608:	83 ec 1c             	sub    $0x1c,%esp
  80460b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80460f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804613:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804617:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80461b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80461f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804623:	89 f3                	mov    %esi,%ebx
  804625:	89 fa                	mov    %edi,%edx
  804627:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80462b:	89 34 24             	mov    %esi,(%esp)
  80462e:	85 c0                	test   %eax,%eax
  804630:	75 1a                	jne    80464c <__umoddi3+0x48>
  804632:	39 f7                	cmp    %esi,%edi
  804634:	0f 86 a2 00 00 00    	jbe    8046dc <__umoddi3+0xd8>
  80463a:	89 c8                	mov    %ecx,%eax
  80463c:	89 f2                	mov    %esi,%edx
  80463e:	f7 f7                	div    %edi
  804640:	89 d0                	mov    %edx,%eax
  804642:	31 d2                	xor    %edx,%edx
  804644:	83 c4 1c             	add    $0x1c,%esp
  804647:	5b                   	pop    %ebx
  804648:	5e                   	pop    %esi
  804649:	5f                   	pop    %edi
  80464a:	5d                   	pop    %ebp
  80464b:	c3                   	ret    
  80464c:	39 f0                	cmp    %esi,%eax
  80464e:	0f 87 ac 00 00 00    	ja     804700 <__umoddi3+0xfc>
  804654:	0f bd e8             	bsr    %eax,%ebp
  804657:	83 f5 1f             	xor    $0x1f,%ebp
  80465a:	0f 84 ac 00 00 00    	je     80470c <__umoddi3+0x108>
  804660:	bf 20 00 00 00       	mov    $0x20,%edi
  804665:	29 ef                	sub    %ebp,%edi
  804667:	89 fe                	mov    %edi,%esi
  804669:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80466d:	89 e9                	mov    %ebp,%ecx
  80466f:	d3 e0                	shl    %cl,%eax
  804671:	89 d7                	mov    %edx,%edi
  804673:	89 f1                	mov    %esi,%ecx
  804675:	d3 ef                	shr    %cl,%edi
  804677:	09 c7                	or     %eax,%edi
  804679:	89 e9                	mov    %ebp,%ecx
  80467b:	d3 e2                	shl    %cl,%edx
  80467d:	89 14 24             	mov    %edx,(%esp)
  804680:	89 d8                	mov    %ebx,%eax
  804682:	d3 e0                	shl    %cl,%eax
  804684:	89 c2                	mov    %eax,%edx
  804686:	8b 44 24 08          	mov    0x8(%esp),%eax
  80468a:	d3 e0                	shl    %cl,%eax
  80468c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804690:	8b 44 24 08          	mov    0x8(%esp),%eax
  804694:	89 f1                	mov    %esi,%ecx
  804696:	d3 e8                	shr    %cl,%eax
  804698:	09 d0                	or     %edx,%eax
  80469a:	d3 eb                	shr    %cl,%ebx
  80469c:	89 da                	mov    %ebx,%edx
  80469e:	f7 f7                	div    %edi
  8046a0:	89 d3                	mov    %edx,%ebx
  8046a2:	f7 24 24             	mull   (%esp)
  8046a5:	89 c6                	mov    %eax,%esi
  8046a7:	89 d1                	mov    %edx,%ecx
  8046a9:	39 d3                	cmp    %edx,%ebx
  8046ab:	0f 82 87 00 00 00    	jb     804738 <__umoddi3+0x134>
  8046b1:	0f 84 91 00 00 00    	je     804748 <__umoddi3+0x144>
  8046b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8046bb:	29 f2                	sub    %esi,%edx
  8046bd:	19 cb                	sbb    %ecx,%ebx
  8046bf:	89 d8                	mov    %ebx,%eax
  8046c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8046c5:	d3 e0                	shl    %cl,%eax
  8046c7:	89 e9                	mov    %ebp,%ecx
  8046c9:	d3 ea                	shr    %cl,%edx
  8046cb:	09 d0                	or     %edx,%eax
  8046cd:	89 e9                	mov    %ebp,%ecx
  8046cf:	d3 eb                	shr    %cl,%ebx
  8046d1:	89 da                	mov    %ebx,%edx
  8046d3:	83 c4 1c             	add    $0x1c,%esp
  8046d6:	5b                   	pop    %ebx
  8046d7:	5e                   	pop    %esi
  8046d8:	5f                   	pop    %edi
  8046d9:	5d                   	pop    %ebp
  8046da:	c3                   	ret    
  8046db:	90                   	nop
  8046dc:	89 fd                	mov    %edi,%ebp
  8046de:	85 ff                	test   %edi,%edi
  8046e0:	75 0b                	jne    8046ed <__umoddi3+0xe9>
  8046e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8046e7:	31 d2                	xor    %edx,%edx
  8046e9:	f7 f7                	div    %edi
  8046eb:	89 c5                	mov    %eax,%ebp
  8046ed:	89 f0                	mov    %esi,%eax
  8046ef:	31 d2                	xor    %edx,%edx
  8046f1:	f7 f5                	div    %ebp
  8046f3:	89 c8                	mov    %ecx,%eax
  8046f5:	f7 f5                	div    %ebp
  8046f7:	89 d0                	mov    %edx,%eax
  8046f9:	e9 44 ff ff ff       	jmp    804642 <__umoddi3+0x3e>
  8046fe:	66 90                	xchg   %ax,%ax
  804700:	89 c8                	mov    %ecx,%eax
  804702:	89 f2                	mov    %esi,%edx
  804704:	83 c4 1c             	add    $0x1c,%esp
  804707:	5b                   	pop    %ebx
  804708:	5e                   	pop    %esi
  804709:	5f                   	pop    %edi
  80470a:	5d                   	pop    %ebp
  80470b:	c3                   	ret    
  80470c:	3b 04 24             	cmp    (%esp),%eax
  80470f:	72 06                	jb     804717 <__umoddi3+0x113>
  804711:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804715:	77 0f                	ja     804726 <__umoddi3+0x122>
  804717:	89 f2                	mov    %esi,%edx
  804719:	29 f9                	sub    %edi,%ecx
  80471b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80471f:	89 14 24             	mov    %edx,(%esp)
  804722:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804726:	8b 44 24 04          	mov    0x4(%esp),%eax
  80472a:	8b 14 24             	mov    (%esp),%edx
  80472d:	83 c4 1c             	add    $0x1c,%esp
  804730:	5b                   	pop    %ebx
  804731:	5e                   	pop    %esi
  804732:	5f                   	pop    %edi
  804733:	5d                   	pop    %ebp
  804734:	c3                   	ret    
  804735:	8d 76 00             	lea    0x0(%esi),%esi
  804738:	2b 04 24             	sub    (%esp),%eax
  80473b:	19 fa                	sbb    %edi,%edx
  80473d:	89 d1                	mov    %edx,%ecx
  80473f:	89 c6                	mov    %eax,%esi
  804741:	e9 71 ff ff ff       	jmp    8046b7 <__umoddi3+0xb3>
  804746:	66 90                	xchg   %ax,%ax
  804748:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80474c:	72 ea                	jb     804738 <__umoddi3+0x134>
  80474e:	89 d9                	mov    %ebx,%ecx
  804750:	e9 62 ff ff ff       	jmp    8046b7 <__umoddi3+0xb3>
