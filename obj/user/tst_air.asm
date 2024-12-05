
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
  800044:	e8 a2 24 00 00       	call   8024eb <sys_getenvid>
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
  80007c:	bb b2 48 80 00       	mov    $0x8048b2,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800094:	bb bc 48 80 00       	mov    $0x8048bc,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  8000ac:	bb c8 48 80 00       	mov    $0x8048c8,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000c4:	bb d7 48 80 00       	mov    $0x8048d7,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8000dc:	bb e6 48 80 00       	mov    $0x8048e6,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8000f4:	bb fb 48 80 00       	mov    $0x8048fb,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  80010c:	bb 10 49 80 00       	mov    $0x804910,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	bb 21 49 80 00       	mov    $0x804921,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80013c:	bb 32 49 80 00       	mov    $0x804932,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800154:	bb 43 49 80 00       	mov    $0x804943,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80016c:	bb 4c 49 80 00       	mov    $0x80494c,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  800184:	bb 56 49 80 00       	mov    $0x804956,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b5 fe ff ff    	lea    -0x14b(%ebp),%eax
  80019c:	bb 61 49 80 00       	mov    $0x804961,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 ab fe ff ff    	lea    -0x155(%ebp),%eax
  8001b4:	bb 6d 49 80 00       	mov    $0x80496d,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a1 fe ff ff    	lea    -0x15f(%ebp),%eax
  8001cc:	bb 77 49 80 00       	mov    $0x804977,%ebx
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
  8001f7:	bb 81 49 80 00       	mov    $0x804981,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 7e fe ff ff    	lea    -0x182(%ebp),%eax
  80020f:	bb 8f 49 80 00       	mov    $0x80498f,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800227:	bb 9e 49 80 00       	mov    $0x80499e,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  80023f:	bb a5 49 80 00       	mov    $0x8049a5,%ebx
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
  800499:	e8 0c 3e 00 00       	call   8042aa <create_semaphore>
  80049e:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  8004a1:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	6a 01                	push   $0x1
  8004ac:	8d 95 a1 fe ff ff    	lea    -0x15f(%ebp),%edx
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	e8 f1 3d 00 00       	call   8042aa <create_semaphore>
  8004b9:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  8004bc:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 95 8d fe ff ff    	lea    -0x173(%ebp),%edx
  8004cd:	52                   	push   %edx
  8004ce:	50                   	push   %eax
  8004cf:	e8 d6 3d 00 00       	call   8042aa <create_semaphore>
  8004d4:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  8004d7:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	6a 01                	push   $0x1
  8004e2:	8d 95 b5 fe ff ff    	lea    -0x14b(%ebp),%edx
  8004e8:	52                   	push   %edx
  8004e9:	50                   	push   %eax
  8004ea:	e8 bb 3d 00 00       	call   8042aa <create_semaphore>
  8004ef:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  8004f2:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	6a 03                	push   $0x3
  8004fd:	8d 95 9b fe ff ff    	lea    -0x165(%ebp),%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	e8 a0 3d 00 00       	call   8042aa <create_semaphore>
  80050a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  80050d:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	6a 00                	push   $0x0
  800518:	8d 95 c1 fe ff ff    	lea    -0x13f(%ebp),%edx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	e8 85 3d 00 00       	call   8042aa <create_semaphore>
  800525:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  800528:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	6a 00                	push   $0x0
  800533:	8d 95 7e fe ff ff    	lea    -0x182(%ebp),%edx
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	e8 6a 3d 00 00       	call   8042aa <create_semaphore>
  800540:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  800543:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	6a 01                	push   $0x1
  80054e:	50                   	push   %eax
  80054f:	68 40 46 80 00       	push   $0x804640
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
  80057b:	bb ac 49 80 00       	mov    $0x8049ac,%ebx
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
  8005fc:	e8 a9 3c 00 00       	call   8042aa <create_semaphore>
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
  800648:	e8 49 1e 00 00       	call   802496 <sys_create_env>
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  800656:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 4f 1e 00 00       	call   8024b4 <sys_run_env>
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
  800695:	e8 fc 1d 00 00       	call   802496 <sys_create_env>
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006a3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	50                   	push   %eax
  8006ad:	e8 02 1e 00 00       	call   8024b4 <sys_run_env>
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
  8006e2:	e8 af 1d 00 00       	call   802496 <sys_create_env>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	50                   	push   %eax
  8006fa:	e8 b5 1d 00 00       	call   8024b4 <sys_run_env>
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
  800738:	e8 59 1d 00 00       	call   802496 <sys_create_env>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800746:	83 bd 70 ff ff ff ef 	cmpl   $0xffffffef,-0x90(%ebp)
  80074d:	75 17                	jne    800766 <_main+0x72e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	68 54 46 80 00       	push   $0x804654
  800757:	68 98 00 00 00       	push   $0x98
  80075c:	68 9a 46 80 00       	push   $0x80469a
  800761:	e8 2b 05 00 00       	call   800c91 <_panic>

		sys_run_env(envId);
  800766:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	50                   	push   %eax
  800770:	e8 3f 1d 00 00       	call   8024b4 <sys_run_env>
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
  800795:	e8 44 3b 00 00       	call   8042de <wait_semaphore>
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
  8007b0:	e8 68 3b 00 00       	call   80431d <env_sleep>
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
  8007f6:	68 ac 46 80 00       	push   $0x8046ac
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
  80084e:	68 dc 46 80 00       	push   $0x8046dc
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
  80088d:	68 0c 47 80 00       	push   $0x80470c
  800892:	68 b8 00 00 00       	push   $0xb8
  800897:	68 9a 46 80 00       	push   $0x80469a
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
  8008d0:	68 0c 47 80 00       	push   $0x80470c
  8008d5:	68 c1 00 00 00       	push   $0xc1
  8008da:	68 9a 46 80 00       	push   $0x80469a
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
  800931:	68 0c 47 80 00       	push   $0x80470c
  800936:	68 ca 00 00 00       	push   $0xca
  80093b:	68 9a 46 80 00       	push   $0x80469a
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
  80095e:	e8 af 39 00 00       	call   804312 <semaphore_count>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	83 f8 01             	cmp    $0x1,%eax
  800969:	74 19                	je     800984 <_main+0x94c>
  80096b:	68 30 47 80 00       	push   $0x804730
  800970:	68 50 47 80 00       	push   $0x804750
  800975:	68 ce 00 00 00       	push   $0xce
  80097a:	68 9a 46 80 00       	push   $0x80469a
  80097f:	e8 0d 03 00 00       	call   800c91 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80098d:	e8 80 39 00 00       	call   804312 <semaphore_count>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	83 f8 01             	cmp    $0x1,%eax
  800998:	74 19                	je     8009b3 <_main+0x97b>
  80099a:	68 68 47 80 00       	push   $0x804768
  80099f:	68 50 47 80 00       	push   $0x804750
  8009a4:	68 cf 00 00 00       	push   $0xcf
  8009a9:	68 9a 46 80 00       	push   $0x80469a
  8009ae:	e8 de 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8009bc:	e8 51 39 00 00       	call   804312 <semaphore_count>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	83 f8 01             	cmp    $0x1,%eax
  8009c7:	74 19                	je     8009e2 <_main+0x9aa>
  8009c9:	68 88 47 80 00       	push   $0x804788
  8009ce:	68 50 47 80 00       	push   $0x804750
  8009d3:	68 d1 00 00 00       	push   $0xd1
  8009d8:	68 9a 46 80 00       	push   $0x80469a
  8009dd:	e8 af 02 00 00       	call   800c91 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8009eb:	e8 22 39 00 00       	call   804312 <semaphore_count>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	83 f8 01             	cmp    $0x1,%eax
  8009f6:	74 19                	je     800a11 <_main+0x9d9>
  8009f8:	68 ac 47 80 00       	push   $0x8047ac
  8009fd:	68 50 47 80 00       	push   $0x804750
  800a02:	68 d2 00 00 00       	push   $0xd2
  800a07:	68 9a 46 80 00       	push   $0x80469a
  800a0c:	e8 80 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800a1a:	e8 f3 38 00 00       	call   804312 <semaphore_count>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	83 f8 03             	cmp    $0x3,%eax
  800a25:	74 19                	je     800a40 <_main+0xa08>
  800a27:	68 ce 47 80 00       	push   $0x8047ce
  800a2c:	68 50 47 80 00       	push   $0x804750
  800a31:	68 d4 00 00 00       	push   $0xd4
  800a36:	68 9a 46 80 00       	push   $0x80469a
  800a3b:	e8 51 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800a40:	83 ec 0c             	sub    $0xc,%esp
  800a43:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800a49:	e8 c4 38 00 00       	call   804312 <semaphore_count>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800a54:	74 19                	je     800a6f <_main+0xa37>
  800a56:	68 ec 47 80 00       	push   $0x8047ec
  800a5b:	68 50 47 80 00       	push   $0x804750
  800a60:	68 d6 00 00 00       	push   $0xd6
  800a65:	68 9a 46 80 00       	push   $0x80469a
  800a6a:	e8 22 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800a78:	e8 95 38 00 00       	call   804312 <semaphore_count>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	85 c0                	test   %eax,%eax
  800a82:	74 19                	je     800a9d <_main+0xa65>
  800a84:	68 10 48 80 00       	push   $0x804810
  800a89:	68 50 47 80 00       	push   $0x804750
  800a8e:	68 d8 00 00 00       	push   $0xd8
  800a93:	68 9a 46 80 00       	push   $0x80469a
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
  800ac4:	e8 49 38 00 00       	call   804312 <semaphore_count>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	85 c0                	test   %eax,%eax
  800ace:	74 19                	je     800ae9 <_main+0xab1>
  800ad0:	68 38 48 80 00       	push   $0x804838
  800ad5:	68 50 47 80 00       	push   $0x804750
  800ada:	68 e2 00 00 00       	push   $0xe2
  800adf:	68 9a 46 80 00       	push   $0x80469a
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
  800af7:	68 60 48 80 00       	push   $0x804860
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
  800b58:	e8 a7 19 00 00       	call   802504 <sys_getenvindex>
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
  800bc6:	e8 bd 16 00 00       	call   802288 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800bcb:	83 ec 0c             	sub    $0xc,%esp
  800bce:	68 e4 49 80 00       	push   $0x8049e4
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
  800bf6:	68 0c 4a 80 00       	push   $0x804a0c
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
  800c27:	68 34 4a 80 00       	push   $0x804a34
  800c2c:	e8 1d 03 00 00       	call   800f4e <cprintf>
  800c31:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c34:	a1 20 60 80 00       	mov    0x806020,%eax
  800c39:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	50                   	push   %eax
  800c43:	68 8c 4a 80 00       	push   $0x804a8c
  800c48:	e8 01 03 00 00       	call   800f4e <cprintf>
  800c4d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800c50:	83 ec 0c             	sub    $0xc,%esp
  800c53:	68 e4 49 80 00       	push   $0x8049e4
  800c58:	e8 f1 02 00 00       	call   800f4e <cprintf>
  800c5d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800c60:	e8 3d 16 00 00       	call   8022a2 <sys_unlock_cons>
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
  800c78:	e8 53 18 00 00       	call   8024d0 <sys_destroy_env>
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
  800c89:	e8 a8 18 00 00       	call   802536 <sys_exit_env>
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
  800ca0:	a1 4c 60 80 00       	mov    0x80604c,%eax
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	74 16                	je     800cbf <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ca9:	a1 4c 60 80 00       	mov    0x80604c,%eax
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	50                   	push   %eax
  800cb2:	68 a0 4a 80 00       	push   $0x804aa0
  800cb7:	e8 92 02 00 00       	call   800f4e <cprintf>
  800cbc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cbf:	a1 00 60 80 00       	mov    0x806000,%eax
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	ff 75 08             	pushl  0x8(%ebp)
  800cca:	50                   	push   %eax
  800ccb:	68 a5 4a 80 00       	push   $0x804aa5
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
  800cef:	68 c1 4a 80 00       	push   $0x804ac1
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
  800d1e:	68 c4 4a 80 00       	push   $0x804ac4
  800d23:	6a 26                	push   $0x26
  800d25:	68 10 4b 80 00       	push   $0x804b10
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
  800df3:	68 1c 4b 80 00       	push   $0x804b1c
  800df8:	6a 3a                	push   $0x3a
  800dfa:	68 10 4b 80 00       	push   $0x804b10
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
  800e66:	68 70 4b 80 00       	push   $0x804b70
  800e6b:	6a 44                	push   $0x44
  800e6d:	68 10 4b 80 00       	push   $0x804b10
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
  800ea5:	a0 28 60 80 00       	mov    0x806028,%al
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
  800ec0:	e8 81 13 00 00       	call   802246 <sys_cputs>
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
  800f1a:	a0 28 60 80 00       	mov    0x806028,%al
  800f1f:	0f b6 c0             	movzbl %al,%eax
  800f22:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f28:	83 ec 04             	sub    $0x4,%esp
  800f2b:	50                   	push   %eax
  800f2c:	52                   	push   %edx
  800f2d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f33:	83 c0 08             	add    $0x8,%eax
  800f36:	50                   	push   %eax
  800f37:	e8 0a 13 00 00       	call   802246 <sys_cputs>
  800f3c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f3f:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
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
  800f54:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
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
  800f81:	e8 02 13 00 00       	call   802288 <sys_lock_cons>
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
  800fa1:	e8 fc 12 00 00       	call   8022a2 <sys_unlock_cons>
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
  800feb:	e8 e4 33 00 00       	call   8043d4 <__udivdi3>
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
  80103b:	e8 a4 34 00 00       	call   8044e4 <__umoddi3>
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	05 d4 4d 80 00       	add    $0x804dd4,%eax
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
  801196:	8b 04 85 f8 4d 80 00 	mov    0x804df8(,%eax,4),%eax
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
  801277:	8b 34 9d 40 4c 80 00 	mov    0x804c40(,%ebx,4),%esi
  80127e:	85 f6                	test   %esi,%esi
  801280:	75 19                	jne    80129b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801282:	53                   	push   %ebx
  801283:	68 e5 4d 80 00       	push   $0x804de5
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
  80129c:	68 ee 4d 80 00       	push   $0x804dee
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
  8012c9:	be f1 4d 80 00       	mov    $0x804df1,%esi
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
  8014c1:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
			break;
  8014c8:	eb 2c                	jmp    8014f6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8014ca:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
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
  801cd4:	68 68 4f 80 00       	push   $0x804f68
  801cd9:	68 3f 01 00 00       	push   $0x13f
  801cde:	68 8a 4f 80 00       	push   $0x804f8a
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
  801cf4:	e8 f8 0a 00 00       	call   8027f1 <sys_sbrk>
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
  801d6f:	e8 01 09 00 00       	call   802675 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d74:	85 c0                	test   %eax,%eax
  801d76:	74 16                	je     801d8e <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	ff 75 08             	pushl  0x8(%ebp)
  801d7e:	e8 41 0e 00 00       	call   802bc4 <alloc_block_FF>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d89:	e9 8a 01 00 00       	jmp    801f18 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d8e:	e8 13 09 00 00       	call   8026a6 <sys_isUHeapPlacementStrategyBESTFIT>
  801d93:	85 c0                	test   %eax,%eax
  801d95:	0f 84 7d 01 00 00    	je     801f18 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	e8 da 12 00 00       	call   803080 <alloc_block_BF>
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
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801dda:	a1 20 60 80 00       	mov    0x806020,%eax
  801ddf:	8b 40 78             	mov    0x78(%eax),%eax
  801de2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801de5:	29 c2                	sub    %eax,%edx
  801de7:	89 d0                	mov    %edx,%eax
  801de9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dee:	c1 e8 0c             	shr    $0xc,%eax
  801df1:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	0f 85 ab 00 00 00    	jne    801eab <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e03:	05 00 10 00 00       	add    $0x1000,%eax
  801e08:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801e0b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
  801e3e:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  801e45:	85 c0                	test   %eax,%eax
  801e47:	74 08                	je     801e51 <malloc+0x153>
					{
						
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
  801e95:	c7 04 85 60 60 88 00 	movl   $0x1,0x886060(,%eax,4)
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
				

			}
			sayed:
			if(ok) break;
  801eab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801eaf:	75 16                	jne    801ec7 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801eb1:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801eb8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801ebf:	0f 86 15 ff ff ff    	jbe    801dda <malloc+0xdc>
  801ec5:	eb 01                	jmp    801ec8 <malloc+0x1ca>
				}
				

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
  801ef7:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801efe:	83 ec 08             	sub    $0x8,%esp
  801f01:	ff 75 08             	pushl  0x8(%ebp)
  801f04:	ff 75 f0             	pushl  -0x10(%ebp)
  801f07:	e8 1c 09 00 00       	call   802828 <sys_allocate_user_mem>
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	eb 07                	jmp    801f18 <malloc+0x21a>
		
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
  801f4f:	e8 f0 08 00 00       	call   802844 <get_block_size>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	ff 75 08             	pushl  0x8(%ebp)
  801f60:	e8 00 1b 00 00       	call   803a65 <free_block>
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
  801f9a:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
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
  801fd7:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
  801fde:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801fe2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	83 ec 08             	sub    $0x8,%esp
  801feb:	52                   	push   %edx
  801fec:	50                   	push   %eax
  801fed:	e8 1a 08 00 00       	call   80280c <sys_free_user_mem>
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
  802005:	68 98 4f 80 00       	push   $0x804f98
  80200a:	68 87 00 00 00       	push   $0x87
  80200f:	68 c2 4f 80 00       	push   $0x804fc2
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
  802033:	e9 87 00 00 00       	jmp    8020bf <smalloc+0xa3>
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
  802064:	75 07                	jne    80206d <smalloc+0x51>
  802066:	b8 00 00 00 00       	mov    $0x0,%eax
  80206b:	eb 52                	jmp    8020bf <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80206d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802071:	ff 75 ec             	pushl  -0x14(%ebp)
  802074:	50                   	push   %eax
  802075:	ff 75 0c             	pushl  0xc(%ebp)
  802078:	ff 75 08             	pushl  0x8(%ebp)
  80207b:	e8 93 03 00 00       	call   802413 <sys_createSharedObject>
  802080:	83 c4 10             	add    $0x10,%esp
  802083:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802086:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80208a:	74 06                	je     802092 <smalloc+0x76>
  80208c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802090:	75 07                	jne    802099 <smalloc+0x7d>
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
  802097:	eb 26                	jmp    8020bf <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  802099:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80209c:	a1 20 60 80 00       	mov    0x806020,%eax
  8020a1:	8b 40 78             	mov    0x78(%eax),%eax
  8020a4:	29 c2                	sub    %eax,%edx
  8020a6:	89 d0                	mov    %edx,%eax
  8020a8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8020ad:	c1 e8 0c             	shr    $0xc,%eax
  8020b0:	89 c2                	mov    %eax,%edx
  8020b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b5:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  8020bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020c7:	83 ec 08             	sub    $0x8,%esp
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	ff 75 08             	pushl  0x8(%ebp)
  8020d0:	e8 68 03 00 00       	call   80243d <sys_getSizeOfSharedObject>
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8020db:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8020df:	75 07                	jne    8020e8 <sget+0x27>
  8020e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e6:	eb 7f                	jmp    802167 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020ee:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fb:	39 d0                	cmp    %edx,%eax
  8020fd:	73 02                	jae    802101 <sget+0x40>
  8020ff:	89 d0                	mov    %edx,%eax
  802101:	83 ec 0c             	sub    $0xc,%esp
  802104:	50                   	push   %eax
  802105:	e8 f4 fb ff ff       	call   801cfe <malloc>
  80210a:	83 c4 10             	add    $0x10,%esp
  80210d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802110:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802114:	75 07                	jne    80211d <sget+0x5c>
  802116:	b8 00 00 00 00       	mov    $0x0,%eax
  80211b:	eb 4a                	jmp    802167 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80211d:	83 ec 04             	sub    $0x4,%esp
  802120:	ff 75 e8             	pushl  -0x18(%ebp)
  802123:	ff 75 0c             	pushl  0xc(%ebp)
  802126:	ff 75 08             	pushl  0x8(%ebp)
  802129:	e8 2c 03 00 00       	call   80245a <sys_getSharedObject>
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  802134:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802137:	a1 20 60 80 00       	mov    0x806020,%eax
  80213c:	8b 40 78             	mov    0x78(%eax),%eax
  80213f:	29 c2                	sub    %eax,%edx
  802141:	89 d0                	mov    %edx,%eax
  802143:	2d 00 10 00 00       	sub    $0x1000,%eax
  802148:	c1 e8 0c             	shr    $0xc,%eax
  80214b:	89 c2                	mov    %eax,%edx
  80214d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802150:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802157:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80215b:	75 07                	jne    802164 <sget+0xa3>
  80215d:	b8 00 00 00 00       	mov    $0x0,%eax
  802162:	eb 03                	jmp    802167 <sget+0xa6>
	return ptr;
  802164:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80216f:	8b 55 08             	mov    0x8(%ebp),%edx
  802172:	a1 20 60 80 00       	mov    0x806020,%eax
  802177:	8b 40 78             	mov    0x78(%eax),%eax
  80217a:	29 c2                	sub    %eax,%edx
  80217c:	89 d0                	mov    %edx,%eax
  80217e:	2d 00 10 00 00       	sub    $0x1000,%eax
  802183:	c1 e8 0c             	shr    $0xc,%eax
  802186:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80218d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802190:	83 ec 08             	sub    $0x8,%esp
  802193:	ff 75 08             	pushl  0x8(%ebp)
  802196:	ff 75 f4             	pushl  -0xc(%ebp)
  802199:	e8 db 02 00 00       	call   802479 <sys_freeSharedObject>
  80219e:	83 c4 10             	add    $0x10,%esp
  8021a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8021a4:	90                   	nop
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8021ad:	83 ec 04             	sub    $0x4,%esp
  8021b0:	68 d0 4f 80 00       	push   $0x804fd0
  8021b5:	68 e4 00 00 00       	push   $0xe4
  8021ba:	68 c2 4f 80 00       	push   $0x804fc2
  8021bf:	e8 cd ea ff ff       	call   800c91 <_panic>

008021c4 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021ca:	83 ec 04             	sub    $0x4,%esp
  8021cd:	68 f6 4f 80 00       	push   $0x804ff6
  8021d2:	68 f0 00 00 00       	push   $0xf0
  8021d7:	68 c2 4f 80 00       	push   $0x804fc2
  8021dc:	e8 b0 ea ff ff       	call   800c91 <_panic>

008021e1 <shrink>:

}
void shrink(uint32 newSize)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021e7:	83 ec 04             	sub    $0x4,%esp
  8021ea:	68 f6 4f 80 00       	push   $0x804ff6
  8021ef:	68 f5 00 00 00       	push   $0xf5
  8021f4:	68 c2 4f 80 00       	push   $0x804fc2
  8021f9:	e8 93 ea ff ff       	call   800c91 <_panic>

008021fe <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802204:	83 ec 04             	sub    $0x4,%esp
  802207:	68 f6 4f 80 00       	push   $0x804ff6
  80220c:	68 fa 00 00 00       	push   $0xfa
  802211:	68 c2 4f 80 00       	push   $0x804fc2
  802216:	e8 76 ea ff ff       	call   800c91 <_panic>

0080221b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	57                   	push   %edi
  80221f:	56                   	push   %esi
  802220:	53                   	push   %ebx
  802221:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80222d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802230:	8b 7d 18             	mov    0x18(%ebp),%edi
  802233:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802236:	cd 30                	int    $0x30
  802238:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80223b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80223e:	83 c4 10             	add    $0x10,%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5f                   	pop    %edi
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    

00802246 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 04             	sub    $0x4,%esp
  80224c:	8b 45 10             	mov    0x10(%ebp),%eax
  80224f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802252:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	52                   	push   %edx
  80225e:	ff 75 0c             	pushl  0xc(%ebp)
  802261:	50                   	push   %eax
  802262:	6a 00                	push   $0x0
  802264:	e8 b2 ff ff ff       	call   80221b <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	90                   	nop
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <sys_cgetc>:

int
sys_cgetc(void)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 02                	push   $0x2
  80227e:	e8 98 ff ff ff       	call   80221b <syscall>
  802283:	83 c4 18             	add    $0x18,%esp
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 03                	push   $0x3
  802297:	e8 7f ff ff ff       	call   80221b <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	90                   	nop
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 04                	push   $0x4
  8022b1:	e8 65 ff ff ff       	call   80221b <syscall>
  8022b6:	83 c4 18             	add    $0x18,%esp
}
  8022b9:	90                   	nop
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	52                   	push   %edx
  8022cc:	50                   	push   %eax
  8022cd:	6a 08                	push   $0x8
  8022cf:	e8 47 ff ff ff       	call   80221b <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	56                   	push   %esi
  8022dd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022de:	8b 75 18             	mov    0x18(%ebp),%esi
  8022e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	56                   	push   %esi
  8022ee:	53                   	push   %ebx
  8022ef:	51                   	push   %ecx
  8022f0:	52                   	push   %edx
  8022f1:	50                   	push   %eax
  8022f2:	6a 09                	push   $0x9
  8022f4:	e8 22 ff ff ff       	call   80221b <syscall>
  8022f9:	83 c4 18             	add    $0x18,%esp
}
  8022fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ff:	5b                   	pop    %ebx
  802300:	5e                   	pop    %esi
  802301:	5d                   	pop    %ebp
  802302:	c3                   	ret    

00802303 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802306:	8b 55 0c             	mov    0xc(%ebp),%edx
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	52                   	push   %edx
  802313:	50                   	push   %eax
  802314:	6a 0a                	push   $0xa
  802316:	e8 00 ff ff ff       	call   80221b <syscall>
  80231b:	83 c4 18             	add    $0x18,%esp
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	ff 75 0c             	pushl  0xc(%ebp)
  80232c:	ff 75 08             	pushl  0x8(%ebp)
  80232f:	6a 0b                	push   $0xb
  802331:	e8 e5 fe ff ff       	call   80221b <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 0c                	push   $0xc
  80234a:	e8 cc fe ff ff       	call   80221b <syscall>
  80234f:	83 c4 18             	add    $0x18,%esp
}
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 0d                	push   $0xd
  802363:	e8 b3 fe ff ff       	call   80221b <syscall>
  802368:	83 c4 18             	add    $0x18,%esp
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 0e                	push   $0xe
  80237c:	e8 9a fe ff ff       	call   80221b <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 0f                	push   $0xf
  802395:	e8 81 fe ff ff       	call   80221b <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	ff 75 08             	pushl  0x8(%ebp)
  8023ad:	6a 10                	push   $0x10
  8023af:	e8 67 fe ff ff       	call   80221b <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 11                	push   $0x11
  8023c8:	e8 4e fe ff ff       	call   80221b <syscall>
  8023cd:	83 c4 18             	add    $0x18,%esp
}
  8023d0:	90                   	nop
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	83 ec 04             	sub    $0x4,%esp
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	50                   	push   %eax
  8023ec:	6a 01                	push   $0x1
  8023ee:	e8 28 fe ff ff       	call   80221b <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
}
  8023f6:	90                   	nop
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 14                	push   $0x14
  802408:	e8 0e fe ff ff       	call   80221b <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
}
  802410:	90                   	nop
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	83 ec 04             	sub    $0x4,%esp
  802419:	8b 45 10             	mov    0x10(%ebp),%eax
  80241c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80241f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802422:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	6a 00                	push   $0x0
  80242b:	51                   	push   %ecx
  80242c:	52                   	push   %edx
  80242d:	ff 75 0c             	pushl  0xc(%ebp)
  802430:	50                   	push   %eax
  802431:	6a 15                	push   $0x15
  802433:	e8 e3 fd ff ff       	call   80221b <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
}
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802440:	8b 55 0c             	mov    0xc(%ebp),%edx
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	52                   	push   %edx
  80244d:	50                   	push   %eax
  80244e:	6a 16                	push   $0x16
  802450:	e8 c6 fd ff ff       	call   80221b <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80245d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802460:	8b 55 0c             	mov    0xc(%ebp),%edx
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	51                   	push   %ecx
  80246b:	52                   	push   %edx
  80246c:	50                   	push   %eax
  80246d:	6a 17                	push   $0x17
  80246f:	e8 a7 fd ff ff       	call   80221b <syscall>
  802474:	83 c4 18             	add    $0x18,%esp
}
  802477:	c9                   	leave  
  802478:	c3                   	ret    

00802479 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80247c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	52                   	push   %edx
  802489:	50                   	push   %eax
  80248a:	6a 18                	push   $0x18
  80248c:	e8 8a fd ff ff       	call   80221b <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	6a 00                	push   $0x0
  80249e:	ff 75 14             	pushl  0x14(%ebp)
  8024a1:	ff 75 10             	pushl  0x10(%ebp)
  8024a4:	ff 75 0c             	pushl  0xc(%ebp)
  8024a7:	50                   	push   %eax
  8024a8:	6a 19                	push   $0x19
  8024aa:	e8 6c fd ff ff       	call   80221b <syscall>
  8024af:	83 c4 18             	add    $0x18,%esp
}
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	50                   	push   %eax
  8024c3:	6a 1a                	push   $0x1a
  8024c5:	e8 51 fd ff ff       	call   80221b <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
}
  8024cd:	90                   	nop
  8024ce:	c9                   	leave  
  8024cf:	c3                   	ret    

008024d0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	50                   	push   %eax
  8024df:	6a 1b                	push   $0x1b
  8024e1:	e8 35 fd ff ff       	call   80221b <syscall>
  8024e6:	83 c4 18             	add    $0x18,%esp
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 05                	push   $0x5
  8024fa:	e8 1c fd ff ff       	call   80221b <syscall>
  8024ff:	83 c4 18             	add    $0x18,%esp
}
  802502:	c9                   	leave  
  802503:	c3                   	ret    

00802504 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 06                	push   $0x6
  802513:	e8 03 fd ff ff       	call   80221b <syscall>
  802518:	83 c4 18             	add    $0x18,%esp
}
  80251b:	c9                   	leave  
  80251c:	c3                   	ret    

0080251d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80251d:	55                   	push   %ebp
  80251e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 07                	push   $0x7
  80252c:	e8 ea fc ff ff       	call   80221b <syscall>
  802531:	83 c4 18             	add    $0x18,%esp
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <sys_exit_env>:


void sys_exit_env(void)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 1c                	push   $0x1c
  802545:	e8 d1 fc ff ff       	call   80221b <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
}
  80254d:	90                   	nop
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802556:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802559:	8d 50 04             	lea    0x4(%eax),%edx
  80255c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	52                   	push   %edx
  802566:	50                   	push   %eax
  802567:	6a 1d                	push   $0x1d
  802569:	e8 ad fc ff ff       	call   80221b <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
	return result;
  802571:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802574:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802577:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80257a:	89 01                	mov    %eax,(%ecx)
  80257c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	c9                   	leave  
  802583:	c2 04 00             	ret    $0x4

00802586 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	ff 75 10             	pushl  0x10(%ebp)
  802590:	ff 75 0c             	pushl  0xc(%ebp)
  802593:	ff 75 08             	pushl  0x8(%ebp)
  802596:	6a 13                	push   $0x13
  802598:	e8 7e fc ff ff       	call   80221b <syscall>
  80259d:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a0:	90                   	nop
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 1e                	push   $0x1e
  8025b2:	e8 64 fc ff ff       	call   80221b <syscall>
  8025b7:	83 c4 18             	add    $0x18,%esp
}
  8025ba:	c9                   	leave  
  8025bb:	c3                   	ret    

008025bc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8025bc:	55                   	push   %ebp
  8025bd:	89 e5                	mov    %esp,%ebp
  8025bf:	83 ec 04             	sub    $0x4,%esp
  8025c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025c8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	50                   	push   %eax
  8025d5:	6a 1f                	push   $0x1f
  8025d7:	e8 3f fc ff ff       	call   80221b <syscall>
  8025dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8025df:	90                   	nop
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <rsttst>:
void rsttst()
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 21                	push   $0x21
  8025f1:	e8 25 fc ff ff       	call   80221b <syscall>
  8025f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8025f9:	90                   	nop
}
  8025fa:	c9                   	leave  
  8025fb:	c3                   	ret    

008025fc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	83 ec 04             	sub    $0x4,%esp
  802602:	8b 45 14             	mov    0x14(%ebp),%eax
  802605:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802608:	8b 55 18             	mov    0x18(%ebp),%edx
  80260b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80260f:	52                   	push   %edx
  802610:	50                   	push   %eax
  802611:	ff 75 10             	pushl  0x10(%ebp)
  802614:	ff 75 0c             	pushl  0xc(%ebp)
  802617:	ff 75 08             	pushl  0x8(%ebp)
  80261a:	6a 20                	push   $0x20
  80261c:	e8 fa fb ff ff       	call   80221b <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
	return ;
  802624:	90                   	nop
}
  802625:	c9                   	leave  
  802626:	c3                   	ret    

00802627 <chktst>:
void chktst(uint32 n)
{
  802627:	55                   	push   %ebp
  802628:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	ff 75 08             	pushl  0x8(%ebp)
  802635:	6a 22                	push   $0x22
  802637:	e8 df fb ff ff       	call   80221b <syscall>
  80263c:	83 c4 18             	add    $0x18,%esp
	return ;
  80263f:	90                   	nop
}
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <inctst>:

void inctst()
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	6a 23                	push   $0x23
  802651:	e8 c5 fb ff ff       	call   80221b <syscall>
  802656:	83 c4 18             	add    $0x18,%esp
	return ;
  802659:	90                   	nop
}
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    

0080265c <gettst>:
uint32 gettst()
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 24                	push   $0x24
  80266b:	e8 ab fb ff ff       	call   80221b <syscall>
  802670:	83 c4 18             	add    $0x18,%esp
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 25                	push   $0x25
  802687:	e8 8f fb ff ff       	call   80221b <syscall>
  80268c:	83 c4 18             	add    $0x18,%esp
  80268f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802692:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802696:	75 07                	jne    80269f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802698:	b8 01 00 00 00       	mov    $0x1,%eax
  80269d:	eb 05                	jmp    8026a4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 25                	push   $0x25
  8026b8:	e8 5e fb ff ff       	call   80221b <syscall>
  8026bd:	83 c4 18             	add    $0x18,%esp
  8026c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026c3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026c7:	75 07                	jne    8026d0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ce:	eb 05                	jmp    8026d5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
  8026da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 25                	push   $0x25
  8026e9:	e8 2d fb ff ff       	call   80221b <syscall>
  8026ee:	83 c4 18             	add    $0x18,%esp
  8026f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026f4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026f8:	75 07                	jne    802701 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ff:	eb 05                	jmp    802706 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 25                	push   $0x25
  80271a:	e8 fc fa ff ff       	call   80221b <syscall>
  80271f:	83 c4 18             	add    $0x18,%esp
  802722:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802725:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802729:	75 07                	jne    802732 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80272b:	b8 01 00 00 00       	mov    $0x1,%eax
  802730:	eb 05                	jmp    802737 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802732:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802737:	c9                   	leave  
  802738:	c3                   	ret    

00802739 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	ff 75 08             	pushl  0x8(%ebp)
  802747:	6a 26                	push   $0x26
  802749:	e8 cd fa ff ff       	call   80221b <syscall>
  80274e:	83 c4 18             	add    $0x18,%esp
	return ;
  802751:	90                   	nop
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802758:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80275b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80275e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	6a 00                	push   $0x0
  802766:	53                   	push   %ebx
  802767:	51                   	push   %ecx
  802768:	52                   	push   %edx
  802769:	50                   	push   %eax
  80276a:	6a 27                	push   $0x27
  80276c:	e8 aa fa ff ff       	call   80221b <syscall>
  802771:	83 c4 18             	add    $0x18,%esp
}
  802774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802777:	c9                   	leave  
  802778:	c3                   	ret    

00802779 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80277c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	52                   	push   %edx
  802789:	50                   	push   %eax
  80278a:	6a 28                	push   $0x28
  80278c:	e8 8a fa ff ff       	call   80221b <syscall>
  802791:	83 c4 18             	add    $0x18,%esp
}
  802794:	c9                   	leave  
  802795:	c3                   	ret    

00802796 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802799:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80279c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	6a 00                	push   $0x0
  8027a4:	51                   	push   %ecx
  8027a5:	ff 75 10             	pushl  0x10(%ebp)
  8027a8:	52                   	push   %edx
  8027a9:	50                   	push   %eax
  8027aa:	6a 29                	push   $0x29
  8027ac:	e8 6a fa ff ff       	call   80221b <syscall>
  8027b1:	83 c4 18             	add    $0x18,%esp
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	ff 75 10             	pushl  0x10(%ebp)
  8027c0:	ff 75 0c             	pushl  0xc(%ebp)
  8027c3:	ff 75 08             	pushl  0x8(%ebp)
  8027c6:	6a 12                	push   $0x12
  8027c8:	e8 4e fa ff ff       	call   80221b <syscall>
  8027cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d0:	90                   	nop
}
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    

008027d3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8027d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	52                   	push   %edx
  8027e3:	50                   	push   %eax
  8027e4:	6a 2a                	push   $0x2a
  8027e6:	e8 30 fa ff ff       	call   80221b <syscall>
  8027eb:	83 c4 18             	add    $0x18,%esp
	return;
  8027ee:	90                   	nop
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	50                   	push   %eax
  802800:	6a 2b                	push   $0x2b
  802802:	e8 14 fa ff ff       	call   80221b <syscall>
  802807:	83 c4 18             	add    $0x18,%esp
}
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	ff 75 0c             	pushl  0xc(%ebp)
  802818:	ff 75 08             	pushl  0x8(%ebp)
  80281b:	6a 2c                	push   $0x2c
  80281d:	e8 f9 f9 ff ff       	call   80221b <syscall>
  802822:	83 c4 18             	add    $0x18,%esp
	return;
  802825:	90                   	nop
}
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	ff 75 0c             	pushl  0xc(%ebp)
  802834:	ff 75 08             	pushl  0x8(%ebp)
  802837:	6a 2d                	push   $0x2d
  802839:	e8 dd f9 ff ff       	call   80221b <syscall>
  80283e:	83 c4 18             	add    $0x18,%esp
	return;
  802841:	90                   	nop
}
  802842:	c9                   	leave  
  802843:	c3                   	ret    

00802844 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802844:	55                   	push   %ebp
  802845:	89 e5                	mov    %esp,%ebp
  802847:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	83 e8 04             	sub    $0x4,%eax
  802850:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802853:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80285b:	c9                   	leave  
  80285c:	c3                   	ret    

0080285d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	83 e8 04             	sub    $0x4,%eax
  802869:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80286c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80286f:	8b 00                	mov    (%eax),%eax
  802871:	83 e0 01             	and    $0x1,%eax
  802874:	85 c0                	test   %eax,%eax
  802876:	0f 94 c0             	sete   %al
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
  80287e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802881:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80288b:	83 f8 02             	cmp    $0x2,%eax
  80288e:	74 2b                	je     8028bb <alloc_block+0x40>
  802890:	83 f8 02             	cmp    $0x2,%eax
  802893:	7f 07                	jg     80289c <alloc_block+0x21>
  802895:	83 f8 01             	cmp    $0x1,%eax
  802898:	74 0e                	je     8028a8 <alloc_block+0x2d>
  80289a:	eb 58                	jmp    8028f4 <alloc_block+0x79>
  80289c:	83 f8 03             	cmp    $0x3,%eax
  80289f:	74 2d                	je     8028ce <alloc_block+0x53>
  8028a1:	83 f8 04             	cmp    $0x4,%eax
  8028a4:	74 3b                	je     8028e1 <alloc_block+0x66>
  8028a6:	eb 4c                	jmp    8028f4 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8028a8:	83 ec 0c             	sub    $0xc,%esp
  8028ab:	ff 75 08             	pushl  0x8(%ebp)
  8028ae:	e8 11 03 00 00       	call   802bc4 <alloc_block_FF>
  8028b3:	83 c4 10             	add    $0x10,%esp
  8028b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028b9:	eb 4a                	jmp    802905 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8028bb:	83 ec 0c             	sub    $0xc,%esp
  8028be:	ff 75 08             	pushl  0x8(%ebp)
  8028c1:	e8 c7 19 00 00       	call   80428d <alloc_block_NF>
  8028c6:	83 c4 10             	add    $0x10,%esp
  8028c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028cc:	eb 37                	jmp    802905 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8028ce:	83 ec 0c             	sub    $0xc,%esp
  8028d1:	ff 75 08             	pushl  0x8(%ebp)
  8028d4:	e8 a7 07 00 00       	call   803080 <alloc_block_BF>
  8028d9:	83 c4 10             	add    $0x10,%esp
  8028dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028df:	eb 24                	jmp    802905 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8028e1:	83 ec 0c             	sub    $0xc,%esp
  8028e4:	ff 75 08             	pushl  0x8(%ebp)
  8028e7:	e8 84 19 00 00       	call   804270 <alloc_block_WF>
  8028ec:	83 c4 10             	add    $0x10,%esp
  8028ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028f2:	eb 11                	jmp    802905 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8028f4:	83 ec 0c             	sub    $0xc,%esp
  8028f7:	68 08 50 80 00       	push   $0x805008
  8028fc:	e8 4d e6 ff ff       	call   800f4e <cprintf>
  802901:	83 c4 10             	add    $0x10,%esp
		break;
  802904:	90                   	nop
	}
	return va;
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	53                   	push   %ebx
  80290e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802911:	83 ec 0c             	sub    $0xc,%esp
  802914:	68 28 50 80 00       	push   $0x805028
  802919:	e8 30 e6 ff ff       	call   800f4e <cprintf>
  80291e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802921:	83 ec 0c             	sub    $0xc,%esp
  802924:	68 53 50 80 00       	push   $0x805053
  802929:	e8 20 e6 ff ff       	call   800f4e <cprintf>
  80292e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802937:	eb 37                	jmp    802970 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802939:	83 ec 0c             	sub    $0xc,%esp
  80293c:	ff 75 f4             	pushl  -0xc(%ebp)
  80293f:	e8 19 ff ff ff       	call   80285d <is_free_block>
  802944:	83 c4 10             	add    $0x10,%esp
  802947:	0f be d8             	movsbl %al,%ebx
  80294a:	83 ec 0c             	sub    $0xc,%esp
  80294d:	ff 75 f4             	pushl  -0xc(%ebp)
  802950:	e8 ef fe ff ff       	call   802844 <get_block_size>
  802955:	83 c4 10             	add    $0x10,%esp
  802958:	83 ec 04             	sub    $0x4,%esp
  80295b:	53                   	push   %ebx
  80295c:	50                   	push   %eax
  80295d:	68 6b 50 80 00       	push   $0x80506b
  802962:	e8 e7 e5 ff ff       	call   800f4e <cprintf>
  802967:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80296a:	8b 45 10             	mov    0x10(%ebp),%eax
  80296d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802974:	74 07                	je     80297d <print_blocks_list+0x73>
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	8b 00                	mov    (%eax),%eax
  80297b:	eb 05                	jmp    802982 <print_blocks_list+0x78>
  80297d:	b8 00 00 00 00       	mov    $0x0,%eax
  802982:	89 45 10             	mov    %eax,0x10(%ebp)
  802985:	8b 45 10             	mov    0x10(%ebp),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	75 ad                	jne    802939 <print_blocks_list+0x2f>
  80298c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802990:	75 a7                	jne    802939 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802992:	83 ec 0c             	sub    $0xc,%esp
  802995:	68 28 50 80 00       	push   $0x805028
  80299a:	e8 af e5 ff ff       	call   800f4e <cprintf>
  80299f:	83 c4 10             	add    $0x10,%esp

}
  8029a2:	90                   	nop
  8029a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029a6:	c9                   	leave  
  8029a7:	c3                   	ret    

008029a8 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
  8029ab:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8029ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b1:	83 e0 01             	and    $0x1,%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	74 03                	je     8029bb <initialize_dynamic_allocator+0x13>
  8029b8:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8029bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8029bf:	0f 84 c7 01 00 00    	je     802b8c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8029c5:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8029cc:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8029cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d5:	01 d0                	add    %edx,%eax
  8029d7:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8029dc:	0f 87 ad 01 00 00    	ja     802b8f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	0f 89 a5 01 00 00    	jns    802b92 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8029ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f3:	01 d0                	add    %edx,%eax
  8029f5:	83 e8 04             	sub    $0x4,%eax
  8029f8:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  8029fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802a04:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0c:	e9 87 00 00 00       	jmp    802a98 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802a11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a15:	75 14                	jne    802a2b <initialize_dynamic_allocator+0x83>
  802a17:	83 ec 04             	sub    $0x4,%esp
  802a1a:	68 83 50 80 00       	push   $0x805083
  802a1f:	6a 79                	push   $0x79
  802a21:	68 a1 50 80 00       	push   $0x8050a1
  802a26:	e8 66 e2 ff ff       	call   800c91 <_panic>
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 00                	mov    (%eax),%eax
  802a30:	85 c0                	test   %eax,%eax
  802a32:	74 10                	je     802a44 <initialize_dynamic_allocator+0x9c>
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 00                	mov    (%eax),%eax
  802a39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3c:	8b 52 04             	mov    0x4(%edx),%edx
  802a3f:	89 50 04             	mov    %edx,0x4(%eax)
  802a42:	eb 0b                	jmp    802a4f <initialize_dynamic_allocator+0xa7>
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 40 04             	mov    0x4(%eax),%eax
  802a4a:	a3 30 60 80 00       	mov    %eax,0x806030
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	8b 40 04             	mov    0x4(%eax),%eax
  802a55:	85 c0                	test   %eax,%eax
  802a57:	74 0f                	je     802a68 <initialize_dynamic_allocator+0xc0>
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 40 04             	mov    0x4(%eax),%eax
  802a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a62:	8b 12                	mov    (%edx),%edx
  802a64:	89 10                	mov    %edx,(%eax)
  802a66:	eb 0a                	jmp    802a72 <initialize_dynamic_allocator+0xca>
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 00                	mov    (%eax),%eax
  802a6d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a85:	a1 38 60 80 00       	mov    0x806038,%eax
  802a8a:	48                   	dec    %eax
  802a8b:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802a90:	a1 34 60 80 00       	mov    0x806034,%eax
  802a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9c:	74 07                	je     802aa5 <initialize_dynamic_allocator+0xfd>
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	eb 05                	jmp    802aaa <initialize_dynamic_allocator+0x102>
  802aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aaa:	a3 34 60 80 00       	mov    %eax,0x806034
  802aaf:	a1 34 60 80 00       	mov    0x806034,%eax
  802ab4:	85 c0                	test   %eax,%eax
  802ab6:	0f 85 55 ff ff ff    	jne    802a11 <initialize_dynamic_allocator+0x69>
  802abc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac0:	0f 85 4b ff ff ff    	jne    802a11 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802ad5:	a1 44 60 80 00       	mov    0x806044,%eax
  802ada:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802adf:	a1 40 60 80 00       	mov    0x806040,%eax
  802ae4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	83 c0 08             	add    $0x8,%eax
  802af0:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	83 c0 04             	add    $0x4,%eax
  802af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802afc:	83 ea 08             	sub    $0x8,%edx
  802aff:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	01 d0                	add    %edx,%eax
  802b09:	83 e8 08             	sub    $0x8,%eax
  802b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b0f:	83 ea 08             	sub    $0x8,%edx
  802b12:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802b27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b2b:	75 17                	jne    802b44 <initialize_dynamic_allocator+0x19c>
  802b2d:	83 ec 04             	sub    $0x4,%esp
  802b30:	68 bc 50 80 00       	push   $0x8050bc
  802b35:	68 90 00 00 00       	push   $0x90
  802b3a:	68 a1 50 80 00       	push   $0x8050a1
  802b3f:	e8 4d e1 ff ff       	call   800c91 <_panic>
  802b44:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4d:	89 10                	mov    %edx,(%eax)
  802b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b52:	8b 00                	mov    (%eax),%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	74 0d                	je     802b65 <initialize_dynamic_allocator+0x1bd>
  802b58:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802b5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b60:	89 50 04             	mov    %edx,0x4(%eax)
  802b63:	eb 08                	jmp    802b6d <initialize_dynamic_allocator+0x1c5>
  802b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b68:	a3 30 60 80 00       	mov    %eax,0x806030
  802b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b70:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7f:	a1 38 60 80 00       	mov    0x806038,%eax
  802b84:	40                   	inc    %eax
  802b85:	a3 38 60 80 00       	mov    %eax,0x806038
  802b8a:	eb 07                	jmp    802b93 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802b8c:	90                   	nop
  802b8d:	eb 04                	jmp    802b93 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802b8f:	90                   	nop
  802b90:	eb 01                	jmp    802b93 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802b92:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802b93:	c9                   	leave  
  802b94:	c3                   	ret    

00802b95 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802b95:	55                   	push   %ebp
  802b96:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802b98:	8b 45 10             	mov    0x10(%ebp),%eax
  802b9b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba7:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	83 e8 04             	sub    $0x4,%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	83 e0 fe             	and    $0xfffffffe,%eax
  802bb4:	8d 50 f8             	lea    -0x8(%eax),%edx
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	01 c2                	add    %eax,%edx
  802bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bbf:	89 02                	mov    %eax,(%edx)
}
  802bc1:	90                   	nop
  802bc2:	5d                   	pop    %ebp
  802bc3:	c3                   	ret    

00802bc4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802bc4:	55                   	push   %ebp
  802bc5:	89 e5                	mov    %esp,%ebp
  802bc7:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	83 e0 01             	and    $0x1,%eax
  802bd0:	85 c0                	test   %eax,%eax
  802bd2:	74 03                	je     802bd7 <alloc_block_FF+0x13>
  802bd4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802bd7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802bdb:	77 07                	ja     802be4 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802bdd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802be4:	a1 24 60 80 00       	mov    0x806024,%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	75 73                	jne    802c60 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802bed:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf0:	83 c0 10             	add    $0x10,%eax
  802bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802bf6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802bfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c03:	01 d0                	add    %edx,%eax
  802c05:	48                   	dec    %eax
  802c06:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0c:	ba 00 00 00 00       	mov    $0x0,%edx
  802c11:	f7 75 ec             	divl   -0x14(%ebp)
  802c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c17:	29 d0                	sub    %edx,%eax
  802c19:	c1 e8 0c             	shr    $0xc,%eax
  802c1c:	83 ec 0c             	sub    $0xc,%esp
  802c1f:	50                   	push   %eax
  802c20:	e8 c3 f0 ff ff       	call   801ce8 <sbrk>
  802c25:	83 c4 10             	add    $0x10,%esp
  802c28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c2b:	83 ec 0c             	sub    $0xc,%esp
  802c2e:	6a 00                	push   $0x0
  802c30:	e8 b3 f0 ff ff       	call   801ce8 <sbrk>
  802c35:	83 c4 10             	add    $0x10,%esp
  802c38:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802c41:	83 ec 08             	sub    $0x8,%esp
  802c44:	50                   	push   %eax
  802c45:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c48:	e8 5b fd ff ff       	call   8029a8 <initialize_dynamic_allocator>
  802c4d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c50:	83 ec 0c             	sub    $0xc,%esp
  802c53:	68 df 50 80 00       	push   $0x8050df
  802c58:	e8 f1 e2 ff ff       	call   800f4e <cprintf>
  802c5d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802c60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c64:	75 0a                	jne    802c70 <alloc_block_FF+0xac>
	        return NULL;
  802c66:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6b:	e9 0e 04 00 00       	jmp    80307e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802c70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c77:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c7f:	e9 f3 02 00 00       	jmp    802f77 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802c8a:	83 ec 0c             	sub    $0xc,%esp
  802c8d:	ff 75 bc             	pushl  -0x44(%ebp)
  802c90:	e8 af fb ff ff       	call   802844 <get_block_size>
  802c95:	83 c4 10             	add    $0x10,%esp
  802c98:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	83 c0 08             	add    $0x8,%eax
  802ca1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ca4:	0f 87 c5 02 00 00    	ja     802f6f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	83 c0 18             	add    $0x18,%eax
  802cb0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802cb3:	0f 87 19 02 00 00    	ja     802ed2 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802cb9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cbc:	2b 45 08             	sub    0x8(%ebp),%eax
  802cbf:	83 e8 08             	sub    $0x8,%eax
  802cc2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	8d 50 08             	lea    0x8(%eax),%edx
  802ccb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cce:	01 d0                	add    %edx,%eax
  802cd0:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	83 c0 08             	add    $0x8,%eax
  802cd9:	83 ec 04             	sub    $0x4,%esp
  802cdc:	6a 01                	push   $0x1
  802cde:	50                   	push   %eax
  802cdf:	ff 75 bc             	pushl  -0x44(%ebp)
  802ce2:	e8 ae fe ff ff       	call   802b95 <set_block_data>
  802ce7:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 40 04             	mov    0x4(%eax),%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	75 68                	jne    802d5c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802cf4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802cf8:	75 17                	jne    802d11 <alloc_block_FF+0x14d>
  802cfa:	83 ec 04             	sub    $0x4,%esp
  802cfd:	68 bc 50 80 00       	push   $0x8050bc
  802d02:	68 d7 00 00 00       	push   $0xd7
  802d07:	68 a1 50 80 00       	push   $0x8050a1
  802d0c:	e8 80 df ff ff       	call   800c91 <_panic>
  802d11:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802d17:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d1a:	89 10                	mov    %edx,(%eax)
  802d1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	74 0d                	je     802d32 <alloc_block_FF+0x16e>
  802d25:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802d2a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d2d:	89 50 04             	mov    %edx,0x4(%eax)
  802d30:	eb 08                	jmp    802d3a <alloc_block_FF+0x176>
  802d32:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d35:	a3 30 60 80 00       	mov    %eax,0x806030
  802d3a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d3d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d42:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4c:	a1 38 60 80 00       	mov    0x806038,%eax
  802d51:	40                   	inc    %eax
  802d52:	a3 38 60 80 00       	mov    %eax,0x806038
  802d57:	e9 dc 00 00 00       	jmp    802e38 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 00                	mov    (%eax),%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	75 65                	jne    802dca <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d65:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d69:	75 17                	jne    802d82 <alloc_block_FF+0x1be>
  802d6b:	83 ec 04             	sub    $0x4,%esp
  802d6e:	68 f0 50 80 00       	push   $0x8050f0
  802d73:	68 db 00 00 00       	push   $0xdb
  802d78:	68 a1 50 80 00       	push   $0x8050a1
  802d7d:	e8 0f df ff ff       	call   800c91 <_panic>
  802d82:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802d88:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d8b:	89 50 04             	mov    %edx,0x4(%eax)
  802d8e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d91:	8b 40 04             	mov    0x4(%eax),%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	74 0c                	je     802da4 <alloc_block_FF+0x1e0>
  802d98:	a1 30 60 80 00       	mov    0x806030,%eax
  802d9d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	eb 08                	jmp    802dac <alloc_block_FF+0x1e8>
  802da4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802da7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802dac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802daf:	a3 30 60 80 00       	mov    %eax,0x806030
  802db4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802db7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dbd:	a1 38 60 80 00       	mov    0x806038,%eax
  802dc2:	40                   	inc    %eax
  802dc3:	a3 38 60 80 00       	mov    %eax,0x806038
  802dc8:	eb 6e                	jmp    802e38 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802dca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dce:	74 06                	je     802dd6 <alloc_block_FF+0x212>
  802dd0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802dd4:	75 17                	jne    802ded <alloc_block_FF+0x229>
  802dd6:	83 ec 04             	sub    $0x4,%esp
  802dd9:	68 14 51 80 00       	push   $0x805114
  802dde:	68 df 00 00 00       	push   $0xdf
  802de3:	68 a1 50 80 00       	push   $0x8050a1
  802de8:	e8 a4 de ff ff       	call   800c91 <_panic>
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 10                	mov    (%eax),%edx
  802df2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802df5:	89 10                	mov    %edx,(%eax)
  802df7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	74 0b                	je     802e0b <alloc_block_FF+0x247>
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e08:	89 50 04             	mov    %edx,0x4(%eax)
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e11:	89 10                	mov    %edx,(%eax)
  802e13:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e19:	89 50 04             	mov    %edx,0x4(%eax)
  802e1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e1f:	8b 00                	mov    (%eax),%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	75 08                	jne    802e2d <alloc_block_FF+0x269>
  802e25:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e28:	a3 30 60 80 00       	mov    %eax,0x806030
  802e2d:	a1 38 60 80 00       	mov    0x806038,%eax
  802e32:	40                   	inc    %eax
  802e33:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802e38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3c:	75 17                	jne    802e55 <alloc_block_FF+0x291>
  802e3e:	83 ec 04             	sub    $0x4,%esp
  802e41:	68 83 50 80 00       	push   $0x805083
  802e46:	68 e1 00 00 00       	push   $0xe1
  802e4b:	68 a1 50 80 00       	push   $0x8050a1
  802e50:	e8 3c de ff ff       	call   800c91 <_panic>
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	85 c0                	test   %eax,%eax
  802e5c:	74 10                	je     802e6e <alloc_block_FF+0x2aa>
  802e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e61:	8b 00                	mov    (%eax),%eax
  802e63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e66:	8b 52 04             	mov    0x4(%edx),%edx
  802e69:	89 50 04             	mov    %edx,0x4(%eax)
  802e6c:	eb 0b                	jmp    802e79 <alloc_block_FF+0x2b5>
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 40 04             	mov    0x4(%eax),%eax
  802e74:	a3 30 60 80 00       	mov    %eax,0x806030
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 40 04             	mov    0x4(%eax),%eax
  802e7f:	85 c0                	test   %eax,%eax
  802e81:	74 0f                	je     802e92 <alloc_block_FF+0x2ce>
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 40 04             	mov    0x4(%eax),%eax
  802e89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8c:	8b 12                	mov    (%edx),%edx
  802e8e:	89 10                	mov    %edx,(%eax)
  802e90:	eb 0a                	jmp    802e9c <alloc_block_FF+0x2d8>
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eaf:	a1 38 60 80 00       	mov    0x806038,%eax
  802eb4:	48                   	dec    %eax
  802eb5:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  802eba:	83 ec 04             	sub    $0x4,%esp
  802ebd:	6a 00                	push   $0x0
  802ebf:	ff 75 b4             	pushl  -0x4c(%ebp)
  802ec2:	ff 75 b0             	pushl  -0x50(%ebp)
  802ec5:	e8 cb fc ff ff       	call   802b95 <set_block_data>
  802eca:	83 c4 10             	add    $0x10,%esp
  802ecd:	e9 95 00 00 00       	jmp    802f67 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802ed2:	83 ec 04             	sub    $0x4,%esp
  802ed5:	6a 01                	push   $0x1
  802ed7:	ff 75 b8             	pushl  -0x48(%ebp)
  802eda:	ff 75 bc             	pushl  -0x44(%ebp)
  802edd:	e8 b3 fc ff ff       	call   802b95 <set_block_data>
  802ee2:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee9:	75 17                	jne    802f02 <alloc_block_FF+0x33e>
  802eeb:	83 ec 04             	sub    $0x4,%esp
  802eee:	68 83 50 80 00       	push   $0x805083
  802ef3:	68 e8 00 00 00       	push   $0xe8
  802ef8:	68 a1 50 80 00       	push   $0x8050a1
  802efd:	e8 8f dd ff ff       	call   800c91 <_panic>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 00                	mov    (%eax),%eax
  802f07:	85 c0                	test   %eax,%eax
  802f09:	74 10                	je     802f1b <alloc_block_FF+0x357>
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f13:	8b 52 04             	mov    0x4(%edx),%edx
  802f16:	89 50 04             	mov    %edx,0x4(%eax)
  802f19:	eb 0b                	jmp    802f26 <alloc_block_FF+0x362>
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 40 04             	mov    0x4(%eax),%eax
  802f21:	a3 30 60 80 00       	mov    %eax,0x806030
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 40 04             	mov    0x4(%eax),%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 0f                	je     802f3f <alloc_block_FF+0x37b>
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 40 04             	mov    0x4(%eax),%eax
  802f36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f39:	8b 12                	mov    (%edx),%edx
  802f3b:	89 10                	mov    %edx,(%eax)
  802f3d:	eb 0a                	jmp    802f49 <alloc_block_FF+0x385>
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 00                	mov    (%eax),%eax
  802f44:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5c:	a1 38 60 80 00       	mov    0x806038,%eax
  802f61:	48                   	dec    %eax
  802f62:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  802f67:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f6a:	e9 0f 01 00 00       	jmp    80307e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802f6f:	a1 34 60 80 00       	mov    0x806034,%eax
  802f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7b:	74 07                	je     802f84 <alloc_block_FF+0x3c0>
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	eb 05                	jmp    802f89 <alloc_block_FF+0x3c5>
  802f84:	b8 00 00 00 00       	mov    $0x0,%eax
  802f89:	a3 34 60 80 00       	mov    %eax,0x806034
  802f8e:	a1 34 60 80 00       	mov    0x806034,%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	0f 85 e9 fc ff ff    	jne    802c84 <alloc_block_FF+0xc0>
  802f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9f:	0f 85 df fc ff ff    	jne    802c84 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	83 c0 08             	add    $0x8,%eax
  802fab:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802fae:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802fb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802fbb:	01 d0                	add    %edx,%eax
  802fbd:	48                   	dec    %eax
  802fbe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802fc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fc4:	ba 00 00 00 00       	mov    $0x0,%edx
  802fc9:	f7 75 d8             	divl   -0x28(%ebp)
  802fcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fcf:	29 d0                	sub    %edx,%eax
  802fd1:	c1 e8 0c             	shr    $0xc,%eax
  802fd4:	83 ec 0c             	sub    $0xc,%esp
  802fd7:	50                   	push   %eax
  802fd8:	e8 0b ed ff ff       	call   801ce8 <sbrk>
  802fdd:	83 c4 10             	add    $0x10,%esp
  802fe0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802fe3:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802fe7:	75 0a                	jne    802ff3 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fee:	e9 8b 00 00 00       	jmp    80307e <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ff3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ffa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ffd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803000:	01 d0                	add    %edx,%eax
  803002:	48                   	dec    %eax
  803003:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803006:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803009:	ba 00 00 00 00       	mov    $0x0,%edx
  80300e:	f7 75 cc             	divl   -0x34(%ebp)
  803011:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803014:	29 d0                	sub    %edx,%eax
  803016:	8d 50 fc             	lea    -0x4(%eax),%edx
  803019:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80301c:	01 d0                	add    %edx,%eax
  80301e:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  803023:	a1 40 60 80 00       	mov    0x806040,%eax
  803028:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80302e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803035:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803038:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80303b:	01 d0                	add    %edx,%eax
  80303d:	48                   	dec    %eax
  80303e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803041:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803044:	ba 00 00 00 00       	mov    $0x0,%edx
  803049:	f7 75 c4             	divl   -0x3c(%ebp)
  80304c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80304f:	29 d0                	sub    %edx,%eax
  803051:	83 ec 04             	sub    $0x4,%esp
  803054:	6a 01                	push   $0x1
  803056:	50                   	push   %eax
  803057:	ff 75 d0             	pushl  -0x30(%ebp)
  80305a:	e8 36 fb ff ff       	call   802b95 <set_block_data>
  80305f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803062:	83 ec 0c             	sub    $0xc,%esp
  803065:	ff 75 d0             	pushl  -0x30(%ebp)
  803068:	e8 f8 09 00 00       	call   803a65 <free_block>
  80306d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803070:	83 ec 0c             	sub    $0xc,%esp
  803073:	ff 75 08             	pushl  0x8(%ebp)
  803076:	e8 49 fb ff ff       	call   802bc4 <alloc_block_FF>
  80307b:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80307e:	c9                   	leave  
  80307f:	c3                   	ret    

00803080 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803080:	55                   	push   %ebp
  803081:	89 e5                	mov    %esp,%ebp
  803083:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	83 e0 01             	and    $0x1,%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	74 03                	je     803093 <alloc_block_BF+0x13>
  803090:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803093:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803097:	77 07                	ja     8030a0 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803099:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8030a0:	a1 24 60 80 00       	mov    0x806024,%eax
  8030a5:	85 c0                	test   %eax,%eax
  8030a7:	75 73                	jne    80311c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	83 c0 10             	add    $0x10,%eax
  8030af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8030b2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8030b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030bf:	01 d0                	add    %edx,%eax
  8030c1:	48                   	dec    %eax
  8030c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8030c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8030cd:	f7 75 e0             	divl   -0x20(%ebp)
  8030d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d3:	29 d0                	sub    %edx,%eax
  8030d5:	c1 e8 0c             	shr    $0xc,%eax
  8030d8:	83 ec 0c             	sub    $0xc,%esp
  8030db:	50                   	push   %eax
  8030dc:	e8 07 ec ff ff       	call   801ce8 <sbrk>
  8030e1:	83 c4 10             	add    $0x10,%esp
  8030e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8030e7:	83 ec 0c             	sub    $0xc,%esp
  8030ea:	6a 00                	push   $0x0
  8030ec:	e8 f7 eb ff ff       	call   801ce8 <sbrk>
  8030f1:	83 c4 10             	add    $0x10,%esp
  8030f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8030f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030fa:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8030fd:	83 ec 08             	sub    $0x8,%esp
  803100:	50                   	push   %eax
  803101:	ff 75 d8             	pushl  -0x28(%ebp)
  803104:	e8 9f f8 ff ff       	call   8029a8 <initialize_dynamic_allocator>
  803109:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80310c:	83 ec 0c             	sub    $0xc,%esp
  80310f:	68 df 50 80 00       	push   $0x8050df
  803114:	e8 35 de ff ff       	call   800f4e <cprintf>
  803119:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80311c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803123:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80312a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803131:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803138:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80313d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803140:	e9 1d 01 00 00       	jmp    803262 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80314b:	83 ec 0c             	sub    $0xc,%esp
  80314e:	ff 75 a8             	pushl  -0x58(%ebp)
  803151:	e8 ee f6 ff ff       	call   802844 <get_block_size>
  803156:	83 c4 10             	add    $0x10,%esp
  803159:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	83 c0 08             	add    $0x8,%eax
  803162:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803165:	0f 87 ef 00 00 00    	ja     80325a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	83 c0 18             	add    $0x18,%eax
  803171:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803174:	77 1d                	ja     803193 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803176:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803179:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80317c:	0f 86 d8 00 00 00    	jbe    80325a <alloc_block_BF+0x1da>
				{
					best_va = va;
  803182:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803185:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803188:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80318b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80318e:	e9 c7 00 00 00       	jmp    80325a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	83 c0 08             	add    $0x8,%eax
  803199:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80319c:	0f 85 9d 00 00 00    	jne    80323f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	6a 01                	push   $0x1
  8031a7:	ff 75 a4             	pushl  -0x5c(%ebp)
  8031aa:	ff 75 a8             	pushl  -0x58(%ebp)
  8031ad:	e8 e3 f9 ff ff       	call   802b95 <set_block_data>
  8031b2:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8031b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b9:	75 17                	jne    8031d2 <alloc_block_BF+0x152>
  8031bb:	83 ec 04             	sub    $0x4,%esp
  8031be:	68 83 50 80 00       	push   $0x805083
  8031c3:	68 2c 01 00 00       	push   $0x12c
  8031c8:	68 a1 50 80 00       	push   $0x8050a1
  8031cd:	e8 bf da ff ff       	call   800c91 <_panic>
  8031d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d5:	8b 00                	mov    (%eax),%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	74 10                	je     8031eb <alloc_block_BF+0x16b>
  8031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031de:	8b 00                	mov    (%eax),%eax
  8031e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031e3:	8b 52 04             	mov    0x4(%edx),%edx
  8031e6:	89 50 04             	mov    %edx,0x4(%eax)
  8031e9:	eb 0b                	jmp    8031f6 <alloc_block_BF+0x176>
  8031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ee:	8b 40 04             	mov    0x4(%eax),%eax
  8031f1:	a3 30 60 80 00       	mov    %eax,0x806030
  8031f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f9:	8b 40 04             	mov    0x4(%eax),%eax
  8031fc:	85 c0                	test   %eax,%eax
  8031fe:	74 0f                	je     80320f <alloc_block_BF+0x18f>
  803200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803203:	8b 40 04             	mov    0x4(%eax),%eax
  803206:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803209:	8b 12                	mov    (%edx),%edx
  80320b:	89 10                	mov    %edx,(%eax)
  80320d:	eb 0a                	jmp    803219 <alloc_block_BF+0x199>
  80320f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803212:	8b 00                	mov    (%eax),%eax
  803214:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803225:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322c:	a1 38 60 80 00       	mov    0x806038,%eax
  803231:	48                   	dec    %eax
  803232:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803237:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80323a:	e9 01 04 00 00       	jmp    803640 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80323f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803242:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803245:	76 13                	jbe    80325a <alloc_block_BF+0x1da>
					{
						internal = 1;
  803247:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80324e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803251:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803254:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803257:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80325a:	a1 34 60 80 00       	mov    0x806034,%eax
  80325f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803262:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803266:	74 07                	je     80326f <alloc_block_BF+0x1ef>
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	eb 05                	jmp    803274 <alloc_block_BF+0x1f4>
  80326f:	b8 00 00 00 00       	mov    $0x0,%eax
  803274:	a3 34 60 80 00       	mov    %eax,0x806034
  803279:	a1 34 60 80 00       	mov    0x806034,%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	0f 85 bf fe ff ff    	jne    803145 <alloc_block_BF+0xc5>
  803286:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328a:	0f 85 b5 fe ff ff    	jne    803145 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803290:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803294:	0f 84 26 02 00 00    	je     8034c0 <alloc_block_BF+0x440>
  80329a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80329e:	0f 85 1c 02 00 00    	jne    8034c0 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8032a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a7:	2b 45 08             	sub    0x8(%ebp),%eax
  8032aa:	83 e8 08             	sub    $0x8,%eax
  8032ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b3:	8d 50 08             	lea    0x8(%eax),%edx
  8032b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b9:	01 d0                	add    %edx,%eax
  8032bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	83 c0 08             	add    $0x8,%eax
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	6a 01                	push   $0x1
  8032c9:	50                   	push   %eax
  8032ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8032cd:	e8 c3 f8 ff ff       	call   802b95 <set_block_data>
  8032d2:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8032d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d8:	8b 40 04             	mov    0x4(%eax),%eax
  8032db:	85 c0                	test   %eax,%eax
  8032dd:	75 68                	jne    803347 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032df:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032e3:	75 17                	jne    8032fc <alloc_block_BF+0x27c>
  8032e5:	83 ec 04             	sub    $0x4,%esp
  8032e8:	68 bc 50 80 00       	push   $0x8050bc
  8032ed:	68 45 01 00 00       	push   $0x145
  8032f2:	68 a1 50 80 00       	push   $0x8050a1
  8032f7:	e8 95 d9 ff ff       	call   800c91 <_panic>
  8032fc:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803302:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803305:	89 10                	mov    %edx,(%eax)
  803307:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	74 0d                	je     80331d <alloc_block_BF+0x29d>
  803310:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803315:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803318:	89 50 04             	mov    %edx,0x4(%eax)
  80331b:	eb 08                	jmp    803325 <alloc_block_BF+0x2a5>
  80331d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803320:	a3 30 60 80 00       	mov    %eax,0x806030
  803325:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803328:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80332d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803330:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803337:	a1 38 60 80 00       	mov    0x806038,%eax
  80333c:	40                   	inc    %eax
  80333d:	a3 38 60 80 00       	mov    %eax,0x806038
  803342:	e9 dc 00 00 00       	jmp    803423 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334a:	8b 00                	mov    (%eax),%eax
  80334c:	85 c0                	test   %eax,%eax
  80334e:	75 65                	jne    8033b5 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803350:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803354:	75 17                	jne    80336d <alloc_block_BF+0x2ed>
  803356:	83 ec 04             	sub    $0x4,%esp
  803359:	68 f0 50 80 00       	push   $0x8050f0
  80335e:	68 4a 01 00 00       	push   $0x14a
  803363:	68 a1 50 80 00       	push   $0x8050a1
  803368:	e8 24 d9 ff ff       	call   800c91 <_panic>
  80336d:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803376:	89 50 04             	mov    %edx,0x4(%eax)
  803379:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80337c:	8b 40 04             	mov    0x4(%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	74 0c                	je     80338f <alloc_block_BF+0x30f>
  803383:	a1 30 60 80 00       	mov    0x806030,%eax
  803388:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80338b:	89 10                	mov    %edx,(%eax)
  80338d:	eb 08                	jmp    803397 <alloc_block_BF+0x317>
  80338f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803392:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80339a:	a3 30 60 80 00       	mov    %eax,0x806030
  80339f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a8:	a1 38 60 80 00       	mov    0x806038,%eax
  8033ad:	40                   	inc    %eax
  8033ae:	a3 38 60 80 00       	mov    %eax,0x806038
  8033b3:	eb 6e                	jmp    803423 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8033b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033b9:	74 06                	je     8033c1 <alloc_block_BF+0x341>
  8033bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8033bf:	75 17                	jne    8033d8 <alloc_block_BF+0x358>
  8033c1:	83 ec 04             	sub    $0x4,%esp
  8033c4:	68 14 51 80 00       	push   $0x805114
  8033c9:	68 4f 01 00 00       	push   $0x14f
  8033ce:	68 a1 50 80 00       	push   $0x8050a1
  8033d3:	e8 b9 d8 ff ff       	call   800c91 <_panic>
  8033d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033db:	8b 10                	mov    (%eax),%edx
  8033dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033e0:	89 10                	mov    %edx,(%eax)
  8033e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033e5:	8b 00                	mov    (%eax),%eax
  8033e7:	85 c0                	test   %eax,%eax
  8033e9:	74 0b                	je     8033f6 <alloc_block_BF+0x376>
  8033eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ee:	8b 00                	mov    (%eax),%eax
  8033f0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8033f3:	89 50 04             	mov    %edx,0x4(%eax)
  8033f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8033fc:	89 10                	mov    %edx,(%eax)
  8033fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803401:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803404:	89 50 04             	mov    %edx,0x4(%eax)
  803407:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80340a:	8b 00                	mov    (%eax),%eax
  80340c:	85 c0                	test   %eax,%eax
  80340e:	75 08                	jne    803418 <alloc_block_BF+0x398>
  803410:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803413:	a3 30 60 80 00       	mov    %eax,0x806030
  803418:	a1 38 60 80 00       	mov    0x806038,%eax
  80341d:	40                   	inc    %eax
  80341e:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803423:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803427:	75 17                	jne    803440 <alloc_block_BF+0x3c0>
  803429:	83 ec 04             	sub    $0x4,%esp
  80342c:	68 83 50 80 00       	push   $0x805083
  803431:	68 51 01 00 00       	push   $0x151
  803436:	68 a1 50 80 00       	push   $0x8050a1
  80343b:	e8 51 d8 ff ff       	call   800c91 <_panic>
  803440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803443:	8b 00                	mov    (%eax),%eax
  803445:	85 c0                	test   %eax,%eax
  803447:	74 10                	je     803459 <alloc_block_BF+0x3d9>
  803449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344c:	8b 00                	mov    (%eax),%eax
  80344e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803451:	8b 52 04             	mov    0x4(%edx),%edx
  803454:	89 50 04             	mov    %edx,0x4(%eax)
  803457:	eb 0b                	jmp    803464 <alloc_block_BF+0x3e4>
  803459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345c:	8b 40 04             	mov    0x4(%eax),%eax
  80345f:	a3 30 60 80 00       	mov    %eax,0x806030
  803464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803467:	8b 40 04             	mov    0x4(%eax),%eax
  80346a:	85 c0                	test   %eax,%eax
  80346c:	74 0f                	je     80347d <alloc_block_BF+0x3fd>
  80346e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803471:	8b 40 04             	mov    0x4(%eax),%eax
  803474:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803477:	8b 12                	mov    (%edx),%edx
  803479:	89 10                	mov    %edx,(%eax)
  80347b:	eb 0a                	jmp    803487 <alloc_block_BF+0x407>
  80347d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803480:	8b 00                	mov    (%eax),%eax
  803482:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803493:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349a:	a1 38 60 80 00       	mov    0x806038,%eax
  80349f:	48                   	dec    %eax
  8034a0:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  8034a5:	83 ec 04             	sub    $0x4,%esp
  8034a8:	6a 00                	push   $0x0
  8034aa:	ff 75 d0             	pushl  -0x30(%ebp)
  8034ad:	ff 75 cc             	pushl  -0x34(%ebp)
  8034b0:	e8 e0 f6 ff ff       	call   802b95 <set_block_data>
  8034b5:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8034b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bb:	e9 80 01 00 00       	jmp    803640 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  8034c0:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8034c4:	0f 85 9d 00 00 00    	jne    803567 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8034ca:	83 ec 04             	sub    $0x4,%esp
  8034cd:	6a 01                	push   $0x1
  8034cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8034d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8034d5:	e8 bb f6 ff ff       	call   802b95 <set_block_data>
  8034da:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8034dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034e1:	75 17                	jne    8034fa <alloc_block_BF+0x47a>
  8034e3:	83 ec 04             	sub    $0x4,%esp
  8034e6:	68 83 50 80 00       	push   $0x805083
  8034eb:	68 58 01 00 00       	push   $0x158
  8034f0:	68 a1 50 80 00       	push   $0x8050a1
  8034f5:	e8 97 d7 ff ff       	call   800c91 <_panic>
  8034fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034fd:	8b 00                	mov    (%eax),%eax
  8034ff:	85 c0                	test   %eax,%eax
  803501:	74 10                	je     803513 <alloc_block_BF+0x493>
  803503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803506:	8b 00                	mov    (%eax),%eax
  803508:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80350b:	8b 52 04             	mov    0x4(%edx),%edx
  80350e:	89 50 04             	mov    %edx,0x4(%eax)
  803511:	eb 0b                	jmp    80351e <alloc_block_BF+0x49e>
  803513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803516:	8b 40 04             	mov    0x4(%eax),%eax
  803519:	a3 30 60 80 00       	mov    %eax,0x806030
  80351e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803521:	8b 40 04             	mov    0x4(%eax),%eax
  803524:	85 c0                	test   %eax,%eax
  803526:	74 0f                	je     803537 <alloc_block_BF+0x4b7>
  803528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352b:	8b 40 04             	mov    0x4(%eax),%eax
  80352e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803531:	8b 12                	mov    (%edx),%edx
  803533:	89 10                	mov    %edx,(%eax)
  803535:	eb 0a                	jmp    803541 <alloc_block_BF+0x4c1>
  803537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353a:	8b 00                	mov    (%eax),%eax
  80353c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803544:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80354a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803554:	a1 38 60 80 00       	mov    0x806038,%eax
  803559:	48                   	dec    %eax
  80355a:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  80355f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803562:	e9 d9 00 00 00       	jmp    803640 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	83 c0 08             	add    $0x8,%eax
  80356d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803570:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803577:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80357a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80357d:	01 d0                	add    %edx,%eax
  80357f:	48                   	dec    %eax
  803580:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803583:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803586:	ba 00 00 00 00       	mov    $0x0,%edx
  80358b:	f7 75 c4             	divl   -0x3c(%ebp)
  80358e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803591:	29 d0                	sub    %edx,%eax
  803593:	c1 e8 0c             	shr    $0xc,%eax
  803596:	83 ec 0c             	sub    $0xc,%esp
  803599:	50                   	push   %eax
  80359a:	e8 49 e7 ff ff       	call   801ce8 <sbrk>
  80359f:	83 c4 10             	add    $0x10,%esp
  8035a2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8035a5:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8035a9:	75 0a                	jne    8035b5 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8035ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b0:	e9 8b 00 00 00       	jmp    803640 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8035b5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8035bc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035c2:	01 d0                	add    %edx,%eax
  8035c4:	48                   	dec    %eax
  8035c5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8035c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8035d0:	f7 75 b8             	divl   -0x48(%ebp)
  8035d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035d6:	29 d0                	sub    %edx,%eax
  8035d8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8035db:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8035de:	01 d0                	add    %edx,%eax
  8035e0:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  8035e5:	a1 40 60 80 00       	mov    0x806040,%eax
  8035ea:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8035f0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8035f7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035fd:	01 d0                	add    %edx,%eax
  8035ff:	48                   	dec    %eax
  803600:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803603:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803606:	ba 00 00 00 00       	mov    $0x0,%edx
  80360b:	f7 75 b0             	divl   -0x50(%ebp)
  80360e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803611:	29 d0                	sub    %edx,%eax
  803613:	83 ec 04             	sub    $0x4,%esp
  803616:	6a 01                	push   $0x1
  803618:	50                   	push   %eax
  803619:	ff 75 bc             	pushl  -0x44(%ebp)
  80361c:	e8 74 f5 ff ff       	call   802b95 <set_block_data>
  803621:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803624:	83 ec 0c             	sub    $0xc,%esp
  803627:	ff 75 bc             	pushl  -0x44(%ebp)
  80362a:	e8 36 04 00 00       	call   803a65 <free_block>
  80362f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803632:	83 ec 0c             	sub    $0xc,%esp
  803635:	ff 75 08             	pushl  0x8(%ebp)
  803638:	e8 43 fa ff ff       	call   803080 <alloc_block_BF>
  80363d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803640:	c9                   	leave  
  803641:	c3                   	ret    

00803642 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803642:	55                   	push   %ebp
  803643:	89 e5                	mov    %esp,%ebp
  803645:	53                   	push   %ebx
  803646:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803650:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803657:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80365b:	74 1e                	je     80367b <merging+0x39>
  80365d:	ff 75 08             	pushl  0x8(%ebp)
  803660:	e8 df f1 ff ff       	call   802844 <get_block_size>
  803665:	83 c4 04             	add    $0x4,%esp
  803668:	89 c2                	mov    %eax,%edx
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	01 d0                	add    %edx,%eax
  80366f:	3b 45 10             	cmp    0x10(%ebp),%eax
  803672:	75 07                	jne    80367b <merging+0x39>
		prev_is_free = 1;
  803674:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80367b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80367f:	74 1e                	je     80369f <merging+0x5d>
  803681:	ff 75 10             	pushl  0x10(%ebp)
  803684:	e8 bb f1 ff ff       	call   802844 <get_block_size>
  803689:	83 c4 04             	add    $0x4,%esp
  80368c:	89 c2                	mov    %eax,%edx
  80368e:	8b 45 10             	mov    0x10(%ebp),%eax
  803691:	01 d0                	add    %edx,%eax
  803693:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803696:	75 07                	jne    80369f <merging+0x5d>
		next_is_free = 1;
  803698:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80369f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a3:	0f 84 cc 00 00 00    	je     803775 <merging+0x133>
  8036a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036ad:	0f 84 c2 00 00 00    	je     803775 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8036b3:	ff 75 08             	pushl  0x8(%ebp)
  8036b6:	e8 89 f1 ff ff       	call   802844 <get_block_size>
  8036bb:	83 c4 04             	add    $0x4,%esp
  8036be:	89 c3                	mov    %eax,%ebx
  8036c0:	ff 75 10             	pushl  0x10(%ebp)
  8036c3:	e8 7c f1 ff ff       	call   802844 <get_block_size>
  8036c8:	83 c4 04             	add    $0x4,%esp
  8036cb:	01 c3                	add    %eax,%ebx
  8036cd:	ff 75 0c             	pushl  0xc(%ebp)
  8036d0:	e8 6f f1 ff ff       	call   802844 <get_block_size>
  8036d5:	83 c4 04             	add    $0x4,%esp
  8036d8:	01 d8                	add    %ebx,%eax
  8036da:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8036dd:	6a 00                	push   $0x0
  8036df:	ff 75 ec             	pushl  -0x14(%ebp)
  8036e2:	ff 75 08             	pushl  0x8(%ebp)
  8036e5:	e8 ab f4 ff ff       	call   802b95 <set_block_data>
  8036ea:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8036ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036f1:	75 17                	jne    80370a <merging+0xc8>
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 83 50 80 00       	push   $0x805083
  8036fb:	68 7d 01 00 00       	push   $0x17d
  803700:	68 a1 50 80 00       	push   $0x8050a1
  803705:	e8 87 d5 ff ff       	call   800c91 <_panic>
  80370a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	85 c0                	test   %eax,%eax
  803711:	74 10                	je     803723 <merging+0xe1>
  803713:	8b 45 0c             	mov    0xc(%ebp),%eax
  803716:	8b 00                	mov    (%eax),%eax
  803718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80371b:	8b 52 04             	mov    0x4(%edx),%edx
  80371e:	89 50 04             	mov    %edx,0x4(%eax)
  803721:	eb 0b                	jmp    80372e <merging+0xec>
  803723:	8b 45 0c             	mov    0xc(%ebp),%eax
  803726:	8b 40 04             	mov    0x4(%eax),%eax
  803729:	a3 30 60 80 00       	mov    %eax,0x806030
  80372e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803731:	8b 40 04             	mov    0x4(%eax),%eax
  803734:	85 c0                	test   %eax,%eax
  803736:	74 0f                	je     803747 <merging+0x105>
  803738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373b:	8b 40 04             	mov    0x4(%eax),%eax
  80373e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803741:	8b 12                	mov    (%edx),%edx
  803743:	89 10                	mov    %edx,(%eax)
  803745:	eb 0a                	jmp    803751 <merging+0x10f>
  803747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374a:	8b 00                	mov    (%eax),%eax
  80374c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803751:	8b 45 0c             	mov    0xc(%ebp),%eax
  803754:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80375a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80375d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803764:	a1 38 60 80 00       	mov    0x806038,%eax
  803769:	48                   	dec    %eax
  80376a:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80376f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803770:	e9 ea 02 00 00       	jmp    803a5f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803779:	74 3b                	je     8037b6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80377b:	83 ec 0c             	sub    $0xc,%esp
  80377e:	ff 75 08             	pushl  0x8(%ebp)
  803781:	e8 be f0 ff ff       	call   802844 <get_block_size>
  803786:	83 c4 10             	add    $0x10,%esp
  803789:	89 c3                	mov    %eax,%ebx
  80378b:	83 ec 0c             	sub    $0xc,%esp
  80378e:	ff 75 10             	pushl  0x10(%ebp)
  803791:	e8 ae f0 ff ff       	call   802844 <get_block_size>
  803796:	83 c4 10             	add    $0x10,%esp
  803799:	01 d8                	add    %ebx,%eax
  80379b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80379e:	83 ec 04             	sub    $0x4,%esp
  8037a1:	6a 00                	push   $0x0
  8037a3:	ff 75 e8             	pushl  -0x18(%ebp)
  8037a6:	ff 75 08             	pushl  0x8(%ebp)
  8037a9:	e8 e7 f3 ff ff       	call   802b95 <set_block_data>
  8037ae:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037b1:	e9 a9 02 00 00       	jmp    803a5f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8037b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037ba:	0f 84 2d 01 00 00    	je     8038ed <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8037c0:	83 ec 0c             	sub    $0xc,%esp
  8037c3:	ff 75 10             	pushl  0x10(%ebp)
  8037c6:	e8 79 f0 ff ff       	call   802844 <get_block_size>
  8037cb:	83 c4 10             	add    $0x10,%esp
  8037ce:	89 c3                	mov    %eax,%ebx
  8037d0:	83 ec 0c             	sub    $0xc,%esp
  8037d3:	ff 75 0c             	pushl  0xc(%ebp)
  8037d6:	e8 69 f0 ff ff       	call   802844 <get_block_size>
  8037db:	83 c4 10             	add    $0x10,%esp
  8037de:	01 d8                	add    %ebx,%eax
  8037e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8037e3:	83 ec 04             	sub    $0x4,%esp
  8037e6:	6a 00                	push   $0x0
  8037e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037eb:	ff 75 10             	pushl  0x10(%ebp)
  8037ee:	e8 a2 f3 ff ff       	call   802b95 <set_block_data>
  8037f3:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8037f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8037f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8037fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803800:	74 06                	je     803808 <merging+0x1c6>
  803802:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803806:	75 17                	jne    80381f <merging+0x1dd>
  803808:	83 ec 04             	sub    $0x4,%esp
  80380b:	68 48 51 80 00       	push   $0x805148
  803810:	68 8d 01 00 00       	push   $0x18d
  803815:	68 a1 50 80 00       	push   $0x8050a1
  80381a:	e8 72 d4 ff ff       	call   800c91 <_panic>
  80381f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803822:	8b 50 04             	mov    0x4(%eax),%edx
  803825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803828:	89 50 04             	mov    %edx,0x4(%eax)
  80382b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80382e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803831:	89 10                	mov    %edx,(%eax)
  803833:	8b 45 0c             	mov    0xc(%ebp),%eax
  803836:	8b 40 04             	mov    0x4(%eax),%eax
  803839:	85 c0                	test   %eax,%eax
  80383b:	74 0d                	je     80384a <merging+0x208>
  80383d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803840:	8b 40 04             	mov    0x4(%eax),%eax
  803843:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803846:	89 10                	mov    %edx,(%eax)
  803848:	eb 08                	jmp    803852 <merging+0x210>
  80384a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80384d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803852:	8b 45 0c             	mov    0xc(%ebp),%eax
  803855:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803858:	89 50 04             	mov    %edx,0x4(%eax)
  80385b:	a1 38 60 80 00       	mov    0x806038,%eax
  803860:	40                   	inc    %eax
  803861:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803866:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80386a:	75 17                	jne    803883 <merging+0x241>
  80386c:	83 ec 04             	sub    $0x4,%esp
  80386f:	68 83 50 80 00       	push   $0x805083
  803874:	68 8e 01 00 00       	push   $0x18e
  803879:	68 a1 50 80 00       	push   $0x8050a1
  80387e:	e8 0e d4 ff ff       	call   800c91 <_panic>
  803883:	8b 45 0c             	mov    0xc(%ebp),%eax
  803886:	8b 00                	mov    (%eax),%eax
  803888:	85 c0                	test   %eax,%eax
  80388a:	74 10                	je     80389c <merging+0x25a>
  80388c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388f:	8b 00                	mov    (%eax),%eax
  803891:	8b 55 0c             	mov    0xc(%ebp),%edx
  803894:	8b 52 04             	mov    0x4(%edx),%edx
  803897:	89 50 04             	mov    %edx,0x4(%eax)
  80389a:	eb 0b                	jmp    8038a7 <merging+0x265>
  80389c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80389f:	8b 40 04             	mov    0x4(%eax),%eax
  8038a2:	a3 30 60 80 00       	mov    %eax,0x806030
  8038a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038aa:	8b 40 04             	mov    0x4(%eax),%eax
  8038ad:	85 c0                	test   %eax,%eax
  8038af:	74 0f                	je     8038c0 <merging+0x27e>
  8038b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b4:	8b 40 04             	mov    0x4(%eax),%eax
  8038b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038ba:	8b 12                	mov    (%edx),%edx
  8038bc:	89 10                	mov    %edx,(%eax)
  8038be:	eb 0a                	jmp    8038ca <merging+0x288>
  8038c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c3:	8b 00                	mov    (%eax),%eax
  8038c5:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8038ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038dd:	a1 38 60 80 00       	mov    0x806038,%eax
  8038e2:	48                   	dec    %eax
  8038e3:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8038e8:	e9 72 01 00 00       	jmp    803a5f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8038ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8038f0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8038f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038f7:	74 79                	je     803972 <merging+0x330>
  8038f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038fd:	74 73                	je     803972 <merging+0x330>
  8038ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803903:	74 06                	je     80390b <merging+0x2c9>
  803905:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803909:	75 17                	jne    803922 <merging+0x2e0>
  80390b:	83 ec 04             	sub    $0x4,%esp
  80390e:	68 14 51 80 00       	push   $0x805114
  803913:	68 94 01 00 00       	push   $0x194
  803918:	68 a1 50 80 00       	push   $0x8050a1
  80391d:	e8 6f d3 ff ff       	call   800c91 <_panic>
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	8b 10                	mov    (%eax),%edx
  803927:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80392a:	89 10                	mov    %edx,(%eax)
  80392c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	85 c0                	test   %eax,%eax
  803933:	74 0b                	je     803940 <merging+0x2fe>
  803935:	8b 45 08             	mov    0x8(%ebp),%eax
  803938:	8b 00                	mov    (%eax),%eax
  80393a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80393d:	89 50 04             	mov    %edx,0x4(%eax)
  803940:	8b 45 08             	mov    0x8(%ebp),%eax
  803943:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803946:	89 10                	mov    %edx,(%eax)
  803948:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80394b:	8b 55 08             	mov    0x8(%ebp),%edx
  80394e:	89 50 04             	mov    %edx,0x4(%eax)
  803951:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803954:	8b 00                	mov    (%eax),%eax
  803956:	85 c0                	test   %eax,%eax
  803958:	75 08                	jne    803962 <merging+0x320>
  80395a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80395d:	a3 30 60 80 00       	mov    %eax,0x806030
  803962:	a1 38 60 80 00       	mov    0x806038,%eax
  803967:	40                   	inc    %eax
  803968:	a3 38 60 80 00       	mov    %eax,0x806038
  80396d:	e9 ce 00 00 00       	jmp    803a40 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803972:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803976:	74 65                	je     8039dd <merging+0x39b>
  803978:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80397c:	75 17                	jne    803995 <merging+0x353>
  80397e:	83 ec 04             	sub    $0x4,%esp
  803981:	68 f0 50 80 00       	push   $0x8050f0
  803986:	68 95 01 00 00       	push   $0x195
  80398b:	68 a1 50 80 00       	push   $0x8050a1
  803990:	e8 fc d2 ff ff       	call   800c91 <_panic>
  803995:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80399b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399e:	89 50 04             	mov    %edx,0x4(%eax)
  8039a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a4:	8b 40 04             	mov    0x4(%eax),%eax
  8039a7:	85 c0                	test   %eax,%eax
  8039a9:	74 0c                	je     8039b7 <merging+0x375>
  8039ab:	a1 30 60 80 00       	mov    0x806030,%eax
  8039b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039b3:	89 10                	mov    %edx,(%eax)
  8039b5:	eb 08                	jmp    8039bf <merging+0x37d>
  8039b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ba:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8039bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039c2:	a3 30 60 80 00       	mov    %eax,0x806030
  8039c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d0:	a1 38 60 80 00       	mov    0x806038,%eax
  8039d5:	40                   	inc    %eax
  8039d6:	a3 38 60 80 00       	mov    %eax,0x806038
  8039db:	eb 63                	jmp    803a40 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8039dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8039e1:	75 17                	jne    8039fa <merging+0x3b8>
  8039e3:	83 ec 04             	sub    $0x4,%esp
  8039e6:	68 bc 50 80 00       	push   $0x8050bc
  8039eb:	68 98 01 00 00       	push   $0x198
  8039f0:	68 a1 50 80 00       	push   $0x8050a1
  8039f5:	e8 97 d2 ff ff       	call   800c91 <_panic>
  8039fa:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803a00:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a03:	89 10                	mov    %edx,(%eax)
  803a05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a08:	8b 00                	mov    (%eax),%eax
  803a0a:	85 c0                	test   %eax,%eax
  803a0c:	74 0d                	je     803a1b <merging+0x3d9>
  803a0e:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a13:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a16:	89 50 04             	mov    %edx,0x4(%eax)
  803a19:	eb 08                	jmp    803a23 <merging+0x3e1>
  803a1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a1e:	a3 30 60 80 00       	mov    %eax,0x806030
  803a23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a26:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a35:	a1 38 60 80 00       	mov    0x806038,%eax
  803a3a:	40                   	inc    %eax
  803a3b:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803a40:	83 ec 0c             	sub    $0xc,%esp
  803a43:	ff 75 10             	pushl  0x10(%ebp)
  803a46:	e8 f9 ed ff ff       	call   802844 <get_block_size>
  803a4b:	83 c4 10             	add    $0x10,%esp
  803a4e:	83 ec 04             	sub    $0x4,%esp
  803a51:	6a 00                	push   $0x0
  803a53:	50                   	push   %eax
  803a54:	ff 75 10             	pushl  0x10(%ebp)
  803a57:	e8 39 f1 ff ff       	call   802b95 <set_block_data>
  803a5c:	83 c4 10             	add    $0x10,%esp
	}
}
  803a5f:	90                   	nop
  803a60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a63:	c9                   	leave  
  803a64:	c3                   	ret    

00803a65 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803a65:	55                   	push   %ebp
  803a66:	89 e5                	mov    %esp,%ebp
  803a68:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803a6b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a70:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803a73:	a1 30 60 80 00       	mov    0x806030,%eax
  803a78:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a7b:	73 1b                	jae    803a98 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803a7d:	a1 30 60 80 00       	mov    0x806030,%eax
  803a82:	83 ec 04             	sub    $0x4,%esp
  803a85:	ff 75 08             	pushl  0x8(%ebp)
  803a88:	6a 00                	push   $0x0
  803a8a:	50                   	push   %eax
  803a8b:	e8 b2 fb ff ff       	call   803642 <merging>
  803a90:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a93:	e9 8b 00 00 00       	jmp    803b23 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803a98:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803aa0:	76 18                	jbe    803aba <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803aa2:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803aa7:	83 ec 04             	sub    $0x4,%esp
  803aaa:	ff 75 08             	pushl  0x8(%ebp)
  803aad:	50                   	push   %eax
  803aae:	6a 00                	push   $0x0
  803ab0:	e8 8d fb ff ff       	call   803642 <merging>
  803ab5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803ab8:	eb 69                	jmp    803b23 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803aba:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac2:	eb 39                	jmp    803afd <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac7:	3b 45 08             	cmp    0x8(%ebp),%eax
  803aca:	73 29                	jae    803af5 <free_block+0x90>
  803acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acf:	8b 00                	mov    (%eax),%eax
  803ad1:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ad4:	76 1f                	jbe    803af5 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad9:	8b 00                	mov    (%eax),%eax
  803adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803ade:	83 ec 04             	sub    $0x4,%esp
  803ae1:	ff 75 08             	pushl  0x8(%ebp)
  803ae4:	ff 75 f0             	pushl  -0x10(%ebp)
  803ae7:	ff 75 f4             	pushl  -0xc(%ebp)
  803aea:	e8 53 fb ff ff       	call   803642 <merging>
  803aef:	83 c4 10             	add    $0x10,%esp
			break;
  803af2:	90                   	nop
		}
	}
}
  803af3:	eb 2e                	jmp    803b23 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803af5:	a1 34 60 80 00       	mov    0x806034,%eax
  803afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b01:	74 07                	je     803b0a <free_block+0xa5>
  803b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b06:	8b 00                	mov    (%eax),%eax
  803b08:	eb 05                	jmp    803b0f <free_block+0xaa>
  803b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0f:	a3 34 60 80 00       	mov    %eax,0x806034
  803b14:	a1 34 60 80 00       	mov    0x806034,%eax
  803b19:	85 c0                	test   %eax,%eax
  803b1b:	75 a7                	jne    803ac4 <free_block+0x5f>
  803b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b21:	75 a1                	jne    803ac4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803b23:	90                   	nop
  803b24:	c9                   	leave  
  803b25:	c3                   	ret    

00803b26 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803b26:	55                   	push   %ebp
  803b27:	89 e5                	mov    %esp,%ebp
  803b29:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803b2c:	ff 75 08             	pushl  0x8(%ebp)
  803b2f:	e8 10 ed ff ff       	call   802844 <get_block_size>
  803b34:	83 c4 04             	add    $0x4,%esp
  803b37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803b41:	eb 17                	jmp    803b5a <copy_data+0x34>
  803b43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b49:	01 c2                	add    %eax,%edx
  803b4b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b51:	01 c8                	add    %ecx,%eax
  803b53:	8a 00                	mov    (%eax),%al
  803b55:	88 02                	mov    %al,(%edx)
  803b57:	ff 45 fc             	incl   -0x4(%ebp)
  803b5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b5d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803b60:	72 e1                	jb     803b43 <copy_data+0x1d>
}
  803b62:	90                   	nop
  803b63:	c9                   	leave  
  803b64:	c3                   	ret    

00803b65 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803b65:	55                   	push   %ebp
  803b66:	89 e5                	mov    %esp,%ebp
  803b68:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803b6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b6f:	75 23                	jne    803b94 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803b71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b75:	74 13                	je     803b8a <realloc_block_FF+0x25>
  803b77:	83 ec 0c             	sub    $0xc,%esp
  803b7a:	ff 75 0c             	pushl  0xc(%ebp)
  803b7d:	e8 42 f0 ff ff       	call   802bc4 <alloc_block_FF>
  803b82:	83 c4 10             	add    $0x10,%esp
  803b85:	e9 e4 06 00 00       	jmp    80426e <realloc_block_FF+0x709>
		return NULL;
  803b8a:	b8 00 00 00 00       	mov    $0x0,%eax
  803b8f:	e9 da 06 00 00       	jmp    80426e <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803b94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b98:	75 18                	jne    803bb2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803b9a:	83 ec 0c             	sub    $0xc,%esp
  803b9d:	ff 75 08             	pushl  0x8(%ebp)
  803ba0:	e8 c0 fe ff ff       	call   803a65 <free_block>
  803ba5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  803bad:	e9 bc 06 00 00       	jmp    80426e <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803bb2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803bb6:	77 07                	ja     803bbf <realloc_block_FF+0x5a>
  803bb8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bc2:	83 e0 01             	and    $0x1,%eax
  803bc5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bcb:	83 c0 08             	add    $0x8,%eax
  803bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803bd1:	83 ec 0c             	sub    $0xc,%esp
  803bd4:	ff 75 08             	pushl  0x8(%ebp)
  803bd7:	e8 68 ec ff ff       	call   802844 <get_block_size>
  803bdc:	83 c4 10             	add    $0x10,%esp
  803bdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803be5:	83 e8 08             	sub    $0x8,%eax
  803be8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803beb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bee:	83 e8 04             	sub    $0x4,%eax
  803bf1:	8b 00                	mov    (%eax),%eax
  803bf3:	83 e0 fe             	and    $0xfffffffe,%eax
  803bf6:	89 c2                	mov    %eax,%edx
  803bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfb:	01 d0                	add    %edx,%eax
  803bfd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803c00:	83 ec 0c             	sub    $0xc,%esp
  803c03:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c06:	e8 39 ec ff ff       	call   802844 <get_block_size>
  803c0b:	83 c4 10             	add    $0x10,%esp
  803c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c14:	83 e8 08             	sub    $0x8,%eax
  803c17:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c1d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c20:	75 08                	jne    803c2a <realloc_block_FF+0xc5>
	{
		 return va;
  803c22:	8b 45 08             	mov    0x8(%ebp),%eax
  803c25:	e9 44 06 00 00       	jmp    80426e <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c2d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c30:	0f 83 d5 03 00 00    	jae    80400b <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c39:	2b 45 0c             	sub    0xc(%ebp),%eax
  803c3c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803c3f:	83 ec 0c             	sub    $0xc,%esp
  803c42:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c45:	e8 13 ec ff ff       	call   80285d <is_free_block>
  803c4a:	83 c4 10             	add    $0x10,%esp
  803c4d:	84 c0                	test   %al,%al
  803c4f:	0f 84 3b 01 00 00    	je     803d90 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803c55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c58:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c5b:	01 d0                	add    %edx,%eax
  803c5d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803c60:	83 ec 04             	sub    $0x4,%esp
  803c63:	6a 01                	push   $0x1
  803c65:	ff 75 f0             	pushl  -0x10(%ebp)
  803c68:	ff 75 08             	pushl  0x8(%ebp)
  803c6b:	e8 25 ef ff ff       	call   802b95 <set_block_data>
  803c70:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803c73:	8b 45 08             	mov    0x8(%ebp),%eax
  803c76:	83 e8 04             	sub    $0x4,%eax
  803c79:	8b 00                	mov    (%eax),%eax
  803c7b:	83 e0 fe             	and    $0xfffffffe,%eax
  803c7e:	89 c2                	mov    %eax,%edx
  803c80:	8b 45 08             	mov    0x8(%ebp),%eax
  803c83:	01 d0                	add    %edx,%eax
  803c85:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803c88:	83 ec 04             	sub    $0x4,%esp
  803c8b:	6a 00                	push   $0x0
  803c8d:	ff 75 cc             	pushl  -0x34(%ebp)
  803c90:	ff 75 c8             	pushl  -0x38(%ebp)
  803c93:	e8 fd ee ff ff       	call   802b95 <set_block_data>
  803c98:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c9f:	74 06                	je     803ca7 <realloc_block_FF+0x142>
  803ca1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803ca5:	75 17                	jne    803cbe <realloc_block_FF+0x159>
  803ca7:	83 ec 04             	sub    $0x4,%esp
  803caa:	68 14 51 80 00       	push   $0x805114
  803caf:	68 f6 01 00 00       	push   $0x1f6
  803cb4:	68 a1 50 80 00       	push   $0x8050a1
  803cb9:	e8 d3 cf ff ff       	call   800c91 <_panic>
  803cbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc1:	8b 10                	mov    (%eax),%edx
  803cc3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cc6:	89 10                	mov    %edx,(%eax)
  803cc8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ccb:	8b 00                	mov    (%eax),%eax
  803ccd:	85 c0                	test   %eax,%eax
  803ccf:	74 0b                	je     803cdc <realloc_block_FF+0x177>
  803cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd4:	8b 00                	mov    (%eax),%eax
  803cd6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803cd9:	89 50 04             	mov    %edx,0x4(%eax)
  803cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cdf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ce2:	89 10                	mov    %edx,(%eax)
  803ce4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ce7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cea:	89 50 04             	mov    %edx,0x4(%eax)
  803ced:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cf0:	8b 00                	mov    (%eax),%eax
  803cf2:	85 c0                	test   %eax,%eax
  803cf4:	75 08                	jne    803cfe <realloc_block_FF+0x199>
  803cf6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cf9:	a3 30 60 80 00       	mov    %eax,0x806030
  803cfe:	a1 38 60 80 00       	mov    0x806038,%eax
  803d03:	40                   	inc    %eax
  803d04:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d0d:	75 17                	jne    803d26 <realloc_block_FF+0x1c1>
  803d0f:	83 ec 04             	sub    $0x4,%esp
  803d12:	68 83 50 80 00       	push   $0x805083
  803d17:	68 f7 01 00 00       	push   $0x1f7
  803d1c:	68 a1 50 80 00       	push   $0x8050a1
  803d21:	e8 6b cf ff ff       	call   800c91 <_panic>
  803d26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d29:	8b 00                	mov    (%eax),%eax
  803d2b:	85 c0                	test   %eax,%eax
  803d2d:	74 10                	je     803d3f <realloc_block_FF+0x1da>
  803d2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d32:	8b 00                	mov    (%eax),%eax
  803d34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d37:	8b 52 04             	mov    0x4(%edx),%edx
  803d3a:	89 50 04             	mov    %edx,0x4(%eax)
  803d3d:	eb 0b                	jmp    803d4a <realloc_block_FF+0x1e5>
  803d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d42:	8b 40 04             	mov    0x4(%eax),%eax
  803d45:	a3 30 60 80 00       	mov    %eax,0x806030
  803d4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4d:	8b 40 04             	mov    0x4(%eax),%eax
  803d50:	85 c0                	test   %eax,%eax
  803d52:	74 0f                	je     803d63 <realloc_block_FF+0x1fe>
  803d54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d57:	8b 40 04             	mov    0x4(%eax),%eax
  803d5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d5d:	8b 12                	mov    (%edx),%edx
  803d5f:	89 10                	mov    %edx,(%eax)
  803d61:	eb 0a                	jmp    803d6d <realloc_block_FF+0x208>
  803d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d66:	8b 00                	mov    (%eax),%eax
  803d68:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d80:	a1 38 60 80 00       	mov    0x806038,%eax
  803d85:	48                   	dec    %eax
  803d86:	a3 38 60 80 00       	mov    %eax,0x806038
  803d8b:	e9 73 02 00 00       	jmp    804003 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803d90:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803d94:	0f 86 69 02 00 00    	jbe    804003 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803d9a:	83 ec 04             	sub    $0x4,%esp
  803d9d:	6a 01                	push   $0x1
  803d9f:	ff 75 f0             	pushl  -0x10(%ebp)
  803da2:	ff 75 08             	pushl  0x8(%ebp)
  803da5:	e8 eb ed ff ff       	call   802b95 <set_block_data>
  803daa:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803dad:	8b 45 08             	mov    0x8(%ebp),%eax
  803db0:	83 e8 04             	sub    $0x4,%eax
  803db3:	8b 00                	mov    (%eax),%eax
  803db5:	83 e0 fe             	and    $0xfffffffe,%eax
  803db8:	89 c2                	mov    %eax,%edx
  803dba:	8b 45 08             	mov    0x8(%ebp),%eax
  803dbd:	01 d0                	add    %edx,%eax
  803dbf:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803dc2:	a1 38 60 80 00       	mov    0x806038,%eax
  803dc7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803dca:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803dce:	75 68                	jne    803e38 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803dd0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803dd4:	75 17                	jne    803ded <realloc_block_FF+0x288>
  803dd6:	83 ec 04             	sub    $0x4,%esp
  803dd9:	68 bc 50 80 00       	push   $0x8050bc
  803dde:	68 06 02 00 00       	push   $0x206
  803de3:	68 a1 50 80 00       	push   $0x8050a1
  803de8:	e8 a4 ce ff ff       	call   800c91 <_panic>
  803ded:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803df3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803df6:	89 10                	mov    %edx,(%eax)
  803df8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dfb:	8b 00                	mov    (%eax),%eax
  803dfd:	85 c0                	test   %eax,%eax
  803dff:	74 0d                	je     803e0e <realloc_block_FF+0x2a9>
  803e01:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e06:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e09:	89 50 04             	mov    %edx,0x4(%eax)
  803e0c:	eb 08                	jmp    803e16 <realloc_block_FF+0x2b1>
  803e0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e11:	a3 30 60 80 00       	mov    %eax,0x806030
  803e16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e19:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e28:	a1 38 60 80 00       	mov    0x806038,%eax
  803e2d:	40                   	inc    %eax
  803e2e:	a3 38 60 80 00       	mov    %eax,0x806038
  803e33:	e9 b0 01 00 00       	jmp    803fe8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803e38:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e3d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e40:	76 68                	jbe    803eaa <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e42:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e46:	75 17                	jne    803e5f <realloc_block_FF+0x2fa>
  803e48:	83 ec 04             	sub    $0x4,%esp
  803e4b:	68 bc 50 80 00       	push   $0x8050bc
  803e50:	68 0b 02 00 00       	push   $0x20b
  803e55:	68 a1 50 80 00       	push   $0x8050a1
  803e5a:	e8 32 ce ff ff       	call   800c91 <_panic>
  803e5f:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803e65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e68:	89 10                	mov    %edx,(%eax)
  803e6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e6d:	8b 00                	mov    (%eax),%eax
  803e6f:	85 c0                	test   %eax,%eax
  803e71:	74 0d                	je     803e80 <realloc_block_FF+0x31b>
  803e73:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e78:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e7b:	89 50 04             	mov    %edx,0x4(%eax)
  803e7e:	eb 08                	jmp    803e88 <realloc_block_FF+0x323>
  803e80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e83:	a3 30 60 80 00       	mov    %eax,0x806030
  803e88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e8b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e9a:	a1 38 60 80 00       	mov    0x806038,%eax
  803e9f:	40                   	inc    %eax
  803ea0:	a3 38 60 80 00       	mov    %eax,0x806038
  803ea5:	e9 3e 01 00 00       	jmp    803fe8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803eaa:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803eaf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803eb2:	73 68                	jae    803f1c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803eb4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803eb8:	75 17                	jne    803ed1 <realloc_block_FF+0x36c>
  803eba:	83 ec 04             	sub    $0x4,%esp
  803ebd:	68 f0 50 80 00       	push   $0x8050f0
  803ec2:	68 10 02 00 00       	push   $0x210
  803ec7:	68 a1 50 80 00       	push   $0x8050a1
  803ecc:	e8 c0 cd ff ff       	call   800c91 <_panic>
  803ed1:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803ed7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eda:	89 50 04             	mov    %edx,0x4(%eax)
  803edd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ee0:	8b 40 04             	mov    0x4(%eax),%eax
  803ee3:	85 c0                	test   %eax,%eax
  803ee5:	74 0c                	je     803ef3 <realloc_block_FF+0x38e>
  803ee7:	a1 30 60 80 00       	mov    0x806030,%eax
  803eec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803eef:	89 10                	mov    %edx,(%eax)
  803ef1:	eb 08                	jmp    803efb <realloc_block_FF+0x396>
  803ef3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ef6:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803efb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803efe:	a3 30 60 80 00       	mov    %eax,0x806030
  803f03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f0c:	a1 38 60 80 00       	mov    0x806038,%eax
  803f11:	40                   	inc    %eax
  803f12:	a3 38 60 80 00       	mov    %eax,0x806038
  803f17:	e9 cc 00 00 00       	jmp    803fe8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803f1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803f23:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f2b:	e9 8a 00 00 00       	jmp    803fba <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f33:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f36:	73 7a                	jae    803fb2 <realloc_block_FF+0x44d>
  803f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3b:	8b 00                	mov    (%eax),%eax
  803f3d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f40:	73 70                	jae    803fb2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803f42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f46:	74 06                	je     803f4e <realloc_block_FF+0x3e9>
  803f48:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f4c:	75 17                	jne    803f65 <realloc_block_FF+0x400>
  803f4e:	83 ec 04             	sub    $0x4,%esp
  803f51:	68 14 51 80 00       	push   $0x805114
  803f56:	68 1a 02 00 00       	push   $0x21a
  803f5b:	68 a1 50 80 00       	push   $0x8050a1
  803f60:	e8 2c cd ff ff       	call   800c91 <_panic>
  803f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f68:	8b 10                	mov    (%eax),%edx
  803f6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f6d:	89 10                	mov    %edx,(%eax)
  803f6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f72:	8b 00                	mov    (%eax),%eax
  803f74:	85 c0                	test   %eax,%eax
  803f76:	74 0b                	je     803f83 <realloc_block_FF+0x41e>
  803f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7b:	8b 00                	mov    (%eax),%eax
  803f7d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f80:	89 50 04             	mov    %edx,0x4(%eax)
  803f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f86:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f89:	89 10                	mov    %edx,(%eax)
  803f8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f91:	89 50 04             	mov    %edx,0x4(%eax)
  803f94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f97:	8b 00                	mov    (%eax),%eax
  803f99:	85 c0                	test   %eax,%eax
  803f9b:	75 08                	jne    803fa5 <realloc_block_FF+0x440>
  803f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa0:	a3 30 60 80 00       	mov    %eax,0x806030
  803fa5:	a1 38 60 80 00       	mov    0x806038,%eax
  803faa:	40                   	inc    %eax
  803fab:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  803fb0:	eb 36                	jmp    803fe8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803fb2:	a1 34 60 80 00       	mov    0x806034,%eax
  803fb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fbe:	74 07                	je     803fc7 <realloc_block_FF+0x462>
  803fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc3:	8b 00                	mov    (%eax),%eax
  803fc5:	eb 05                	jmp    803fcc <realloc_block_FF+0x467>
  803fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fcc:	a3 34 60 80 00       	mov    %eax,0x806034
  803fd1:	a1 34 60 80 00       	mov    0x806034,%eax
  803fd6:	85 c0                	test   %eax,%eax
  803fd8:	0f 85 52 ff ff ff    	jne    803f30 <realloc_block_FF+0x3cb>
  803fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fe2:	0f 85 48 ff ff ff    	jne    803f30 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803fe8:	83 ec 04             	sub    $0x4,%esp
  803feb:	6a 00                	push   $0x0
  803fed:	ff 75 d8             	pushl  -0x28(%ebp)
  803ff0:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ff3:	e8 9d eb ff ff       	call   802b95 <set_block_data>
  803ff8:	83 c4 10             	add    $0x10,%esp
				return va;
  803ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffe:	e9 6b 02 00 00       	jmp    80426e <realloc_block_FF+0x709>
			}
			
		}
		return va;
  804003:	8b 45 08             	mov    0x8(%ebp),%eax
  804006:	e9 63 02 00 00       	jmp    80426e <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80400b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80400e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804011:	0f 86 4d 02 00 00    	jbe    804264 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  804017:	83 ec 0c             	sub    $0xc,%esp
  80401a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80401d:	e8 3b e8 ff ff       	call   80285d <is_free_block>
  804022:	83 c4 10             	add    $0x10,%esp
  804025:	84 c0                	test   %al,%al
  804027:	0f 84 37 02 00 00    	je     804264 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80402d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804030:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804033:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804036:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804039:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80403c:	76 38                	jbe    804076 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80403e:	83 ec 0c             	sub    $0xc,%esp
  804041:	ff 75 0c             	pushl  0xc(%ebp)
  804044:	e8 7b eb ff ff       	call   802bc4 <alloc_block_FF>
  804049:	83 c4 10             	add    $0x10,%esp
  80404c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80404f:	83 ec 08             	sub    $0x8,%esp
  804052:	ff 75 c0             	pushl  -0x40(%ebp)
  804055:	ff 75 08             	pushl  0x8(%ebp)
  804058:	e8 c9 fa ff ff       	call   803b26 <copy_data>
  80405d:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  804060:	83 ec 0c             	sub    $0xc,%esp
  804063:	ff 75 08             	pushl  0x8(%ebp)
  804066:	e8 fa f9 ff ff       	call   803a65 <free_block>
  80406b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80406e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804071:	e9 f8 01 00 00       	jmp    80426e <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804076:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804079:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80407c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80407f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804083:	0f 87 a0 00 00 00    	ja     804129 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804089:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80408d:	75 17                	jne    8040a6 <realloc_block_FF+0x541>
  80408f:	83 ec 04             	sub    $0x4,%esp
  804092:	68 83 50 80 00       	push   $0x805083
  804097:	68 38 02 00 00       	push   $0x238
  80409c:	68 a1 50 80 00       	push   $0x8050a1
  8040a1:	e8 eb cb ff ff       	call   800c91 <_panic>
  8040a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a9:	8b 00                	mov    (%eax),%eax
  8040ab:	85 c0                	test   %eax,%eax
  8040ad:	74 10                	je     8040bf <realloc_block_FF+0x55a>
  8040af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040b2:	8b 00                	mov    (%eax),%eax
  8040b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040b7:	8b 52 04             	mov    0x4(%edx),%edx
  8040ba:	89 50 04             	mov    %edx,0x4(%eax)
  8040bd:	eb 0b                	jmp    8040ca <realloc_block_FF+0x565>
  8040bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c2:	8b 40 04             	mov    0x4(%eax),%eax
  8040c5:	a3 30 60 80 00       	mov    %eax,0x806030
  8040ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040cd:	8b 40 04             	mov    0x4(%eax),%eax
  8040d0:	85 c0                	test   %eax,%eax
  8040d2:	74 0f                	je     8040e3 <realloc_block_FF+0x57e>
  8040d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d7:	8b 40 04             	mov    0x4(%eax),%eax
  8040da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040dd:	8b 12                	mov    (%edx),%edx
  8040df:	89 10                	mov    %edx,(%eax)
  8040e1:	eb 0a                	jmp    8040ed <realloc_block_FF+0x588>
  8040e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e6:	8b 00                	mov    (%eax),%eax
  8040e8:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8040ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804100:	a1 38 60 80 00       	mov    0x806038,%eax
  804105:	48                   	dec    %eax
  804106:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80410b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80410e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804111:	01 d0                	add    %edx,%eax
  804113:	83 ec 04             	sub    $0x4,%esp
  804116:	6a 01                	push   $0x1
  804118:	50                   	push   %eax
  804119:	ff 75 08             	pushl  0x8(%ebp)
  80411c:	e8 74 ea ff ff       	call   802b95 <set_block_data>
  804121:	83 c4 10             	add    $0x10,%esp
  804124:	e9 36 01 00 00       	jmp    80425f <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804129:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80412c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80412f:	01 d0                	add    %edx,%eax
  804131:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804134:	83 ec 04             	sub    $0x4,%esp
  804137:	6a 01                	push   $0x1
  804139:	ff 75 f0             	pushl  -0x10(%ebp)
  80413c:	ff 75 08             	pushl  0x8(%ebp)
  80413f:	e8 51 ea ff ff       	call   802b95 <set_block_data>
  804144:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804147:	8b 45 08             	mov    0x8(%ebp),%eax
  80414a:	83 e8 04             	sub    $0x4,%eax
  80414d:	8b 00                	mov    (%eax),%eax
  80414f:	83 e0 fe             	and    $0xfffffffe,%eax
  804152:	89 c2                	mov    %eax,%edx
  804154:	8b 45 08             	mov    0x8(%ebp),%eax
  804157:	01 d0                	add    %edx,%eax
  804159:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80415c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804160:	74 06                	je     804168 <realloc_block_FF+0x603>
  804162:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804166:	75 17                	jne    80417f <realloc_block_FF+0x61a>
  804168:	83 ec 04             	sub    $0x4,%esp
  80416b:	68 14 51 80 00       	push   $0x805114
  804170:	68 44 02 00 00       	push   $0x244
  804175:	68 a1 50 80 00       	push   $0x8050a1
  80417a:	e8 12 cb ff ff       	call   800c91 <_panic>
  80417f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804182:	8b 10                	mov    (%eax),%edx
  804184:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804187:	89 10                	mov    %edx,(%eax)
  804189:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80418c:	8b 00                	mov    (%eax),%eax
  80418e:	85 c0                	test   %eax,%eax
  804190:	74 0b                	je     80419d <realloc_block_FF+0x638>
  804192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804195:	8b 00                	mov    (%eax),%eax
  804197:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80419a:	89 50 04             	mov    %edx,0x4(%eax)
  80419d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8041a3:	89 10                	mov    %edx,(%eax)
  8041a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041ab:	89 50 04             	mov    %edx,0x4(%eax)
  8041ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041b1:	8b 00                	mov    (%eax),%eax
  8041b3:	85 c0                	test   %eax,%eax
  8041b5:	75 08                	jne    8041bf <realloc_block_FF+0x65a>
  8041b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041ba:	a3 30 60 80 00       	mov    %eax,0x806030
  8041bf:	a1 38 60 80 00       	mov    0x806038,%eax
  8041c4:	40                   	inc    %eax
  8041c5:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8041ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041ce:	75 17                	jne    8041e7 <realloc_block_FF+0x682>
  8041d0:	83 ec 04             	sub    $0x4,%esp
  8041d3:	68 83 50 80 00       	push   $0x805083
  8041d8:	68 45 02 00 00       	push   $0x245
  8041dd:	68 a1 50 80 00       	push   $0x8050a1
  8041e2:	e8 aa ca ff ff       	call   800c91 <_panic>
  8041e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ea:	8b 00                	mov    (%eax),%eax
  8041ec:	85 c0                	test   %eax,%eax
  8041ee:	74 10                	je     804200 <realloc_block_FF+0x69b>
  8041f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f3:	8b 00                	mov    (%eax),%eax
  8041f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041f8:	8b 52 04             	mov    0x4(%edx),%edx
  8041fb:	89 50 04             	mov    %edx,0x4(%eax)
  8041fe:	eb 0b                	jmp    80420b <realloc_block_FF+0x6a6>
  804200:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804203:	8b 40 04             	mov    0x4(%eax),%eax
  804206:	a3 30 60 80 00       	mov    %eax,0x806030
  80420b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80420e:	8b 40 04             	mov    0x4(%eax),%eax
  804211:	85 c0                	test   %eax,%eax
  804213:	74 0f                	je     804224 <realloc_block_FF+0x6bf>
  804215:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804218:	8b 40 04             	mov    0x4(%eax),%eax
  80421b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80421e:	8b 12                	mov    (%edx),%edx
  804220:	89 10                	mov    %edx,(%eax)
  804222:	eb 0a                	jmp    80422e <realloc_block_FF+0x6c9>
  804224:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804227:	8b 00                	mov    (%eax),%eax
  804229:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80422e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80423a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804241:	a1 38 60 80 00       	mov    0x806038,%eax
  804246:	48                   	dec    %eax
  804247:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  80424c:	83 ec 04             	sub    $0x4,%esp
  80424f:	6a 00                	push   $0x0
  804251:	ff 75 bc             	pushl  -0x44(%ebp)
  804254:	ff 75 b8             	pushl  -0x48(%ebp)
  804257:	e8 39 e9 ff ff       	call   802b95 <set_block_data>
  80425c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80425f:	8b 45 08             	mov    0x8(%ebp),%eax
  804262:	eb 0a                	jmp    80426e <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804264:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80426b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80426e:	c9                   	leave  
  80426f:	c3                   	ret    

00804270 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804270:	55                   	push   %ebp
  804271:	89 e5                	mov    %esp,%ebp
  804273:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804276:	83 ec 04             	sub    $0x4,%esp
  804279:	68 80 51 80 00       	push   $0x805180
  80427e:	68 58 02 00 00       	push   $0x258
  804283:	68 a1 50 80 00       	push   $0x8050a1
  804288:	e8 04 ca ff ff       	call   800c91 <_panic>

0080428d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80428d:	55                   	push   %ebp
  80428e:	89 e5                	mov    %esp,%ebp
  804290:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804293:	83 ec 04             	sub    $0x4,%esp
  804296:	68 a8 51 80 00       	push   $0x8051a8
  80429b:	68 61 02 00 00       	push   $0x261
  8042a0:	68 a1 50 80 00       	push   $0x8050a1
  8042a5:	e8 e7 c9 ff ff       	call   800c91 <_panic>

008042aa <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8042aa:	55                   	push   %ebp
  8042ab:	89 e5                	mov    %esp,%ebp
  8042ad:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8042b0:	83 ec 04             	sub    $0x4,%esp
  8042b3:	68 d0 51 80 00       	push   $0x8051d0
  8042b8:	6a 09                	push   $0x9
  8042ba:	68 f8 51 80 00       	push   $0x8051f8
  8042bf:	e8 cd c9 ff ff       	call   800c91 <_panic>

008042c4 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8042c4:	55                   	push   %ebp
  8042c5:	89 e5                	mov    %esp,%ebp
  8042c7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8042ca:	83 ec 04             	sub    $0x4,%esp
  8042cd:	68 08 52 80 00       	push   $0x805208
  8042d2:	6a 10                	push   $0x10
  8042d4:	68 f8 51 80 00       	push   $0x8051f8
  8042d9:	e8 b3 c9 ff ff       	call   800c91 <_panic>

008042de <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8042de:	55                   	push   %ebp
  8042df:	89 e5                	mov    %esp,%ebp
  8042e1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8042e4:	83 ec 04             	sub    $0x4,%esp
  8042e7:	68 30 52 80 00       	push   $0x805230
  8042ec:	6a 18                	push   $0x18
  8042ee:	68 f8 51 80 00       	push   $0x8051f8
  8042f3:	e8 99 c9 ff ff       	call   800c91 <_panic>

008042f8 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8042f8:	55                   	push   %ebp
  8042f9:	89 e5                	mov    %esp,%ebp
  8042fb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8042fe:	83 ec 04             	sub    $0x4,%esp
  804301:	68 58 52 80 00       	push   $0x805258
  804306:	6a 20                	push   $0x20
  804308:	68 f8 51 80 00       	push   $0x8051f8
  80430d:	e8 7f c9 ff ff       	call   800c91 <_panic>

00804312 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  804312:	55                   	push   %ebp
  804313:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804315:	8b 45 08             	mov    0x8(%ebp),%eax
  804318:	8b 40 10             	mov    0x10(%eax),%eax
}
  80431b:	5d                   	pop    %ebp
  80431c:	c3                   	ret    

0080431d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80431d:	55                   	push   %ebp
  80431e:	89 e5                	mov    %esp,%ebp
  804320:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804323:	8b 55 08             	mov    0x8(%ebp),%edx
  804326:	89 d0                	mov    %edx,%eax
  804328:	c1 e0 02             	shl    $0x2,%eax
  80432b:	01 d0                	add    %edx,%eax
  80432d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804334:	01 d0                	add    %edx,%eax
  804336:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80433d:	01 d0                	add    %edx,%eax
  80433f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804346:	01 d0                	add    %edx,%eax
  804348:	c1 e0 04             	shl    $0x4,%eax
  80434b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80434e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  804355:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804358:	83 ec 0c             	sub    $0xc,%esp
  80435b:	50                   	push   %eax
  80435c:	e8 ef e1 ff ff       	call   802550 <sys_get_virtual_time>
  804361:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  804364:	eb 41                	jmp    8043a7 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  804366:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804369:	83 ec 0c             	sub    $0xc,%esp
  80436c:	50                   	push   %eax
  80436d:	e8 de e1 ff ff       	call   802550 <sys_get_virtual_time>
  804372:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804375:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80437b:	29 c2                	sub    %eax,%edx
  80437d:	89 d0                	mov    %edx,%eax
  80437f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804382:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804385:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804388:	89 d1                	mov    %edx,%ecx
  80438a:	29 c1                	sub    %eax,%ecx
  80438c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80438f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804392:	39 c2                	cmp    %eax,%edx
  804394:	0f 97 c0             	seta   %al
  804397:	0f b6 c0             	movzbl %al,%eax
  80439a:	29 c1                	sub    %eax,%ecx
  80439c:	89 c8                	mov    %ecx,%eax
  80439e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8043a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8043a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8043a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8043ad:	72 b7                	jb     804366 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8043af:	90                   	nop
  8043b0:	c9                   	leave  
  8043b1:	c3                   	ret    

008043b2 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8043b2:	55                   	push   %ebp
  8043b3:	89 e5                	mov    %esp,%ebp
  8043b5:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8043b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8043bf:	eb 03                	jmp    8043c4 <busy_wait+0x12>
  8043c1:	ff 45 fc             	incl   -0x4(%ebp)
  8043c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8043c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8043ca:	72 f5                	jb     8043c1 <busy_wait+0xf>
	return i;
  8043cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8043cf:	c9                   	leave  
  8043d0:	c3                   	ret    
  8043d1:	66 90                	xchg   %ax,%ax
  8043d3:	90                   	nop

008043d4 <__udivdi3>:
  8043d4:	55                   	push   %ebp
  8043d5:	57                   	push   %edi
  8043d6:	56                   	push   %esi
  8043d7:	53                   	push   %ebx
  8043d8:	83 ec 1c             	sub    $0x1c,%esp
  8043db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8043df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8043e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8043eb:	89 ca                	mov    %ecx,%edx
  8043ed:	89 f8                	mov    %edi,%eax
  8043ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8043f3:	85 f6                	test   %esi,%esi
  8043f5:	75 2d                	jne    804424 <__udivdi3+0x50>
  8043f7:	39 cf                	cmp    %ecx,%edi
  8043f9:	77 65                	ja     804460 <__udivdi3+0x8c>
  8043fb:	89 fd                	mov    %edi,%ebp
  8043fd:	85 ff                	test   %edi,%edi
  8043ff:	75 0b                	jne    80440c <__udivdi3+0x38>
  804401:	b8 01 00 00 00       	mov    $0x1,%eax
  804406:	31 d2                	xor    %edx,%edx
  804408:	f7 f7                	div    %edi
  80440a:	89 c5                	mov    %eax,%ebp
  80440c:	31 d2                	xor    %edx,%edx
  80440e:	89 c8                	mov    %ecx,%eax
  804410:	f7 f5                	div    %ebp
  804412:	89 c1                	mov    %eax,%ecx
  804414:	89 d8                	mov    %ebx,%eax
  804416:	f7 f5                	div    %ebp
  804418:	89 cf                	mov    %ecx,%edi
  80441a:	89 fa                	mov    %edi,%edx
  80441c:	83 c4 1c             	add    $0x1c,%esp
  80441f:	5b                   	pop    %ebx
  804420:	5e                   	pop    %esi
  804421:	5f                   	pop    %edi
  804422:	5d                   	pop    %ebp
  804423:	c3                   	ret    
  804424:	39 ce                	cmp    %ecx,%esi
  804426:	77 28                	ja     804450 <__udivdi3+0x7c>
  804428:	0f bd fe             	bsr    %esi,%edi
  80442b:	83 f7 1f             	xor    $0x1f,%edi
  80442e:	75 40                	jne    804470 <__udivdi3+0x9c>
  804430:	39 ce                	cmp    %ecx,%esi
  804432:	72 0a                	jb     80443e <__udivdi3+0x6a>
  804434:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804438:	0f 87 9e 00 00 00    	ja     8044dc <__udivdi3+0x108>
  80443e:	b8 01 00 00 00       	mov    $0x1,%eax
  804443:	89 fa                	mov    %edi,%edx
  804445:	83 c4 1c             	add    $0x1c,%esp
  804448:	5b                   	pop    %ebx
  804449:	5e                   	pop    %esi
  80444a:	5f                   	pop    %edi
  80444b:	5d                   	pop    %ebp
  80444c:	c3                   	ret    
  80444d:	8d 76 00             	lea    0x0(%esi),%esi
  804450:	31 ff                	xor    %edi,%edi
  804452:	31 c0                	xor    %eax,%eax
  804454:	89 fa                	mov    %edi,%edx
  804456:	83 c4 1c             	add    $0x1c,%esp
  804459:	5b                   	pop    %ebx
  80445a:	5e                   	pop    %esi
  80445b:	5f                   	pop    %edi
  80445c:	5d                   	pop    %ebp
  80445d:	c3                   	ret    
  80445e:	66 90                	xchg   %ax,%ax
  804460:	89 d8                	mov    %ebx,%eax
  804462:	f7 f7                	div    %edi
  804464:	31 ff                	xor    %edi,%edi
  804466:	89 fa                	mov    %edi,%edx
  804468:	83 c4 1c             	add    $0x1c,%esp
  80446b:	5b                   	pop    %ebx
  80446c:	5e                   	pop    %esi
  80446d:	5f                   	pop    %edi
  80446e:	5d                   	pop    %ebp
  80446f:	c3                   	ret    
  804470:	bd 20 00 00 00       	mov    $0x20,%ebp
  804475:	89 eb                	mov    %ebp,%ebx
  804477:	29 fb                	sub    %edi,%ebx
  804479:	89 f9                	mov    %edi,%ecx
  80447b:	d3 e6                	shl    %cl,%esi
  80447d:	89 c5                	mov    %eax,%ebp
  80447f:	88 d9                	mov    %bl,%cl
  804481:	d3 ed                	shr    %cl,%ebp
  804483:	89 e9                	mov    %ebp,%ecx
  804485:	09 f1                	or     %esi,%ecx
  804487:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80448b:	89 f9                	mov    %edi,%ecx
  80448d:	d3 e0                	shl    %cl,%eax
  80448f:	89 c5                	mov    %eax,%ebp
  804491:	89 d6                	mov    %edx,%esi
  804493:	88 d9                	mov    %bl,%cl
  804495:	d3 ee                	shr    %cl,%esi
  804497:	89 f9                	mov    %edi,%ecx
  804499:	d3 e2                	shl    %cl,%edx
  80449b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80449f:	88 d9                	mov    %bl,%cl
  8044a1:	d3 e8                	shr    %cl,%eax
  8044a3:	09 c2                	or     %eax,%edx
  8044a5:	89 d0                	mov    %edx,%eax
  8044a7:	89 f2                	mov    %esi,%edx
  8044a9:	f7 74 24 0c          	divl   0xc(%esp)
  8044ad:	89 d6                	mov    %edx,%esi
  8044af:	89 c3                	mov    %eax,%ebx
  8044b1:	f7 e5                	mul    %ebp
  8044b3:	39 d6                	cmp    %edx,%esi
  8044b5:	72 19                	jb     8044d0 <__udivdi3+0xfc>
  8044b7:	74 0b                	je     8044c4 <__udivdi3+0xf0>
  8044b9:	89 d8                	mov    %ebx,%eax
  8044bb:	31 ff                	xor    %edi,%edi
  8044bd:	e9 58 ff ff ff       	jmp    80441a <__udivdi3+0x46>
  8044c2:	66 90                	xchg   %ax,%ax
  8044c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8044c8:	89 f9                	mov    %edi,%ecx
  8044ca:	d3 e2                	shl    %cl,%edx
  8044cc:	39 c2                	cmp    %eax,%edx
  8044ce:	73 e9                	jae    8044b9 <__udivdi3+0xe5>
  8044d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8044d3:	31 ff                	xor    %edi,%edi
  8044d5:	e9 40 ff ff ff       	jmp    80441a <__udivdi3+0x46>
  8044da:	66 90                	xchg   %ax,%ax
  8044dc:	31 c0                	xor    %eax,%eax
  8044de:	e9 37 ff ff ff       	jmp    80441a <__udivdi3+0x46>
  8044e3:	90                   	nop

008044e4 <__umoddi3>:
  8044e4:	55                   	push   %ebp
  8044e5:	57                   	push   %edi
  8044e6:	56                   	push   %esi
  8044e7:	53                   	push   %ebx
  8044e8:	83 ec 1c             	sub    $0x1c,%esp
  8044eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8044ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8044f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804503:	89 f3                	mov    %esi,%ebx
  804505:	89 fa                	mov    %edi,%edx
  804507:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80450b:	89 34 24             	mov    %esi,(%esp)
  80450e:	85 c0                	test   %eax,%eax
  804510:	75 1a                	jne    80452c <__umoddi3+0x48>
  804512:	39 f7                	cmp    %esi,%edi
  804514:	0f 86 a2 00 00 00    	jbe    8045bc <__umoddi3+0xd8>
  80451a:	89 c8                	mov    %ecx,%eax
  80451c:	89 f2                	mov    %esi,%edx
  80451e:	f7 f7                	div    %edi
  804520:	89 d0                	mov    %edx,%eax
  804522:	31 d2                	xor    %edx,%edx
  804524:	83 c4 1c             	add    $0x1c,%esp
  804527:	5b                   	pop    %ebx
  804528:	5e                   	pop    %esi
  804529:	5f                   	pop    %edi
  80452a:	5d                   	pop    %ebp
  80452b:	c3                   	ret    
  80452c:	39 f0                	cmp    %esi,%eax
  80452e:	0f 87 ac 00 00 00    	ja     8045e0 <__umoddi3+0xfc>
  804534:	0f bd e8             	bsr    %eax,%ebp
  804537:	83 f5 1f             	xor    $0x1f,%ebp
  80453a:	0f 84 ac 00 00 00    	je     8045ec <__umoddi3+0x108>
  804540:	bf 20 00 00 00       	mov    $0x20,%edi
  804545:	29 ef                	sub    %ebp,%edi
  804547:	89 fe                	mov    %edi,%esi
  804549:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80454d:	89 e9                	mov    %ebp,%ecx
  80454f:	d3 e0                	shl    %cl,%eax
  804551:	89 d7                	mov    %edx,%edi
  804553:	89 f1                	mov    %esi,%ecx
  804555:	d3 ef                	shr    %cl,%edi
  804557:	09 c7                	or     %eax,%edi
  804559:	89 e9                	mov    %ebp,%ecx
  80455b:	d3 e2                	shl    %cl,%edx
  80455d:	89 14 24             	mov    %edx,(%esp)
  804560:	89 d8                	mov    %ebx,%eax
  804562:	d3 e0                	shl    %cl,%eax
  804564:	89 c2                	mov    %eax,%edx
  804566:	8b 44 24 08          	mov    0x8(%esp),%eax
  80456a:	d3 e0                	shl    %cl,%eax
  80456c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804570:	8b 44 24 08          	mov    0x8(%esp),%eax
  804574:	89 f1                	mov    %esi,%ecx
  804576:	d3 e8                	shr    %cl,%eax
  804578:	09 d0                	or     %edx,%eax
  80457a:	d3 eb                	shr    %cl,%ebx
  80457c:	89 da                	mov    %ebx,%edx
  80457e:	f7 f7                	div    %edi
  804580:	89 d3                	mov    %edx,%ebx
  804582:	f7 24 24             	mull   (%esp)
  804585:	89 c6                	mov    %eax,%esi
  804587:	89 d1                	mov    %edx,%ecx
  804589:	39 d3                	cmp    %edx,%ebx
  80458b:	0f 82 87 00 00 00    	jb     804618 <__umoddi3+0x134>
  804591:	0f 84 91 00 00 00    	je     804628 <__umoddi3+0x144>
  804597:	8b 54 24 04          	mov    0x4(%esp),%edx
  80459b:	29 f2                	sub    %esi,%edx
  80459d:	19 cb                	sbb    %ecx,%ebx
  80459f:	89 d8                	mov    %ebx,%eax
  8045a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8045a5:	d3 e0                	shl    %cl,%eax
  8045a7:	89 e9                	mov    %ebp,%ecx
  8045a9:	d3 ea                	shr    %cl,%edx
  8045ab:	09 d0                	or     %edx,%eax
  8045ad:	89 e9                	mov    %ebp,%ecx
  8045af:	d3 eb                	shr    %cl,%ebx
  8045b1:	89 da                	mov    %ebx,%edx
  8045b3:	83 c4 1c             	add    $0x1c,%esp
  8045b6:	5b                   	pop    %ebx
  8045b7:	5e                   	pop    %esi
  8045b8:	5f                   	pop    %edi
  8045b9:	5d                   	pop    %ebp
  8045ba:	c3                   	ret    
  8045bb:	90                   	nop
  8045bc:	89 fd                	mov    %edi,%ebp
  8045be:	85 ff                	test   %edi,%edi
  8045c0:	75 0b                	jne    8045cd <__umoddi3+0xe9>
  8045c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8045c7:	31 d2                	xor    %edx,%edx
  8045c9:	f7 f7                	div    %edi
  8045cb:	89 c5                	mov    %eax,%ebp
  8045cd:	89 f0                	mov    %esi,%eax
  8045cf:	31 d2                	xor    %edx,%edx
  8045d1:	f7 f5                	div    %ebp
  8045d3:	89 c8                	mov    %ecx,%eax
  8045d5:	f7 f5                	div    %ebp
  8045d7:	89 d0                	mov    %edx,%eax
  8045d9:	e9 44 ff ff ff       	jmp    804522 <__umoddi3+0x3e>
  8045de:	66 90                	xchg   %ax,%ax
  8045e0:	89 c8                	mov    %ecx,%eax
  8045e2:	89 f2                	mov    %esi,%edx
  8045e4:	83 c4 1c             	add    $0x1c,%esp
  8045e7:	5b                   	pop    %ebx
  8045e8:	5e                   	pop    %esi
  8045e9:	5f                   	pop    %edi
  8045ea:	5d                   	pop    %ebp
  8045eb:	c3                   	ret    
  8045ec:	3b 04 24             	cmp    (%esp),%eax
  8045ef:	72 06                	jb     8045f7 <__umoddi3+0x113>
  8045f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045f5:	77 0f                	ja     804606 <__umoddi3+0x122>
  8045f7:	89 f2                	mov    %esi,%edx
  8045f9:	29 f9                	sub    %edi,%ecx
  8045fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8045ff:	89 14 24             	mov    %edx,(%esp)
  804602:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804606:	8b 44 24 04          	mov    0x4(%esp),%eax
  80460a:	8b 14 24             	mov    (%esp),%edx
  80460d:	83 c4 1c             	add    $0x1c,%esp
  804610:	5b                   	pop    %ebx
  804611:	5e                   	pop    %esi
  804612:	5f                   	pop    %edi
  804613:	5d                   	pop    %ebp
  804614:	c3                   	ret    
  804615:	8d 76 00             	lea    0x0(%esi),%esi
  804618:	2b 04 24             	sub    (%esp),%eax
  80461b:	19 fa                	sbb    %edi,%edx
  80461d:	89 d1                	mov    %edx,%ecx
  80461f:	89 c6                	mov    %eax,%esi
  804621:	e9 71 ff ff ff       	jmp    804597 <__umoddi3+0xb3>
  804626:	66 90                	xchg   %ax,%ax
  804628:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80462c:	72 ea                	jb     804618 <__umoddi3+0x134>
  80462e:	89 d9                	mov    %ebx,%ecx
  804630:	e9 62 ff ff ff       	jmp    804597 <__umoddi3+0xb3>
